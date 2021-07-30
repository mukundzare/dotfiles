#!/usr/bin//zsh 
while true
do
    if [[ (-z $TMUX) &&
	      (-z $(nmcli con show -active | grep -i 'tun')) ]] then
       echo "VPN connection not found..autoconnecting"
       echo "VPN stat: $(vpnstat)"
	osd-vpn-connect
    fi
    sleep 150
done
