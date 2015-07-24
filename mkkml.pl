#!/usr/bin/env perl
# create kml from txt genereated by scrapgps.pl
use feature 'say';
use warnings; use strict;
#use HTML::Entities;


say '
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
 <Document>
 <name>Mountain Project PA</name>
';
#Acid Drop		40.5682	-75.4358	Pennsylvania>North Central>Pennsylvania>Northeast Ridges and Valleys>Bauer Rock (South Mountain)>White Trash Rocks
while(<>) {
 chomp;
 my ($name,$type,$lon,$lat,$tree) = split/\t/;
 $name =~ s/&/and/g; $name =~ s/>/--/g;$name =~ s/[^A-Za-z0-9]/ /g;
 $tree =~ s/&/and/g; $tree =~ s/>/--/g;$tree =~ s/[^A-Za-z0-9]/ /g;

 #$name = encode_entities($name);
 #$tree = encode_entities($tree);
 say "
 <Placemark>
   <name>$name $type</name>
   <description>$tree</description>
   <Point>
     <coordinates>$lat,$lon</coordinates>
   </Point>
 </Placemark>
"

}

say "</Document></kml>";
