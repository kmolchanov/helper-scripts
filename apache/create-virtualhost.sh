#!/bin/bash
if [ "$(sudo whoami)" != "root" ]; then
	echo -e "\033[37;1;41mSorry, you are not root.\033[0m"
	exit
fi

source config/virtualhost.conf

read -p "Virtual host name: " projectName

projectDirectory=$virtualhostsDirectory$projectName
vhostFile=$apacheVhostsDirectory$projectName".conf"
hostsFileTmp="${hostsFile}.tmp"

ValidateVirtualHost ()
{
	if [ -d $projectDirectory ]
	then
		echo -e "\033[37;1;41mDirectory for virtual host is already exists.\033[0m"
		error=true
	fi
	if [ -f $vhostFile ]
	then
		echo -e "\033[37;1;41mVirtual host is already exists.\033[0m"
		error=true
	fi
}

VirtualHostQuestion ()
{
	read -p "Do you want to create virtual host(y/n)?: " choice
	case "$choice" in 
		"y") createVirtualHost=true;;
		"n") ;;
		* ) echo "Type 'y' to create virtual host, if no type 'n'"; VirtualHostQuestion;;
	esac
}

CreateVirtualHost ()
{
	mkdir $projectDirectory

	sudo cp /etc/apache2/sites-available/host.original $vhostFile
	echo "<VirtualHost *:80>" | sudo tee $vhostFile
	echo -e "\tServerName ${projectName}.${domain}" | sudo tee -a $vhostFile
	echo -e "\tDocumentRoot ${virtualhostsDirectory}${projectName}" | sudo tee -a $vhostFile
	echo -e "\t<Directory ${virtualhostsDirectory}${projectName}>" | sudo tee -a $vhostFile
	echo -e "\t\tAllowOverride All" | sudo tee -a $vhostFile
	echo -e "\t\tRequire all granted" | sudo tee -a $vhostFile
	echo -e "\t</Directory>" | sudo tee -a $vhostFile
	echo "</VirtualHost>" | sudo tee -a $vhostFile

	sudo cp $hostsFile $hostsFileTmp
	echo -e "127.0.0.1\t${projectName}.${domain}" | sudo tee $hostsFile
	cat $hostsFileTmp | sudo tee -a $hostsFile
	sudo rm $hostsFileTmp

	sudo a2ensite $projectName".conf"
	sudo /etc/init.d/apache2 restart

	echo "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'><html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en' lang='en'><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><title>${projectName} - Empty project</title></head><body bgcolor='#C9E0ED'><center><h3>Welcome to <i>${projectName}</i></h3><p>Project directory: <code>${projectDirectory}</code></p></center></body></html>" > "${projectDirectory}/index.html"
}

ValidateVirtualHost

if [ $error ]
then
	echo -e "\033[37;1;41mNothing created.\033[0m"
	exit
fi

CreateVirtualHost

echo -e "\033[37;1;42mVirtual host url: http://${projectName}.${domain}/\033[0m";
echo -e "\033[37;1;42mVirtual host directory: ${virtualhostsDirectory}${projectName}\033[0m";
