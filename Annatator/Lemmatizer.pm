package Lingua::Annotator::Lemmatizer;

use strict;
use warnings;

our ($JAVA_ARGS, $JAR_PATH, $SHARED_JVM, $DIRECTORY);

BEGIN {
    $JAVA_ARGS  = $Lingua::Config::config{'jvm-mem'};
    $JAR_PATH   = $Lingua::Config::config{'jvm-cp'};
    $SHARED_JVM = $Lingua::Config::config{'jvm-share'};
    $DIRECTORY  = $Lingua::Config::config{'jvm-dir'}; 
}

use Inline (
    Java => <<'END_JAVA',
    
import edu.stanford.nlp.process.Morphology;

class Lemmatizer {

    private Morphology Morph;

    public Lemmatizer () {
        Morph = new Morphology();
    }

    public String [] lemmatize (String tokens[], String tags[]) {
        int sent_len    = tokens.length;  
        String[] lemmas = new String[sent_len];

        for (int j = 0; j < sent_len; j++ ) {
            lemmas[j] = Morph.lemma(tokens[j], tags[j]);
        }

        return lemmas;
    }
}

END_JAVA

    CLASSPATH       => $JAR_PATH,
    EXTRA_JAVA_ARGS => $JAVA_ARGS,
    #AUTOSTUDY       => 1,
    SHARED_JVM      => $SHARED_JVM,
    DIRECTORY       => $DIRECTORY,
    PACKAGE         => "Lingua::Annotator",
);

1;
