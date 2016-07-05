#!/usr/bin/bash
#prompts user for sudo password at beginning so I can use it throughout the script
sudo -v

#Find all of the "AttrXfr" instances stash the old copy, drop the stash, pull the code
find /var/lib/tomcat/webapps/attrxfr#* -maxdepth 0 -type d -exec sh -c 'echo "Pulling new code to: "$0 && cd $0 && git stash && git stash drop &&  git pull' {} \;

#fix the permissions 
echo "Changing permissions for /var/lib/tomcat/webapps/attrxfr#"
sudo chmod -R 775 /var/lib/tomcat/webapps/attrxfr#*
echo "Changing owner for /var/lib/tomcat/webapps/attrxfr#"
sudo chown -R owen:tomcat /var/lib/tomcat/webapps/attrxfr#*


#restart Tomcat
echo "Restarting Tomcat"
sudo service tomcat restart
