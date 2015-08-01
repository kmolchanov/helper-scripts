#!/bin/bash
if [ "$(sudo whoami)" != "root" ]; then
	echo -e "\033[37;1;41mSorry, you are not root.\033[0m"
	exit
fi

source config/virtualhost.conf

read -p "Remove virtual host with name: " projectName

projectDirectory=$virtualhostsDirectory$projectName
vhostFile=$apacheVhostsDirectory$projectName".conf"

ValidateVirtualHost ()
{
	if [ ! -d $projectDirectory ]
	then
		echo -e "\033[37;1;41mDirectory of virtual host is not exists.\033[0m"
		error=true
	fi
	if [ ! -f $vhostFile ]
	then
		echo -e "\033[37;1;41mVirtual host is not exists.\033[0m"
		error=true
	fi
}

VirtualHostQuestion ()
{
	read -p "Are you really want to remove virtual host(y/n)?: " choice
	case "$choice" in 
		"y") removeVirtualHost=true;;
		"n") ;;
		* ) echo "Type 'y' to remove virtual host, if no type 'n'"; VirtualHostQuestion;;
	esac
}

RemoveVirtualHost ()
{
	sudo a2dissite $projectName
	sudo /etc/init.d/apache2 restart
	sudo rm -rf $projectDirectory
	sudo rm $vhostFile
}

VirtualHostQuestion

if [ $removeVirtualHost ]
then
	ValidateVirtualHost
fi

if [ $error ]
then
	echo -e "\033[37;1;41mNothing removed.\033[0m"
	exit
fi

if [ $removeVirtualHost ]
then
	RemoveVirtualHost
fi

if [ $removeVirtualHost ]
then
	echo -e "\033[37;1;42mVirtual host url: http://${projectName}.${domain}/ - removed.\033[0m";
	echo -e "\033[37;1;42mVirtual host directory: ${virtualhostsDirectory}${projectName} - removed.\033[0m";
	echo -e "\033[37;1;44mRemove domain '${projectName}.${rainweb}' from /etc/hosts to complete removing virtual host.\033[0m";
fi
