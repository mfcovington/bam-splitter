#!/usr/bin/env perl
# Mike Covington
# created: 2013-12-11
#
# Description: Split a bam file based on run/lane info
#
use strict;
use warnings;
use autodie;

my $bam_file = $ARGV[0];
my %bam_out_fh;

open my $bam_fh, "-|", "samtools view $bam_file";
while (<$bam_fh>) {
    my ( $machine_run, $lane ) = split /:/;
    open $bam_out_fh{"$machine_run-$lane"}, ">", "$machine_run-$lane.sam"
      unless exists $bam_out_fh{"$machine_run-$lane"};
    print { $bam_out_fh{"$machine_run-$lane"} } $_;
}
close $bam_fh;

close $bam_out_fh{$_} for keys %bam_out_fh;
