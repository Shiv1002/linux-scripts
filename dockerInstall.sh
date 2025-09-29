#!/bin/bash

PM="apt-get"

## Function to check for and handle errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: The last command failed."
        exit 1
    fi
}

# Remove any docker installs
echo -e "\nRemoving any Docker components\n"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
	${PM} remove $pkg; 
done
check_error

echo -e  "\n1. Updating Packages...\n"
${PM} update

echo -e "\n2. Installing Curl Ca Certificates...\n"
${PM} install ca-certificates curl
check_error

echo -e "\n3. Installing Keyrings...\n"
install -m 0755 -d /etc/apt/keyrings
check_error

echo -e "\n4. Putting Ubuntu Image Enc key in Keyrings...\n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
check_error

echo -e "\n5. Permission Change of Keyrings...\n"
chmod a+r /etc/apt/keyrings/docker.asc
check_error

echo -e "\n6. Update docker config...\n"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
check_error

echo -e "\n7. Installing docker...\n"
${PM} install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_error

echo "✅ Successfully installed Docker-engine."
echo "Starting and enabling docker service..."
systemctl enable docker --now
check_error

# Display the running status
systemctl status docker | grep "Active:"

echo "Install Complete!"
