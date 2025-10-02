#!/bin/bash

PM="apt-get"
LOG_PREFIX="[DEBUG] "

## Function to check for and handle errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: The last command failed."
        exit 1
    fi
}

echo "${LOG_PREFIX} 1. Installing DVWA"
sudo docker pull vulnerables/web-dvwa
check_error
sudo docker create --name dvwa -p 80:80 -it vulnerables/web-dvwa /bin/bash

echo "${LOG_PREFIX} 2. Installing WebGoat"
sudo docker pull szsecurity/webgoat
check_error
sudo docker create --name webgoat -p 80:8080 -it szsecurity/webgoat /bin/bash


echo "${LOG_PREFIX} 3. Installing BWAPP"
sudo docker pull raesene/bwapp
check_error
sudo docker create --name bwapp -p 8080:80 -it raesene/bwapp

echo "${LOG_PREFIX} 4. Installing Juice-Shop"
sudo docker pull bkimminich/juice-shop
check_error
sudo docker create --name juicy -p 80:3000 -it bkimminich/juice-shop

echo "${LOG_PREFIX} List Docker Images"
docker ps -a

