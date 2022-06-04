#!/bin/bash
# Agnaldo Fernandes 26/05/2022
# Versão 1.0
	cpls_arquivo="https://admin.cloudprix.com.br/VersaoSoftwareFile/2116_cloud-prix-linux-service-1.0.265.zip"
	vera=$(uname);verc=$(uname -i);verb=$(echo $DESKTOP_SESSION)
	sudo hostnamectl > CPLS.log 2>&1
	versao=$(grep -i "Operating System:" CPLS.log)
clear
Menu(){
   clear
   echo "	-----------------------------------------------------------------"
   echo "		Bem vindo a instalação e Configuração do Serviço"
   echo "			do MGV Clod Prix - CPLS 1.0.265"
   echo "	-----------------------------------------------------------------"
   echo
   echo "	Sistemas Operacionais Compatíveis:"
   echo
   echo "		-- Linux CentOS 7"
   echo "		--  Ubuntu 16.04, 18.04, 20.04."
   echo
   echo
	echo "	 Sistema:       " $vera $verb $verc
	net=$(dotnet --version) >/dev/null 2>&1

	if [ $? = 0 ]; then
	echo "        .Net instalado:  $net."
	else
	echo "         Versão do .Net:\033[31;1m Não instalado \033m"
	fi
   echo "\033[33;1m	 $versao\033[m"
	service cpls status > CPLS.log 2>&1
	cpls_stat=$(grep "Active:" CPLS.log)
	cpls_status=${cpls_stat}
	sudo rm -rf CPLS.log

	if [ "$cpls_status" = "" ]; then
		echo " 	 Status do servico CPLS: \033[31;1m Não instalado.\033[m"
		else
		echo " 	 Status do servico CPLS: ${cpls_status}"
	fi
   echo
   echo
   echo
   echo "		[ 1 ] Instala o Serviço CPLS"
   echo "		[ 2 ] Desinstalar o .Net"
   echo "		[ 3 ] Desinstalar o serviço Cloud Prix"
   echo "		[ 4 ] Configura Conexão Cloud Prix (somente)"
   echo
   echo "                [ 5 ] Sair"



   echo
   echo
   echo
   echo -n "		Qual a opção desejada ? "
   read opcao
   case $opcao in
      1) InstallCPLS ;;
      2) Rm_net ;;
      3) DeletaCPLS ;;
      4) IniciaConfcpls ;;
      5) exit ;;
      *) "Opção desconhecida." ; echo ; Menu ;;
   esac
} #fim do Menu

 Rm_net() {
	clear
	echo "	REMOVENDO O .NET"
	echo
	sudo apt remove dotnet-host ;
	sudo apt autoremove
	Menu
}

InstallCPLS() {
	clear
	echo
	echo
	echo "	instalando o wget"
	sudo apt install wget

	echo "	instalando o unzip"
	sudo apt install zip unzip -y

	clear
	echo
	echo "	Instalação do Serviço  do Cloud Service";echo
	echo "	  Digite uma tecla para continuar"
	read resp
        #wget https://admin.cloudprix.com.br/VersaoSoftware/CPSLinux
        # wget https://admin.cloudprix.com.br/VersaoSoftwareFile/2116_cloud-prix-linux-service-1.0.265.zip
	sudo wget $cpls_arquivo

	echo
	echo "	Descompactando a pasta de serviço"
	#sudo unzip CPSLinux
	sudo unzip ${cpls_arquivo##*/}
	clear
	echo
	echo  "		Instalando o .Net Core SDK 3.1"
	echo
	echo
	echo -n "  	Digite uma tecla para continuar"
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
#	echo "  Digite uma tecla para visualizar a versão do .Net";echo
#	echo "	Depois tecle [Entrar] para continuar."
#	read resp
#	dotnet --version

#	read resp
	echo
	echo  "	Apagando a pasta zipada do serviço"
	sudo rm -rf ${cpls_arquivo##*/}
	sudo rm -rf CPSLinux


	clear
	echo
	echo
	echo
	echo "  Digite uma tecla para criar o Serviço Cloud Prix Service";echo
	echo "	No final do processo tecle [Enter] para continuar"
	read resp
	echo


	CriaServico="[Unit]\n
	\nDescription=Cloud Prix Linux Service\n
	\nAfter=network.target\n
	\n
	\n[Service]\n
	\nExecStart=/usr/bin/dotnet $(pwd)/CloudPrixServiceLinux/CPLGService.dll 5000\n
	\nRestart=on-failure\n
	\n
	\n[Install]\n
	\nWantedBy=multi-user.target\n"

	echo $CriaServico > cpls.service
	#${CriaServico}

	clear

	echo
	echo "	copiando o serviço para o /etc/init.d  para a inicial. automatica"
	sudo cp  cpls.service /etc/init.d
	sudo chmod +x /etc/init.d/cpls.service 
	echo
	echo "	copiando o serviço para a pasta System"
	echo
	sudo mv cpls.service /lib/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl enable cpls
	echo
IniciaConfcpls
 


	clear
	echo
	echo
	echo "	Iniciando o serviço"
	sudo systemctl start cpls
	clear
	echo
	echo
#	echo "  Digite uma tecla para verificar se o Serviço  do Cloud está ativo"
	echo
#	echo " Obs.: O status do serviço deve aparecer como 'ativo' no Terminal."
#	echo "		logo após digite [Ctrl + C]"
#	read resp



	clear
	echo
	echo
	echo "		Parabéns o Serviço Cloud Prix Linux foi instalado e configurado!"
	echo
	echo
	echo "		Continue a configuração na página web: https://mgv.cloudprix.com.br/"
	echo
	Menu


}

IniciaConfcpls(){
        clear
        echo
        echo
        echo "          Agora você deverá configurar o serviço da Cloud Prix"
        echo
        echo
        echo "  Será necessário informar:"
        echo
        echo "           » As configurações de usuário da Cloud Prix,"
        echo "           » O ambiente que pretende se conectar,"
        echo "           » A assinatura,"
        echo "           » A Porta de comunicação,"
        echo "           » e se irá utilizar proxy."
        echo;echo;echo
        echo -n "  Digite uma tecla para continuar "
        read resp
        clear ;echo
        cd CloudPrixServiceLinux
        sudo dotnet CPLGService.dll setup tdb


}


DeletaCPLS(){
	clear
	echo; echo
	echo "	Removendo o serviço CPLS..."; echo; echo
	sudo apt remove cpls.service
	sudo rm -rf CloudPrixServiceLinux
	sudo rm -rf /lib/systemd/system/cpls.service
	sudo rm -rf /etc/init.d/cpls.service
	echo ; echo
	echo "  Talvez seja necessário reiniciar o Pc"
	echo -n "  Tecle qq tecla p/ continuar..."
	read resp
Menu
}
Menu
