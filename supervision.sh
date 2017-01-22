#!/bin/bash

entreprise=`cat /etc/overview/entreprise`
ip=`cat /etc/overview/ip`

moyenne() {
        somme=`awk '{s+=$1}END{print s}' RS=" " /etc/overview/tmp1`
        echo $somme / $cp |bc -l|awk '{printf "%0.1f", $0}'
}
        top -b -n 1 | grep "KiB Mem" > /etc/overview/memory
        top -b -n 5 | grep Cpu > /etc/overview/cpu
        df -h > /etc/overview/partition
        lsblk -l > /etc/overview/disk
        lsof > /etc/overview/process
        memtotal=`sed -n /'KiB Mem'/p /etc/overview/memory |awk '{print $4}'`
        memfree=`sed -n /'KiB Mem'/p /etc/overview/memory |awk '{print $6}'`
        #vartotal=`echo $memtotal/1000 |bc -l`
        #varfree=`echo $memfree/1000 |bc -l`
        result=`echo $memtotal - $memfree|bc -l`
        val=`echo $((100 * $result / $memtotal)) |bc -l`
        echo "ram:"$val > /etc/overview/$entreprise"_"$ip # en pourcentage
        lshw -C cpu > tmp
        var=`sed -n /'Cpu'/= /etc/overview/cpu`
        cp=`echo $var| wc -w`
        var=`sed -n /'processor'/= /etc/overview/tmp`
        cp2=`echo $var |wc -w`
        #echo $cp
        if [ $cp2 -le 1 ]; then
        cpuusr=`sed -n /'Cpu'/p /etc/overview/cpu |awk '{print $2}'`
        cpusys=`sed -n /'Cpu'/p /etc/overview/cpu |awk '{print $4}'`
        echo $cpuusr > /etc/overview/tmp1
        varusr=`moyenne $cpuusr`
        echo $cpusys > /etc/overview/tmp1
        varsys=`moyenne $cpusys`
        echo $varusr $varsys
        result=`echo $varusr + $varsys |bc|awk '{printf "%0.1f", $0}'`
        let "cp2++"
        echo "cpu_"$cp2":"$result>> /etc/overview/$entreprise"_"$ip # en pourcentage cpu utilisé
        else
        for i in `seq 1 $cp2`
        do
                val=`echo $var|awk '{print $i}'|cut -d' ' -f$i`
                cpuusr=`sed -n ''$val'p' /etc/overview/cpu |awk '{print $2}'`
                cpusys=`sed -n ''$val'p' /etc/overview/cpu|awk '{print $4}'`
                result=`echo $cpuusr + $cpusys |bc`
                aff=`echo 100*$result |bc -l`
                val=`echo $aff/100 |bc -l`
                let "cp2++"
                echo "cpu_"$cp2":"$val >> /etc/overview/$entreprise"_"$ip
        done
        fi
        var=`sed -n /'part'/= /etc/overview/disk`
        cp=`echo $var |wc -w`
        partname=`sed -n /'part'/p /etc/overview/disk |awk '{print $1}'`
        mntpoint=`sed -n /'part'/p /etc/overview/disk |awk '{print $7}'`
        partsize=`sed -n /'^\/dev'/p /etc/overview/partition |awk '{print $2}'`
        partuse=`sed -n /'^\/dev'/p /etc/overview/partition |awk '{print $3}'`
        disksize=`sed -n /'disk'/p /etc/overview/disk |awk '{print $4}'`
        diskname=`sed -n /'disk'/p /etc/overview/disk |awk '{print $1}'`
        echo $partsize$partuse > /etc/overview/view
        if [ $cp -le 1 ]; then
        echo "total_part_"$partname"_"$mntpoint":"$partsize >> /etc/overview/$entreprise"_"$ip
        echo "utilisé_part_"$partname"_"$mntpoint":"$partuse >> /etc/overview/$entreprise"_"$ip
        else
        for i in `seq 1 $cp`
        do
                val=`echo $partname |awk '{print $i}' |cut -d' ' -f$i`
                val2=`echo $mntpoint |awk '{print $i}' |cut -d' ' -f$i`
                val3=`df -h /dev/$val |awk '{print $2}'`
                val4=`df -h /dev/$val |awk '{print $3}'`
                if [ -z $val3 ]; then
                        val3='Inconnu'
                        val4='Inconnu'
                fi
                echo "total_part_"$val"_"$val2":"$val3 >> /etc/overview/$entreprise"_"$ip
                echo "utilisé_part_"$val"_"$val2":"$val4 >> /etc/overview/$entreprise"_"$ip
        done
        fi
        var2=`sed -n /'disk'/= /etc/overview/disk`
        cp2=`echo $var2 |wc -w`
        if [ $cp2 -le 1 ]; then
        echo "disque_"$diskname":"$disksize >> /etc/overview/$entreprise"_"$ip
        else
        for i in `seq 1 $cp2`
        do
                if [ -z $disksize ]; then
                        disksize='Inconnu'
                        diskname='Inconnu'
                fi
                val5=`echo $disksize |awk '{print $i}' |cut -d' ' -f$i`
                val6=`echo $diskname |awk '{print $i}' |cut -d' ' -f$i`
                echo "disque_"$val5":"$val6 >> /etc/overview/$entreprise"_"$ip
        done
        fi
        lshw -C network > /etc/overview/tmp
        var=`sed -n /'logical name'/p /etc/overview/tmp |awk '{print $3}'`
        cp=`echo $var| wc -w`
        if [ $cp -le 1 ]; then
                vnstat -i $var -tr 5 > /etc/overview/network
                debent=`sed -n /'rx'/p /etc/overview/network |awk '{print $2}'`
                valent=`sed -n /'rx'/p /etc/overview/network |awk '{print $3}'`
                debsor=`sed -n /'tx'/p /etc/overview/network |awk '{print $3}'`
                valsor=`sed -n /'rx'/p /etc/overview/network |awk '{print $2}'`
                echo "carte_"$var":"$debent $valent";"$debsor $valsor >> /etc/overview/$entreprise"_"$ip # en kb/s
        else
        for i in `seq 1 $cp`
        do
                eth=`echo $var|awk '{print $i}'|cut -d' ' -f$i`
                vnstat -i $eth -tr 5 > /etc/overview/network
                debent=`sed -n /'rx'/p /etc/overview/network |awk '{print $2}'`
                valent=`sed -n /'rx'/p /etc/overview/network |awk '{print $3}'`
                debsor=`sed -n /'tx'/p /etc/overview/network |awk '{print $3}'`
                valsor=`sed -n /'rx'/p /etc/overview/network |awk '{print $2}'`
                echo "carte_"$var":"$debent $valent";"$debsor $valsor >> /etc/overview/$entreprise"_"$ip
        done
        fi

        scp -i /etc/overview/id_rsa -P 4322 /etc/overview/$entreprise"_"$ip transfert@labo.itinet.fr:/home/transfert/supervision