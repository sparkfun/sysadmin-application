#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 11 09:32:53 2014
@author: cwray
this script will get merged back into the metro check script when we I time
"""

import os
import sys
import time
import cPickle as pickle
from prettytable import PrettyTable
import argparse
import pprint


def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument("-sm", "--Scheduled_Maintenance", required=True,
                        help="REQUIRED ARG use SM number only")

    parser.add_argument("-i", "--Index", type=int, default=2,
                        help="set to 1 to look at a .bin after the first pass")

    parser.add_argument("-ff", "--Fudge_Factor", type=int, default=95,
                        help="Percentage of traffic that needs to move across an interface between the Time_sample time fraim. Range 1-100 . DEFAUTL = 95" )

    parser.add_argument("-da", "--Display_All", action="store_true",
                        help="Display all")

    parser.add_argument("-df", "--DupFile", action="store_true",
                        help="This will dump the contents of the .bin file to the screen in a humanly readable format. this is kinda like perls datadumper. pipe this data to a file")
    args = parser.parse_args()
    return args

def ImportPickleFile(SmNumber):
    if ".bin" not in SmNumber:
        handle = SmNumber + ".bin"
    else:
        handle = SmNumber
    if handle in os.listdir('.'):
        with open(handle,'rb') as fp:
            crap = pickle.load(fp)
            return crap
    else:
        print 'File not valid. please check file.'
        sys.exit(0)


def ErrReport(SnmpPull):
    badtids = []
    for tid in SnmpPull:
        ifname  = SnmpPull[tid]['intinfo']['ifname']
        iftype  = SnmpPull[tid]['intinfo']['iftype']
        ifdesc  = SnmpPull[tid]['intinfo']['ifdesc']
        ifin1   = SnmpPull[tid]['traffic'][1]['ifInUcastPkts']
        ifout1  = SnmpPull[tid]['traffic'][1]['ifOutUcastPkts']
        ifin2   = SnmpPull[tid]['traffic'][2]['ifInUcastPkts']
        ifout2  = SnmpPull[tid]['traffic'][2]['ifOutUcastPkts']
        ifin3   = SnmpPull[tid]['traffic'][3]['ifInUcastPkts']
        ifout3  = SnmpPull[tid]['traffic'][3]['ifOutUcastPkts']
        ifin4   = SnmpPull[tid]['traffic'][4]['ifInUcastPkts']
        ifout4  = SnmpPull[tid]['traffic'][4]['ifOutUcastPkts']
        stuff = [ifname, ifdesc, iftype, ifin1, ifin2, ifout1, ifout2, ifin3, ifin4, ifout3, ifout4]
        if 'Pull Failed' in stuff:
            badtids.append(tid)
    for tid in badtids:
        SnmpPull.pop(tid)
        time.sleep(.01)
    print "please check all tids in this list to see if they are on the network and are reachable by name\n", badtids
    return SnmpPull


def PercentChange(first, second, third, forth):
    A = (int(forth) - int(third)) - (int(second) - int(first))
    B = (int(second) - int(first))
    if A == 0 or B == 0:
        return 0
    else:
        C = (float(A) / float(B)) * 100
        return "%.2f" % C

def ParseAndPrint(args):
    index = args.Index
    SnmpPull = ImportPickleFile(args.Scheduled_Maintenance)
    walkawalka = ErrReport(SnmpPull)
    fudge = int('-' + str(args.Fudge_Factor))
    if index == 1:
        x = PrettyTable(["TID", "INT", "Diff IN", "Diff OUT"])
    if index == 2:
        x = PrettyTable(["TID", "INT", "Diff 1 IN ","%IN", "Diff 2 IN",'*',"Diff 1 OUT","%OUT", "Diff 2 OUT","CHECK!"])

    for tid in iter(walkawalka):
        ifname  = walkawalka[tid]['intinfo']['ifname']
        iftype  = walkawalka[tid]['intinfo']['iftype']
        ifdesc  = walkawalka[tid]['intinfo']['ifdesc']
        ifin1   = walkawalka[tid]['traffic'][1]['ifInUcastPkts']
        ifout1  = walkawalka[tid]['traffic'][1]['ifOutUcastPkts']
        ifin2   = walkawalka[tid]['traffic'][2]['ifInUcastPkts']
        ifout2  = walkawalka[tid]['traffic'][2]['ifOutUcastPkts']
        ifin3   = walkawalka[tid]['traffic'][3]['ifInUcastPkts']
        ifout3  = walkawalka[tid]['traffic'][3]['ifOutUcastPkts']
        ifin4   = walkawalka[tid]['traffic'][4]['ifInUcastPkts']
        ifout4  = walkawalka[tid]['traffic'][4]['ifOutUcastPkts']
        if index == 1:
            x.add_row([tid," "," "," "])
            matrix = zip(ifname,ifdesc,iftype,ifin1,ifin2,ifout1,ifout2)
        if index  == 2:
            x.add_row([tid," "," "," "," "," "," "," "," ", " "])
            matrix = zip(ifname,ifdesc,iftype,ifin1,ifin2,ifout1,ifout2,ifin3,ifin4,ifout3,ifout4,)

        for iface in matrix:
            if iface[1] != None:
                if '[METRO]' not in iface[1]:
                    if 'Vl' not in iface[2]:
                        if 'VLAN' not in iface[2]:
                            check = 0
                            if index == 1:
                                x.add_row([ " ", iface[2], int(iface[4]) - int(iface[3]), int(iface[6]) - int(iface[5])])
                            if index == 2:
                                IN = PercentChange(iface[3], iface[4], iface[7], iface[8])
                                if float(IN) < float(fudge) or IN == 0:
                                    check = 1
                                OUT = PercentChange(iface[5], iface[6], iface[9], iface[10])
                                if float(OUT) < float(fudge) or OUT == 0:
                                    check = 1

                                if check == 1:
                                    x.add_row([" ", iface[2], int(iface[4]) - int(iface[3]), IN, int(iface[8]) - int(iface[7])," ", int(iface[6]) - int(iface[5]), OUT, int(iface[10]) - int(iface[9]), "*"])
                                if check == 0:
                                    if args.Display_All == True:
                                        x.add_row([" ", iface[2], int(iface[4]) - int(iface[3]), IN, int(iface[8]) - int(iface[7])," ", int(iface[6]) - int(iface[5]), OUT, int(iface[10]) - int(iface[9]), " "])
    print x


def DumpData(smnumber):
    print smnumber
    OpenBIN = ImportPickleFile(smnumber)
    pp = pprint.PrettyPrinter(indent=2)
    print 'past pp'
    pp.pprint(OpenBIN)


def main():
    args = parse()
    if args.DupFile == True:
        DumpData(args.Scheduled_Maintenance)
    else:
        ParseAndPrint(args)


if __name__ == "__main__":
    main()
