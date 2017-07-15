package Lingua::Annotator::Parser;

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

import java.util.List;
import java.util.ArrayList;

import edu.stanford.nlp.parser.lexparser.LexicalizedParser;
import edu.stanford.nlp.trees.*;
import edu.stanford.nlp.ling.Sentence;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.ling.TaggedWord;
import edu.stanford.nlp.util.*;

class Parser {

    private LexicalizedParser lp;
    private GrammaticalStructureFactory gsf;
    private TreebankLanguagePack tlp;

    public Parser () {
        String parser_model = "edu/stanford/nlp/models/lexparser/englishPCFG.ser.gz";
        String[] options = {"-retainTmpSubcategories"}; 
        lp = LexicalizedParser.loadModel(parser_model, options);
    }

    public Tree parse (String tokens[], String tags[]) {
        List<CoreLabel> sents = Sentence.toCoreLabelList(tokens);
        int sent_len = sents.size();
        List sentence = new ArrayList();
        
        for (int i = 0; i < sent_len; i++) {
            sentence.add(new TaggedWord(tokens[i], tags[i]));
        }
  
        Tree parse = lp.apply(sentence);
        parse.setSpans();

        return parse;
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
