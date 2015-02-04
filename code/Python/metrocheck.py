#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 11 09:32:53 2014
@author: cwray
"""
# imports
import multiprocessing
import netsnmp
import time
import signal
import sys
import os
import cPickle as pickle
import argparse
import getpass
import datetime

# declarations
ifname =('ifname', '.1.3.6.1.2.1.2.2.1.7')
ifindex =('ifindex', '.1.3.6.1.2.1.2.2.1.1')
iftype = ('iftype', '.1.3.6.1.2.1.31.1.1.1.1')
ifdesc = ('ifdesc', '.1.3.6.1.4.1.9.2.2.1.1.28')
ifInUcastPkts = ('ifInUcastPkts','ifInUcastPkts')
ifOutUcastPkts = ('ifOutUcastPkts', 'ifOutUcastPkts')
interfaceinfo = [ifname,ifindex,iftype,ifdesc]
interfacetraffic = [ifInUcastPkts,ifOutUcastPkts]
task_queue = multiprocessing.Queue()
done_queue = multiprocessing.Queue()
inttimeoutqueue = multiprocessing.Queue()
processes = []
MPP = []
SPP = []


# arg list / help menu.
def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument("-sm", "--Scheduled_Maintenance", required=True,
                        help="REQUIRED ARG use SM number only")

    parser.add_argument("-l", "--List_of_TIDS", nargs='*',
                        help="Pass list of tids to script. You will only need to do this the first time you run the script")

    parser.add_argument("-f", "--File",
                        help="Pass file of Tids to scrript. format one tid per line.")

    parser.add_argument("-sc", "--Snmp_Community", default="REDACTED",
                        help="Change default snmp community")

    parser.add_argument("-sv", "--Snmp_Version", type=int, default=2,
                        help="Default to Snmp Version 2")

    parser.add_argument("-ts", "--Time_Sample", type=int, default=30,
                        help="Min time between lookups for traffic comparison. Range 1-60 SEC")

    parser.add_argument("-NMP", "--NUMBER_OF_PROCESSES_IN_MAIN_POOL",type=int, default=32,
                        help="Default to 32. watch CPU/BW usage on server if pushing this any higher. Range 1-400\n")

    parser.add_argument("-NSP", "--NUMBER_OF_PROCESSES_IN_SECONDARY_POOL",type=int, default=1, choices=range(1, 5),
                        help=argparse.SUPPRESS) #"Default to 1. BE VERY CAREFUL WITH THIS. CAN CAUSE HIGH CPU USAGE!" I have removed this option for the help list. you should not ever need to change this option.

    parser.add_argument("-v ", "--verbose", choices=['v'],
                        help="Displays Verbosity")

    parser.add_argument("-s", "--spider", action="store_true",
                        help=argparse.SUPPRESS)
    args = parser.parse_args()
    return args


# count work to be done on the first pass
def numberofwork1(SnmpPull,interfaceinfo,interfacetraffic):
    pullcount = len(SnmpPull) * (len(interfaceinfo) + (len(interfacetraffic) * 2))
    return pullcount

# count work to be done on the second pass
def numberofwork2(SnmpPull,interfacetraffic):
    pullcount = len(SnmpPull) * (len(interfacetraffic) * 2 )
    return pullcount

# build storage structure.
def PassNodesToDict(UniqueNodes,SnmpPull):
    for node in UniqueNodes:
        sanitized_node = node.upper().strip()
        if sanitized_node not in SnmpPull:
            SnmpPull[sanitized_node] = {}
            SnmpPull[sanitized_node]['intinfo'] = {}
            SnmpPull[sanitized_node]['intinfo']['ifname'] = []
            SnmpPull[sanitized_node]['intinfo']['ifindex'] = []
            SnmpPull[sanitized_node]['intinfo']['iftype'] = []
            SnmpPull[sanitized_node]['intinfo']['ifdesc'] = []
            SnmpPull[sanitized_node]['traffic'] = {}
            SnmpPull[sanitized_node]['traffic'][1] = {}
            SnmpPull[sanitized_node]['traffic'][1]['ifInUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][1]['ifOutUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][2] = {}
            SnmpPull[sanitized_node]['traffic'][2]['ifInUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][2]['ifOutUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][3] = {}
            SnmpPull[sanitized_node]['traffic'][3]['ifInUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][3]['ifOutUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][4] = {}
            SnmpPull[sanitized_node]['traffic'][4]['ifInUcastPkts'] = []
            SnmpPull[sanitized_node]['traffic'][4]['ifOutUcastPkts'] = []


# This is what args is handing to this function (File=None, Fudge_Factor=5, List_of_TIDS=None, NUMBER_OF_PROCESSES_IN_MAIN_POOL=30, NUMBER_OF_PROCESSES_IN_SECONDARY_POOL=2, Scheduled_Maintenance='SMtest', Snmp_Community='twtinet94', Snmp_Version=2, Time_Sample=5, spider=False, verbose=None)
def ParseImportTids(args):

    handle = args.Scheduled_Maintenance + ".bin"
    if handle in os.listdir('.') and args.List_of_TIDS != None or  handle in os.listdir('.') and args.File != None:
        print 'There is a file in current dir named %s please remove file' % handle
        sys.exit(0)
    elif handle not in os.listdir('.') and args.List_of_TIDS != None or handle not in os.listdir('.') and args.File != None:
        index = 1
        if args.File != None:
            SnmpPull = {}
            lines = open(args.File, 'r').read().splitlines()
            UniqueNodes = set(lines)
            PassNodesToDict(UniqueNodes,SnmpPull)
        elif args.List_of_TIDS != None:
            SnmpPull = {}
            UniqueNodes = set(args.List_of_TIDS)
            PassNodesToDict(UniqueNodes,SnmpPull)
    elif handle in os.listdir('.') and args.List_of_TIDS == None:
        index = 2
        with open(handle,'rb') as fp:
            SnmpPull = pickle.load(fp)
    elif  handle not in os.listdir('.') and args.List_of_TIDS == None and args.File == None:
        print "You need to pass the script a list of tids or a file with one tid per line. Exiting NOW!"
        sys.exit(0)
    return SnmpPull, index


def AddInterfaceInfoToPool(SnmpPull,interfaceinfo,Snmp_Community,Snmp_Version):
    jobs = 0
    for Tid in SnmpPull:
        for SnmpQuery in interfaceinfo:
            #time.sleep(.0001)
            task_queue.put([Tid,SnmpQuery,'intinfo',Snmp_Community,Snmp_Version], block=True)
            jobs += 1
    return jobs


def AddInterfaceTrafficToPool(SnmpPull,interfacetraffic,Snmp_Community,Snmp_Version,index):
    jobs = 0
    for Tid in SnmpPull:
        for SnmpQuery1 in interfacetraffic:
            #time.sleep(.00001)
            task_queue.put([Tid,SnmpQuery1,index,Snmp_Community,Snmp_Version], block=True)
            jobs += 1
    return jobs



def BuildWork(SnmpPull, args):
    if SnmpPull[1] == 1:
        AddInterfaceInfoToPool(SnmpPull[0],interfaceinfo,args.Snmp_Community,args.Snmp_Version)
        AddInterfaceTrafficToPool(SnmpPull[0],interfacetraffic,args.Snmp_Community,args.Snmp_Version,SnmpPull[1])
    elif SnmpPull[1] == 2:
        AddInterfaceTrafficToPool(SnmpPull[0],interfacetraffic,args.Snmp_Community,args.Snmp_Version,SnmpPull[1] + 1)


# this is the part that does the snmp pull. this will be split across manny processes
def query(work):
#   work == Tid,SnmpQuery,index,Snmp_Community,Snmp_Version
    result =''
    try:
        #time.sleep(randint(0,5))
        oid = netsnmp.VarList(netsnmp.Varbind('%s' % work[1][1]))
        pull = netsnmp.snmpwalk(oid, Version = work[4], DestHost=work[0], Community='%s' % (work[3]), Timeout=2000000, Retries=2) # timeout is in MS. there is good error handling in the netsnmp mod.
        if pull:
            pulllist = list(pull)
            result = work[0],work[1][0],pulllist,work[2],time.time()
        else:
            result = work[0],work[1][0],'Pull Failed',work[2],time.time()
    except Exception, err:
        print "printing err", err
        result = work[0],work[1][0],'Pull Failed',work[2],time.time()
    finally:
        return result


# this will build the list to pull for the first snmp pull.
def workerpass1(task_queue, done_queue,inttimeoutqueue,index):
#    Tid,SnmpQuery,'intinfo',Snmp_Community,Snmp_Version
    for func in iter(task_queue.get, 'STOP'):
        #print "func", func
        result = query(func)
        done_queue.put(result, block=True)
        if result[1] == "ifInUcastPkts" or result[1] == "ifOutUcastPkts":
            if index == 1:
                if result[3] in range(1,2):
                    inttimeoutqueue.put([result[0],func[1],result[2],result[3],result[4]],block=True)
            if index == 2:
                if result[3] in range(3,5):
                    inttimeoutqueue.put([result[0],func[1],result[2],result[3],result[4]],block=True)


# this will build the list for the second, third and forth snmp pull.
def workerpass2(inttimeoutqueue,task_queue,index,Snmp_Community,Snmp_Version,Time_Sample):
#  format that needs to be placed in  task_queue  = Tid,SnmpQuery,index,Snmp_Community,Snmp_Version
    for func in iter(inttimeoutqueue.get, 'STOP'):
        if time.time() - func[4] > Time_Sample:
            task_queue.put([func[0],func[1],func[3] + 1,Snmp_Community,Snmp_Version])
        else:
            inttimeoutqueue.put(func)



def spinning_cursor():
    while True:
        for cursor in '|/-\\':
            yield cursor
spinner = spinning_cursor()


# this will check the done Q to see if there is work to process
def RemoveFormDoneQPutInDict(done_queue,SnmpPull,index):
    if index == 1:
        numberofjobs = numberofwork1(SnmpPull,interfaceinfo,interfacetraffic)
    elif index == 2:
        numberofjobs = numberofwork2(SnmpPull,interfacetraffic)
    pullcounter = 0
    start_time = time.time()
#    while done_queue.empty() != True and pullcounter != numberofjobs:
    while pullcounter != numberofjobs:
        gen = done_queue.get(block=True)
        sys.stdout.write(spinner.next())
        sys.stdout.flush()
        time.sleep(0.1)
        sys.stdout.write('\b')
        pullcounter += 1
        if gen[3] == "intinfo":
            SnmpPull[gen[0]]['intinfo'][gen[1]] = gen[2]
        elif gen[3] in range(1,5):
            SnmpPull[gen[0]]['traffic'][gen[3]][gen[1]] = gen[2]
        elif time.time() - start_time > 120:
            print '"Script is broke" Call Creigan and give him the output.', SnmpPull # there should be more error handling here at some point
            break


# This needs to be rebuilt when when I have some time
def ErrReport(SnmpPull, index):
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
    print '###########################################################################################################'
    print '###########################################################################################################'
    # except this part
    # I put this here just for Jim Rethmann
    if getpass.getuser() == 'jrethmann':
        print '____YOU__CAN__DO__IT__JIM____'
        print '###########################################################################################################'
        print '###########################################################################################################'
    print "please check all tids in this list to see if they are on the network\n", badtids
    print '###########################################################################################################'
    print '###########################################################################################################'
    return SnmpPull


# The 4900 snmp clean up only runs the first time you run the script.
def FortyNinecleanup(SnmpPull, index):
    if index == 1:
        for node in SnmpPull.keys():
            if '4c00' in node:
                b = []
                newdict = {}
                newdict['iftype'] = []
                newdict['ifindex'] = []
                newdict['ifname'] = []
                for index, item in enumerate(SnmpPull[node]['intinfo']['iftype']):
                    if 'VLAN-1' == item or 'Vl1' == item or 'Nu0' == item or 'Fa1' in item or 'Gi' in item or 'Te' in item or 'Po' in item:
                        b.append(index)

                for location in b:
                    newdict['iftype'].append(SnmpPull[node]['intinfo']['iftype'][location])
                    newdict['ifindex'].append(SnmpPull[node]['intinfo']['ifindex'][location])
                    newdict['ifname'].append(SnmpPull[node]['intinfo']['ifname'][location])

                SnmpPull[node]['intinfo'].update(newdict)
    else:
        pass


# name is not what it is, this is where the print function will go once we are done building that part of the script
def ParseAndPrint(SnmpPull, index):
    walkawalka = ErrReport(SnmpPull, index)
    FortyNinecleanup(SnmpPull, index)
    print 'Done!'


# save the dictonary to ta file.
def ExportPickleFile(SmNumber,SnmpPull):
    handle = SmNumber + ".bin"
    if handle in os.listdir('.'):
        DateAndTime = datetime.datetime.now().strftime("%a-%B.%d.%Y-%I:%M%p")
        newfilename = SmNumber + '_' + DateAndTime + '.bin'
        with open(newfilename,'wb') as fp:
            pickle.dump(SnmpPull,fp)
    elif handle not in os.listdir('.'):
        with open(handle,'wb') as fp:
            pickle.dump(SnmpPull,fp)


#######################################################################################################################################################################################################
# CTL-C handling this needs to be just before MAIN or it will not work correctly
# When threads are enabled, this function can only be called from the main thread; attempting to call it from other threads will cause a ValueError exception to be raised.
#        https://docs.python.org/2/library/signal.html
#######################################################################################################################################################################################################
def signal_handler(signal,frame):
    print '\nCaught interrupt, cleaning up...'
    for i in MPP:
        task_queue.put('STOP')
    for i in SPP:
        inttimeoutqueue.put('STOP')
    for process in processes:
        process.terminate()

    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
#######################################################################################################################################################################################################


# let the party start.
def main():
    # build timestamp
    start_time = time.time()
    # parse args
    args = parse()
    # set verbose
    verbose = args.verbose
    # this will take list of tids and build dictionary.
    SnmpPull = ParseImportTids(args)
    # this will take list of tids from the dictonary and build the work that need to be done per run of the script
    BuildWork(SnmpPull, args)
    #Start primary processes pool
    for number in range(args.NUMBER_OF_PROCESSES_IN_MAIN_POOL):
        PrimaryProcess = multiprocessing.Process(target=workerpass1,
                                                 args=(task_queue,
                                                       done_queue,
                                                       inttimeoutqueue,
                                                       SnmpPull[1]
                                                       )
                                                 )
        PrimaryProcess.start()
        processes.append(PrimaryProcess)

    # start seconday process pool
    for number in range(args.NUMBER_OF_PROCESSES_IN_SECONDARY_POOL):
        SecondaryProcess = multiprocessing.Process(target=workerpass2,
                                                   args=(inttimeoutqueue,
                                                         task_queue,
                                                         SnmpPull[1],
                                                         args.Snmp_Community,
                                                         args.Snmp_Version,
                                                         args.Time_Sample
                                                         )
                                                   )
        SecondaryProcess.start()
        processes.append(SecondaryProcess)
        SPP.append(1)

    # check done Queue for work to be processed.
    RemoveFormDoneQPutInDict(done_queue, SnmpPull[0], SnmpPull[1])
    print "KILLING off process pool"
    time.sleep(1)

    # Tell primary child processes to stop
    for i in MPP:
        task_queue.put('STOP')
        if verbose == 1:
            print "Stopping Process #%s" % i
    # Tell secondary child processes to stop
    for i in SPP:
        inttimeoutqueue.put('STOP')
        if verbose == 1:
            print "Stopping Process #%s" % i
    # this sleep is here for system clean up
    time.sleep(1)
    # A kill all processes
    for process in processes:
        process.terminate()
    time.sleep(2)
    print "Process pool cleaned up"
    # This is where the print statment was before changing a bunch of stuff around. The print function will go back here at some point.
    ParseAndPrint(SnmpPull[0], SnmpPull[1])

    # save file. O ya hildo, it is a bin use "metroprint -df -sm <SM_NUMBER> > 'file name'" now you can do what you want in perl. ( ha, perl! )
    ExportPickleFile(args.Scheduled_Maintenance,SnmpPull[0])


    # print run time of the script.
    print "Result (%.2f secs)" % (time.time() - start_time)


if __name__ == "__main__":
    main()
