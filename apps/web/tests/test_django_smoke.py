from django.conf import settings

def test_django_settings_loaded():
    assert bool(getattr(settings, "SECRET_KEY", "")), "SECRET_KEY vacío"
