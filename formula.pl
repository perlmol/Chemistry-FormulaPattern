#!/home/ivan/bin/perl

use strict;
use warnings;

use lib 'lib';
use Chemistry::File::FormulaPattern;
use Chemistry::File::MDLMol;
use Chemistry::File::SLN;
use Chemistry::File::SMILES;
use Data::Dumper;

unless (@ARGV >= 1) {
    die "usage: $0 <pattern> <file>...\n";
}

my $str = shift;
#my $patt = Chemistry::FormulaPattern->new($str);
#$patt->options( allow_others => 1 );
my $patt = Chemistry::Pattern->parse($str, format => "formula_pattern", 
    #allow_others => 1
);

#print "$str\n";
print Data::Dumper->new([$str, $patt->{formula_pattern}, $patt->{options}], 
    [qw(formula_patt expected_ranges expected_options)])
    ->Indent(1)->Dump;

exit;

for my $fname (@ARGV) {
    for my $mol (grep {$patt->match($_)} Chemistry::Mol->read($fname)) {
        $mol->printf("$fname: %f\t%S\t%n\n");
    }
}

