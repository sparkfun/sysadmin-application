#!/usr/bin/env python

import csv
import sys
import ldap


# Given an uid find the full name (gecos)
def lookup(uid):
    try:
        l = ldap.initialize("ldap://ldapserver.domain.com")
	dn = "cn=readonlyuser,dc=domain,dc=com" 
	password = "password"
	l.simple_bind(dn, password)
	base_dn = 'ou=People,dc=domain,dc=com'
	filter = '(uid=%s)' % (uid)
	attrs = ['givenName','sn']
	gecosraw = l.search_s(base_dn, ldap.SCOPE_SUBTREE, filter, attrs )
	if gecosraw:
		gecos = gecosraw[0][1]['givenName'] + gecosraw[0][1]['sn']
        	return ' '.join(gecos)
	l.unbind
    except ldap.LDAPError, e:
        return 'uid (Full name not found)'

def main():
    if len(sys.argv) != 3:
        print "Usage: python user_ldap_mapping.py [uidfield] [gecosfield]"
        sys.exit(1)

    uidfield = sys.argv[1]
    gecosfield = sys.argv[2]

    infile = sys.stdin
    outfile = sys.stdout

    r = csv.DictReader(infile)
    header = r.fieldnames

    w = csv.DictWriter(outfile, fieldnames=r.fieldnames)
    w.writeheader()

    for result in r:
        # Perform the lookup
        if result[uidfield] and result[gecosfield]:
            # both fields were provided, just pass it along
            w.writerow(result)

        elif result[uidfield]:
            # uid was provided, add gecos
            result[gecosfield] = lookup(result[uidfield])
            if result[gecosfield]:
                w.writerow(result)

main()