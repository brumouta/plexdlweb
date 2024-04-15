FROM --platform=linux/amd64 python:3.12-alpine AS base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

WORKDIR /app

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

COPY . .

RUN addgroup -S plexdlweb \
    && adduser -S plexdlweb -G plexdlweb

RUN sh -c "pip install -r requirements.txt"

ENV CONFIG_PATH="/config/config.json"

RUN mkdir /config
RUN python config.py

RUN chown -R plexdlweb .
RUN chown -R plexdlweb "$CONFIG_PATH"

EXPOSE 8766

USER plexdlweb
ENTRYPOINT ["python", "__main__.py"]
