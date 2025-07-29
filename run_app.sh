#!/bin/bash

set -e

REPO_SSH_URL="git@github.com:amitranjan9708/polling_app.git"
APP_DIR="polling_app"

echo "[INFO] Cloning repository..."
if [ -d "$APP_DIR" ]; then
  echo "[WARN] Directory already exists. Removing it."
  rm -rf "$APP_DIR"
fi

if ! git clone "$REPO_SSH_URL"; then
  echo "[ERROR] Git clone failed. Check SSH config and repo URL."
  exit 1
fi

echo "[INFO] Running the JAR..."
cd "$APP_DIR"

JAR_PATH="build/libs/project.jar"
if [ ! -f "$JAR_PATH" ]; then
  echo "[ERROR] JAR file not found at $JAR_PATH"
  exit 1
fi

nohup java -jar "$JAR_PATH" > app.log 2>&1 &
APP_PID=$!
echo "[INFO] App started with PID $APP_PID on port 9000."
