# --- Stage 1: Build & Dependency Gathering ---
FROM python:3.12-slim AS builder

WORKDIR /usr/src/app

# System build dependencies (psutil compilation ke liye)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./

# Packages ko system site-packages mein install kar rahe hain
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# --- Stage 2: Final Secure Runtime Image ---
FROM python:3.12-slim AS runner

# Python optimization parameters setting
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/src/app

# 🛡️ Trivy Compliance: Secure Non-Root User & Group Generation
RUN groupadd -g 10001 appuser && \
    useradd -u 10001 -g appuser -m -s /bin/bash appuser

# Stage 1 se installed python packages ko standard python library path par copy karna
COPY --from=builder /install /usr/local

# Main application code script copy karna non-root user permissions ke saath
COPY --chown=appuser:appuser app.py ./

EXPOSE 80

# Non-root user context switch
USER appuser

# Bufferless tracking mode execution
CMD [ "python", "-u", "app.py" ]