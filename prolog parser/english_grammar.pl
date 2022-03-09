% Andreea Ioana Tudor

%%% RULES

%% root 
s(Tree) --> s_single(Tree0), s_star(Tree0,Tree).

s_single(t(s,[NP,VP])) --> np_subj(NP, NUM), vp(VP, NUM).

%% vp
vp(Tree,NUM) --> vp_single(Tree0,NUM), vp_star(Tree0,Tree).

vp_single(Tree,NUM) --> vp_basic(Tree0,NUM), pp_star_vp(Tree0,Tree).

vp_basic(t(vp,[VERB]), NUM) --> verb(VERB, NUM, _).
vp_basic(t(vp,[VERB, NP]), NUM) --> verb(VERB, NUM, trans), np_obj(NP, _).
% only transitive verbs allow NP objects

%% np
% for multiple subjects, we need plural agreemnent (for the conjunction "and")
% nouns can be both subject and object (they have the same form)
np_subj(Tree,NUM) --> np_single(Tree1,NUM1), np_star_subj(Tree1,Tree,NUM1,NUM).
np_subj(Tree,NUM) --> np_subj_single(Tree1,NUM1), np_star_subj(Tree1,Tree,NUM1,NUM).

np_obj(Tree,NUM) --> np_single(Tree1,NUM), np_star_obj(Tree1,Tree).
np_obj(Tree,NUM) --> np_obj_single(Tree1,NUM), np_star_obj(Tree1,Tree).

% only np-noun can attach pp
np_single(Tree,NUM) --> np_basic(Tree0,NUM), pp_star_np(Tree0,Tree).

% subject vs object pronouns
np_subj_single(t(np, [PRON]), NUM) --> pron_subj(PRON, NUM).
np_obj_single(t(np, [PRON]), NUM) --> pron_obj(PRON, NUM).

% np -- noun
np_basic(t(np,[DET,NOUN]), NUM) --> det(DET, NUM), noun(NOUN, NUM). 
np_basic(t(np,[DET,ADJ,NOUN]), NUM) --> det(DET, NUM), adj_star(ADJ0), ap_star(ADJ0,ADJ), noun(NOUN, NUM).
np_basic(t(np,[NOUN]), not_sg3) --> noun(NOUN, not_sg3).
np_basic(t(np,[ADJ,NOUN]), not_sg3) --> adj_star(ADJ0), ap_star(ADJ0,ADJ), noun(NOUN, not_sg3).

%% pp
% np_obj can be either np with nouns or objective pronouns
pp(t(pp,[P,PRON])) --> prep(P), np_obj(PRON,_).

pp_star_vp(Tree,Tree) --> [].
pp_star_vp(Tree0,Tree) --> pp(TreePP), pp_star_vp(t(vp,[Tree0,TreePP]),Tree).

pp_star_np(Tree,Tree) --> [].
pp_star_np(Tree0,Tree) --> pp(TreePP), pp_star_np(t(np,[Tree0,TreePP]),Tree).

%% ap
adj_star(ADJ) --> adj(ADJ).
adj_star(t(ap,[ADJ,AP])) --> adj(ADJ), adj_star(AP).

% conjunctions
s_star(T,T) --> [].
s_star(T0,T) --> conj(CONJ,s,_), s_single(S), s_star(t(s,[T0,CONJ,S]),T).

vp_star(Tree,Tree) --> [].
vp_star(Tree0,Tree) --> conj(CONJ,vp,_), vp_basic(VP,_), vp_star(t(vp,[Tree0,CONJ,VP]),Tree).

np_star_subj(NP,NP,NUM,NUM) --> [].
np_star_subj(NP1,Tree,_,NUM) --> conj(CONJ,np,NUM), np_subj(NP2,_), np_star_subj(t(np,[NP1,CONJ,NP2]),Tree,_,_).

np_star_obj(Tree,Tree) --> [].
np_star_obj(NP1,Tree) --> conj(CONJ,np,_), np_obj(NP2,_), np_star_obj(t(np,[NP1,CONJ,NP2]),Tree).

