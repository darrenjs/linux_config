#!/usr/bin/perl

use POSIX;
use strict;
use warnings;
use Data::Dumper;

# Process command line args

my $opt_mapfile;
my $opt_mapKeyCol;
my $opt_srcfile;
my $opt_srcKeyCol;
my $opt_verbose = 0;
my $opt_show = 0;

my $opt_delim=' ';

# This is the lookup map.
my %lookup;

#----------------------------------------------------------------------
sub color
{
    my $name = shift;

    my %__colors = ("redinv"    => "\033[31;07m",
                    "redbold"   => "\033[31;01m",
                    "red"       => "\033[31m",
                    "greenbold"     => "\033[32;01m",
                    "green"     => "\033[32m",
                    "brownbold"     => "\033[33;01m",
                    "brown"     => "\033[33m",
                    "bluebold"      => "\033[34;01m",
                    "blue"      => "\033[34m",
                    "magnetabold"   => "\033[35;01m",
                    "magneta"   => "\033[35m",
                    "cyanbold"      => "\033[36;01m",
                    "cyan"      => "\033[36m",
                    "whitebold" => "\033[37;01m",
                    "bold" => "\033[01m",
                    "default"   => "\033[;0m" );

    if ( exists $__colors{$name}  )
    {
        return $__colors{$name};
    }
    else
    {
        return "\033[;0m";
    }
}
#----------------------------------------------------------------------
sub colorcycle
{
    my $index = shift;

    $index = $index % 14;

    return color("redbold") if ($index == 0);
    return color("red") if ($index == 1);
    return color("greenbold") if ($index == 2);
    return color("green") if ($index == 3);
    return color("brownbold") if ($index == 4);
    return color("brown") if ($index == 5);
    return color("bluebold") if ($index == 6);
    return color("blue") if ($index == 7);
    return color("magnetabold") if ($index == 8);
    return color("magneta") if ($index == 9);
    return color("cyanbold") if ($index == 10);
    return color("cyan") if ($index == 11);
    return color("bold") if ($index ==  12);
    return color("default") if ($index == 13);
}
#----------------------------------------------------------------------
sub error
{
  my $color_red = color "redbold";
  my $color_def = color "default";

  print ${color_red} . (join(" ", @_)) .  ${color_def} . "\n";
}
#----------------------------------------------------------------------

#----------------------------------------------------------------------
sub help
{
    my $c1 = color "whitebold" ;
    my $c0 = color ("default");

    print "${c1}vlookup${c0}";
    print "\n\tvlookup - provide Excel-like vlookup capability\n";
    print "\n\tEnrich a SOURCE file by performing a lookup into a MAP. Rows ";
    print "\n\tin the source & map are matched via a lookup key. The columns ";
    print "\n\tholding the key in source & map are specified as arguments.";
    print "\n\n\tColumns are counted from 1 (like awk).";
    print "\n\n${c1}SYNOPSIS${c0}";
    print "\n\tvlookup  [options]  MAPFILE  MAPCOL  SOURCEFILE  SOURCECOL";
    print "\n\tvlookup  [options]  --head  FILES";
    print "\n";
    print "\n${c1}OPTIONS${c0}";
    print "\n\t${c1}MAPFILE${c0}";
    print "\n\t\tfile storing the map which will be looked-up";
    print "\n\t${c1}MAPCOL${c0}";
    print "\n\t\tcolumn index into MAPFILE map which stores primary key";
    print "\n\t${c1}SOURCEFILE${c0}";
    print "\n\t\tdata to be enriched";
    print "\n\t${c1}SOURCECOL${c0}";
    print "\n\t\tcolumn index into SOURCEFILE which stores primary key";
    print "\n\t${c1}--head${c0}";
    print "\n\t\tparse & display head of files, and show column indicies";
    print "\n\t${c1}-F DELIM${c0}";
    print "\n\t\tuse DELIM as delimiter (default is space). Example: -F ,";
    print "\n\t${c1}-v${c0}";
    print "\n\t\tverbose";
    print "\n${c1}NOTES${c0}";
    print "\n\tThe standard Unix tool ${c1}join${c0} provides much the same functionality, although ";
    print "\n\t${c1}join${c0} does require that its input files are sorted on the join field.\n";
    exit 0;
}
#----------------------------------------------------------------------
sub build_lookup
{
    # Read the lookup file
    open ( FILE, "<$opt_mapfile") or die "Failed to open $opt_mapfile";

    while ( <FILE> )
    {
        chomp; # yum
        my $line = $_;
        $line =~ s/^\s+|\s+$//g ;  # trim
        next unless ( $line =~ /\S/ ); # skip empty lines


        # for loose splitting, lets eat up additional whitespace
        my $__splitdelim = " *" . $opt_delim . " *";

        my @parts = split($__splitdelim . " *", $line);

        my $key = $parts[ $opt_mapKeyCol ];

        if (exists $lookup{ $key })
        {
            error "ignorning duplicate mapping for key=[" . $key . "]\n";
        }
        else
        {
            $lookup{ $key } = $line;
            my $value = join "|", @parts;
            print "map insert: [$key]=>[$value]\n" if ($opt_verbose);
        }
    }
}
#----------------------------------------------------------------------
#
# Display a column header, which is just the sequence of column indicies, spaced
# so that they line up with the fields in the first line of data.
sub show_heading
{
    my $line = shift;

    # for loose splitting, lets eat up additional whitespace around delim
    my $__splitdelim = " *" . $opt_delim . " *";
    my @parts = split($__splitdelim . " *", $_);

    my $colindex = 1;
    my $headlen = 0;
    my $firstLineLen = 0;

    for  my $part (@parts)
    {
        my $c1 = colorcycle( $colindex );
        my $c0 = color( "default" );

        # always display the next column header index straight away.
        print "$c1" . $colindex . "$c0";
        $headlen = $headlen + length( $colindex );

        # get actual length of field
        my $partlen = length( $part );
        $firstLineLen = $firstLineLen + $partlen;

        # pad the headerline to match length of firstLine
        if ($firstLineLen > $headlen )
        {
            my $padsize = $firstLineLen - $headlen;
            my $padded = sprintf("%${padsize}s","");
            print $padded;
            $headlen = $headlen + length( $padded );
        }
        print "|"; $headlen++;$firstLineLen++;
        $colindex++;
    }



    print "\n";
}
#----------------------------------------------------------------------
sub show_file_head
{
    my $filename = shift;
    print "==> $filename <==\n";
    open ( INPUT, "<$filename") or die "Failed to open for reading: $filename";
    my $linenumber = 0;

    my $headerDisplayed;

    while ( <INPUT> )
    {
        chomp;  #yum

        $linenumber++;
        last if ($linenumber == 5);

        if (!$headerDisplayed)
        {
            show_heading();
            $headerDisplayed=1;
        }


        # for loose splitting, lets eat up additional whitespace
        my $__splitdelim = " *" . $opt_delim . " *";
        my @parts = split($__splitdelim . " *", $_);

        my $colindex = 1;
        for my $part (@parts)
        {
            my $c1 = colorcycle( $colindex  );
            my $c0 = color( "default" );

            print $c1 . $part . $c0;
            print "|";
            $colindex++;
        }
        print "\n";
    }
    print "\n";
}
#----------------------------------------------------------------------


