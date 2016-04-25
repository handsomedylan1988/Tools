#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: mono.pl
#
#        USAGE: ./mono.pl  
#
#  DESCRIPTION:extract mono channel audio from multichannel audio
#
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Ran Zhang (Dr.), zran1988@outlook.com
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2016年04月12日 20时40分14秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Getopt::Std;

use vars qw($opt_c $opt_i $opt_o);
getopts("c:i:o:");

if(not defined($opt_c) or not defined($opt_i) or not defined($opt_o))
{
    die("usage: perl ./mono.pl -c [option] -i input.wav -o output.wav\n");
}

open IN, $opt_i;
open OUT,">",$opt_o;

binmode(IN);
binmode(OUT);

my $buf;
my $audiobuf;
read(IN,$buf,44);
my $format="A4IA8ISSIISSA4I";
my ($riff,$filelen,$wavfmt,$pcmsize,$fmttag,$channel,$samplerate,$byterate,$blockalign,$bitpersamples,$data,$audiosize)=unpack($format,$buf);
print "$riff,$filelen,$wavfmt,$pcmsize,$fmttag,$channel,$samplerate,$byterate,$blockalign,$bitpersamples,$data,$audiosize";
my $i=0;
print $opt_c;
while(read(IN,$buf,$blockalign*$bitpersamples/8/$channel))
{
    $i++;
    $audiobuf.=$buf if $i%$channel==$opt_c;
}
$byterate/=$channel;
$blockalign/=$channel;
$audiosize/=$channel;
$filelen=36+$audiosize;
$channel=1;

$buf=pack($format,$riff,$filelen,$wavfmt,$pcmsize,$fmttag,$channel,$samplerate,$byterate,$blockalign,$bitpersamples,$data,$audiosize);
print OUT $buf;
print OUT $audiobuf;



