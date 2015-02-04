#!/usr/bin/python -ttu
import time
import os
import re
import datetime
import gzip
import sys


syslogfile = ''
#homedir = 'REDACTED'
loglist = []


def arg():
    if len(sys.argv) > 1:
        syslogfile = sys.argv[1]
        print sys.argv[1]
        
    if len(sys.argv) < 2:
        print "This command will unique the syslog file provided to it   |||||| USE = COMMAND path to file / file "
        sys.exit("no file to parse")



def parseline(fileparse, loglist):
    print 'in parse'
    listisblank = 0
    lines = gzip.open(fileparse, 'r').read().splitlines()
    for line in lines:
        p = re.compile(r'%\S*\d*\s')
        m = p.search(line)
        if m:
            match = m.group()
            if listisblank == 0:
                loglist.append(match)
                listisblank = 1

            elif loglist.count(match) == 0:
                loglist.append(match)
                


def formatlist(loglist):
    for each in loglist:
        print each
 
 
      
# timestampedfile                
def buildfile(loglist, homedir):
    dt = str(datetime.datetime.now())
    split = dt.split()
    stamp = split[0] + '_' + split[1] 
    fullpath =  homedir + "syslogchop" + stamp 
    f = open(fullpath, 'w')
    try:
        for each in loglist:
            fmat = each + '\n'
            f.write(fmat)
    finally:
        f.close


                
def main():
    arg()
    parseline(syslogfile, loglist)
    formatlist(loglist)

if __name__ == '__main__':
    main()
