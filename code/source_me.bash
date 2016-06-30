#
# 'source' this script !
#
if  [ $0 != "-bash" ]
then
   echo "Sorry, it doesn't look like you 'source'd this, exiting."
   return
fi

# it launches the archive tapes
# but assumes the #8 & #9 drives in our tape library are
# disabled (within NetWorker), and loaded with blank tapes

# will prompt for Run# if not supplied
DATE=`date +%Y%m%d`
RUNID="$1"
while  [ "$RUNID" = "" ]
do
   echo -en "\nRun ID (rWXYZ)?:  "
   read RUNID
done

DIR="/ap/lt/$RUNID"
if [ ! -d $DIR ]
then
   echo -e "\nthe archive, \"$DIR\" doesn't exist, bailing\n"
   return
fi

DSIZE=`df -h $DIR  |  tail -1  |  awk '{print $3}'`
echo -e "\nYou'll be archiving ${DSIZE}B worth of $DIR (in the background)...\n"

# let 'em rip
nohup tape.pl /dev/rmt/8b $DIR  > $DATE.1.$RUNID.out  2> $DATE.1.$RUNID.err  &
nohup tape.pl /dev/rmt/9b $DIR  > $DATE.2.$RUNID.out  2> $DATE.2.$RUNID.err  &

