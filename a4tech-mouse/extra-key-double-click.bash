#!/bin/bash

sleep 1
for Id in $(xinput --list | grep  "A4TECH USB" | grep -oE "id=[0-9]{1,2}" | grep -oE "[0-9]{1,2}")
do
	if [ "$(xinput --list-props $Id | grep -oE "\"Rel Horiz Wheel\"")" ]
		then
			buttonId=$Id
	fi
done
sleep 1
xinput --disable $buttonId
sleep 1
tEvent=$(xinput --list-props $buttonId | grep -oE "event+[0-9]{1,3}")
evtest /dev/input/$tEvent | awk '/KEY_LEFTMETA\), value 1/ {system("xdotool click --repeat 2 1")}'
