#!/bin/bash

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$((${upSeconds}%60))
mins=$((${upSeconds}/60%60))
hours=$((${upSeconds}/3600%24))
days=$((${upSeconds}/86400))
UPTIME=`printf "%dd%02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "$(tput setaf 2)
`date +"%A, %e %B %Y, %r"`
`uname -srmo`$(tput setaf 1)

Uptime.............: ${UPTIME}
Memory.............: `cat /proc/meminfo | grep MemFree | awk {'mem = $2 / 1024; print mem'}`MB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'mem = $2 / 1024; print mem'}`MB (Total)
Load Averages......: ${one}, ${five}, ${fifteen}
Running Processes..: `ps ax | wc -l | tr -d " "`
IP Addresses.......: `ip a | grep glo | grep -v docker | awk '{print $2}' | cut -f1 -d/ | awk '{ ORS = (NR%2 ? ", " : RS) } 1'` and `wget -q -O - http://icanhazip.com/ | tail`
Weather............: `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|ES|SP013|MADRID" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
$(tput sgr0)"

fortune
