FROM python:3.10-slim

RUN apt-get update && apt-get install -y wget gnupg ca-certificates --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install hanya Chromium, bukan semua browser
RUN playwright install chromium --with-deps

COPY . .

CMD ["python", "app.py"]
