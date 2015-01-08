#this is a function i used on my VM host back when it was virtuozzo (ew)
function load()
{
    local load=$(cut -d " " -f1 /proc/loadavg | tr -d '.') #dirty but it works
    local dec_load=$((10#$load)) #convert to a decimal, since that's a string
    local cores=$(dmidecode | grep 'Socket.*CPU'| wc -l) #count the number of CPUs
    echo $(($dec_load/10#$cores)); #assuming that 1.00 is 100% load on one core, this divides by the number of cores to return a percentage-based load figure.
}


