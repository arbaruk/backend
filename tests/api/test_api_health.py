import pytest
from httpx import AsyncClient

from apps.api.app.main import app


@pytest.mark.asyncio
async def test_health():
    async with AsyncClient(app=app, base_url='http://test') as ac:
        r = await ac.get('/healthz')
        assert r.status_code == 200
        assert r.json() == {'status': 'ok'}
