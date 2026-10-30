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
    if uv >= 8:
        score -= 3
    elif uv >= 6:
        score -= 1

    return max(score, 0)


def best_window(times, scores, threshold=8):
    """Gündüz saatlerinde art arda en uzun iyi aralığı bulur (başlangıç, bitiş).
    06-16 arasında başlayan aralıklar öncelikli."""
    windows = []
    start = None
    for i in range(len(times)):
        hour = int(times[i][11:13])
        good = 6 <= hour < 21 and scores[i] >= threshold
        if good and start is None:
            start = i
        elif not good and start is not None:
            windows.append((start, i))
            start = None
    if start is not None:
        windows.append((start, len(times)))

    if not windows:
        return None

    early = [w for w in windows if int(times[w[0]][11:13]) < 16]
    pool = early if early else windows
    return max(pool, key=lambda w: w[1] - w[0])


def window_label(times, start, end):
    """(start, end) aralığını '10:00–13:00' gibi yazıya çevirir."""
    end_hour = int(times[end - 1][11:13]) + 1
    return f"{times[start][11:16]}–{end_hour:02d}:00"


def window_warnings(feels_like, rain_prob, uv, start, end):
    """Önerilen aralıkta dikkat edilmesi gerekenler."""
    notes = []
    coldest = min(feels_like[start:end])
    rainiest = max(rain_prob[start:end])
    highest_uv = max(uv[start:end])
    if coldest <= 12:
        notes.append(f"Serin (en düşük {coldest:.0f}°C), kat kat giyin")
    if rainiest >= 30:
        notes.append(f"Yağmur ihtimali %{rainiest}, yağmurluk al")
    if highest_uv >= 8:
        notes.append(f"UV çok yüksek ({highest_uv:.0f}), öğlen saatlerinde gölgede kal")
    elif highest_uv >= 3:
        notes.append(f"UV {highest_uv:.0f}, güneş kremi ve şapka önerilir")
    return notes