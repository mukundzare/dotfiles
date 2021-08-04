#!/usr/bin/zsh 
# echo $jobs
# echo "Current PID: $$"
# echo $jobs | grep -i $$ | wc -l
# If vpn_autoconnect.sh does not exist then run it
# echo $(ps --no-headers | grep -i vpn | wc -l)
# echo Hello $(ps --no-headers | grep -i vpn)
if [[ $(ps --no-headers | grep -i vpn | wc -l) -eq  2 ]]
then
   while true
   do
       if [[  -z $TMUX ]] &&
	      [[ -z $(nmcli con show -active | grep -i 'tun') ]] then
	  osd-vpn-connect
       fi
	  sleep 20
   done
else
       echo "Script already running"
fi

