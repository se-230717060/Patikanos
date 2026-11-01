from fastapi import Depends, FastAPI, HTTPException, Response
from geoalchemy2.shape import to_shape
from shapely.geometry import mapping
from sqlalchemy import select
from sqlalchemy.orm import Session
from app.weather.router import router as weather_router

from app.db import Base, engine, get_db
from pydantic import BaseModel

from app.models import Favorite, Route, User

# Create tables on startup (routes, users, favorites) if they do not exist yet
Base.metadata.create_all(bind=engine)
app = FastAPI(title="Patikanos API")
app.include_router(weather_router)


def route_to_feature(r: Route) -> dict:
    return {
        "type": "Feature",
        "properties": {
            "id": r.id,
            "name": r.name,
            "region": r.region,
            "activity": r.activity,
            "distance_km": r.distance_km,
            "elevation_gain_m": r.elevation_gain_m,
            "difficulty": r.difficulty,
            "est_duration_min": r.est_duration_min,
            "surface": r.surface,
            "start": [r.start_lon, r.start_lat],
            "warnings": r.warnings,
            "source_url": r.source_url,
        },
        "geometry": mapping(to_shape(r.geom)) if r.geom is not None else None,
    }


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/routes")
def list_routes(activity: str | None = None, db: Session = Depends(get_db)):
    query = select(Route)
    if activity:
        query = query.where(Route.activity.any(activity))
    routes = db.scalars(query).all()
    return {
        "type": "FeatureCollection",
        "features": [route_to_feature(r) for r in routes],
    }


@app.get("/routes/{route_id}")
def get_route(route_id: str, db: Session = Depends(get_db)):
    route = db.get(Route, route_id)
    if route is None:
        raise HTTPException(status_code=404, detail="Route not found")
    return route_to_feature(route)

# ---------- Users, favorites & preferences (B-4, #26) ----------

class UserIn(BaseModel):
    name: str
    email: str


class FavoriteIn(BaseModel):
    route_id: str


class PreferencesIn(BaseModel):
    preferences: dict


def get_user_or_404(user_id: int, db: Session) -> User:
    user = db.get(User, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.post("/users", status_code=201)
def create_user(body: UserIn, db: Session = Depends(get_db)):
    if db.scalar(select(User).where(User.email == body.email)):
        raise HTTPException(status_code=409, detail="Email already registered")
    user = User(name=body.name, email=body.email, preferences={})
    db.add(user)
    db.commit()
    db.refresh(user)
    return {"id": user.id, "name": user.name, "email": user.email,
            "preferences": user.preferences}


@app.get("/users/{user_id}/favorites")
def list_favorites(user_id: int, db: Session = Depends(get_db)):
    get_user_or_404(user_id, db)
    query = (
        select(Route)
        .join(Favorite, Favorite.route_id == Route.id)
        .where(Favorite.user_id == user_id)
        .order_by(Favorite.created_at.desc())
    )
    routes = db.scalars(query).all()
    return {
        "type": "FeatureCollection",
        "features": [route_to_feature(r) for r in routes],
    }


@app.post("/users/{user_id}/favorites", status_code=201)
def add_favorite(user_id: int, body: FavoriteIn, db: Session = Depends(get_db)):
    get_user_or_404(user_id, db)
    if db.get(Route, body.route_id) is None:
        raise HTTPException(status_code=404, detail="Route not found")
    if db.get(Favorite, (user_id, body.route_id)) is not None:
        raise HTTPException(status_code=409, detail="Route already in favorites")
    db.add(Favorite(user_id=user_id, route_id=body.route_id))
    db.commit()
    return {"user_id": user_id, "route_id": body.route_id}


@app.delete("/users/{user_id}/favorites/{route_id}", status_code=204)
def remove_favorite(user_id: int, route_id: str, db: Session = Depends(get_db)):
    favorite = db.get(Favorite, (user_id, route_id))
    if favorite is None:
        raise HTTPException(status_code=404, detail="Favorite not found")
    db.delete(favorite)
    db.commit()
    return Response(status_code=204)


@app.get("/users/{user_id}/preferences")
def get_preferences(user_id: int, db: Session = Depends(get_db)):
    return get_user_or_404(user_id, db).preferences


@app.put("/users/{user_id}/preferences")
def update_preferences(user_id: int, body: PreferencesIn, db: Session = Depends(get_db)):
    user = get_user_or_404(user_id, db)
    user.preferences = body.preferences
    db.commit()
    return user.preferences