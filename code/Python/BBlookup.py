#!/usr/bin/python -ttu
#BBlookup
# VER.005

import sys
import re
#import subprocess
import os

CommandArgument = 0

def CommandArgumentlookup():
    global CommandArgument
    if len(sys.argv) > 2:
        print 'Hey your stuff needs to be in single quotes'
    elif len(sys.argv) == 2: 
        CommandArgument = sys.argv[1]
        return
    else:
        print 'Nothing to lookup, GIVE ME SOMETHING TO LOOKUP NOW! HURRY! HURRY! HURRY!!!'
        return


def main():
    shint = 'show interface %s ext; '
    shospf = 'show ospf neighbor detail | match %s '
    CommandArgumentlookup()
    encap = "((( %s )))" % (CommandArgument)
    tid = re.compile(r'\w{3}\d\-\w{2}\d')
    interface = re.compile(r'\w{2}\-\d\/\d\/\d')
    t = tid.findall(encap)
    i = interface.findall(encap)
    zipped = zip(t, i)
    print zipped
    print 't[0] should be tid 1'
    print 't[1] should be tid 2'
    print 'i[0]  should be INT 1'
    print 'i[1]  should be INT 2'
    print 'Commands that we are going to run!!!!'
    FirstRun = "j -c'show interface %s ext; show ospf neighbor detail | match %s' %s " % (i[0], i[0], t[0])
    SecondRun =  "j -c'show interface %s ext; show ospf neighbor detail | match %s' %s " % (i[1], i[1], t[1])
    print FirstRun
    print SecondRun
#    subprocess.check_call(FirstRun, shell=True)
#    subprocess.check_call(SecondRun, shell=True)
    print os.system(FirstRun)
    print os.system(SecondRun)


if __name__ == '__main__':
    main()
