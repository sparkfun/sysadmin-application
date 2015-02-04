#!/usr/bin/perl -w
#########################################################################
# Batch create home directories on servers
########################################################################## 

use strict;
use Net::SSH::Perl;

my $servername;
my $userid;
my @idrsa = "/home/automation/.ssh/idrsa";
my($stdout, $stderr, $exit);

if ($#ARGV < 1 ) {
	print "Usage: $0 userid servername [servername] [servername]\n";
	exit(1);
}

# Extract userid from first argument
$userid = $ARGV[0]; shift @ARGV;

# For the remaining servernames passed as arguments, connect and create home directories.
while (@ARGV) {

$servername = $ARGV[0];

my $serverssh = Net::SSH::Perl->new($servername, protocol => 2, interactive => 0, debug => 0, identity_files => \@idrsa);
$serverssh->login;

($stdout, $stderr, $exit) = $serverssh->cmd("sudo mkdir /home/users/$userid");
die "Can't mkdir: $stderr\n" unless $exit == 0;

($stdout, $stderr, $exit) = $serverssh->cmd("sudo chown -R $userid:staff /home/users/$userid");
die "Changing home dir perms failed!: $stderr\n" unless $exit == 0;

print "Home directory created on $servername for $userid successfully\n";

shift @ARGV;
}
