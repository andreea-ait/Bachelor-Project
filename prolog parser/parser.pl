%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  from here you should not change anything  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

test :-
    findall(s(X,Sentence),sentence(X,Sentence),Pars),
    test_sentences(Pars, Ok, [], Fail, []),
    findall(s(X2,Sentence2),ungrammatical(X2,Sentence2),Us),
    test_sentences(Us, UsOk, [], UsFail, []),
    format("~n~nparsed ~w good sentences,          missed ~w sentences~n",[Ok, Fail]),
    format("parsed ~w ungrammatical sentences, missed ~w ungrammaticals~n",[UsOk, UsFail]).


t :-
    findall(s(X,Sentence),gj_sentence(X,Sentence),Pars),
    test_sentences(Pars, Ok, [], Fail, []),
    findall(s(X2,Sentence2),gj_ungrammatical(X2,Sentence2),Us),
    test_sentences(Us, UsOk, [], UsFail, []),
    format("~n~nparsed ~w good sentences,          missed ~w sentences~n",[Ok, Fail]),
    format("parsed ~w ungrammatical sentences, missed ~w ungrammaticals~n",[UsOk, UsFail]).


test_sentences([],Ok,Ok,Mis,Mis).
test_sentences([s(Id,Sent)|Sents],Ok0,Ok,Mis0,Mis) :-
    findall(_,parse(Sent),Results),
    (   Results == []
    ->  format(user_error,"parsing sentence ~w no~n",[Id]),
	Mis0 =[ Id|Mis1],
	Ok1  = Ok0
    ;   format(user_error,"parsing sentence ~w yes~n",[Id]),
	Ok0 = [Id|Ok1],
	Mis1 = Mis0
    ),
    test_sentences(Sents,Ok1,Ok,Mis1,Mis).

%% pprint a tree
pprint_tree(Tree) :-
    (   ground(Tree)
    ->  (   pprint_this_line(Tree,0,0)
        ->  nl, nl
        ;   format(user_error,"ERROR: Parse tree is incorrect: ~w~n",[Tree]),
            fail
        )
    ;   format(user_error,"ERROR: Parse boom contains variables: ~w~n",[Tree]),
        fail
    ).

p(Id) :-
    sentence(Id,Sentence),
    parse(Sentence).

u(Id) :-
    ungrammatical(Id,Sentence),
    parse(Sentence).

%% parse a string, and pprint the result
parse(String) :-
    s(Tree,String,[]),
    pprint_tree(Tree).

%%% pretty printer to print trees horizontally

%%% Tree is: t(Node,Dochters). Node must be an atom.
%%% Daughters is a lit of Trees or terminals.
%%% A terminal is w(Word) where Word is an atom
%%% e.g.: t(np,[t(det,[w(de)]),t(n,[w(man)]),t(pp,[t(p,[w(uit)]),t(np,[w(groningen)])])])

pprint_this_line(t(Mother,Daughters),Indent,Dashes) :-
    format(' ~*c ~w',[Dashes,45,Mother]),
    dashes(Mother,NewDashes),
    NewIndent is Indent + 8, 
    pprint_daughters(Daughters,NewIndent,NewDashes).
pprint_this_line(w(Word),_,Dashes) :-
    format(' ~*c ~w',[Dashes,45,Word]).

pprint_next_line(t(Mother,Daughters),Indent,Dashes) :-
    Spaces is Indent - Dashes, 
    format('~n~*c ~*c ~w',[Spaces,32, Dashes,45,Mother]),
    dashes(Mother,NewDashes),
    NewIndent is Indent + 8, 
    pprint_daughters(Daughters,NewIndent,NewDashes).

pprint_daughters([],_,_).
pprint_daughters([D|Ds],Indent,Dashes) :-
    pprint_this_line(D,Indent,Dashes),
    pprint_next_daughters(Ds,Indent,Dashes). 
    
pprint_next_daughters([],_,_).
pprint_next_daughters([D|Ds],Indent,Dashes) :-
    pprint_next_line(D,Indent,Dashes),
    pprint_next_daughters(Ds,Indent,Dashes).

dashes(Atom,N) :-
    name(Atom,Chars),
    length(Chars,C),
    N is 6 - C.

    

