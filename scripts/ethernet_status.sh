#!/bin/sh

echo "%{F#e0a0a0}%{F-} %{F#d0b0b0}$(/usr/sbin/ifconfig eth0 | grep "inet " | awk '{print $2}')%{u-}"