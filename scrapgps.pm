#!/usr/bin/env perl
use strict; use warnings;
use feature qw/say/;
use Mojo::DOM;
use Mojo::UserAgent;
use Data::Dumper;

#my $url="http://mountainproject.com/v/pennsylvania/105913279";
## first argument can be a url
#$url = $ARGV[0] if $ARGV[0];
#
#getMPRoutes([$url],'',[]);

#sub new {
# my $self = shift;
# $self->{root} = shift;
# $self->{root}='http://mountainproject.com' if !$self->{root}; # default to mountain project
#}

sub getMPRoutes {
 my ($origurl,$name,$loc) = @_;
 my $url=$origurl->[0];

 $url='http://mountainproject.com' . $url if $url =~ m:^/v:;

 #say "# $url $name @$loc";
 my $dom = Mojo::UserAgent->new->get($url)->res->dom;
 
 # what is this place called
 my $title = $dom->at('h1')->all_text; 
 $title="$name>$title" if $name;

 # where is it located
 my $locdom=$dom->at('.rspCol > table');
 $loc=[$1, $2] if $locdom and $locdom->all_text =~ m/Location: ([-\d\.]+), ([-\d\.]+)/;
 
 # routes
 my $routes = $dom->at('#leftNavRoutes');

 # if no routes get links and descend
 if(!$routes){
   
   #if we cannot descend than its all over
   #
   my $navdom=$dom->at('#viewerLeftNavColContent');
   return 0 if(!$navdom);

   my @doma = $navdom->find('a')->map(attr=>'href')->each;
   # map(attr => 'id')

   for my $a (@doma) {
     next unless $a =~ /v/ and $a!~/all-locations/;
     
     # dont go anywhere we've been
     next if grep {"$a" eq "$_"} @$origurl;

     #say "# descending $title @$loc to $a";
     getMPRoutes([$a,@$origurl ],$title,$loc)
   }

 } else {

   my @rinfo=();
   for my $tr ( $dom->at('#leftNavRoutes')->find('tr')->each ) {
      my $namedom = $tr->at('a');
      my $typedom = $tr->find('span.textLight');
      #say Dumper( $tr->find('span')->text );
      my $rt = [ 
        $namedom?$namedom->all_text:"NA",
        $typedom?$typedom->map('text')->join(" "):"NA",
       
       # $tr->at('a')->all_text,
       # $tr->find('span.textLight')->all_text,
       
        # ( $tr->find('span.rateYDS')->text || "") .
        # ( $tr->find('span.rateHueco')->text || ""),
        #$tr->at('a')->attr('href')
        $namedom?$namedom->attr('href'):"NA"
      ];
      push @rinfo, $rt;
   }

   say join("\t",@$_,@$loc,$title) for @rinfo;
 } 

 #return 0;
}

1;
