from datetime import datetime
from typing import Literal
from zoneinfo import ZoneInfo
from fastapi.responses import JSONResponse


class UTF8JSONResponse(JSONResponse):
    media_type = "application/json; charset=utf-8"
import httpx
from fastapi import APIRouter, HTTPException

from app.weather.client import get_hourly
from app.weather.scoring import best_window, score_hour, window_label, window_warnings

router = APIRouter(prefix="/weather", tags=["weather"], default_response_class=UTF8JSONResponse)


@router.get("/score")
def get_score(lat: float, lon: float, activity: Literal["bike", "walk"]):
    try:
        h = get_hourly(lat, lon)
    except httpx.HTTPError:
        raise HTTPException(status_code=503, detail="Hava durumu servisine ulaşılamadı")

    times = h["time"]
    feels = h["apparent_temperature"]
    wind = h["wind_speed_10m"]
    rain = h["precipitation_probability"]
    uv = h["uv_index"]

    scores = [score_hour(feels[i], wind[i], rain[i], uv[i], activity) for i in range(len(times))]

    now_key = datetime.now(ZoneInfo("Europe/Istanbul")).strftime("%Y-%m-%dT%H:00")
    now_i = times.index(now_key) if now_key in times else None

    window = best_window(times, scores)
    best, warnings = None, []
    if window:
        start, end = window
        label = window_label(times, start, end)
        best = {"start": label[:5], "end": label[-5:]}
        warnings = window_warnings(feels, rain, uv, start, end)

    return {
        "activity": activity,
        "now": {"time": times[now_i][11:16], "score": scores[now_i]} if now_i is not None else None,
        "best_window": best,
        "warnings": warnings,
        "hourly": [
            {"time": times[i][11:16], "score": scores[i], "feels_like": feels[i],
             "wind": wind[i], "rain_prob": rain[i], "uv": uv[i]}
            for i in range(len(times))
        ],
    }