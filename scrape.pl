use 5.18.0;
use warnings;
use strict;
use LWP::UserAgent;
use JSON;
use CGI qw/escape/;

# Create an LWP User-Agent object for sending HTTP requests.
my $ua = LWP::UserAgent->new;

# Open data files
open(L, 'locations26.txt') or die "Can't open locations: $!";
open(O, '>', 'out26.txt') or die "Can't open output file: $!";

# Enable autoflush on the output file handle
my $oldh = select(O);
$| = 1;
select($oldh);

while (my $location = <L>) {
    # This regular expression is like chomp, but removes both Windows and
    # *nix line-endings, regardless of the system the script is running on.
    $location =~ s/[\r\n]//g;
    foreach my $year (1923..1923) {
        # If you need to add quotes around the location, use "\"$location\"".
        my %args = (LOCATION => $location, YEAR => $year);

        my $url = 'https://familysearch.org/proxy?uri=https%3A%2F%2Ffamilysearch.org%2Fsearch%2Frecords%3Fcount%3D20%26query%3D%252Bevent_place_level_1%253ACalifornia%2520%252Bevent_place_level_2%253A^LOCATION^%2520%252Bbirth_year%253A^YEAR^-^YEAR^~%2520%252Bgender%253AM%2520%252Brace%253AWhite%26collection_id%3D2000219';
        # Note that values need to be doubly-escaped because of the
        # weird way their website is set up (the "/proxy" URL we're
        # requesting is subsequently loading some *other* URL which
        # is provided to "/proxy" as a URL-encoded URL).
        #
        # This regular expression replaces any ^WHATEVER^ in the URL
        # with the double-URL-encoded value of WHATEVER in %args.
        # The /e flag causes the replacement to be evaluated as Perl
        # code. This way I can look data up in a hash and do URL-encoding
        # as part of the regular expression without an extra step.
        $url =~ s/\^([A-Z]+)\^/escape(escape($args{$1}))/ge;
        #print "$url\n";

        # Create an HTTP request object for this URL.
        my $request = HTTP::Request->new(GET => $url);
        # This HTTP header is required. The server outputs garbage if
        # it's not present.
        $request->push_header('Content-Type' => 'application/json');
        # Send the request and check for an error from the server.
        my $response = $ua->request($request);
        die "Error ".$response->code if !$response->is_success;
        # The response should be JSON.
        my $obj = from_json($response->content);
        my $str = "$args{LOCATION},$args{YEAR},$obj->{totalHits}\n";
        print O $str;
        print $str;
    }
}
