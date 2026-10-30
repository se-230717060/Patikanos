def score_hour(feels_like, wind, rain_prob, uv, activity):
    """Bir saatin bisiklet veya yürüyüş için uygunluk skoru (0-10)."""
    score = 10

    # Sıcaklık
    if feels_like > 32:
        score -= 4
    elif feels_like >= 27:
        score -= 2
    elif feels_like < 8:
        score -= 3 if activity == "bike" else 2

    # Yağış
    if rain_prob > 60:
        score -= 5 if activity == "bike" else 4
    elif rain_prob >= 30:
        score -= 2

    # Rüzgâr
    if wind > 30:
        score -= 4 if activity == "bike" else 1
    elif wind >= 20 and activity == "bike":
        score -= 2

    # UV
    if uv > 7:
        score -= 2

    return max(score, 0)