#!/usr/bin/perl -w

use strict;
use Getopt::Long "GetOptions";

my $itpenabled = 1;         # interactive translation prediction
my $srenabled = 1;          # search and replace
my $biconcorenabled = 0;    # biconcordancer
my $hidecontributions = 1;  # hide the TM suggestions
my $floatpredictions = 1;   # whether the ITP predictions should be displayed
                            # in a floating box rather than inserted directly
                            # into the textarea
my $translationoptions = 0; # translation options
my $allowchangevisualizationoptions = 1; # show a menu box for user to choose word level viz options
my $itpdraftonly = 0;       # turn off ITP during revision
#Visualization Preferences
my $displayMouseAlign = 0;       # turn off ITP during revision
my $displayCaretAlign = 0;
my $displayShadeOffTranslatedSource = 0;
my $displayconfidences = 0;
my $highlightValidated = 0;
my $highlightPrefix = 0;
my $highlightSuffix = 0;
my $highlightLastValidated = 0;
my $limitSuffixLength = 0;

my $HELP;
$HELP = 1
    unless &GetOptions('itpenabled=i' => \$itpenabled,
                       'srenabled=i' => \$srenabled,
                       'biconcorenabled=i' => \$biconcorenabled,
                       'hidecontributions=i' => \$hidecontributions,
                       'floatpredictions=i' => \$floatpredictions,
                       'translationoptions=i' => \$translationoptions,
                       'allowchangevisualizationoptions=i' => \$allowchangevisualizationoptions,
                       'itpdraftonly=i' => \$itpdraftonly,
                       'displayMouseAlign=i' => \$displayMouseAlign,
                       'displayCaretAlign=i' => \$displayCaretAlign,
                       'displayShadeOffTranslatedSource=i' => \$displayShadeOffTranslatedSource,
                       'displayconfidences=i' => \$displayconfidences,
                       'highlightValidated=i' => \$highlightValidated,
                       'highlightPrefix=i' => \$highlightPrefix,
                       'highlightSuffix=i' => \$highlightSuffix,
                       'highlightLastValidated=i' => \$highlightLastValidated,
                       'limitSuffixLength=i' => \$limitSuffixLength);

my $inet_string = `/sbin/ifconfig | grep 'inet addr'`;
my $host = "localhost";
$host = $1 if $inet_string =~ /inet addr:(192\.\d+\.\d+\.\d+)/;

# get language info
my ($source,$target) = ("","");;
my $engine = `cat /opt/casmacat/engines/deployed`;
chop($engine);
open(ENGINE_INFO,"/opt/casmacat/engines/$engine/info");
while(<ENGINE_INFO>) {
  $source = $1 if /^source *\= *(\S+)/;
  $target = $1 if /^target *\= *(\S+)/;
}
close(ENGINE_INFO);

open(TEMPLATE,"/opt/casmacat/web-server/inc/config.ini.sample");
open(MINE,">/opt/casmacat/web-server/inc/config.ini");
while(<TEMPLATE>) {
  if (/^\[db\]/) {
    print MINE $_;
    print MINE "hostname = \"127.0.0.1\"\n";
    print MINE "username = \"katze\"\n";
    print MINE "password = \"miau\"\n";
    print MINE "database = \"matecat_sandbox\"\n\n";
    while(<TEMPLATE>) {
      if (/^\[/) {
        print MINE $_;
        last;
      }
    }
  }
  elsif(/^directory = "logs"/) { # log dir
    print MINE "directory = \"../log/web\"\n";
  }
  elsif(/^itpserver/) {
    print MINE "itpserver = \"http://$host:9999/cat\"\n";
  }
  elsif(/^biconcorserver/) {
    print MINE "biconcorserver = \"http://$host:9999/cat\"\n";
  }
  elsif(/^sourcelanguage/) {
    print MINE "sourcelanguage = \"$source\"\n";
  }
  elsif(/^targetlanguage/) {
    print MINE "targetlanguage = \"$target\"\n";
  }
  elsif(/^itpenabled/) {
    print MINE "itpenabled = $itpenabled\n";
  }
  elsif(/^etenabled/) {
    print MINE "etenabled = 0\n";
  }
  elsif(/^srenabled/) {
    print MINE "srenabled = $srenabled\n";
  }
  elsif(/^biconcorenabled/) {
    print MINE "biconcorenabled = $biconcorenabled\n";
  }
  elsif(/^hidecontributions/) {
    print MINE "hidecontributions = $hidecontributions\n";
  }
  elsif(/^floatpredictions/) {
    print MINE "floatpredictions = $floatpredictions\n";
  }
  elsif(/^translationoptions/) {
    print MINE "translationoptions = $translationoptions\n";
  }
  elsif(/^allowchangevisualizationoptions/) {
    print MINE "allowchangevisualizationoptions = $allowchangevisualizationoptions\n";
  }
  elsif(/^itpdraftonly/) {
    print MINE "itpdraftonly = $itpdraftonly\n";
  }
  elsif(/^displayMouseAlign/) {
    print MINE "displayMouseAlign = $displayMouseAlign\n";
  }
  elsif(/^displayCaretAlign/) {
    print MINE "displayCaretAlign = $displayCaretAlign\n";
  }
  elsif(/^displayShadeOffTranslatedSource/) {
    print MINE "displayShadeOffTranslatedSource = $displayShadeOffTranslatedSource\n";
  }
  elsif(/^displayconfidences/) {
    print MINE "displayconfidences = $displayconfidences\n";
  }
  elsif(/^highlightValidated/) {
    print MINE "highlightValidated = $highlightValidated\n";
  }
  elsif(/^highlightPrefix/) {
    print MINE "highlightPrefix = $highlightPrefix\n";
  }
  elsif(/^highlightSuffix/) {
    print MINE "highlightSuffix = $highlightSuffix\n";
  }
  elsif(/^highlightLastValidated/) {
    print MINE "highlightLastValidated = $highlightLastValidated\n";
  }
  elsif(/^limitSuffixLength/) {
    print MINE "limitSuffixLength = $limitSuffixLength\n";
  }
  else {
    print MINE $_;
  }
}
close(MINE);

