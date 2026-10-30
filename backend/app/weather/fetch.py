import httpx

from app.weather.scoring import score_hour

URL = "https://api.open-meteo.com/v1/forecast"

params = {
    "latitude": 37.21,
    "longitude": 28.36,
    "hourly": "temperature_2m,apparent_temperature,wind_speed_10m,precipitation_probability,uv_index",
    "timezone": "Europe/Istanbul",
    "forecast_days": 1,
}

response = httpx.get(URL, params=params, timeout=10)
data = response.json()
hourly = data["hourly"]

for i in range(len(hourly["time"])):
    saat = hourly["time"][i][11:16]
    sicaklik = hourly["temperature_2m"][i]
    hissedilen = hourly["apparent_temperature"][i]
    ruzgar = hourly["wind_speed_10m"][i]
    yagis = hourly["precipitation_probability"][i]
    uv = hourly["uv_index"][i]

    bisiklet = score_hour(hissedilen, ruzgar, yagis, uv, "bike")
    yuruyus = score_hour(hissedilen, ruzgar, yagis, uv, "walk")

    print(f"{saat} → {sicaklik}°C (hissedilen {hissedilen}), rüzgâr {ruzgar}, yağış %{yagis}, UV {uv}  |  🚲 {bisiklet}  🚶 {yuruyus}")