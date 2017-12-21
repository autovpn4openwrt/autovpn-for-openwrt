#!/bin/bash
DNSServer=8.8.8.8

if [ ! -f "$1" ] ;then
    echo "File not found: $1"
    exit 1
fi
file=$1
shift
if [ "$1" == "openwrt" ] ; then
    format="openwrt"
    shift
fi

if [ "$1" == "" ] ;then
    Max=5
else
    Max=$1
fi

temp=$(mktemp)
temp2=$(mktemp)

./autoproxy2domain $file >$temp

i=1
while read line ;do
    if [ $(( i % Max )) -eq 0 ] ;then
        domains="$domains/$line"
        if [ "$format" == "openwrt" ] ;then
            echo "list server '$domains/$DNSServer'"
        else
            echo "server=$domains/$DNSServer"
        fi
        domains=""
    else
        domains="$domains/$line"
    fi 
    ((i++))
done < $temp >$temp2

rm $temp
mv $temp2 ./dnsmasq.conf
echo "`pwd`/dnsmasq.conf"
echo "Done."
