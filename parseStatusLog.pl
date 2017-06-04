#!/usr/bin/perl

use 5.18.0;
use warnings;
use Scalar::Util qw(looks_like_number);
sub print_hash;
main();

sub main {
        my $fileName = \@ARGV;
        my $fn;
        my @lines_text;  # entire text of the line array
 	my $key_temp;
	my @array_temp;
        die "wrong file!" unless  open($fn,'<', @ARGV);
	my $i=0;
	my @array_hashes; # stores the addresses of hash tables
			  # depending on the # of classAdds

LABLE: 	while(my $line = <$fn>){
		my %hash;
		$array_hashes[$i] = \%hash;  # each hash takes the attribute as key of the hash
					     # and each value of the attribute as the value present
					     # in that corresponding key
	      while(my $line = <$fn>){
       		
	 		my $s = $line;
			if(!($s =~ /\S/)){
				$i = $i + 1;
				next LABLE;			
				
			}
		
			my $tem_int = $s;
			if($tem_int =~ /(.*) = /g){ 	# the sample classAdds have a " = " pattern
					    		# separating the attribute from the values
					    		# hence everything before " = " is the attribute 
					    		# or the key of the hash
					    		# and after " = " is value of that key
				@array_temp = $s =~ /(.*) = /g;
				$key_temp = $array_temp[0];
			}
			$tem_int = $s = $line;
			if($tem_int =~ / = (.*)/g){
				@array_temp = $s =~ / = (.*)/g;
				my $value = $array_temp[0];
				$hash{$key_temp} = $value;
			}
		}
	
	}					
	foreach my $j (@array_hashes){     #prints the contents of all the hash tables/classAdds
		say "**********CLASSADD SEPARATOR************";
		print_hash($j,0,0);	
	}
	say "\nstate the name of the attribute: ";
	my $input = <STDIN>;
	chomp($input);
	my $jik=0;
	my @search_results_array;
	my $returnInt;
	$i=0;
	foreach my $j (@array_hashes){
        	
               # say "hash value to passed: $j". "at index: ". $jik;
		 $returnInt = print_hash($j,$input,1); 			#decides if the given stdin corresponds to 
									# an attribute/value
									# depending on that returns a value 
		 $returnInt >= 0 ? $i=10: $i;				# determines if the given stdin is present in hash
		 $search_results_array[$jik] = search_hash($j, $input,$returnInt); # searches the hash 
		 $jik = $jik +1;
	}
	if($i == 0){
		say "SORRY: ATTRIBUTE NOT FOUND. TRYAGAIN! ";
		die;
	}
	say "************************SEARCH RESULTS!**********************";
	say foreach @search_results_array;	
	say "adding the values of the given attribute";
	my $itr= scalar @search_results_array;
	my $index =0;
	my $sum_total=0;
	while($itr){					# adds the value or the entered stdin if number
		if(looks_like_number($search_results_array[$index])){
			$sum_total = $sum_total + $search_results_array[$index];
		}
		$index = $index +1;
		$itr = $itr -1;
	}
	say "the sum is ".$sum_total;
}
# this sub routine prints the attributes present in the hash table
# further also finds out if the given attribute/value is present
# in the hash if found, determines if the stdin is attribute/value
# returns 0 if value
# returns 1 if attribute
# returns -5 if not found in hash
sub print_hash{
        my($new_hash) = shift;
	my $value_key = shift;
	my $donotPrint = shift;
        my $refHash = $new_hash;
       # say "hash1 received: ".$refHash;
        my $value;
	my $temp =0;
	if( $donotPrint){
		chomp($value_key);
	}
        foreach my $j (keys %{$new_hash}){
		$value = $new_hash->{$j};
			if($donotPrint and $temp!=2 and $value_key eq $j){
				$temp =1;
				return 1;
			}
			if($donotPrint and $temp!=1 and $value_key eq $value){
				$temp =2;
				return 0;
			}
			if(!$donotPrint){
                		say "key value: ". $j . " main value: ". $value;
			}
        }
	if($donotPrint and $temp!=1 or $temp!=2){
		return -5;
	}

}
# args: hash table, attribute/value bool, actual stdin value/aattribute
# returns the value of an attribute or the attribute corresponding to a value
sub search_hash{
        my ($hash1) = shift;
        my ($key_arg,$valueOrKey) = (shift,shift);
        my $value1;
        foreach my $j (keys %{$hash1}){
                $value1 = $hash1->{$j};
		chomp($key_arg);
                if($valueOrKey == 1 and ($j eq $key_arg)){
                        return $value1;
                }
                else {
                        if($valueOrKey==0 and ($value1 eq $key_arg)){
                                return $j;
                        }
                }
               # print " key value (bottom print searh_hash): $j \n";
        }

}
