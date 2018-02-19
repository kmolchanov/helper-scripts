#!/bin/bash

buttonId=$(xinput --list | grep 'A4TECH USB.*keyboard' | grep -oE 'id=[0-9]+' | grep -oE '[0-9]+')

if [ -n "$buttonId" ]
	then
		xinput --disable $buttonId
		tEvent=$(xinput --list-props $buttonId | grep -oE "event+[0-9]{1,3}")
		evtest /dev/input/$tEvent | awk '/KEY_LEFTMETA\), value 1/ {system("xdotool click --repeat 2 1")}'
fi
