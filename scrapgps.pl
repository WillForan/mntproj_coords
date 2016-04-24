#!/usr/bin/env perl
use strict; use warnings;
use feature qw/say/;
use Mojo::DOM;
use Mojo::UserAgent;
use Data::Dumper;

#my $url="http://mountainproject.com/v/pennsylvania/105913279";
my $url="https://www.mountainproject.com/v/pennsylvania/105913279";
# first argument can be a url
$url = $ARGV[0] if $ARGV[0];

getRoutes([$url],'',[]);

sub getRoutes {
 my ($origurl,$name,$loc) = @_;
 my $url=$origurl->[0];
 $url=~s;http://m;https://www.m;;
 $url='https://www.mountainproject.com' . $url if $url =~ m:^/v:;

 #say "# $url $name @$loc";
 my $dom = Mojo::UserAgent->new->get($url)->res->dom;
 
 # what is this place called
 my $title = $dom->at('h1')->all_text; 
 $title="$name>$title" if $name;


 # where is it located
 my $desctable = $dom->at('.rspCol > table');
 if(!$desctable){
  say STDERR "no loc for $url";
  return;
 }
 $loc=[$1, $2] if $desctable->all_text =~ m/Location: ([-\d\.]+), ([-\d\.]+)/;
 
 # routes
 my $routes = $dom->at('#leftNavRoutes');

 # if no routes get links and descend
 if(!$routes){
   
   my @doma = $dom->at('#viewerLeftNavColContent')->find('a')->attr->each;

   for (@doma) {
     my $a=$_->{href};
     #say Dumper($_);
     next unless $a =~ /v/ and $a!~/all-locations/;
     
     # dont go anywhere we've been
     next if grep {"$a" eq "$_"} @$origurl;

     #say "# descending $title @$loc to $a";
     getRoutes([$a,@$origurl ],$title,$loc)
   }

 } else {

   my @rinfo=();
   for my $tr ( $dom->at('#leftNavRoutes')->find('tr')->each ) {
      #say Dumper( $tr->find('span')->text );
      my $rt = [ 
        $tr->at('a')->text,
        $tr->find('span.textLight')->text,
        # ( $tr->find('span.rateYDS')->text || "") .
        # ( $tr->find('span.rateHueco')->text || ""),
        $tr->at('a')->attr('href')
      ];
      push @rinfo, $rt;
   }

   say join("\t",@$_,@$loc,$title) for @rinfo;
 } 

}
