#!/usr/bin/perl

use 5.18.0;
use warnings;
say "first perl script";
sub print_hash;
main();

sub main {
    #say foreach @ARGV;
	my $fileName = \@ARGV;
	my $fn;
	my %hash; 	 # attribute as the key and the valueof
		 	 # the attribute is the value in hash
	my @lines_text;  # entire text of the line array
	
	die "wrong file!" unless  open($fn,'<', @ARGV);
	while(my $line = <$fn>){
		unshift @lines_text, $line;
	}
	my $arraySize = scalar @lines_text;
	my $i=0;
	my $s = $lines_text[1];
	my $key_temp;
	while($arraySize>0){
			my @array1;
			my $s1	= $lines_text[$i]; 
			if($s1=~/\S/g){
				say "BLANK LINE DETECTED";
			}
			@array1 = $s1 =~ /(.*) = /g;
			$key_temp = $array1[0]; 			
			
			my $s2  = $lines_text[$i];
			my @array2 = $s2 =~ / = (.*)/g;
			$hash{$key_temp} = $array2[0];
			
		$arraySize = $arraySize - 1;	
		$i= $i + 1;
	}
	say "***********************END OF WHILE LOOP HERE**************************\n";
	my $value;
 say"##################### hash being passed ". \%hash;
	print_hash(\%hash);
	say "state the name of attribute: ";
	my $atb_name = <STDIN>;
	
	foreach my $j (keys %hash){
		$value = $hash{$j};
		chomp($atb_name);
		chomp($j);
		if($j eq $atb_name){
			say "value is: ". $value;
		}
	#	print " key value: $j <;, and the value: $value\n";
	}
}
sub search_hash{
	my %hash1 = %_;
	my $key_arg = $_;
	my $valueOrKey = $_;
	my $refHash = \%hash1;
	say "hash1 received: ".$refHash;
	if($valueOrKey==1){
		say"key";
		say "key value is: ". $key_arg;
	} 
	else{
		say "value";
		say "value is: ". $key_arg;
	}
	
	my $value1;
	foreach my $j (keys %hash1){
		$value1 = $hash1{$j};
		
		if($valueOrKey ==1 and $j eq $key_arg){
			return $value1;
		}
		else {
			if($valueOrKey==0 and $value1 eq $key_arg ){
				return $value1;
			}
		}
		print " key value: $j \n";
	}
		



}
sub print_hash{
	my($new_hash) = @_;
	say "hash received inside the print_has sub: ". \%{$new_hash}. "compare with: ". \%_;
	my $refHash = $new_hash;
	say "hash1 received: ".$refHash;
	my $value;
	say "check if it actually reaches this place";
	foreach my $j (keys %{$new_hash}){
		$value = $new_hash->{$j};
		say "key value: ". $j; 
	}
	
}
