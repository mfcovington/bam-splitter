#!/usr/bin/env perl
# Mike Covington
# created: 2013-12-11
#
# Description: Split a bam file based on run/lane info
#
use strict;
use warnings;
use autodie;
use File::Basename;

my $bam_file = $ARGV[0];
my ( $bam_id, $bam_path ) = fileparse( $bam_file, ".bam" );

open my $header_fh, "-|", "samtools view -H $bam_file";
my @header = <$header_fh>;
close $header_fh;

open my $bam_fh, "-|", "samtools view $bam_file";
my %bam_out_fh;
while (<$bam_fh>) {
    my ( $machine_run, $lane ) = split /:/;
    my $unique_id = "$machine_run-$lane";
    unless ( exists $bam_out_fh{$unique_id} ) {
        my $bam_out = "$bam_id.$unique_id.bam";
        open $bam_out_fh{$unique_id}, "|-", "samtools view -Sb - > $bam_out";
        print { $bam_out_fh{$unique_id} } @header;
    }
    print { $bam_out_fh{$unique_id} } $_;
}
close $bam_fh;
close $bam_out_fh{$_} for keys %bam_out_fh;
