from app.weather.scoring import score_hour


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