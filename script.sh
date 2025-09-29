#!/bin/bash

# --- Configuration ---
APP_NAME="oneko"
PACKAGE_MANAGER="apt-get"

## Function to check for and handle errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: The last command failed."
        exit 1
    fi
}

## Function to check for root privileges
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "🚨 ERROR: This script must be run as root or with sudo."
        exit 1
    fi
}

# --- Main Script ---

echo "Starting installation of ${APP_NAME}..."

# 1. Check for root access
check_root

# 2. Update the package list
echo "Updating package lists..."
${PACKAGE_MANAGER} update
check_error

# 3. Install the application
echo "Installing ${APP_NAME}..."
# The -y flag automatically answers 'yes' to prompts
${PACKAGE_MANAGER} install -y "${APP_NAME}"
check_error

# 4. Verification and cleanup
echo "✅ Successfully installed ${APP_NAME}."
echo "Starting and enabling ${APP_NAME} service..."
systemctl enable "${APP_NAME}" --now
check_error

# Display the running status
systemctl status "${APP_NAME}" | grep "Active:"

echo "Installation complete!"
