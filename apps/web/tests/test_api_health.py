import httpx

def test_api_health():
    r = httpx.get("http://api:8001/healthz", timeout=5)
    assert r.status_code == 200
    assert r.json().get("status") == "ok"
