# test_app.py
from app import app

def test_root_ok():
    client = app.test_client()
    resp = client.get('/')
    assert resp.status_code == 200
    assert "Halo dari Flask + Docker + Jenkins!" in resp.get_data(as_text=True)
