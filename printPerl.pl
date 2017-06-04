#! usr/bin/perl

use 5.18.0;
use warnings;

say "sample program to test piping from c programs";

my $stringInput = <STDIN>;
say "this: ". $stringInput;
