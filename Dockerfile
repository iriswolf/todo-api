# build layer
FROM python:3.13-slim AS builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_HOME=/opt/poetry

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="$POETRY_HOME/bin:$PATH"
RUN python -m venv $POETRY_HOME
RUN $POETRY_HOME/bin/pip install poetry==2.1.2

WORKDIR /app

COPY pyproject.toml poetry.lock ./
# RUN $POETRY_HOME/bin/poetry install --no-root --only main
RUN poetry config virtualenvs.create false \
 && poetry install --no-root --only main

COPY . .

# runtime layer
FROM python:3.13-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY --from=builder /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu

WORKDIR /app
COPY --from=builder /app /app
COPY --from=builder /usr/local /usr/local

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
