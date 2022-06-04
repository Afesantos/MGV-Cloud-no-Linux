#!/usr/#!/bin/sh

clear
echo
echo
echo "		Bem vindo a instalação e Configuração do Serviço"
echo "				do MGV Clod Prix"
echo
echo
echo "	Digite uma tecla para continuar"
read resp
clear
echo
echo
echo "	instalando o wget"
sudo apt install wget

echo "	instalando o unzip"
sudo apt install zip unzip -y

clear
echo
echo "	Instalação do Serviço  do Cloud Service"
echo "  Digite uma tecla para continuar"
read resp
wget https://admin.cloudprix.com.br/VersaoSoftware/CPSLinux

echo
echo "	Descompactando a pasta de serviço"
sudo unzip CPSLinux

clear
echo
echo  "		Instalando o .Net Core SDK 3.1"
echo
echo
echo "  Digite uma tecla para continuar"
read resp
echo
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

sudo dpkg -i packages-microsoft-prod.deb

sudo add-apt-repository universe

sudo apt-get install apt-transport-https

sudo apt-get update

sudo apt-get install dotnet-sdk-3.1

export PATH=$PATH:$HOME/dotnet

clear
echo
echo "  Digite uma tecla para visualizar a versão do .Net"
echo "	Depois tecle [Entrar] para continuar."
read resp
dotnet --version

read resp
echo
echo  "	Apagando a pasta zipada do serviço"
rm CPSLinux
clear
echo
echo
echo
echo "  Digite uma tecla para criar o Serviço Cloud Prix Service"
echo "	No final do processo tecle [Enter] para continuar"
read resp
echo
cat > cpls.service <<EOF

[Unit]

Description=Cloud Prix Linux Service

After=network.target


[Service]

ExecStart=/usr/bin/dotnet $(pwd)/CloudPrixServiceLinux/CPLGService.dll 5000

Restart=on-failure


[Install]

WantedBy=multi-user.target

EOF

clear

echo 
echo "	copiando o serviço para a pasta System"
echo
sudo cp cpls.service /lib/systemd/system

sudo systemctl daemon-reload

sudo systemctl enable cpls
clear
echo
echo
echo "		Agora você deverá configurar o serviço da Cloud Prix"
echo
echo
echo "	Será necessário informar:"
echo
echo "		 » As configurações de usuário da Cloud Prix,"
echo "		 » O ambiente que pretende se conectar,"
echo "		 » A assinatura,"
echo "		 » A Porta de comunicação,"
echo "		 » e se irá utilizar proxy."
echo;echo;echo
echo "  Digite uma tecla para continuar"
read resp

cd CloudPrixServiceLinux
sudo dotnet CPLGService.dll setup tdb

clear
echo
echo
echo "	Iniciando o serviço"
sudo systemctl start cpls
clear
echo
echo
echo "  Digite uma tecla para verificar se o Serviço  do Cloud está ativo"
echo
echo " Obs.: O status do serviço deve aparecer como 'ativo' no Terminal."	
echo "		logo após digite [Ctrl + C]"
read resp



clear
echo
echo
echo "		Parabéns o Serviço Cloud Prix Linux foi instalado e configurado!"
echo
echo
echo "		Continue a configuração na página web: https://mgv.cloudprix.com.br/"
echo


