# How to use the parser

1. open terminal in current directory
2. run:
```
swipl
```
3. load the parser: 
```
?- reconsult(parser), reconsult(ro_grammar).
```

## Parser commands:
- a sentence can be parsed by:
```
?- parse([the,man,burns,the,book]).
```

- all the sentence and ungrammatical examples can be parsed by typing:
```
test.
```
    
- `grammar.pl` contains a set of sentences, which can be parsed by running p(X) for the grammatical sentence number X, or u(X) for the ungrammatical sentence number X:
```
p(5).
u(3).
```

## Functionality

The parser currently allows a few types of phrases, namely:
- sentences containing a subject, a verb and a direct object (for transitive verbs only); the subject agrees with the verb:
    - S -> NP_subj VP
    - VP -> VERB
    - VP -> VERB_trans NP_obj
    - VP -> VP PP
- noun phrases:
    - NP -> DET NOUN
    - NP -> NOUN_pl
    - NP -> DET AP NOUN
    - NP -> AP NOUN_pl
    - NP -> NP PP


