#!/bin/bash

entreprise=`cat /etc/overview/entreprise`
ip=`cat /etc/overview/ip`
        cat /proc/cpuinfo > /etc/overview/test
        dmidecode > /etc/overview/test2
        lshw -C network > /etc/overview/test3
        lshw -C cpu > /etc/overview/test4
        lsblk -l > /etc/overview/test5
        lshw -C storage > /etc/overview/test6
        #sed -i "s/^[ \t]//g" /etc/overview/test2
        #sed -i "s/ //g" /etc/overview/test2
        touch /etc/overview/$entreprise_$ip
        echo "BI0S information" > /etc/overview/$entreprise_$ip
        sed -n /'Vendor'/p /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        sed -n /'Release Date'/p /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        sed -n '10p' /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        echo -e "\nSystem information" >> /etc/overview/$entreprise_$ip
        val=`sed -n /'Manufacturer'/= /etc/overview/test2 |awk '{print $1}'`
        aff=`echo $val|awk '{print $1}'`
        sed -n ''$aff'p' /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        sed -n /'Product Name'/p /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        val=`sed -n /'Serial Number'/= /etc/overview/test2 |awk '{print $1}'`
        aff=`echo $val|awk '{print $1}'`
        sed -n ''$aff'p' /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        echo -e "\nProcessor information" >> /etc/overview/$entreprise_$ip
        cpu=`sed -n /'cpu'/= /etc/overview/test`
        cpu2=`sed -n /'model'/= /etc/overview/test`
        cpu3=`sed -n /'flags'/= /etc/overview/test`
        cpu4=`sed -n /'width'/= /etc/overview/test4`
        tmp=`sed -n /'model name'/p /etc/overview/test`
        cp=`echo $tmp|tr -d -c "\\:"| wc -c`
        #echo $cp
        if [ $cp -le 1 ]; then
        sed -n /'cpu'/p /etc/overview/test >> /etc/overview/$entreprise_$ip
        sed -n /'model'/p /etc/overview/test >> /etc/overview/$entreprise_$ip
        sed -n /'flags'/p /etc/overview/test >> /etc/overview/$entreprise_$ip
        sed -n /'width'/p /etc/overview/test4 >> /etc/overview/$entreprise_$ip
        else
        for i in `seq 1 $cp`
        do
                var=`echo $cpu|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$var'p' /etc/overview/test >> /etc/overview/$entreprise_$ip
                var2=`echo $cpu2|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$var2'p' /etc/overview/test >> /etc/overview/$entreprise_$ip
                var3=`echo $cpu3|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$var3'p' /etc/overview/test >> /etc/overview/$entreprise_$ip
                var4=`echo $cpu4|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$var4'p' /etc/overview/test >> /etc/overview/$entreprise_$ip
        done
        fi
        echo -e "\nmemory information" >> /etc/overview/$entreprise_$ip
        sed -n /'\tSize: '/p /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        sed -n /'Number Of Devices'/p /etc/overview/test2 >> /etc/overview/$entreprise_$ip
        echo -e "\nNetwork information" >> /etc/overview/$entreprise_$ip
        net=`sed -n /'description'/= /etc/overview/test3`
        net2=`sed -n /'product'/= /etc/overview/test3 `
        net3=`sed -n /'vendor'/= /etc/overview/test3`
        net4=`sed -n /'logical name'/= /etc/overview/test3`
        net5=`sed -n /'serial'/= /etc/overview/test3`
        net6=`ifconfig | grep 'inet adr:' |awk '{print $2}'|cut -d: -f2`
        tmp=`sed -n /'logical name'/p /etc/overview/test3`
        cp=`echo $tmp|tr -d -c "\\:"| wc -c`
        ip=`sed -n /'logical name'/p /etc/overview/test3|awk '{print $3}'`
        #echo $cp
        #echo $net|awk '{print $2}'|cut -d: -f2
        if [ $cp -le 1 ]; then
        sed -n /'description'/p /etc/overview/test3 >> /etc/overview/$entreprise_$ip
        sed -n /'product'/p /etc/overview/test3 >> /etc/overview/$entreprise_$ip
        sed -n /'vendor'/p /etc/overview/test3 >> /etc/overview/$entreprise_$ip
        sed -n /'logical name'/p /etc/overview/test3 >> /etc/overview/$entreprise_$ip
        sed -n /'serial'/p /etc/overview/test3 >> /etc/overview/$entreprise_$ip
        inet=`echo $ip |awk '{print $1}'|cut -d' ' -f1`
        aff=`ifconfig $inet| grep "inet ad" | cut -f2 -d: | awk '{print $1}'`
        echo "       ip:"$aff >> /etc/overview/$entreprise_$ip
        else
        for i in `seq 1 $cp`
        do
                desc=`echo $net|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$desc'p' /etc/overview/test3 >> /etc/overview/$entreprise_$ip
                prod=`echo $net2|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$prod'p' /etc/overview/test3 >> /etc/overview/$entreprise_$ip
                fab=`echo $net3|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$fab'p' /etc/overview/test3 >> /etc/overview/$entreprise_$ip
                log=`echo $net4|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$log'p' /etc/overview/test3 >> /etc/overview/$entreprise_$ip
                num=`echo $net5|awk '{print $i}'|cut -d' ' -f$i`
                sed -n ''$num'p' /etc/overview/test3 >> /etc/overview/$entreprise_$ip
                inet=`echo $ip |awk '{print $i}'|cut -d' ' -f$i`
                aff=`ifconfig $inet| grep "inet ad" | cut -f2 -d: | awk '{print $1}'`
                echo "       ip:"$aff >> /etc/overview/$entreprise_$ip
                echo -e "\n" >> /etc/overview/$entreprise_$ip
        done
        fi
        echo -e "\nStorage information" >> /etc/overview/$entreprise_$ip
        stk=`sed -n /'disk'/p /etc/overview/test5 |awk ' {print $1}'`
        stk2=`sed -n /'disk'/p /etc/overview/test5 |awk '{print $4}'`
        cp=`echo $stk | wc -w`
        echo $cp
        if [ $cp -le 1 ]; then
                if [ -s /sys/class/block/$stk/device/model ]; then
                        diskmodel=`cat /sys/class/block/$stk/device/model`
                        echo "       Disque:/dev/"$stk >> /etc/overview/$entreprise_$ip
                        echo "       Modèle:"$diskmodel >> /etc/overview/$entreprise_$ip
                        echo "       Taille disque:"$stk2 >> /etc/overview/$entreprise_$ip
                        echo -e "\n" >> /etc/overview/$entreprise_$ip
                        else
                        echo "       Disque:/dev/"$stk >> /etc/overview/$entreprise_$ip
                        echo "       Modèle:inconnu" >> /etc/overview/$entreprise_$ip
                        echo "       Taille disque:"$stk2 >> /etc/overview/$entreprise_$ip
                        echo -e "\n" >> /etc/overview/$entreprise_$ip
                fi
        else
        for i in `seq 1 $cp`
        do
                disk=`echo $stk|awk '{print $i}'|cut -d' ' -f$i`
                echo "       Disque:/dev/"$disk  >> /etc/overview/$entreprise_$ip
                if [ -s /sys/class/block/$stk/device/model ]; then
                        diskmodel=`cat /sys/class/block/$disk/device/model`
                        else echo "       Modèle:inconnu" >> /etc/overview/$entreprise_$ip
                fi
                disk1=`echo $stk1|awk '{print $i}'|cut -d' ' -f$i`
                echo "       Taille disque:"$disk1 >> /etc/overview/$entreprise_$ip
                echo -e "\n" >> /etc/overview/$entreprise_$ip
        done
        fi
        val=`sed -n /'part'/p /etc/overview/test5 |awk ' {print $1}'`
        cp=`echo $val | wc -w`
        #echo $val
        val2=`sed -n /'part'/p /etc/overview/test5 |awk '{print $4}'`
        if [ $cp -le 1 ]; then
        echo "       Partition:/dev/"$val >> /etc/overview/$entreprise_$ip
        echo "       Taille partition:"$val2 >> /etc/overview/$entreprise_$ip
        else
        for i in `seq 1 $cp`
        do
                part=`echo $val|awk '{print $i}'|cut -d' ' -f$i`
                echo "       Partition:/dev/"$part  >>/etc/overview/$entreprise_$ip
                taille=`echo $val2|awk '{print $i}'|cut -d' ' -f$i`
                echo "       Taille partition:"$taille  >>/etc/overview/$entreprise_$ip
                echo -e "\n" >> /etc/overview/$entreprise_$ip

        done
        fi
        #rm test /etc/overview/test2 /etc/overview/test3 /etc/overview/test4 test5 test6
        #sed -i "s/^ //g" /etc/overview/$entreprise_$ip
        #sed 's/.*/\L&/' /etc/overview/$entreprise_$ip
