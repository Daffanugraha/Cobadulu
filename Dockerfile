# Gunakan image Python ringan
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install Chrome & driver minimal
RUN apt-get update && apt-get install -y \
    chromium-driver chromium fonts-liberation \
    libasound2 libatk-bridge2.0-0 libnss3 libxss1 libgbm1 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Salin requirements
COPY requirements.txt .

# Install dependencies tanpa cache
RUN pip install --no-cache-dir -r requirements.txt

# Copy seluruh project
COPY . .

# Jalankan Streamlit di Railway
CMD ["streamlit", "run", "app.py", "--server.port=8080", "--server.address=0.0.0.0"]
