#!/bin/bash

echo "Interpolation works in $(echo 'strange') ways." 

if [ -d "/etc" ];
	then echo "Hooray, your /etc isn't missing!";
fi

if [ -w "/etc/shadow" ];
	then echo "WHY ARE YOU RUNNING THIS AS ROOT?! ARE YOU INSANE? You must really trust applicants.";
	else echo "You should try running this as root.";
fi

ssh -G 2>/dev/null
if [ $? -eq 0 ]; then
	echo "Umm.. it kinda seems like you might have eBury.";
	else echo "Phew. Simplistic ebury scan negative.";
fi

for i in $(grep -v '^#' /etc/shells); do count=$(grep -c $i /etc/passwd); echo "$i has $count users configured to use it as a shell."; done
echo $TEMPVAR;
