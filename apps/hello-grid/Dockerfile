FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy only requirements first for better layer caching
COPY requirements.txt /app/requirements.txt

# Install curl for HEALTHCHECK; keep image small
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r /app/requirements.txt

# Copy application code
COPY . /app

# Create a non-root user and switch to it
RUN addgroup --system app && adduser --system --ingroup app app

USER app

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD curl -f http://127.0.0.1:8000/ || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
