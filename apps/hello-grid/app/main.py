from fastapi import FastAPI
from typing import Optional, Dict, Any
import platform
import socket
import os
import psutil
import re

app = FastAPI(title="hello-grid")


def _read_proc_cgroup() -> Optional[str]:
    """
    Try to extract a container id from /proc/self/cgroup.
    Returns a short container id (12 chars) or full id if available, or None.
    """
    cgroup_path = "/proc/self/cgroup"
    if not os.path.exists(cgroup_path):
        return None

    try:
        with open(cgroup_path, "r") as f:
            for line in f:
                line = line.strip()
                # Typical lines look like:
                # 1:name=systemd:/docker/<containerid>
                # 1:name=systemd:/kubepods/.../pod.../<containerid>
                # Try to find a hex id of length >= 12
                m = re.search(r"([0-9a-fA-F]{12,64})", line)
                if m:
                    # return the full id (or truncated to 12 for readability)
                    full = m.group(1)
                    return full[:12]
    except Exception:
        return None

    return None


def build_metrics_payload() -> Dict[str, Any]:
    """
    Build a metrics payload dictionary suitable for returning from /metrics.
    Separated so unit tests can import and test it without running the server.
    """
    cpu = psutil.cpu_percent(interval=0.1)
    mem = psutil.virtual_memory().percent
    pid = os.getpid()
    container_id = _read_proc_cgroup()

    payload: Dict[str, Any] = {
        "cpu_percent": cpu,
        "mem_percent": mem,
        "pid": pid,
        "container_id": container_id,
    }

    # Add load average when available (POSIX)
    try:
        if hasattr(os, "getloadavg"):
            load1, load5, load15 = os.getloadavg()
            payload["load_avg"] = {"1": load1, "5": load5, "15": load15}
    except Exception:
        # Ignore if not supported
        pass

    return payload


@app.get("/")
def root():
    hostname = platform.node() or socket.gethostname()
    return {"service": "hello-grid", "host": hostname}


@app.get("/metrics")
def metrics():
    return build_metrics_payload()
