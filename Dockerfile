# Gunakan image Playwright yang sudah siap pakai (ada Chromium & deps)
FROM mcr.microsoft.com/playwright/python:v1.47.0-jammy

# Set working directory
WORKDIR /app

# Salin file yang dibutuhkan
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Jalankan aplikasi
CMD ["python", "app.py"]
