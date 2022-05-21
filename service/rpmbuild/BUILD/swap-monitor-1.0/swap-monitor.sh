#!/bin/bash
touch ~/swap-service.log; 
logger "Start swap service.";
sudo tail -1 /var/log/messages >> ~/swap-monitor.log

function check_swap {
used="$( free -ms 30 | tail -1|tr -s ' ' ' '| cut -d' ' -f3)";
total="$( free -ms 30 | tail -1|tr -s ' ' ' '| cut -d' ' -f2)";
	if (( $((used*2)) > $total )); then
		result=1
	else
		result=0
	fi
}

function create_new_swap() {
	sudo dd if=/dev/zero of=/swapfile"$1" bs=1M count=$total;
	sudo chmod 600 /swapfile"$1";
	sudo mkswap /swapfile"$1";
	sudo swapon /swapfile"$1";
}

function delete_swap() {
	sudo swapoff /swapfile"$1"
	sudo rm /swapfile"$1"	
}

finish() {
	echo "Service swap finished."
	logger "Service swap finished."
	sudo tail -1 /var/log/messages >> ~/swap-monitor.log
	exit 0
}

trap_usr1() {
	check_swap
	echo "Signal USR1 received."
	if (( result == 1 )); then 
		logger "Signal USR1 received. Status service: Swap file was created!"
		sudo tail -1 /var/log/messages >> ~/swap-monitor.log
	else
		logger "Signal USR1 received. Status service: New swap file wasn't created."
		sudo tail -1 /var/log/messages >> ~/swap-monitor.log	
	fi	
}

trap trap_usr1 USR1
trap finish SIGINT

k=1

while true; do
	check_swap
	if (( result == 1 )); then 
		create_new_swap "$k" ; 
		let "k += 1";
		logger "Create new file for swap. Double swap space."
		sudo tail -1 /var/log/messages >> ~/swap-monitor.log
	fi
	#sleep 30 &
	#wait
done;

exit 0
	


		
