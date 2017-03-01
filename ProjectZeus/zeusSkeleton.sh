#!/usr/bin/env bash

#################################################################################
# https://github.com/cjtopher
# chris.sh
#################################################################################

#################################################################################
# Purpose
#################################################################################
# Allows people to interactively iterate through prompts

#################################################################################
# Usage
#################################################################################
# Just run the command. It will prompt you for the specifics.

#################################################################################
# Limitations
#################################################################################
#

################################################################################
# Config 
################################################################################

        #########################################################################
        # Color variables							#
        #########################################################################
	reset=`tput sgr0`
	off='\033[0m'
	white=`tput setaf 7`

	color114=$(echo -en "\e[38;5;114m") 
	color203=$(echo -en "\e[38;5;203m") 
	color207=$(echo -en "\e[38;5;207m") 
	color215=$(echo -en "\e[38;5;215m") 
	color240=$(echo -en "\e[38;5;240m") 
	color25=$(echo -en "\e[38;5;25m") 
	color81=$(echo -en "\e[38;5;81m") 
	bg25=$(echo -en "\e[48;5;25m") 
	line1="       ╔════════════════════════════════════════════════════════════════════════════════╗"
	line1m="       ╠════════════════════════════════════════════════════════════════════════════════╣"
	line1b="       ╚════════════════════════════════════════════════════════════════════════════════╝"
	line2="         ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	line3=""

################################################################################
# Main 
################################################################################

	#########################################################################
	# Usage
	#########################################################################
	if [ -z "$1" ]; then
		echo "Usage"
		exit 0
	fi

	# This will print a nice border, though note that it is unicode
	echo "$line1"

	# You can set a variable, and then use it as the default prompt
	var="Yes"

	#########################################################################
	# 
	#########################################################################
	echo "	Your first selection?	$color25"
	echo -n "	"
	read -e -p "" -i "$var" inputOne
	echo $reset
	# test the variable to see if they wanted to quit
	if echo $inputOne | grep -iq "q!"; then echo "	No problem, exiting now"; exit 0; fi

	inputOneCleaned=$(echo "$inputOne" | tr '[:upper:]' '[:lower:]')

	if [ "$inputOneCleaned" == "yes" ]; then

		echo "$line1m"
		#########################################################################
		# 
		#########################################################################
		echo "	Your next selection?	$color25"
		echo -n "	"
		read -e -p "" -i "yes" inputTwo
		echo $reset
		# Test to see if they wanted to quit
		if echo $inputTwo | grep -iq "q!"; then echo "	No problem, exiting now"; exit 0; fi
	fi
	echo "$line2"



	echo "$line1b"