while (scalar(@ARGV))
{
    my $arg = $ARGV[0];
    help() if ($arg eq "--help" || $arg eq "-h");

    if ($arg eq "--head")
    {
        shift @ARGV;
        $opt_show=1;
        last;
    }

    if ($arg =~ /^-F(..*)$/)
    {
        shift @ARGV;
        $opt_delim = $1;
        next;
    }

    if ($arg eq "-F")
    {
        shift @ARGV;
        $opt_delim = shift @ARGV;
        next;
    }

    if ($arg eq "-v")
    {
        shift @ARGV;
        $opt_verbose = 1;
        next;
    }

    # If we reach here, the argument wasn't recognised -- so it must be a
    # filename. So break out of this loop;
    last;
}

# --- read mandatory args ---

if ($opt_show)
{
    foreach (@ARGV) { show_file_head ( $_ ); }
    exit(0);
}

$opt_mapfile     = shift @ARGV;
$opt_mapKeyCol   = shift @ARGV;
$opt_srcfile     = shift @ARGV;
$opt_srcKeyCol   = shift @ARGV;

# check all mandatory args are populated
if (!defined $opt_srcKeyCol)
{
    error("missing mandatory arguments");
    help();
}

die "Invalid column index (must be 1 or greater)\n" if ($opt_mapKeyCol < 1 || $opt_srcKeyCol < 1);

# For AWK compatibility, the initial field has index 1, so we decrement here to
# be compatible with Perl.
$opt_mapKeyCol--;
$opt_srcKeyCol--;


# Read the map file, and build the lookup in the internal hash
build_lookup();

my $outfile = $opt_srcfile . ".enriched";

# Now open the source file

my $columnsInStdIn;

# Open the source and output files
open ( INPUT, "<$opt_srcfile") or die "Failed to open for reading: $opt_srcfile";
open ( OUTPUT, ">$outfile"   ) or die "Failed to open for writing: $outfile";


print "Opened: $opt_srcfile\n";

my $linenumber = 0;
while ( <INPUT> )
{
    $linenumber++;
    my $line = $_;
    $line =~ s/^\s+|\s+$//g ;
    next unless ( $line =~ /\S/ );

    # for loose splitting, lets eat up additional whitespace
    my $__splitdelim = " *" . $opt_delim . " *";

    my @parts = split($__splitdelim , $line);

    if (!defined $columnsInStdIn)
    {
        $columnsInStdIn = scalar( @parts );
    }
    else
    {
        if ($columnsInStdIn != scalar( @parts ))
        {
            error "Missing columns in source file, line $linenumber ... skipping";
            next;

        }
    }

    my $stdinKey = $parts[ $opt_srcKeyCol ];
    # TODO: validate

    if (! exists( $lookup{ $stdinKey } ))
    {
        error "No mapping exists for source key [$stdinKey], line $linenumber ... skipping";
    }
    else
    {
        my $map_contents=$lookup{ $stdinKey };
        print OUTPUT $line . $opt_delim . $map_contents . "\n";
    }
}

print "Enriched file written: $outfile\n";
