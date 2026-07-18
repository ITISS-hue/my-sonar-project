# 1. Image vulnerability patches ke liye updated secure version use karein
FROM python:3.12-slim

# 2. Environment variables set karein
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/app

# 3. Create a non-privileged system user
RUN groupadd -g 10001 appuser && \
    useradd -u 10001 -g appuser -m -s /bin/bash appuser

# 4. Copy the source code with proper ownership
COPY --chown=appuser:appuser app.py ./

USER appuser

CMD [ "python", "app.py" ]