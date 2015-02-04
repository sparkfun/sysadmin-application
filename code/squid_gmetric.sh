#!/usr/bin/ksh
#########################################################################
# Script collects Squid statistics through SNMP
# Squid Cache Metrics
########################################################################## 
GMETRIC="/usr/local/bin/gmetric -c /usr/local/etc/gmond.conf"
SNMPGET=/usr/local/bin/snmpget

# Squid Cache Hit Rate Percentage
CACHEPERCENT=`${SNMPGET} -v2c -Oqv -c 'ganglia' squidserver:3401 1.3.6.1.4.1.3495.1.3.2.2.1.9.60`

# Squid Cache Hit Rate Bytes
CACHEBYTE=`${SNMPGET} -v2c -Oqv -c 'ganglia' squidserver:3401 1.3.6.1.4.1.3495.1.3.2.2.1.10.60`

# Submit data to Ganglia
${GMETRIC} --name "Squid Cache Hit Ratio" --value $CACHEPERCENT --type int16 --units "%" 
${GMETRIC} --name "Squid Cache Hit Bytes" --value $CACHEBYTE --type int16 --units "%"