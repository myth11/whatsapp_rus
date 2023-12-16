#!/usr/bin/perl -w

use strict;
use warnings;

use Data::Dumper;
use Net::IP qw(:PROC);
use Net::CIDR::Lite;

my @cidr_list;
my $ip_all;
my @ip_all_filtered;
my @ip_all_filtered_1;
my %ip_all;
my @meta_list;
my $cnt_all;
my $cnt_processed = '0';
my $need_processing = '0';

my $cidr = Net::CIDR::Lite->new;
my $white = 'whatsapp_white.conf';

open(my $fh_w, '<:encoding(UTF-8)', $white)
  or die "Could not open file '$white' $!";

my $prefix = shift @ARGV;
	my $ip = new Net::IP ($prefix);
	do {
		$cnt_all++;
		$need_processing = '0';
		$ip_all{$ip->ip()} = $ip->ip();
	   } while (++$ip);
		while (my $row = <$fh_w>) {
			chomp $row;
			my $ipa = new Net::IP($row) or next;
		do {
			$cnt_processed++;
#			print "Removed Addr: ".$ipa->ip()." ALL: $cnt_processed($need_processing)\n";
			delete $ip_all{$ipa->ip()};
			$need_processing = '1';
		} while (++$ipa);
	}

	for my $ipx (values(%ip_all)) {
        	do {
			$cidr->add_ip($ipx) if $need_processing == '1';
			$cidr->add_any($prefix) if $need_processing == '0';
		}
	}
@ip_all_filtered = $cidr->list;
$cidr->clean;

foreach my $subnet (@ip_all_filtered) {
print "subnet://$subnet\n";
}
