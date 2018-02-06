#!/usr/bin/perl

# =======================================================================

use DBI;
use utf8;
use strict;
use Net::Ping;

# =======================================================================

my %nodes;
my $rc;
my $rx;

my $JOBS = 64;
my $PKTS = 64;
my $DBURI = 'dbi:mysql:host=****;port=****';
my $DBUSR = '****';
my $DBPWD = '****';

my $dbh = DBI->connect($DBURI, $DBUSR, $DBPWD);
$dbh->{'mysql_enable_utf8'} = 1;
$dbh->do('set names utf8');


my $site_assets = $dbh->selectall_arrayref("**** LIMIT 0,1000");
$dbh->disconnect;

my $pcs = 0;


while((scalar @{$site_assets}) > 0) 
{
	my $site_packet = [ splice(@{$site_assets},0,$PKTS) ];
	
	if(not fork())
	{
		my $icmp = Net::Ping->new('icmp', 1);
		$dbh = DBI->connect($DBURI, $DBUSR, $DBPWD);
		$dbh->begin_work;
		foreach my $asset (@{$site_packet})
		{
			my $rv = $icmp->ping($asset->[0]);
			
			my $time = time();
			my $inst = $asset->[0];
			my $ival = 300;
			
			##print "\tHost\t$asset->[0]\t$rv\n";
	
			my $q = "INSERT INTO availability_tool.availability_results ";
			
			if($rv)
			{
				$q.="(ar_ip4addr, ar_last_update, ar_update_interval, ar_last_state, ar_last_up) ";
				$q.="VALUES(?, ?, ?, 1, ?) ";
			}
			else
			{
				$q.="(ar_ip4addr, ar_last_update, ar_update_interval, ar_last_state, ar_last_down) ";
				$q.="VALUES(?, ?, ?, 0, ?) ";
			}
			$q.="ON DUPLICATE KEY UPDATE ";
			if($rv)
			{
				$q.="ar_last_update=?, ar_update_interval=?, ar_last_state=1, ar_last_up=?, ";
			}
			else
			{
				$q.="ar_last_update=?, ar_update_interval=?, ar_last_state=0, ar_last_down=?, ";
			}
			
			$q.="ar_last_0=ar_last_state,  ar_last_1=ar_last_0, ar_last_2=ar_last_1, ar_last_3=ar_last_2, ar_last_4=ar_last_3, ar_last_5=ar_last_4, ar_last_6=ar_last_5, ar_last_7=ar_last_6, ar_last_8=ar_last_7, ar_last_9=ar_last_8, ar_last_10=ar_last_9, ar_last_11=ar_last_10, ar_last_12=ar_last_11, ar_last_13=ar_last_12, ar_last_14=ar_last_13, ar_last_15=ar_last_14, ar_last_16=ar_last_15, ar_last_17=ar_last_16, ar_last_18=ar_last_17, ar_last_19=ar_last_18 ";
	
			my $sth = $dbh->prepare($q);
			my $rc = $sth->execute($inst, $time, $ival, $time, $time, $ival, $time);
			##print STDERR  "$rc = $q\n";
		}
		$dbh->commit();
		$dbh->disconnect;
		$icmp->close();
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

