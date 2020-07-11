#!/bin/bash

if [ "$(sudo whoami)" != "root" ]; then
        echo -e "\033[37;1;41mSorry, you are not root.\033[0m"
        exit
fi

buttonId=$(xinput --list | grep 'A4TECH USB Device Keyboard' | grep -oE 'id=[0-9]+' | grep -oE '[0-9]+')

if [ -n "$buttonId" ]
	then
		xinput --disable $buttonId
		tEvent=$(xinput --list-props $buttonId | grep -oE "event+[0-9]{1,3}")
		sudo evtest /dev/input/$tEvent | awk '/KEY_LEFTMETA\), value 1/ {system("xdotool click --repeat 2 1")}'
fi
