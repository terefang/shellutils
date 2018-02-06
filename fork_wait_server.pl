#!/usr/bin/perl

# =======================================================================

use utf8;
use strict;

# =======================================================================

my %nodes;
my $rc;
my $rx;

my $JOBS = 64;
my $PKTS = 64;


my $site_assets = $dbh->selectall_arrayref("**** LIMIT 0,1000");
$dbh->disconnect;

my $pcs = 0;

while((scalar @{$site_assets}) > 0) 
{
	my $site_packet = [ splice(@{$site_assets},0,$PKTS) ];
	
	if(not fork())
	{
		foreach my $asset (@{$site_packet})
		{
			##print STDERR  "$rc = $q\n";
		}
		exit(0);
	}
	$pcs++;
	if($pcs>$JOBS)
	{
		$rx = wait();
		$pcs--;
	}
}

while (wait() != -1) {}


__END__

