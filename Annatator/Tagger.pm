package Lingua::Annotator::Tagger;

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

import java.io.IOException;
import java.util.List;

import edu.stanford.nlp.ling.Sentence;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.tagger.maxent.MaxentTagger;

class Tagger {

    private MaxentTagger tagger;

    public Tagger () {
        try {
            String tagger_model = "edu/stanford/nlp/models/tagger/english-left3words-distsim.tagger";
            tagger = new MaxentTagger(tagger_model);
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public String [] tag (String tokens[]) {
        List<CoreLabel> sents = Sentence.toCoreLabelList(tokens);
        tagger.tagCoreLabels(sents);
        int sent_len = sents.size();
        String[] tags = new String[sent_len];
        for (int i = 0; i < sent_len; i++) {
            CoreLabel word = sents.get(i);
            tags[i] = word.tag();
        }

        return tags;
    }
}

END_JAVA

    CLASSPATH       => $JAR_PATH,
    EXTRA_JAVA_ARGS => $JAVA_ARGS,
    #AUTOSTUDY      => 1,
    SHARED_JVM      => $SHARED_JVM,
    DIRECTORY       => $DIRECTORY,
    PACKAGE         => "Lingua::Annotator",
);

1;
