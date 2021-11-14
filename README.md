  # F-Square Installation
  ## Shell script for installation of a F-Square app.

                              ______      _____
                              |  ____|    / ____|
                              | |__ _____| (___   __ _ _   _  __ _ _ __ ___
                              |  __|______\___ \ / _` | | | |/ _` | '__/ _ \
                              | |         ____) | (_| | |_| | (_| | | |  __/
                              |_|        |_____/ \__, |\__,_|\__,_|_|  \___|
                                                    | |
                                                    |_|

# In your home directory, do:
```bash
source fsquare.sh
```

  # 1. Compile & install Python 3.10/pip 3.10
  ```bash
    export PYTHON_VERSION=3.10.0
    export PYTHON_MAJOR=3

    sudo apt update
    sudo apt install wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

    curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
    tar -xvzf Python-${PYTHON_VERSION}.tgz
    cd Python-${PYTHON_VERSION}

    ./configure --enable-optimizations

    sudo make install -j4


    # (Optional) Set Python3.10 as python
    # sudo update-alternatives --install /usr/bin/python python /usr/local/bin/python3.10 1

    # (Optional) Set Pip3.10 as pip
    # sudo update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.10 1

    python3.10 --version
    pip3.10 --version


    # Clear python installation files
    cd
    sudo rm -rf Python-${PYTHON_VERSION}.tar.xz
    sudo rm -rf Python-${PYTHON_VERSION}
  ```

  # 2. Install nvm
  ```bash
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

    nvm --version
  ```

  # 3. Install vue, vue/cli and vue/cli-init
  ```bash
    nvm use 16
    npm install vue
    npm install -g @vue/cli
    npm install -g @vue/cli-init
  ```

  # 4. Install docker
  ```bash
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

    # Checking docker hello-world
    sudo docker run hello-world

    # Adding your user to docker group
    # You need to logoff and login for that
    sudo usermod -aG docker ubuntu
  ```


  # 5. Install docker-compose
  ```bash
    sudo curl -L https://github.com/docker/compose/releases/download/$COMPOSER_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    docker-compose --version
  ```


  # 6. Instanciate Vue CLI F-Square template
  ```bash
    # Create projects directory
    if ! [ -d "projects" ]; then
      mkdir projects
    fi
    cd projects

    vue init vidalmatheus/fsquare <your_project_name>
  ```

  # 7. Create alias for the project
  ```bash
  echo "alias <your_project_name>='cd ~/projects/<your_project_name>;
          source ~/projects/.virtualenv/<your_project_name>/bin/activate;
          nvm use 16'" | sudo tee -a ~/.bashrc >> /dev/null
  ```

  # 8. Create a virtualenv for the project
  ```bash
  pip3.10 install virtualenv
  cd projects
  mkdir .virtualenv
  virtualenv -p python3.10 .virtualenv/<your_project_name> >> /dev/null;
  . ~/projects/.virtualenv/<your_project_name>/bin/activate;
  cd <your_project_name>
  ```

  # 9. Install python modules
  ```bash
  pip install -r requirements.txt
  ```

  # 10. Install node modules
  ```bash
  cd frontend
  npm i
  cd ..
  ```

  # 11. Check virtualenv
  ```bash
  python --version
  pip --version
  ```

  ## You are good to go!
  ### You can use <your_project_name> anywhere to go to your project
