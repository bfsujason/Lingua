package Lingua::Annotator::Tokenizer;

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
import java.io.StringReader;

import edu.stanford.nlp.objectbank.TokenizerFactory;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.process.CoreLabelTokenFactory;
import edu.stanford.nlp.process.PTBTokenizer;
import edu.stanford.nlp.process.WordToSentenceProcessor;
import edu.stanford.nlp.util.StringUtils;

class Tokenizer {

    private TokenizerFactory<CoreLabel> tokenizerFactory;
    
    public Tokenizer () {
        tokenizerFactory = PTBTokenizer.factory(new CoreLabelTokenFactory(), "latexQuotes=true,normalizeOtherBrackets=false,ptb3Escaping=false,untokenizable=noneKeep,invertible=true");
    }
  
    public String [] tokenize (String text) {

        List<CoreLabel> tokens =
            tokenizerFactory.getTokenizer(new StringReader(text)).tokenize();
        List<List<CoreLabel>> sents = (new WordToSentenceProcessor()).process(tokens);
        String[] tok_sents = new String[sents.size()];
        
        int i = 0;
        for ( List<CoreLabel> sent : sents ) {
            int sent_len = sent.size();
            StringBuilder buf = new StringBuilder();
            for ( CoreLabel label : sent ) {
                buf.append(label.word()).append(" ");
            }
            String orig_sent = StringUtils.joinWithOriginalWhiteSpace(sent);
            buf.append("\t").append(orig_sent);

            tok_sents[i] = buf.toString();
            i++;
        }

        return tok_sents;
    }

    public String [] get_tok_span (String text) {

        List<CoreLabel> tokens =
            tokenizerFactory.getTokenizer(new StringReader(text)).tokenize();
        List<List<CoreLabel>> sents = (new WordToSentenceProcessor()).process(tokens);
        String[] tok_sents = new String[sents.size()];
        
        int i = 0;
        for ( List<CoreLabel> sent : sents ) {
            int sent_len = sent.size();
            StringBuilder buf = new StringBuilder();
            StringBuilder buf_1 = new StringBuilder();
            for ( CoreLabel label : sent ) {
                buf.append(label.word()).append(" ");
                buf_1.append(label.beginPosition()).append("-").append(label.endPosition()).append(" ");
            }
            //String orig_sent = StringUtils.joinWithOriginalWhiteSpace(sent);

            buf.append("\t").append(buf_1.toString());

            tok_sents[i] = buf.toString();
            i++;
        }

        return tok_sents;
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
