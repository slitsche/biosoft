#!/bin/bash

# Automated deployment script for biosoft.de
# Builds the Hugo site and uploads to FTP server

set -e  # Exit on error

# Configuration
FTP_HOST="${FTP_HOST:?Error: FTP_HOST environment variable not set}"
FTP_PATH="${FTP_PATH:?Error: FTP_PATH environment variable not set}"

# Check if .netrc exists
if [ ! -f ~/.netrc ]; then
    echo "Error: ~/.netrc not found. Please create it with FTP credentials."
    echo "See deploy.sh comments for setup instructions."
    exit 1
fi

# we expect the deploy script in the root of the project.  Get the absolute path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting deployment..."
echo "======================"

# Step 1: Build the site
echo "Building Hugo site..."
cd "$SCRIPT_DIR"
hugo build

if [ ! -d "public" ]; then
    echo "Error: Build failed - public directory not found"
    exit 1
fi

echo "Build complete: $(find public -type f | wc -l) files generated"

# Step 2: Upload via FTP
echo ""
echo "Uploading to FTP server..."
lftp "$FTP_HOST" << EOF
set ssl:verify-certificate no
mirror -R --delete public/ $FTP_PATH
quit
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Deployment successful!"
    echo "Site deployed to: ftp://$FTP_HOST$FTP_PATH"
else
    echo ""
    echo "✗ Deployment failed!"
    exit 1
fi
