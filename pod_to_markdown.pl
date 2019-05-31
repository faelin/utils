#!/bin/perl

use Pod::Markdown;
use File::Basename;
use open IO => ':utf8';

my $suffs = qr/\.(?:md|mdown|markdown|markdn|pl|pm|pod)/;

my $source = $ARGV[0] or die "Source-file argument required!";
my $dest = ($ARGV[1] // $source) =~ s/$suffs$/.md/r;

while (-e $dest) {
  my ($name, $path) = fileparse($dest => $suffs );
	my $index = $1 if $name =~ s/\h\((\d+)\)$//;
	$dest = "$path$name (" . ++$index . ').md';
}

open( INPUT_FH, '<', $source ) or die $!;
open( OUTPUT_FH, '>', $dest ) or die $!;
my $parser = Pod::Markdown->new;
$parser->output_fh( *OUTPUT_FH );
$parser->parse_file( *INPUT_FH );
