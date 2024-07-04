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

my $catalog  = q(catalog.html);                                                 # Catalog file

makeDieConfess;

my @f = searchDirectoryTreesForMatchingFiles currentDirectory, qw(.txt);

my @m;
for my $f(@f)                                                                   # Read each file
 {my $D = readFile $f;
     $D =~ s(":) (" =>)gs;
  my $d = eval $D;
  say STDERR $@ if $@;
  push @m, $d;
 }

if (@m)                                                                         # Create html
 {my @h = <<END;
<table border=0 cellpadding=10>
END

  push @h, join ' ', '<tr>', map {"<th>$_"} sort keys $m[0]->%*;                # Table column headers

  for my $m(@m)
   {my @k = sort keys $m->%*;
    my @d = map {"<td>".$$m{$_}} @k;                                            # Data in column header order
    push @h, join ' ', "<tr>", @d;
   }
  push @h, <<END;
</table>
END
  owf $ARGV[1]//$catalog, join "\n", @h;
 }
