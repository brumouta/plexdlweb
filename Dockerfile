FROM --platform=linux/amd64 python:3.12-alpine AS base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONUNBUFFERED=1

WORKDIR /app

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

COPY plexdlweb ./plexdlweb

RUN addgroup -S plexdlweb \
    && adduser -S plexdlweb -G plexdlweb

RUN addgroup -S plexdlweb \
    && adduser -S plexdlweb -G plexdlweb

RUN chown -R plexdlweb .

USER plexdlweb
RUN sh -c "pip3 install -r plexdlweb/requirements.txt && python plexdlweb/__main__.py"

ENTRYPOINT ["python plexdlweb/__main__.py"]
