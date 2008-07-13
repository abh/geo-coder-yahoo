
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Geo::Coder::Yahoo',
    AUTHOR              => 'Ask Bjoern Hansen <ask@develooper.com>',
    VERSION_FROM        => 'lib/Geo/Coder/Yahoo.pm',
    ABSTRACT_FROM       => 'lib/Geo/Coder/Yahoo.pm',
    PL_FILES            => {},
    PREREQ_PM => {
                  'Test::More' => 0,
                  'Yahoo::Search::XML' => '20060729.004',
                  'LWP::UserAgent' => 0,
                  'URI' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Geo-Coder-Yahoo-*' },
);
