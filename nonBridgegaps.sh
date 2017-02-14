#!/bin/bash

#runBits.sh on a chain track to intersect with non-bridged gaps

#printf "Enter directory name:\>"
#read name


printf "Enter Assembly Name: \e[38;5;106m"; 
read name
printf "\033[0m"

printf "Enter chainLink assembly: \e[38;5;106m"; 
read db 
printf "\033[0m"

preparedName="$(tr '[:lower:]' '[:upper:]' <<< ${db:0:1})${db:1}"

#Get non-bridged gaps:

hgsql $name -N -e 'select chrom,chromStart,chromEnd from gap where bridge="no"' > ${name}.unbridge.bed

#convert chainLink to bed file
hgsql -N -e "select tName,tStart,tEnd from chain${preparedName}Link" $name > chain${preparedName}Link.bed

#intersect the chainLink with the non-bridged gaps

bedIntersect  -aHitAny chain${preparedName}Link.bed ${name}.unbridge.bed linkAny.bed

#check if linkAny.bed has elements, that is an intersection 

