from django.test import Client


def test_django_health():
    c = Client()
    r = c.get("/healthz")
    assert r.status_code == 200
    assert r.json().get("status") == "ok"
