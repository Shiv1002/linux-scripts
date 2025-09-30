#!/bin/bash

# Configuration
PM="apt-get"
LOG_PREFIX="[DEBUG] "
DOCKER_GPG_URL="https://download.docker.com/linux/debian/gpg"
DOCKER_REPO_URL="https://download.docker.com/linux/debian"

## Function to check for and handle errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: The last command failed."
        exit 1
    fi
}

# --------------------------------------------------------------------------------------------------

echo "${LOG_PREFIX}Starting Docker Installation for Kali Linux (Debian-based)..."

# 1. Remove any conflicting Docker installs
echo "${LOG_PREFIX}1. Removing any conflicting Docker components..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    echo "${LOG_PREFIX}   Attempting to remove package: ${pkg}"
    ${PM} remove -y $pkg > /dev/null 2>&1
done
# Note: check_error is omitted here as removal will fail if packages aren't installed, which is expected.

# 2. Update Packages and Install Prerequisites
echo "${LOG_PREFIX}2. Updating packages and installing prerequisites (ca-certificates, curl)..."
${PM} update
check_error
${PM} install -y ca-certificates curl
check_error

# 3. Setup Keyrings Directory
echo "${LOG_PREFIX}3. Setting up /etc/apt/keyrings directory..."
install -m 0755 -d /etc/apt/keyrings
check_error

# 4. Download and configure the GPG key (Changed to DEBIAN URL)
echo "${LOG_PREFIX}4. Downloading Docker's official GPG key from Debian repository..."
curl -fsSL ${DOCKER_GPG_URL}  -o /etc/apt/keyrings/docker.asc
check_error

echo "${LOG_PREFIX}   Setting permissions for the GPG key."
chmod a+r /etc/apt/keyrings/docker.asc
check_error

# 5. Add the Docker repository to APT sources (Changed to DEBIAN URL and variable logic)
echo "${LOG_PREFIX}5. Adding the Docker Debian stable repository to APT sources list..."
# Determine Debian code name (Kali typically uses Debian testing/sid codenames, but this is the Docker-preferred method)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] ${DOCKER_REPO_URL} \
   bookworm stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_error

# 6. Final APT Update
echo "${LOG_PREFIX}6. Updating APT package index after adding new repository..."
${PM} update
check_error

# 7. Install Docker
echo "${LOG_PREFIX}7. Installing Docker Engine, CLI, Containerd, and Compose plugins..."
${PM} install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_error

# 8. Start and Enable Docker Service
echo "${LOG_PREFIX}8. Enabling and starting the Docker service..."
systemctl enable docker --now
check_error

# 9. Verification
echo -e "\n${LOG_PREFIX}Verification:"
echo "✅ Docker Engine installation complete."
systemctl status docker | grep "Active:"

echo "${LOG_PREFIX}Testing installation with hello-world (requires user to be in docker group or use sudo)..."
# Optional: test run (run as root/sudo for script compatibility)
sudo docker run hello-world

echo "${LOG_PREFIX}Installation script finished."

