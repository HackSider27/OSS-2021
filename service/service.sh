#!/bin/bash

function expand {
    echo 'Expanding swap area...'  

    newfile='/swapfile'$1
    dd if=/dev/zero of=$newfile bs=1024 count=$1 
    chmod 600 $newfile  
    mkswap $newfile  
    swapon $newfile  

    echo $newfile 'swap swap defaults 0 0' >> /etc/fstab  

}

function check {

    swap=$(free -b | grep 'Swap' | tr -s ' ')
    swapsize=$($swap | cut -d' ' -f2)
    freesize=$($swap | cut -d' ' -f4)

    if (( freesize < (swapsize / 2) ))
    then
        expand swapsize
    fi
}

while true
do 
    check
    sleep 30 &
    wait
done
