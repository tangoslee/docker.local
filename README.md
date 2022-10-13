# How to build local environment

## Directory Structure
```shell
.
├── src
│   └── mysql-files
├── var
│   └── lib
│       └── mysql
└── workspace
    ├── docker.local
    │   └── bin
    └── www
        ├── php8.localhost
        │   └── public
        └── tendopay.localhost
            └── public
```

## Pre-requirements
### Mac
#### Install Docker
- https://docs.docker.com/desktop/install/mac-install/
#### Install brew packages
```shell
brew install coreutils
brew install mysql-client
echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.zshrc
```
#### Create directory
```shell
mkdir -p $HOME/src/mysql-files
mkdir -p $HOME/var/lib/mysql
mkdir -p $HOME/var/lib/data.ms
mkdir -p $HOME/workspace/www/php8.localhost/public
mkdir -p $HOME/workspace/www/tendopay.localhost/public
```
#### Setup DNSMasquerading
```shell
brew install dnsmasq
```
- Create dnsmasq conf
```shell
mkdir -p $HOME/.config/valet
cat<<EOF > $HOME/.config/valet/dnsmasq.conf
# Local development server (custom setting)
address=/.localhost/127.0.0.1
port=53
EOF
```
- Start dnsmasq
```shell
brew tap homebrew/services
sudo brew services start dnsmasq
```
- Add .localhost resolver
```shell
sudo mkdir -pv /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localhost'
```
- Flush DNS cache
```shell
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

- https://firxworx.com/blog/it-devops/sysadmin/using-dnsmasq-on-macos-to-setup-a-local-domain-for-development/

### Windows
#### Install Docker
- https://docs.docker.com/desktop/install/windows-install/

### Linux
#### Install Docker
- https://docs.docker.com/desktop/install/linux-install/
#### Create directory
```shell
mkdir -p $HOME/src/mysql-files
mkdir -p $HOME/var/lib/mysql
mkdir -p $HOME/var/lib/data.ms
mkdir -p $HOME/workspace/www/php8.localhost/public
mkdir -p $HOME/workspace/www/tendopay.localhost/public
```

## Setup docker.local
### Download
```shell
cd workspace
wget https://github.com/tangoslee/docker.local/archive/refs/tags/v0.1.0.tar.gz -O docler.local.tgz
tar xvfz docker.local.tgz
cd docker.local
```
### Configuration
```shell
cp .env.example .env
```
```dotenv
# echo $UID
USER_UID=1000
# whoami
USER=tangos
# For Window
#HOME=C:\Users\tangos
# For Ubuntu
HOME=/home/tangos
# For Mac
#HOME=/Users/tangos

DATA_DIR=${HOME}/var/lib
APP_DIR=${HOME}/workspace/www
TMP_DIR=/tmp
LOG_DIR=./logs
DB_DUMP_DIR=${HOME}/src/mysql-files
CONTAINER_HOME=/home/${USER}

# DB
DB_HOST=db.localhost
DB_PORT=3306
DB_DATABASE=forge
DB_USERNAME=forge
DB_PASSWORD=forge

# REDIS
REDIS_PORT=6379

# MEILISEARCH
MEILISEARCH_PORT=7700
MEILISEARCH_DATA=${DATA_DIR}/data.ms
MEILISEARCH_KEY=masterKey

# Resource
PHP_MEMORY_LIMITS=2G
PHP8_MEMORY_LIMITS=2G
MYSQL_MEMORY_LIMITS=4G
NGIX_MEMORY_LIMITS=128M
REDIS_MEMORY_LIMITS=16M
MEILSEARCH_MEMORY_LIMITS=512M
```

### Start docker.local
#### Mac
```shell
cd docker.local
docker-compose up --build -d
```
Once the containers are built, they can be managed through the Docker Desktop

#### Windows
```shell
cd docker.local
start.bat
```

#### Linux
```shell
cd docker.local
./start.sh --build
```

## Tutorial (Setting https://tendopay.localhost)

### Create database (Available on Linux and Mac)
```
cd docker.local
./bin/create_db.sh tendopay
```

### Create document root
```shell
mkdir -p $HOME/workspace/www/tendopay.local/public
```

### Create index.php
```shell
cat<<EOF> $HOME/workspace/www/tendopay.local/public/index.php
<?php

$DB_HOST='db.localhost';
$DB_PORT=3306;
$DB_DATABASE='forge';
$DB_USERNAME='forge';
$DB_PASSWORD='forge';

$options = [
  \PDO::ATTR_DEFAULT_FECTH_MODE => \PDO::FETCH_OBJ,
  \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION
];

$dsn = sprintf('mysql:dbname=%s;host=%s', $DB_DATABASE, $DB_HOST);
$pdo = new \PDO($dsn, $DB_USERNAME, $DB_PASSWORD, $options);
$date = $pdo->query("SELECT NOW()")->fetch();
print_r($date);
EOF
```

### Check on chrome
```shell
https://tendopay.localhost
```

