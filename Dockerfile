# 1. Use a specific, official, slim Python version to minimize attack surface
FROM python:3.11-slim

# 2. Set environment variables to prevent Python from writing pyc files & buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Set the working directory securely
WORKDIR /usr/src/app

# 4. Create a non-privileged system user and group for security
RUN groupadd -g 10001 appuser && \
    useradd -u 10001 -g appuser -m -s /bin/bash appuser

# 5. Copy the source code and give ownership to the non-root user
COPY --chown=appuser:appuser app.py ./

# 6. Switch to the non-root user (Crucial for SonarCloud Security Gates)
USER appuser

# 7. Run the secure script
CMD [ "python", "app.py" ]