#!/usr/local/bin/python
#########################################################################
# Script to map LUN ID's to AIX hdisk devices
########################################################################## 

import ssh
import sys

#Target server name is first (and only) command line variable
hostname = sys.argv[1]

# Open connection to server and login using private key
s = ssh.Connection(hostname, username = 'automation')

# Acquire list of volume groups excluding OS and non-datafile VGs
datapathout = s.execute("datapath query device | egrep '(vpath|SERIAL)'")
volumegroups = [line.rstrip() for line in s.execute("lsvg | egrep -v '(rootvg|workareavg|ora.*vg|pagingvg)'")]

# Close connection
s.close()

# Create empty list for LUN ID's
luns = {}

# Split out ID from path output
for i in datapathout:
     if i.split()[0] == 'DEV#:':
             path = i.split()[4]
     else:
             lunid = i.split()[1][-4:]
             luns[path] = lunid

# Format output and store final mapping
for vg in volumegroups:
	print "\n%s: " % vg.upper()
	lsvg = "lsvg -p %s | grep vpath | cut -f1 -d' '" % vg
 	hdisks = [line.rstrip() for line in s.execute(lsvg)] 
	
	for disk in hdisks:
		if disk in luns: print "%10s = %4s" % (disk, luns[disk])