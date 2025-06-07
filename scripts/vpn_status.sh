#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')

if [ "$IFACE" = "tun0" ]; then
    echo "%{F#c05050}%{F-} %{F#d0b0b0}$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')%{F-}"
else
    echo "%{F#5a3030}%{F-} %{F#d0b0b0}Disconnected%{F-}"
fi