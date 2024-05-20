#!/bin/bash

# Check if the directory exists, if not, create it and clone the repository
if [ ! -d "/var/www/simple-backend-api" ]; then
  sudo mkdir -p /var/www/simple-backend-api
  git clone https://github.com/nitin1053/backend_apis.git /var/www/simple-backend-api
fi

# Change directory to the cloned repository
cd /var/www/simple-backend-api

# Pull the latest changes from the repository
git pull origin main

# Install dependencies
npm install

# Kill any existing Node.js process on port 80
sudo fuser -k 80/tcp || true

# Start the Node.js server on port 80 with sudo
sudo PORT=80 nohup node index.js &
