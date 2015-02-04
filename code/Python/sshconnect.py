#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Jun  9 20:13:07 2014
@author: cwray
"""

import pexpect
import subprocess
import getpass
import os
from time import sleep


class sshconnect():
    """ SSHconnect class was built to abstract the connection process and to
    provide ssh connection handling. 'hostename', 'username', and 'password'
    are required! port_number is not required but set to default to port 22."""
    def __init__( self, hostname, username, password, port_number=22 ):
        self.hostname = hostname
        self.username = username
        self._password = password
        self.port_number = port_number


    def _auth(self):
        badassword = '[pP]ermission denied'
        self.child.waitnoecho()
        self.child.sendline(self._password)
        p = self.child.expect([self.post_auth_prompt, badassword, pexpect.TIMEOUT], timeout=10)
        a = 1
        if p == 0:
            print 'auth 0'
            sleep(1)
            a = 1
            b = 1
            return (a, b, True, 'connection established')
        elif p == 1:
            a = 1
            b = 1
            return (a, b, False, 'Permission denied')
        elif p == 2:
            a = 1
            b = 1
            return (a, b, False, 'connection timed out')


    def establish(self, post_auth_prompt, pre_auth_prompt='not in use yet'):
        """ return ('boolean','msg'). Return 'True' if  connection is GOOD. Return 'False' if  connection is BAD """
        self.pre_auth_prompt = pre_auth_prompt  # not using this yet.
        self.post_auth_prompt = post_auth_prompt
        os.environ["TERM"] = "dumb"

        a = 0
        while a == 0:
            b = 0
            newkey = 'Are you sure you want to continue connecting'
            badkey = 'WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!'
            badassword = '[pP]ermission denied'
            clean_ssh = subprocess.call('rm -f ~/.ssh/known_hosts', shell=True)

            self.child = pexpect.spawn('ssh -p %s -l %s %s' % (self.port_number, self.username, self.hostname,))
            self.child.setecho(False)
            i = self.child.expect([pexpect.TIMEOUT, newkey, badkey, badassword, '[Pp]assword:'], timeout=30)
#            self.child.logfile = sys.stdout            #### set to log to standard out
#            self.child.logfile = open('testlog', "w")  #### Set to log to a file in CWD

            while b == 0:
                if i == 0: # ssh failed to work.
                    # print child.before, child.after
                    return (False,'connection timed out')
                    a = 1
                    b = 1

                elif i == 1: # ssh is asking to except a new key
                    self.child.sendline ('yes')
                    self.child.expect('[Pp]assword:', timeout=10)  # OR '[?#\/<>$] ']')
                    c = self._auth()
                    a = c[0]
                    b = c[1]
                    return (c[2], c[3])

                elif i == 2: # ssh key has changed reset key and try again.
                    print "clean keys"
                    self.child.kill()
                    clean_ssh
                    b = 0

                elif i == 3: # Permission denied
                    print 'Permission denied'
                    return (False,'Permission denied')
                    a = 1
                    b = 1

                elif i == 4:
                    print 'auth'
                    c = self._auth()
                    a = c[0]
                    b = c[1]
                    return (c[2], c[3])


    def SendReceive(self, command, post_auth_prompt, delay=3):
        """ This call will return a tuple. Delay needs to be an int.
        The first value being a boolean true/false if the command ran or not.
        The second will be a string of the output of your command if it passed.
        If your command failed there will be output describing why. """
        self.child.sendline(command)
        sleep(delay)
        a = self.child.expect([post_auth_prompt, pexpect.TIMEOUT])
        if a == 0:
            boo = True
            report = self.child.before
        if a == 1:
            boo = False

        return (boo, report)


    def connectioncheck(self):
        """ return bolean. This is checking the isalive() and isatty() methods.
        format will be 'a=isalive b=isatty will return a tuple ( a ,b )"""
        a = self.child.isalive()
        b = self.child.isatty()
        return (a, b)


    def close(self):
        """Close connection"""
        if self.child.isalive():
            self.child.sendline('exit')
            retrycount = 0
            while retrycount <= 4:
                retrycount += 1
                print'retrying to close connection'
                self.child.close(force=True)
                sleep(1)
            if self.child.isalive() == False:
                return True
            elif self.child.isalive() == True:
                return False

        else:
            return False



# This is here for unit testing. HA UNIT! "http://t2.gstatic.com/images?q=tbn:ANd9GcQg6qsGLSoiCafG42ctsixiTEhh2PnKSWIorkqM1lxLaIkNtMjr"
def main():
#    hostname = raw_input('Hostname: ')
    hostname = 'localhost'
#    username = raw_input('User: ')
    username = 'cwray'
    password = getpass.getpass('Password: ')
#    password = 'you thought i would put a password in here'
    post_auth_prompt = '\$' ### change prompt for your system
    command = 'ls -la'
    connection = sshconnect(hostname,username,password)
    a = connection.establish(post_auth_prompt)
    print connection.connectioncheck()
    print a[1]
    if a[0] == False:
        print a[1]
        connection.close()
        print connection.connectioncheck()
        os._exit(1)
    else:
        print 1
        print connection.SendReceive(command, post_auth_prompt)
        print 2
        print connection.SendReceive('uname -a', post_auth_prompt)
        print 3
        print connection.SendReceive('which python', post_auth_prompt)
        print 4
        print connection.SendReceive('ls', post_auth_prompt)
        print 5
        print connection.connectioncheck()
        connection.close()
        print connection.connectioncheck()
        print 6

if __name__ == '__main__':
    main()
