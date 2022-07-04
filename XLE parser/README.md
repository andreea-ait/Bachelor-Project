# XLE Parser

After installing XLE, follow the provided instructions to run the Romanian parser.

1. open the terminal in the directory containing the parser
2. run `xle`
3. in the shell, load the parser and set character encoding to utf-8: 
```
create-parser toy-ro.lfg
set-character-encoding stdio utf-8
```

## Parser commands:
- parse an individual sentence:
```
parse {this is a sentence}
```

- parse a phrase structure:
```
parse {DP: a sentence}
```

- parse all the grammatical test sentences (found in `grammatical.txt`) or the ungrammatical ones (`ungrammatical.txt`):
```
parse-testfile "grammatical.txt"
parse-testfile "ungrammatical.txt"
```