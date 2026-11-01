"""Import routes from a GeoJSON FeatureCollection into the `routes` table.

Usage (run from the `backend` folder, DATABASE_URL set in .env):
    python -m app.seed_routes ../docs/routes.geojson

The file format follows docs/route-data-format.md. Running the script again
updates existing routes instead of creating duplicates.
"""
import json
import sys

from geoalchemy2.shape import from_shape
from shapely.geometry import shape
from sqlalchemy import text

from app.db import Base, SessionLocal, engine
from app.models import Route

REQUIRED = ["id", "name", "region", "activity", "distance_km",
            "elevation_gain_m", "difficulty", "start"]


def feature_to_route(feature: dict) -> Route:
    p = feature["properties"]
    missing = [k for k in REQUIRED if p.get(k) in (None, "", [])]
    if missing:
        raise ValueError(f"{p.get('id', '?')}: missing fields {missing}")
    lon, lat = p["start"]
    geom = feature.get("geometry")
    return Route(
        id=p["id"],
        name=p["name"],
        region=p["region"],
        activity=list(p["activity"]),
        distance_km=float(p["distance_km"]),
        elevation_gain_m=int(round(p["elevation_gain_m"])),
        difficulty=int(p["difficulty"]),
        est_duration_min=p.get("est_duration_min"),
        surface=p.get("surface"),
        start_lat=float(lat),
        start_lon=float(lon),
        warnings=list(p.get("warnings") or []),
        source_url=p.get("source_url"),
        geom=from_shape(shape(geom), srid=4326) if geom else None,
    )


def main(path: str) -> None:
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    features = data["features"]

    with engine.begin() as conn:
        conn.execute(text("CREATE EXTENSION IF NOT EXISTS postgis"))
    Base.metadata.create_all(engine)

    db = SessionLocal()
    try:
        for feature in features:
            db.merge(feature_to_route(feature))  # insert or update by id
        db.commit()
    finally:
        db.close()
    print(f"Imported {len(features)} routes from {path}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: python -m app.seed_routes <routes.geojson>")
    main(sys.argv[1])