ap_star(T,T) --> [].
ap_star(ADJ0,ADJ) --> conj(CONJ,ap,_), adj_star(ADJ1), ap_star(t(ap,[ADJ0,CONJ,ADJ1]), ADJ).

% --------------------------------------------------------------------------------

%%% WORDS

%% determiners
det(t(det,[w(Word)]), NUM) --> [Word], {l_det(NUM, Word)}.

l_det(_, the).
l_det(sg3, a).
l_det(sg3, that).
l_det(sg3, this).
l_det(not_sg3, those).
l_det(not_sg3, these).

%% nouns
noun(t(noun, [w(Word)]), sg3) --> [Word], {l_noun(Word, _)}.
noun(t(noun, [w(Word)]), not_sg3) --> [Word], {l_noun(_, Word)}.

l_noun(man, men).
l_noun(boat, boats).
l_noun(book, books).
l_noun(woman, women).
l_noun(house, houses).

%% adjectives
adj(t(adj, [w(Word)])) --> [Word], {l_adj(Word)}.

l_adj(young).
l_adj(nice).
l_adj(rich).
l_adj(wild).
l_adj(big).
l_adj(interesting).

%% verbs
verb(t(verb, [w(Word)]), sg3, TRANS) --> [Word], {l_verb(_, Word, TRANS)}.
verb(t(verb, [w(Word)]), not_sg3, TRANS) --> [Word], {l_verb(Word, _, TRANS)}.

l_verb(read, reads, trans).
l_verb(write, writes, trans).
l_verb(burn, burns, trans).
l_verb(sleep, sleeps, intrans).
l_verb(die, dies, intrans).
l_verb(talk, talks, intrans).

%% pronouns
pron_subj(t(pron, [w(Word)]), NUM) --> [Word], {l_pron(Word, _, NUM)}.
pron_obj(t(pron, [w(Word)]), NUM) --> [Word], {l_pron(_, Word, NUM)}.

% (subjective, objective, 3sg)
l_pron(i, me, not_sg3).
l_pron(you, you, not_sg3).
l_pron(he, him, sg3).
l_pron(she, her, sg3).
l_pron(it, it, sg3).
l_pron(we, us, not_sg3).
l_pron(they, them, not_sg3).

%% prepositions
prep(t(prep, [w(Word)])) --> [Word], {l_prep(Word)}.

l_prep(on).
l_prep(with).
l_prep(behind).

%% conjunctions
conj(t(conj, [w(Word)]), XP, NUM) --> [Word], {l_conj(Word, XP, NUM)}.

% (conjunction, conjoins_xp)
l_conj(and, _, not_sg3).
l_conj(or, _, _).
l_conj(but, s, _).
l_conj(but, ap, _).
% 'but' can be used to conjoin sentences and APs

% --------------------------------------------------------------------------------

%%% SENTENCES

sentence( 1, [the, man, burns, the, book]).
sentence( 2, [i, read, the, book]).
sentence( 3, [i, write, them]).
sentence( 4, [women, burn, boats]).
sentence( 5, [the, books, burn]).
sentence( 6, [we, read, the, book, behind, the, house]).
sentence( 7, [men, read, and, write]).
sentence( 8, [i, write, the, nice, big, man]).
sentence( 9, [the, women, talk]).
sentence(10, [she, burns, the, house, and, he, dies]).

ungrammatical( 1, [man, reads, book]).
ungrammatical( 2, [i, burns, the, house]).
ungrammatical( 3, [i, write, they]).
ungrammatical( 4, [her, reads, books]).
ungrammatical( 5, [the, but, nice, man]).
ungrammatical( 6 , [i, write, with, he]).
ungrammatical( 7, [the, men, and, writes, book]).
ungrammatical( 8, [man, die]).
ungrammatical( 9, [men, sleep, house]).
ungrammatical(10, [she, burns, the, books, talk]).
