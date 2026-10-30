# Route Data Format

This document defines how a route is stored and exchanged in Patikanos. The map (Esma Gül Baş), backend/database (Tuba Arpaçay) and weather/score module (İrem Çakmak) use the same field names.

- **Database:** `routes` table in PostgreSQL/PostGIS (`backend/app/models.py`)
- **API:** `GET /routes` returns a GeoJSON `FeatureCollection`; `GET /routes/{id}` returns one GeoJSON `Feature` (`backend/app/main.py`)
- **Source data:** `docs/Patikanos_Rota_Aday_Listesi.xlsx` (16 candidate routes)

## Fields

| Field | Database type | Required | Example | Description |
|---|---|---|---|---|
| id | string (max 10) | yes | `"R07"` | Unique route ID, same as the ID in the route candidate list |
| name | string | yes | `"Toparlar Şelalesi"` | Route name |
| region | string | yes | `"Köyceğiz"` | District in Muğla |
| activity | list of strings | yes | `["walking"]` | `"walking"`, `"cycling"` or both |
| distance_km | number | yes | `6.58` | Total distance in kilometres |
| elevation_gain_m | integer | yes | `230` | Total ascent in metres |
| difficulty | integer | yes | `1` | `1` = easy, `2` = moderate, `3` = hard |
| est_duration_min | integer | no | `120` | Estimated duration in minutes |
| surface | string | no | `"trail"` | Surface type, e.g. `"asphalt"`, `"gravel"`, `"trail"` |
| start_lat | number | yes | `36.95` | Latitude of the start point |
| start_lon | number | yes | `28.70` | Longitude of the start point |
| warnings | list of strings | no (default empty) | `["FOREST_BAN"]` | Safety warnings shown on the route detail screen |
| source_url | string | no | `"https://tr.wikiloc.com/..."` | Where the route data came from |
| geom | PostGIS LINESTRING, SRID 4326 | no | – | Route line; returned as GeoJSON `geometry` by the API |

## Mapping from the route candidate list

| Candidate list column | Field | Conversion |
|---|---|---|
| ID | id | as is (`R01` … `R16`) |
| Rota adı | name | as is |
| Bölge | region | as is |
| Tür | activity | `Yürüyüş` → `["walking"]`, `Bisiklet` → `["cycling"]` |
| Mesafe (km) | distance_km | as is |
| Tırmanış (m) | elevation_gain_m | rounded to an integer |
| Zorluk | difficulty | `Kolay` → 1, `Orta` → 2, `Zor` → 3 |
| Link | source_url | as is |
| – | start_lat, start_lon | to be added (issue #21) |
| – | geom | from each route's GPX file, converted to GeoJSON (MR-3) |

`start_lat` and `start_lon` are required in the database, so issue #21 must be completed before the routes are imported (#28).

## API example (`GET /routes/R07`)

```json
{
  "type": "Feature",
  "properties": {
    "id": "R07",
    "name": "Toparlar Şelalesi",
    "region": "Köyceğiz",
    "activity": ["walking"],
    "distance_km": 6.58,
    "elevation_gain_m": 230,
    "difficulty": 1,
    "est_duration_min": null,
    "surface": null,
    "start": [28.70, 36.95],
    "warnings": [],
    "source_url": "https://tr.wikiloc.com/gezi-yuruyus-rotalari/toparlar-selalesi-doga-yuruyusu-280286946"
  },
  "geometry": { "type": "LineString", "coordinates": [[28.70, 36.95], [28.71, 36.96]] }
}
```

Coordinates in the example are placeholders. In GeoJSON the order is always `[longitude, latitude]`; in Muğla, longitude starts with 27–29 and latitude with 36–37.

## Decision

GeoJSON was chosen as the exchange format because PostGIS can produce it directly and `flutter_map` can draw it without extra conversion. The map screen first reads a bundled GeoJSON file (Sprint 3) and switches to the `/routes` API in Sprint 4, so the M3 demo does not depend on the backend integration.
