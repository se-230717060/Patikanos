import httpx

URL = "https://api.open-meteo.com/v1/forecast"


def get_hourly(lat, lon):
    params = {
        "latitude": lat,
        "longitude": lon,
        "hourly": "apparent_temperature,wind_speed_10m,precipitation_probability,uv_index",
        "timezone": "Europe/Istanbul",
        "forecast_days": 1,
    }
    response = httpx.get(URL, params=params, timeout=10)
    response.raise_for_status()
    return response.json()["hourly"]