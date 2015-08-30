#!/usr/bin/env perl
use strict; use warnings;
use feature qw/say/;
use Mojo::DOM;
use Mojo::UserAgent;
use Data::Dumper;

use scrapgps;

my $url="http://mountainproject.com/destinations/";

my $dom = Mojo::UserAgent->new->get($url)->res->dom;
my @urls =  $dom->find('.destArea > a')->map(attr=>'href')->each;;
@urls = grep { ! /in-progress|international/i } @urls;
#say join "\n", @urls;
#exit;

for my $u (reverse @urls) {
 say STDERR $u;
 getMPRoutes([$u],'',[]);
 say STDERR "finished $u";
}
 

exit;
