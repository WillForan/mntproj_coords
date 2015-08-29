#!/usr/bin/env perl
use strict; use warnings;
use feature qw/say/;
use Mojo::DOM;
use Mojo::UserAgent;
use Data::Dumper;

use scapgps.pm;

my $url="http://mountainproject.com/destinations/";

my $scrapper = scarpgsp->new();
my $dom = Mojo::UserAgent->new->get($url)->res->dom;
my @urls=  map {$_->{href}} $dom->find('.destArea > a')->attr->each;

for my $u (@urls) {
 getMPRoutes([$u],'',[]);
}
 

exit;
