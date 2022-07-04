# Prolog parser

After installing SWI-Prolog, follow the provided instructions to run the Romanian parser.

1. open the terminal in the directory containing the parser
2. run `swipl`
3. in the shell, load the parser: 
```
reconsult(parser), reconsult(ro_grammar).
```

## Parser commands:
- parse an individual sentence:
```
parse([this,is,a,sentence]).
```

- parse all the sentence and ungrammatical examples:
```
test.
```
    
- parse grammatical sentence number X using `p(X)` and ungrammatical sentence number X using `u(X)`:
```
p(5).
u(3).
```


