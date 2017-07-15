# Lingua::Annotator

A Perl wrapper for StanfordCoreNLP

## Usage

#!/usr/bin/perl

use strict;
use warnings;

use lib "/home/jason/perl-lib";

use Lingua::Config;
use Lingua::Annotator;

my $text = <<END;
This is the first para.
This is the second para.
END

my $annotator = Lingua::Annotator->new();
my $paras     = $annotator->get_paras($text);

foreach my $para ( @{$paras} ) { 
    #print $para, "\n";
    my $sents = $annotator->get_sents($para);
    foreach my $sent ( @{$sents} ) { 
        my ($raw_sent, $tok_sent) = $annotator->get_raw_and_tok_sent($sent);
        print $raw_sent, "\n", $tok_sent, "\n";
        my @tokens = split /\s+/, $tok_sent;
        my $tags = $annotator->tag_sent(\@tokens);
        print join ' ', @{$tags}, "\n";
        my $tree = $annotator->parse_sent(\@tokens, $tags);
        print $tree, "\n";
        print "\n";
    }   
}

__END__
