#!/bin/sh

ps w|grep -v grep|grep -qe "ssh.*-TCf\|pppd ifname pvpn"
if [ $? -ne 0 ] ;then
    . /etc/autovpn.conf
    echo "[ `date +'%Y/%m/%d %H:%M:%S'` ] restart pvpn" >>/tmp/autopvpn.log
    export SSH_ARGS="-p $SSH_PORT -i $SSH_KEY"
    pvpn -r "$ROUTES" root@$SSH_SERVER 8.8.8.8
    kill -HUP `pgrep dnsmasq`
fi
