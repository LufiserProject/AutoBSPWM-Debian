#!/bin/sh

ip_target=$(cat ~/.config/polybar/shapes/scripts/target | awk '{print $1}')
name_target=$(cat ~/.config/polybar/shapes/scripts/target | awk '{print $2}')

if [ $ip_target ] && [ $name_target ]; then
    echo "%{F#c05050}%{F-} %{F#d0b0b0}$ip_target - $name_target%{F-}"
elif [ $(cat ~/.config/polybar/shapes/scripts/target | wc -w) -eq 1 ]; then
    echo "%{F#c05050}%{F-} %{F#d0b0b0}$ip_target%{F-}"
else
    echo "%{F#5a3030}%{F-} %{F#d0b0b0}No target%{F-}"
fi