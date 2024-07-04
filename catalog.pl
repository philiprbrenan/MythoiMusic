#!/usr/bin/perl -I/home/phil/perl/cpan/DataTableText/lib/
#-------------------------------------------------------------------------------
# Catalog available music
# Philip R Brenan at appaapps dot com, Appa Apps Ltd Inc., 2024
#-------------------------------------------------------------------------------
use v5.34;
use warnings FATAL => qw(all);
use strict;
use Carp;
use Data::Dump qw(dump);
use Data::Table::Text qw(:all);

my $catalogHtm = q(catalog.html);                                               # Catalog file as html
my $catalogCsv = q(catalog.csv);                                                # Catalog file as csv

makeDieConfess;

my @f = searchDirectoryTreesForMatchingFiles currentDirectory, qw(.txt);        # Files to process

my @m;
for my $f(@f)                                                                   # Read each file
 {my $D = readFile $f;
     $D =~ s(":) (" =>)gs;
  my $d = eval $D;
  say STDERR $@ if $@;
  push @m, $d;
 }

if (@m)                                                                         # Create html
 {my @k = sort keys $m[0]->%*;
  my @h = <<END;
<table border=0 cellpadding=10>
END

  push @h, join ' ', '<tr>', map {"<th>$_"} @k;                                 # Table column headers

  for my $m(@m)
   {my @k = sort keys $m->%*;
    my @d = map {"<td>".$$m{$_}} @k;
    push @h, join ' ', "<tr>", @d;
   }
  push @h, <<END;
</table>
END
  owf $catalogHtm, join "\n", @h;
 }

if (@m)                                                                         # Create csv
 {my @k = sort keys $m[0]->%*;
  my @h = join ', ',  @k;

  for my $m(@m)
   {my @d = map {"<td>".$$m{$_}} @k;
    push @h, join ', ', map {"$_"} @d;
   }
  owf $catalogCsv, join "\n", @h;
 }
