#!/usr/bin/perl -w
#########################################################################
# Script to map LUN ID's to AIX hdisk devices
########################################################################## 
use strict;
use Net::SSH::Perl;

my ($servername, $vioserver, $lparflag, $raw, $rawlunid);
my (@hdisks, @volumegroups, @rawlunids, @lunids, @temp, @viomap, @vtd, @vtdraw);
my @idrsa = ("/home/automation/.ssh/id_rsa"); 	#SSH keys to try for passwordless auth

#Target server name is first (and only) command line variable
$servername = $ARGV[0];		

# Open connection to server and login using private key
my $serverssh = Net::SSH::Perl->new($servername, protocol => 2, interactive => 1, identity_files => \@idrsa);
$serverssh->login;

# Acquire list of volume groups excluding OS and non-datafile VGs
@volumegroups = split /\n/, ($serverssh->cmd("lsvg | egrep -v '(rootvg|workareavg|ora.*vg)'"))[0];

#Store LPAR or system ID
$lparflag = ($serverssh->cmd("uname -L | cut -f1 -d' '"))[0];

# Determind if server is an LPAR or physical
if ($lparflag != 1 and $lparflag != -1) {
	die "This looks like an LPAR, but you didn't specify a VIO server!"
		unless defined $ARGV[1];
	$vioserver = $ARGV[1];

	# If LPAR -> connect to VIO server
	my $viossh = Net::SSH::Perl->new($vioserver, protocol => 2, interactive => 1, identity_files => \@idrsa);
	$viossh->login("padmin");

	# Break out VGs into hdisks and acquire LUN ID. Alter formatting and store.
	foreach my $vg (@volumegroups) {
		foreach my $vscsi (split /\n/, ($serverssh->cmd("lsvg -p $vg | grep hdisk | cut -f1 -d' '"))[0]) {
			$raw = ($serverssh->cmd("lscfg -l $vscsi"))[0];

			if ($raw =~ /L(\w+)/) {
				push @temp, $1; 
			}
		}
                push @hdisks, ucfirst($vg) . "\n";
                push @hdisks, @temp;
		push @hdisks, "\n";
                @temp = ();
	}

	# Acquire list of all VIO disk mappings
	@vtdraw = (split /[:\n]/, ($viossh->cmd("ioscli lsmap -type disk -field backing vtd lun -fmt : -all"))[0]);

	# Extract hdisk, vdev name, and LUN id from VIO mapping output. Convert hdisk to SAN serial
	foreach my $rawcounter (@vtdraw) { 
		if ($rawcounter =~ /(hdisk\d+)/) {
			my $serial = ($viossh->cmd("ioscli lsdev -dev $1 -vpd | grep Serial | awk -F'.' '{ print \$NF }' "))[0];
			$serial =~ s/^\w{7}//;
			push @temp, $serial;
		} elsif ($rawcounter =~ /sy/) {
			push @temp, $rawcounter;
		} elsif ($rawcounter =~ /0x(\w+)0000/) {
		 	push @temp, $1;	
		}	
	}

	chomp(@temp);

	# Search VIO mapping to associate LPAR LUN id to SAN serial and format for output 
	foreach my $hcount (@hdisks) {
		for (my $counter=1; $counter <= $#temp; $counter++) { 
			if ($hcount eq $temp[$counter] && ($temp[$counter-1] =~ /$servername\_\d+/)) {
				$hcount = $temp[$counter-1] . " = " . $temp[$counter-2] . "\n";
			}
		}
	}

	print @hdisks;
	@temp = ();

} else {
	# If not an LPAR proceed with extracting VGS
	foreach my $vg (@volumegroups) {

		# For each VG member associate with SAN serial and format for output
		foreach my $vpath (split /\n/, ($serverssh->cmd("lsvg -p $vg | grep vpath | cut -f1 -d' '"))[0]) {
			my $serial = ($serverssh->cmd("datapath query device | grep -wp $vpath | grep SERIAL | cut -f2 -d' '"))[0];
			$serial =~ s/^\w{7}//;
                        push @temp, (sprintf("%-9s", $vpath) . "= " . $serial);
		}
		push @hdisks, ucfirst($vg) . "\n";
		push @hdisks, @temp;
		push @hdisks, "\n";
		@temp = ();
	}

	print @hdisks;
}
