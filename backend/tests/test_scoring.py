from app.weather.scoring import score_hour, best_window, window_label


def test_ideal_weather():
    assert score_hour(18, 10, 0, 3, "bike") == 10
    assert score_hour(18, 10, 0, 3, "walk") == 10


def test_light_rain_light_wind():
    assert score_hour(18, 10, 45, 3, "bike") == 8
    assert score_hour(18, 10, 45, 3, "walk") == 9


def test_light_rain_strong_wind_hits_bike_more():
    assert score_hour(18, 35, 45, 3, "bike") == 4
    assert score_hour(18, 35, 45, 3, "walk") == 8


def test_storm():
    assert score_hour(18, 35, 80, 3, "bike") == 0
    assert score_hour(18, 35, 80, 3, "walk") == 3


def test_cold_affects_only_bike():
    assert score_hour(10, 5, 0, 1, "bike") == 7
    assert score_hour(10, 5, 0, 1, "walk") == 10


def test_score_never_negative():
    assert score_hour(40, 50, 100, 11, "bike") == 0


TIMES = [f"2026-10-30T{h:02d}:00" for h in range(24)]


def test_best_window_finds_good_stretch():
    scores = [5] * 24
    for h in range(8, 12):
        scores[h] = 9
    start, end = best_window(TIMES, scores)
    assert window_label(TIMES, start, end) == "08:00–12:00"


def test_best_window_ignores_night():
    scores = [10] * 24
    start, end = best_window(TIMES, scores)
    assert window_label(TIMES, start, end) == "06:00–21:00"


def test_best_window_prefers_before_16():
    scores = [5] * 24
    for h in (9, 10):
        scores[h] = 9            # sabah: 2 saat
    for h in (16, 17, 18, 19):
        scores[h] = 9            # akşam: 4 saat, daha uzun
    start, end = best_window(TIMES, scores)
    assert window_label(TIMES, start, end) == "09:00–11:00"


def test_no_good_hours():
    assert best_window(TIMES, [5] * 24) is None