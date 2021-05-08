#!/bin/bash

echo '=========================================================='
echo '===   MTIE MIGUEL MANUEL MARTINEZ VAZQUEZ              ==='
echo '=========================================================='

echo ' ___ __ __      ________    ________      ______      '
echo '/__//_//_/\    /________/\ /_______/\    /_____/\     '
echo '\::\| \| \ \   \__.::.__\/ \__.::._\/    \::::_\/_    '
echo ' \:.      \ \     \::\ \      \::\ \      \:\/___/\   '
echo '  \:.\-/\  \ \     \::\ \     _\::\ \__    \::___\/_  '
echo '   \. \  \  \ \     \::\ \   /__\::\__/\    \:\____/\ '
echo '    \__\/ \__\/      \__\/   \________\/     \_____\/ '

echo '  ___     ___      ___  __  __   ___   ___   '
echo ' |   \   / _ \    / __| | |/ /  | __| | _ \  '
echo ' | |) | | (_) |  | (__  | | <   | _|  |   /  '
echo ' |___/   \___/    \___| |_|\_\  |___| |_|_\  '


echo '======1===================================================='
echo '=== PASO 1: CONFIGURACION DE VARAIBLE VM.MAX_MAP_COUNT ==='
echo '=========================================================='
sudo sysctl -w vm.max_map_count=262144
sudo sysctl -p

echo '=========================================================='
echo '===       PASO 2: INSTALACION DE DOCKER-COMPOSE        ==='
echo '=========================================================='
sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo '=========================================================='
echo '===           PASO 3: FIN DEL SCRIPT CONFIG            ==='
echo '=========================================================='

echo '=========================================================='
echo '===          PASO 4: LIMPIADNO REPO LOCAL              ==='
echo '=========================================================='
if [ -d ~/MMMV-CICD/ ]; then
    echo 'sudo rm -R MMMV-CICD'
    sudo rm -R MMMV-CICD
else
    echo 'No existe el repositorio antiguo'
fi

echo '=========================================================='
echo '===           PASO 5: CONFIGURANCDO GIT                ==='
echo '=========================================================='
echo 'alias git="docker run -ti --rm -v $(pwd):/git bwits/docker-git-alpine"'
alias git="docker run -ti --rm -v $(pwd):/git bwits/docker-git-alpine"


echo '=========================================================='
echo '===           PASO 6: CLONANDO REPO                    ==='
echo '=========================================================='
git clone https://github.com/djmai/MMMV-CICD.git
cd MMMV-CICD

# echo '=========================================================='
# echo '===           PASO 7: LIMPIANDO DATA                   ==='
# echo '=========================================================='
# if [ -d ~/volumes/ ]; then
#     echo 'sudo rm -R volumes'
#     sudo rm -R volumes
# else
#     echo ''
#     echo 'No existe la carpeta volumes antigua'
# fi

# if [ -d ~/data/ ]; then
#     echo 'sudo rm -R data'
#     sudo rm -R data
# else
#     echo ''
#     echo 'No existe la carpeta volumes data'
# fi

echo '=========================================================='
echo '===           PASO 8: COPIANDO DATA                    ==='
echo '=========================================================='
if [ -d ./volumes/ ]; then
    sudo cp -ru volumes/ ~/
    sudo mkdir -p ~/volumes/elk-stack/elasticsearch
    cd ~/volumes/elk-stack/
    sudo chmod 777 elasticsearch/
    cd ~/MMMV-CICD
else
    echo 'No existe la carpeta volumes'
fi

if [ -d ./data/ ]; then
    echo 'sudo cp -R data/ ~/'
    sudo cp -ru data/ ~/
else
    echo 'No existe la carpeta data'
fi

echo '=========================================================='
echo '===          PASO 7: DESPLEGANDO CONTENEDORES          ==='
echo '=========================================================='
echo 'sudo docker-compose up --build -d'
sudo docker-compose up --build -d
