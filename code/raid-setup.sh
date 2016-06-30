## This is a simple RAID config script to display some basic understanding of bash scripting
## Most of the step from http://www.tecmint.com/create-raid-5-in-linux/

function create-partition(){
	# sed block borrowed and updated from http://superuser.com/questions/332252/creating-and-formating-a-partition-using-a-bash-script
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk $drive
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
    # full disk
  p # print the in-memory partition table
  t # change partition type
  fd # select linux raid
  w # write the partition table
EOF
}

# iterate through desired drives to setup the partitions
for drive in /dev/sd[b-e] ; do
	create-partition $drive
done;

# create the RAID Array
sudo mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

# format file system on RAID 
sudo mkfs.ext4 /dev/md0

# create dir to mount filesystem
sudo mkdir /mnt/raid

# mount at boot; use UUID of drive instead of filepath
sudo bash -c 'echo "UUID=$(sudo blkid -o value /dev/md0 | head -n 1)  /mnt/raid  ext4  defaults  0  0" >> /etc/fstab'

# persist RAID config
sudo bash -c 'mdadm --detail --scan --verbose >> /etc/mdadm.conf'

# mount RAID with an alias just for giggles
alias sma="sudo mount -a"
sma

# add status at login to keep informed
echo 'cat /proc/mdstat | tail -n 4 | head -n2' >> .bashrc 
