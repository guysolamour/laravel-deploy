# Laravel Administrable Deploy

[![Packagist](https://img.shields.io/packagist/v/guysolamour/laravel-administrable-deploy.svg)](https://packagist.org/packages/guysolamour/laravel-administrable-deploy)
[![Packagist](https://poser.pugx.org/guysolamour/laravel-administrable-deploy/d/total.svg)](https://packagist.org/packages/guysolamour/laravel-administrable-deploy)
[![Packagist](https://img.shields.io/packagist/l/guysolamour/laravel-administrable-deploy.svg)](https://packagist.org/packages/guysolamour/laravel-administrable-deploy)


This package allows you to install all the tools necessary to deploy a Laravel project on a VPS or dedicated server.
This package is an extension of the package - [laravel-administrable](https://github.com/guysolamour/administrable) and cannot be used outside of it.
For the complete documentation [it's here](https://guysolamour.github.io/laravel-administrable/).

## Installation

Install via composer
```bash
composer require guysolamour/laravel-deploy
```

## PREREQUIS
1. Fonctionne sur systeme type Unix (MacOs et Linux)
2. avoir une version de bash >= 3 (vous pouvez faire ```bash --version ```) dans le cas contraire mettez a jour le shell bash
3. Installer ansible sur votre machine (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


## PREPARING THE SERVER

1- Connect to the server
```bash
ssh root@000.000.000.000
# 000.000.000.000 must be changed with your server ip address
```


2- Create a user to run the tasks
```bash
sudo useradd user -s /bin/bash -d /home/user -m -G sudo
# user must be changed with your own user
```

3- Add created user to sudoers file
```bash
sudo visudo
# Append user ALL=(ALL) NOPASSWD:ALL at the end of line
# user must be changed with your own user
```

4- Install python on the remote server
```bash
sudo apt install -y python-apt
```

5- Disconnect from the remote machine and copy host machine ssh key for the created user
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@000.000.000.000
# If you dont have generate ssh key before use sshkeygen command to generate newly key
# 000.000.000.000 must be changed with your server ip address
```

### CONFIGURE ANSISTRANO


THE DIFFERENT STEPS

1- Generate the file that will contain the passwords
```bash
./vendor/bin/deploy password:create
# Enter the password that will be used for decryption
# This password must be saved in clear in the .vaultpass file
# This file must not be versioned.
```

2- Add theses variables with the correct data
```yaml
# Le mot de passe de lútilisateur du deploiement
vault_user_password: "password"

# Le mot de passe de la db du deploiement
vault_database_password: "password"

# Le mot de passe de lútilisateur root de la db
vault_database_root_password: "password"

# Le mot de passe utilise en local pour se connecter au backend
vault_admin_local_password: "password"

# Le mot de passe utilise en production pour se connecter au backend
vault_admin_production_password: "password"

# Le mot de passe utilise  pour se connecter au ftp
vault_ftp_password: "password"

# Copy and paste the output of *php artisan key:generate --show command
vault_app_key: "appkey"
```


3- To modify the file containing the passwords
```bash
./vendor/bin/deploy password:edit
```

4- To view the contents of the file
```bash
./vendor/bin/deploy password:view
```

## Usage
Les commandes disponibles
help, scaffold, configure:server

1- Lancer la commande scaffold pour generer les fichiers de base necessaires. Cette commande doit etre execute une fois et au tout debut.
```bash
./vendor/bin/deploy scaffold --host 000.001.002.003 --domain domain.com --application appname
```
ou
```bash
./vendor/bin/deploy scaffold -h 000.001.002.003 -d domain.com -a appname
```




If you discover any security related issues, please email rolandassale@gmail.com
instead of using the issue tracker.

## Credits

- [Guy-roland ASSALE](https://github.com/guysolamour/laravel-administrable-deploy)
- [All contributors](https://github.com/guysolamour/laravel-administrable-deploy/graphs/contributors)

This package is bootstrapped with the help of
[melihovv/laravel-package-generator](https://github.com/melihovv/laravel-package-generator).
