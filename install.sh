#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
plain='\033[0m'


# Первоначальная настройка
init_setup() {
	echo "\033[0;34mОбновление и загрузка пакетов"
	apt update && apt upgrade -y
	apt install sudo vim net-tools tree ncdu bash-completion curl dnsutils htop iftop pwgen screen wget git -y


	# Задание юзера
	echo -e "${blue}Задание юзера${blue}"

	read -p "Напиши юзернейм: " USERNAME
	if grep $USERNAME /etc/passwd
	then
		echo "Юзер $USERNAME уже существует"
	else
		read -p "Придумай пароль: " $PASS
		while [[ ${#PASS} -le 4 ]]
		do
			read -p "Пароль должен быть больше 4 символов: " PASS
		done
	
		sudo useradd -m -s /bin/bash $USERNAME
		sudo usermod -aG sudo $USERNAME
		ENCRYPTED_PASSWORD=$(openssl passwd -1 "$PASS")
		sudo usermod --password "$ENCRYPTED_PASSWORD" "$USERNAME"

		echo "Username: $USERNAME"
		echo "Password: $PASS"
	fi
}


	
# Установка панели
panel_download() {
	echo -e "${blue}Установка панели${blue}"	
	if sudo find /usr/local -name x-ui
	then
		echo "3xui уже установлен"
	finally
		sudo bash < <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
	fi
}

# Сканер ip-адресов в одной подсети
ip_scan() {
	echo -e "${blue}Сканер ip-адресов в одной подсети${blue}"

	read -p "Установка языка GO. Версия (по умолчанию 1.24.1): " -e GO_VERSION
	rm -rf /usr/local/go

	if [[ $GO_VERSION == "" ]] || [[ $GO_VERSION == " " ]]
	then 
		GO_VERSION="1.24.1"
	fi

	wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz

	# Распакоука пакета
	echo "Распакоука пакета"
	sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
	export PATH=$PATH:/usr/local/go/bin

	echo "Installing XTLS/Scanner"
	git clone "https://github.com/XTLS/RealiTLScanner.git"
	cd RealiTLScanner
	go build
}


while true; 
do
	sleep 2
	echo -e "1 - Первоначальная установка"
	echo "2 - Установка панели"
	echo "3 - Сканер IP"
	read -p "Выберите пункт: " CHOICE

	case $CHOICE in
	      1)
		init_setup
		;;
	      2)
		panel_download
		;;
	      3)
		ip_scan
		;;
	      *)
		echo $CHOICE
		echo "Неверный пункт. Пожалуйста, выберите правильную цифру в меню."
		;;
	esac
done
