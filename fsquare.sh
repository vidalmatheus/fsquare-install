#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'
BLUE='\033[0;34m'
LBLU='\033[1;34m'

export PYTHON_VERSION=3.10.0
export PYTHON_MAJOR=3
export COMPOSER_VERSION=1.29.2  # ver https://github.com/docker/compose/releases


echo -e "${LBLU}
         ______      _____
        |  ____|    / ____|
        | |__ _____| (___   __ _ _   _  __ _ _ __ ___
        |  __|______\___ \ / _\` | | | |/ _\` | '__/ _ \\
        | |         ____) | (_| | |_| | (_| | | |  __/
        |_|        |_____/ \__, |\__,_|\__,_|_|  \___|
                              | |
                              |_|
${RESTORE}"
echo -e "${LBLU}                Configure your installation\n${RESTORE}"

read -p "$(echo -e ${BLUE}"? "${RESTORE}${LBLU}"Python 3.10 (Y/n): "${RESTORE})" installpython
read -p "$(echo -e ${BLUE}"? "${RESTORE}${LBLU}"nvm (Y/n): "${RESTORE})" installnvm
read -p "$(echo -e ${BLUE}"? "${RESTORE}${LBLU}"Vue.js (Y/n): "${RESTORE})" installvue
read -p "$(echo -e ${BLUE}"? "${RESTORE}${LBLU}"Docker (Y/n): "${RESTORE})" installdocker
read -p "$(echo -e ${BLUE}"? "${RESTORE}${LBLU}"Docker Compose (Y/n): "${RESTORE})" installdockercompose
read -p "$(echo -e ${BLUE}"? "${RESTORE}${LBLU}"Have a f-square instance in ~/projects/ (y/N): "${RESTORE})" haveinstance

read -p "$(echo -e ${YELLOW}"\nAre you sure? (Y/n): "${RESTORE})" confirm


case $confirm in [nN][oO]|[nN])
  return;;
esac

case $installpython in [nN][oO]|[nN]);;*)
  echo -e "${GREEN}\n\t 1. Installing Python${PYTHON_VERSION}${RESTORE}\n"
  sudo apt update
  sudo apt install wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev


  wget -c https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz

  curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
  tar -xvzf Python-${PYTHON_VERSION}.tgz
  cd Python-${PYTHON_VERSION}

  ./configure --enable-optimizations

  sudo make install -j4


  # Set Python3.10 as python
  # sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.10 1

  # Set Pip3.10 as pip
  # sudo update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.10 1

  python3.10 --version
  pip3.10 --version


  # Clear python installation files
  cd
  sudo rm -rf Python-${PYTHON_VERSION}.tar.xz
  sudo rm -rf Python-${PYTHON_VERSION}
esac

case $installnvm in [nN][oO]|[nN]);;*)
  echo -e "${GREEN}\n\t 2. Installing nvm${RESTORE}\n"
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

  nvm --version
esac

case $installvue in [nN][oO]|[nN]);;*)
  echo -e "${GREEN}\n\t 3. Installing vue, vue/cli and vue/cli-init${RESTORE}\n"
  nvm use 16
  npm install vue
  npm install -g @vue/cli
  npm install -g @vue/cli-init
esac


case $installdocker in [nN][oO]|[nN]);;*)
  echo -e "${GREEN}\n\t 4. Installing docker${RESTORE}\n"
  sudo apt-get update
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io
  sudo apt-get install docker-ce

  echo -e "${GREEN}\n\t Checking docker hello-world${RESTORE}\n"
  sudo docker run hello-world

  echo -e "${GREEN}\n\t Adding your user to docker group${RESTORE}\n"
  echo -e "${GREEN}\n\t You need to logoff and login for that${RESTORE}\n"
  sudo usermod -aG docker ubuntu
esac


case $installdocker in [nN][oO]|[nN]);;*)
  echo -e "${GREEN}\n\t 5. Installing docker-compose${RESTORE}\n"
  sudo curl -L https://github.com/docker/compose/releases/download/$COMPOSER_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

  echo -e "${GREEN}\n\t Checking docker-compose${RESTORE}\n"
  docker-compose --version
esac


case $haveinstance in [yY][oO]|[yY]);;*)
  # Create projects directory
  if ! [ -d "projects" ]; then
    mkdir projects
  fi
  cd projects

  echo -e "${GREEN}\n\t Instantiating Vue CLI F-Square template${RESTORE}\n"
  vue init vidalmatheus/fsquare laranja
esac

# Create alias for the project
echo "alias laranja='cd ~/projects/laranja;
        source ~/projects/.virtualenv/laranja/bin/activate;
        nvm use 16'" | sudo tee -a ~/.bashrc >> /dev/null

# Create a virtualenv for the project
pip3.10 install virtualenv
cd projects
mkdir .virtualenv
virtualenv -p python3.10 .virtualenv/laranja >> /dev/null;
. ~/projects/.virtualenv/laranja/bin/activate;
cd laranja


echo -e "${GREEN}\n\t Installing python modules${RESTORE}\n"
pip install -r requirements.txt

echo -e "${GREEN}\n\t Installing node modules${RESTORE}\n"
cd frontend
npm i
cd ..

echo -e "${GREEN}\n\t Checking virtualenv${RESTORE}\n"
python --version
pip --version


echo -e "${GREEN}\nYou are good to go! \o/ \nYou can use ${YELLOW}laranja${RESTORE} ${GREEN}anywhere to go to your project \o/\n${RESTORE}"
