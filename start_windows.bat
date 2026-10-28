@echo off
setlocal
cd /d %~dp0

echo [ISERS] Checking Python version...
py -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)" >nul 2>&1
if errorlevel 1 (
  echo.
  echo ERROR: ISERS requires Python 3.10 or newer.
  echo Install Python 3.10+ from python.org and ensure the Python Launcher ^(py^) is enabled.
  pause
  exit /b 1
)

if not exist .venv (
  echo [ISERS] Creating virtual environment...
  py -m venv .venv
)

call .venv\Scripts\activate
if errorlevel 1 (
  echo ERROR: Could not activate the virtual environment.
  pause
  exit /b 1
)

echo [ISERS] Installing/updating local dependencies...
python -m pip install -r requirements-local.txt
if errorlevel 1 (
  echo ERROR: Dependency installation failed.
  pause
  exit /b 1
)

cd backend

echo [ISERS] Starting on http://127.0.0.1:8000 ...
start "ISERS Server" cmd /k "uvicorn app.main:app --host 127.0.0.1 --port 8000"
timeout /t 3 >nul
start "" http://127.0.0.1:8000
