#!/bin/bash
logfile=$1
nreadsin=$(grep "Total reads processed:" $logfile|awk -F":" '{print $2}'|awk '{print $1}'|sed "s/,//g")
nbasesin=$(grep "Total basepairs processed:" $logfile|awk -F":" '{print $2}'|awk '{print $1}'|sed "s/,//g")
rlin=$(echo $nbasesin $nreadsin|awk '{printf "%.1f", $1/$2}')
nreadsout=$(grep "Reads written (passing filters):" $logfile|awk -F":" '{print $2}'|awk '{print $1}'|sed "s/,//g")
nbasesout=$(grep "Total written (filtered):" $logfile|awk -F":" '{print $2}'|awk '{print $1}'|sed "s/,//g")
rlout=$(echo $nbasesout $nreadsout|awk '{printf "%.1f", $1/$2}')
echo "$nreadsin $rlin $nreadsout $rlout"