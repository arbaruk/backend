from django.test import Client


def test_health_django():
    c = Client()
    resp = c.get('/healthz')
    assert resp.status_code == 200
    assert resp.json() == {'status': 'ok'}
