#!/bin/bash

# Stop any existing server
sudo fuser -k 80/tcp

# Navigate to the deployment directory
cd /home/azureuser/simple-backend-api || exit

# Pull the latest changes from the repository
git pull origin main

# Install dependencies
npm install

# Start the server
sudo npm start &
