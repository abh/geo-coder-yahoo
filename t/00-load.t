#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Geo::Coder::Yahoo' );
}

diag( "Testing Geo::Coder::Yahoo $Geo::Coder::Yahoo::VERSION, Perl $], $^X" );

