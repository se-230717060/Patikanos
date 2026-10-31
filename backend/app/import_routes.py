"""Import routes from a GeoJSON FeatureCollection into the routes table (B-5, #28).

Usage (from the backend folder, while docker compose is running):
    DATABASE_URL=postgresql+psycopg2://patikanos:patikanos@localhost:5433/patikanos \
        python -m app.import_routes path/to/routes.geojson

Format: see route-data-format.md. Re-running the script updates routes with the same id.
"""
import json
import sys

from geoalchemy2.shape import from_shape
from shapely.geometry import shape

from app.db import Base, SessionLocal, engine
from app.models import Route

REQUIRED = ["id", "name", "region", "activity", "distance_km", "elevation_gain_m", "difficulty"]


def feature_to_route(feature: dict) -> Route:
    props = feature.get("properties") or {}
    missing = [f for f in REQUIRED if props.get(f) in (None, "", [])]
    if missing:
        raise ValueError(f"missing fields: {', '.join(missing)}")

    # Start point: start_lat/start_lon, or "start": [lon, lat] like the API output
    if props.get("start_lat") is not None and props.get("start_lon") is not None:
        lat, lon = float(props["start_lat"]), float(props["start_lon"])
    elif props.get("start"):
        lon, lat = map(float, props["start"])
    else:
        raise ValueError("missing start_lat / start_lon (issue #21)")
    if not (36 <= lat <= 38 and 27 <= lon <= 30):
        raise ValueError(f"start point ({lat}, {lon}) is outside Muğla - lat/lon swapped?")

    activity = props["activity"]
    if isinstance(activity, str):
        activity = [activity]

    geometry = feature.get("geometry")
    geom = None
    if geometry:
        if geometry.get("type") != "LineString":
            raise ValueError(f"geometry must be LineString, got {geometry.get('type')}")
        geom = from_shape(shape(geometry), srid=4326)

    duration = props.get("est_duration_min")
    return Route(
        id=str(props["id"]),
        name=props["name"],
        region=props["region"],
        activity=activity,
        distance_km=float(props["distance_km"]),
        elevation_gain_m=round(float(props["elevation_gain_m"])),
        difficulty=int(props["difficulty"]),
        est_duration_min=int(duration) if duration is not None else None,
        surface=props.get("surface"),
        start_lat=lat,
        start_lon=lon,
        warnings=props.get("warnings") or [],
        source_url=props.get("source_url"),
        geom=geom,
    )


def main(path: str) -> None:
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    if data.get("type") != "FeatureCollection":
        sys.exit("File must be a GeoJSON FeatureCollection")

    Base.metadata.create_all(bind=engine)
    imported, skipped = 0, []
    with SessionLocal() as db:
        for i, feature in enumerate(data.get("features", []), start=1):
            try:
                db.merge(feature_to_route(feature))  # insert, or update if the id exists
                imported += 1
            except (ValueError, TypeError, KeyError) as exc:
                route_id = (feature.get("properties") or {}).get("id", f"feature {i}")
                skipped.append(f"{route_id}: {exc}")
        db.commit()

    print(f"Imported/updated {imported} routes.")
    for line in skipped:
        print("Skipped", line)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit("Usage: python -m app.import_routes <routes.geojson>")
    main(sys.argv[1])