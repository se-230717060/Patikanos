import httpx

from app.weather.scoring import score_hour, best_window, window_label, window_warnings

URL = "https://api.open-meteo.com/v1/forecast"

params = {
    "latitude": 37.21,
    "longitude": 28.36,
    "hourly": "temperature_2m,apparent_temperature,wind_speed_10m,precipitation_probability,uv_index",
    "timezone": "Europe/Istanbul",
    "forecast_days": 1,
}

response = httpx.get(URL, params=params, timeout=10)
hourly = response.json()["hourly"]

times = hourly["time"]
feels = hourly["apparent_temperature"]
wind = hourly["wind_speed_10m"]
rain = hourly["precipitation_probability"]
uv = hourly["uv_index"]

scores = {"bike": [], "walk": []}
for i in range(len(times)):
    for activity in scores:
        scores[activity].append(score_hour(feels[i], wind[i], rain[i], uv[i], activity))
    print(f"{times[i][11:16]} → hissedilen {feels[i]}°C, rüzgâr {wind[i]}, yağış %{rain[i]}, UV {uv[i]}"
          f"  |  🚲 {scores['bike'][i]}  🚶 {scores['walk'][i]}")

print()
for activity, emoji, name in [("bike", "🚲", "Bisiklet"), ("walk", "🚶", "Yürüyüş")]:
    window = best_window(times, scores[activity])
    if window is None:
        print(f"{emoji} {name}: Bugün uygun saat yok")
        continue
    start, end = window
    print(f"{emoji} {name} için en iyi zaman: {window_label(times, start, end)}")
    for note in window_warnings(feels, rain, uv, start, end):
        print(f"   ⚠️ {note}")