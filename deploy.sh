#!/bin/bash

# Stop any existing server on port 80
sudo fuser -k 80/tcp

# Create the directory if it does not exist
mkdir -p /var/www/simple-backend-api

# Navigate to the deployment directory
cd /var/www/simple-backend-api || exit

# Check if the repository is already cloned
if [ ! -d ".git" ]; then
  git clone https://github.com/nitin1053/Backend_API.git .
else
  git pull origin main
fi

# Install dependencies
npm install

# Start the server
sudo npm start &
