#!/bin/bash

# --- Letterbox Quick Setup ---
# Automates the initial installation for a new contributor.

echo "--- Letterbox Setup ---"

# 1. Install dependencies
echo "Installing npm dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo "Failed to install dependencies."
    exit 1
fi

# 2. Setup environment variables
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
else
    echo "Environment file (.env) already exists."
fi

# 3. Generate secure API Key
echo "Generating secure INTERNAL_API_KEY..."
NEW_KEY=$(node -e "console.log(require('crypto').randomBytes(16).toString('hex'))")
# Handle different sed variants (macOS/Linux)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/INTERNAL_API_KEY=.*/INTERNAL_API_KEY=$NEW_KEY/" .env
else
    sed -i "s/INTERNAL_API_KEY=.*/INTERNAL_API_KEY=$NEW_KEY/" .env
fi
echo "Secure API Key added to .env"

# 4. Starting Docker (Optional)
echo "Attempting to start infrastructure with Docker..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
    echo "Infrastructure started."
else
    echo "docker-compose not found. Skipping infrastructure step."
fi

echo ""
echo "--- Setup Complete! ---"
echo "You can now run: npm run dev"
