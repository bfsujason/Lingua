package Lingua::Annotator;

use strict;
use warnings;

use Lingua::Annotator::Tokenizer;
use Lingua::Annotator::Tagger;
use Lingua::Annotator::Lemmatizer;
use Lingua::Annotator::Parser;

sub new {
    my $class = shift;
    my $self  = {};

    bless $self, $class;

    $self->{tokenizer}  = Lingua::Annotator::Tokenizer->new();
    $self->{tagger}     = Lingua::Annotator::Tagger->new();
    $self->{lemmatizer} = Lingua::Annotator::Lemmatizer->new(); 
    $self->{parser}     = Lingua::Annotator::Parser->new();

    return $self;
}

# get the paragraphs given a text
sub get_paras {
    my ($self, $text) = @_;
    
    my $paras;
    my @orig_paras  = split /\n/, $text;

    foreach my $para ( @orig_paras ) {
        $para =~ s/^(\s|\t)+//og; # delete leading spaces and tabs
        $para =~ s/(\s|\t)+$//og; # delete trailing spaces and tabs
        $para =~ s/\s+/ /og; # delete extra spaces
    
        $para =~ s/n`t\b/n't/og;
        $para =~ s/`(s|re|m|ve|ll|d)\b/'$1/og;

        push @{$paras}, $para if $para; # delete empty lines
    }

    return $paras;
}

# get tokenized sentences given a paragraph
sub get_sents {
    my ($self, $para) = @_;
    
    my $sents = $self->{tokenizer}->tokenize($para);

    return $sents;
}

# get the raw and tokenized sentence
sub get_raw_and_tok_sent {
    my ($self, $sent) = @_;

    my ($tok_sent, $raw_sent) = split /\t/, $sent;

    return ( $raw_sent, $tok_sent );
}

# get the pos tagged sentence
sub tag_sent {
    my ($self, $tokens) = @_;
    
    return $self->{tagger}->tag($tokens);  
}

# get the lemmatized sentence
sub lemmatize_sent {
    my ($self, $tokens, $tags) = @_;
    
    return $self->{lemmatizer}->lemmatize($tokens, $tags);
}

# get the parsed sentence
sub parse_sent {
    my ($self, $tokens, $tags) = @_;

    return $self->{parser}->parse($tokens, $tags);
}

1;
