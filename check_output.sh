#!/bin/bash
if [[ -z $1 ]]; then
    echo need jobid number as argument
    exit 1
fi
node=$(scontrol show jobid $1|grep NodeList|grep -v Req|cut -c 13-)
echo node is $node
pdsh -w $node 'nvidia-smi; uptime ; cat `find /tmp/ -name "*sto"`'
