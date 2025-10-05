## build stage 
FROM python:3.12-slim AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml ./

RUN uv sync --no-install-project --no-editable

## final stage
FROM python:3.12-slim AS final

ENV VIRTUAL_ENV=/app/.venv
ENV PATH="/app/.venv/bin:${PATH}"
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv

## COPY --from=builder /app/tests ./tests
## COPY . /tests

COPY . /app

RUN useradd -m app

EXPOSE 8000

CMD ["uvicorn", "cc_simple_server.server:app", "--host", "0.0.0.0", "--port", "8000"]


