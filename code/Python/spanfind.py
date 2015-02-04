#!/usr/bin/python -tt
import os
import re

dirs = "REDACTED, REDACTED, REDACTED"
mylist = []
RemoveSpanList = []


def buildcleandir(mylist, dirs):
    path = os.listdir(dirs)
    for stuff in path:
        l = re.compile(r'\w{8}(c6|4a)\d{2}')
        j = l.match(stuff)
        if j:
            mylist.append(stuff)
    
def parsefiles(mylist, dirs, RemoveSpanList):
    for GandE in mylist:
        d = dirs + GandE
        lines = open(d, 'r').read().splitlines()
        for line in lines:
            p = re.compile('monitor session') # match on line print line
            m = p.match(line)
            if m:
                if GandE not in RemoveSpanList:
                    RemoveSpanList.append(GandE)
                    
                    
def cleanprint(RemoveSpanList):
    for each in RemoveSpanList:
            print each
            
   
                
                
def main():
    buildcleandir(mylist, dirs)
    parsefiles(mylist, dirs, RemoveSpanList)
    cleanprint(RemoveSpanList)


if __name__ == '__main__':
    main()
