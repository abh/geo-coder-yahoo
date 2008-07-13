package Geo::Coder::Yahoo;
use warnings;
use strict;
use Carp qw(croak);
use URI;
use URI::QueryParam;
use LWP::UserAgent;
use Yahoo::Search::XML;

our $VERSION = '0.40';


my $ua;
sub _ua {
    return $ua if $ua;
    $ua = LWP::UserAgent->new;
    $ua->agent(__PACKAGE__ . '/' . $VERSION);
    $ua->env_proxy;
    $ua;
}

sub new {
    my $class = shift;
    my %args = @_;
    bless { appid => $args{appid} };
} 

sub geocode {
    my $self = shift;
    my %args = @_;

    my $appid = $args{appid};
    $appid = $self->{appid} if !$appid and ref $self;
    croak "appid parameter required" unless $appid;

    my $u = URI->new('http://api.local.yahoo.com/MapsService/V1/geocode');
    $u->query_param(appid => $self->{appid});
    $u->query_param($_ => $args{$_}) for keys %args;

    my $resp = _ua->get($u->as_string);

    return unless $resp->is_success;
    my $parsed = Yahoo::Search::XML::Parse($resp->content);
    return unless $parsed and $parsed->{Result};
    my $results = $parsed->{Result};
    $results = [ $parsed->{Result} ] if ref $parsed->{Result} eq 'HASH';

    for my $d (@$results) {
        for my $k (keys %$d) {
            $d->{lc $k} = delete $d->{$k};
        }
    }

    $results;
}


=head1 NAME

Geo::Coder::Yahoo - Geocode addresses with the Yahoo! API 

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Provides a thin Perl interface to the Yahoo! Geocoding API.

    use Geo::Coder::Yahoo;

    my $geocoder = Geo::Coder::Yahoo->new(appid => 'my_app' );
    my $location = $geocoder->geocode( location => 'Hollywood and Highland, Los Angeles, CA' );


=head1 OFFICIAL API DOCUMENTATION

Read more about the API at
L<http://developer.yahoo.net/maps/rest/V1/geocode.html>.

=head1 PROXY SETTINGS

We use the standard proxy setting environment variables via LWP.  See
the LWP documentation for more information.

=head1 EVIL HACKS

In version 0.01 this module redefined the Yahoo::Search::XML::_entity
function with a bug-fixed one.  In Yahoo::Search 1.5.8 that function
was fixed, so we don't do that anymore.

=head1 METHODS

=head2 new(appid => $appid)

Instantiates a new object.

appid is your Yahoo Application ID.  You can register at
L<http://api.search.yahoo.com/webservices/register_application>.

If you don't specify it here you must specify it when calling geocode.

=head2 geocode( location => $location )

Parameters are the URI arguments documented on the Yahoo API page
(location, street, city, state, zip).  You usually just need one of
them to get results.

C<geocode> returns a reference to an array of results (an arrayref).
More than one result may be returned if the given address is
ambiguous.

Each result in the arrayref is a hashref with data like the following example:

    {
     'country' => 'US',
     'longitude' => '-118.3387',
     'state' => 'CA',
     'zip' => '90028',
     'city' => 'LOS ANGELES',
     'latitude' => '34.1016',
     'warning' => 'The exact location could not be found, here is the closest match: Hollywood Blvd At N Highland Ave, Los Angeles, CA 90028',
     'address' => 'HOLLYWOOD BLVD AT N HIGHLAND AVE',
     'precision' => 'address'
     }

=over 4

=item precision

The precision of the address used for geocoding, from specific street
address all the way up to country, depending on the precision of the
address that could be extracted. Possible values, from most specific
to most general are:

=over 4

=item address

=item street

=item zip+4

=item zip+2

=item zip

=item city

=item state

=item country


=back

=item warning

If the exact address was not found, the closest available match will be noted here.

=item latitude

The latitude of the location.

=item longitude

The longitude of the location.

=item address

Street address of the result, if a specific location could be determined.

=item city

City in which the result is located.

=item state

State in which the result is located.

=item zip 

Zip code, if known.

=item country

Country in which the result is located.

=back

=head1 AUTHOR

Ask Bjoern Hansen, C<< <ask at develooper.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-geo-coder-yahoo at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Geo-Coder-Yahoo>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Geo::Coder::Yahoo

You can also look for information at:

=over 4

=item * Git Repository

The latest code is available from the perl.org Subversion repository,
L<git://git.develooper.com/Geo-Coder-Yahoo.git>.  You can browse it at 
L<http://git.develooper.com/?p=Geo-Coder-Yahoo.git;a=summary>.

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Geo-Coder-Yahoo>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Geo-Coder-Yahoo>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Geo-Coder-Yahoo>

=item * Search CPAN

L<http://search.cpan.org/dist/Geo-Coder-Yahoo>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Yahoo for providing this free API.

=head1 COPYRIGHT & LICENSE

Copyright 2005-2008 Ask Bjoern Hansen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Geo::Coder::Yahoo
