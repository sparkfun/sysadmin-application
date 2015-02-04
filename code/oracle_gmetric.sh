#!/usr/bin/ksh
#########################################################################
# Script displays total memory usage for oracle instance running under AIX
# Oracle Memory Statistics
########################################################################## 
GMETRIC=/opt/freeware/bin/gmetric
ORACLE_SID=oraclesid
SMON_PID=$(ps -fu oracle | fgrep "ora_smon_${ORACLE_SID}" | grep -v grep | awk '{print $2}')

# Oracle shared (SGA) RSS memory - Determine page size and calculate sum usage
svmon -P $SMON_PID | grep shmat | 
  awk '{if($6 == "s" || $6 == "sm") {page_size=4} 
        else if ($6 == "m") {page_size=64} 
        else if ($6 == "L") {page_size=16*1024} 
        else {page_size = -1}; rss += $7; virt += $10} 
       END {print int(rss*page_size/1024), int(virt*page_size/1024)}' | read sga_rss sga_vss

# Oracle process (PGA) memory sum
ps vgw | egrep " oracle${ORACLE_SID} | ora_.*_${ORACLE_SID} " | grep -v egrep | 
  awk '{rss += ($7-$10); virt+= $6; code=$10 } END {print int((rss+code)/1024), int(virt/1024)}' | read proc_rss procs_vss

# Total Oracle RSS memory
(( total_rss = $sga_rss + $proc_rss ))

# Submit data to Ganglia
${GMETRIC} -n "Oracle SGA RSS" -v ${sga_rss} -t uint32 -x 300 -u "MB" 
${GMETRIC} -n "Oracle SGA Virtual" -v ${sga_vss} -t uint32 -x 300 -u "MB" 
${GMETRIC} -n "Oracle Process RSS" -v ${proc_rss} -t uint32 -x 300 -u "MB" 
${GMETRIC} -n "Oracle Process Virtual" -v ${proc_vss} -t uint32 -x 300 -u "MB" 
${GMETRIC} -n "Oracle Total Memory" -v ${total_rss} -t uint32 -x 300 -u "MB" 
