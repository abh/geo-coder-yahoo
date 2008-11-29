#!perl -T
use strict;
use warnings;
use Test::More tests => 13;
use LWP::Simple;
#use Data::Dump qw(dump);
use utf8;

use Encode qw(encode);

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

       ok($p = $g->geocode(location => 'Montréal, QC'), 'geocode Montréal, Canada');
       ok(@$p == 1, 'got just one result');
       TODO: { 
           local $TODO = "Yahoo API doesn't support utf8 input";
           is($p->[0]->{city}, 'Montréal', 'got the right city');
       }

   }

   ok($p = $g->geocode(location => 'Berlin, Dudenstr. 24' ), 'geocode a street in Berlin, Germany');
   is($p->[0]->{address}, "Dudenstra\xdfe 24");

   {
       local $TODO = "Yahoo API doesn't support utf8 input (a PASS here might be an accident)";
       use utf8;
       ok($p = $g->geocode(location => 'Słubice, Poland' ), 'using unicode codepoints > 255');
       like($p->[0]->{city}, qr{Słubice});
   }

}

