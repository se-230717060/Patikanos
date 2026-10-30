def score_hour(feels_like, wind, rain_prob, uv, activity):
    """Bir saatin bisiklet veya yürüyüş için uygunluk skoru (0-10)."""
    bike = activity == "bike"
    score = 10

    # Sıcaklık
    if feels_like > 32:
        score -= 4
    elif feels_like >= 27:
        score -= 2
    elif feels_like <= 12 and bike:
        score -= 3

    # Yağmur
    heavy_rain = rain_prob > 60
    light_rain = 30 <= rain_prob <= 60
    if heavy_rain:
        score -= 5 if bike else 3
    elif light_rain:
        score -= 2 if bike else 1

    # Rüzgâr
    strong_wind = wind > 30
    moderate_wind = 20 <= wind <= 30
    if strong_wind:
        score -= 4 if bike else 1
    elif moderate_wind and bike:
        score -= 2

    # Fırtına: yüksek yağmur + sert rüzgâr birlikte
    if heavy_rain and strong_wind:
        score -= 2 if bike else 3

    # UV
    if uv > 7:
        score -= 2

    return max(score, 0)