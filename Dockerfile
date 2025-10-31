FROM python:3.11-slim

# --- install system dependencies required by Chromium & Playwright ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg unzip curl \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 \
    libxrandr2 libgbm1 libasound2 libpangocairo-1.0-0 libcairo2 \
    libpango-1.0-0 libgtk-3-0 fonts-liberation \
    libxshmfence1 libx11-xcb1 xvfb \
    && rm -rf /var/lib/apt/lists/*

# --- install playwright and python dependencies ---
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright and its dependencies
RUN pip install playwright && playwright install --with-deps chromium

# --- copy app ---
COPY . /app

# --- set environment variables to disable sandbox (important for docker) ---
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright \
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0 \
    PYTHONUNBUFFERED=1 \
    MPLCONFIGDIR=/tmp/matplotlib \
    DISPLAY=:99 \
    XDG_RUNTIME_DIR=/tmp/runtime-root

# --- expose port for Streamlit ---
EXPOSE 8501

# --- start Xvfb (virtual display) and run the Streamlit app ---
CMD ["xvfb-run", "-s", "-screen 0 1024x768x24", "streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]

