from app.core import add, divide, multiply, subtract
from app.main import app
from fastapi.testclient import TestClient


def test_core_math():
    assert add(2, 3) == 5
    assert subtract(10, 4) == 6
    assert multiply(3, 4) == 12
    assert divide(10, 2) == 5.0
    try:
        divide(10, 0)
    except ZeroDivisionError:
        pass
    else:
        assert False, "Should raise ZeroDivisionError"


def test_health():
    client = TestClient(app)
    response = client.get("/api/health")
    assert response.status_code == 200
    assert response.json() == {
        "status": "ok",
        "checks": {"add": "ok", "metrics": "ok"},
        "errors": {},
    }


def test_add_route():
    client = TestClient(app)
    response = client.get("/api/add?x=2&y=3")
    assert response.status_code == 200
    assert response.json() == {"result": 5}


def test_subtract_route():
    client = TestClient(app)
    response = client.get("/api/subtract?x=10&y=4")
    assert response.status_code == 200
    assert response.json() == {"result": 6}


def test_multiply_route():
    client = TestClient(app)
    response = client.get("/api/multiply?x=3&y=4")
    assert response.status_code == 200
    assert response.json() == {"result": 12}


def test_divide_route():
    client = TestClient(app)
    response = client.get("/api/divide?x=10&y=2")
    assert response.status_code == 200
    assert response.json() == {"result": 5.0}


def test_divide_by_zero_route():
    client = TestClient(app)
    response = client.get("/api/divide?x=10&y=0")
    assert response.status_code == 400
    assert response.json() == {"detail": "division by zero"}


def test_metrics():
    client = TestClient(app)
    response = client.get("/metrics")
    assert response.status_code == 200
    assert "text/plain" in response.headers.get("content-type", "")
