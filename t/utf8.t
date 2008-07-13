#!perl -T
use strict;
use warnings;
use Test::More tests => 6;
use LWP::Simple;
#use Data::Dump qw(dump);

use_ok( 'Geo::Coder::Yahoo' );

ok(my $g = Geo::Coder::Yahoo->new(appid => 'perl-geocoder-test'), 'new geocoder');
isa_ok($g, 'Geo::Coder::Yahoo', 'isa');

SKIP: {
   skip 'Requires a network connection allowing HTTP', 5 unless get('http://www.yahoo.com/');

   ok(my $p = $g->geocode(location => 'Montreal, Canada'), 'geocode Montreal, Canada');
   ok(@$p == 1, 'got just one result');
   is($p->[0]->{city}, 'Montréal', 'got the right city');




}

