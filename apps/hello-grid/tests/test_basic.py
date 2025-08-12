import sys
import os
import types
import pytest

# Ensure the app package is importable when running tests from repo root
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from app.main import build_metrics_payload


def test_build_metrics_payload_smoke():
    payload = build_metrics_payload()
    assert isinstance(payload, dict)
    assert "cpu_percent" in payload
    assert "mem_percent" in payload
    assert "pid" in payload
    # cpu and mem should be numeric
    assert isinstance(payload["cpu_percent"], (int, float))
    assert isinstance(payload["mem_percent"], (int, float))
    assert isinstance(payload["pid"], int)
