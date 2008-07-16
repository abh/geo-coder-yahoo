#!perl -T
use strict;
use warnings;
use Test::More tests => 8;
use LWP::Simple;
#use Data::Dump qw(dump);

use_ok( 'Geo::Coder::Yahoo' );

ok(my $g = Geo::Coder::Yahoo->new(appid => 'perl-geocoder-test'), 'new geocoder');
isa_ok($g, 'Geo::Coder::Yahoo', 'isa');

SKIP: {
   skip 'Requires a network connection allowing HTTP', 5 unless get('http://www.yahoo.com/');

   my $p;

   {
       use utf8;
       ok($p = $g->geocode(location => 'Montreal, Canada'), 'geocode Montreal, Canada');
       ok(@$p == 1, 'got just one result');
       is($p->[0]->{city}, 'Montréal', 'got the right city');
   }

   ok($p = $g->geocode(location => 'Berlin, Dudenstr. 24' ), 'gecode a street in Berlin, Germany');
   is($p->[0]->{address}, "Dudenstra\xdfe 24");

}

