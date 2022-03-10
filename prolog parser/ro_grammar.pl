%%% RULES
s(Tree) --> np(Tree,_,_,_,_).

%% np
np(t(np, [NOUN]), p3, NUM, GEN, CASE) --> noun(NOUN, def, NUM, GEN, CASE).
np(t(np, [PRONOUN]), PERS, NUM, GEN, CASE) --> pronoun(PRONOUN, PERS, NUM, GEN, CASE).
np(t(np, [DET, NOUN]), p3, NUM, GEN, CASE) --> \+ det(DET, indef, sg, fem, gen), det(DET, indef, NUM, GEN, CASE), noun(NOUN, indef, NUM, GEN, nom).
np(t(np, [DET, NOUN]), p3, sg, fem, gen) --> det(DET, indef, sg, fem, gen), noun(NOUN, indef, pl, fem, nom).
np(t(np, [NOUN, DET]), p3, NUM, GEN, CASE) --> noun(NOUN, def, NUM, GEN, CASE), det(DET, def, NUM, GEN, CASE).


% --------------------------------------------------------------------------------

%%% WORDS
det(t(det, [w(Word)]), DEF, NUM, GEN, CASE) --> [Word], {l_det(Word, DEF, NUM, GEN, CASE)}.

%% determiners
% (DET, DEF/INDEF, NUM, GEN, CASE)
% a/an/some
l_det(o, indef, sg, fem, nom).
l_det(un, indef, sg, masc, nom).
l_det(niște, indef, pl, _, nom).
l_det(unei, indef, sg, fem, gen).
l_det(unui, indef, sg, masc, gen).
l_det(unor, indef, pl, _, gen).

% this
l_det(această, indef, sg, fem, nom).
l_det(acest, indef, sg, masc, nom).
l_det(aceste, indef, pl, fem, nom).
l_det(acești, indef, pl, masc, nom).
l_det(acestei, indef, sg, fem, gen).
l_det(acestui, indef, sg, masc, gen).
l_det(acestor, indef, pl, _, gen).
l_det(aceasta, def, sg, fem, nom).
l_det(acesta, def, sg, masc, nom).
l_det(acestea, def, pl, fem, nom).
l_det(aceștia, def, pl, masc, nom).
l_det(acesteia, def, sg, fem, gen).
l_det(acestuia, def, sg, masc, gen).
l_det(acestora, def, pl, _, gen).


%% nouns
noun(t(noun, [w(Word)]), DEF, NUM, GEN, CASE) --> [Word], {l_noun(Word, DEF, NUM, GEN, CASE)}.

% (NOUN, DEF/INDEF, NUM, GEN, CASE)
% girl
l_noun(fată, indef, sg, fem, nom).
l_noun(fete, indef, pl, fem, nom).
l_noun(fata, def, sg, fem, nom).
l_noun(fetele, def, pl, fem, nom).
l_noun(fetei, def, sg, fem, gen).
l_noun(fetelor, def, pl, fem, gen).

% boy
l_noun(băiat, indef, sg, masc, nom).
l_noun(băieți, indef, pl, masc, nom).
l_noun(băiatul, def, sg, masc, nom).
l_noun(băieții, def, pl, masc, nom).
l_noun(băiatului, def, sg, masc, gen).
l_noun(băieților, def, pl, masc, gen).

% apple
l_noun(măr, indef, sg, masc, nom).
l_noun(mere, indef, pl, fem, nom).
l_noun(mărul, def, sg, masc, nom).
l_noun(merele, def, pl, fem, nom).
l_noun(mărului, def, sg, masc, gen).
l_noun(merelor, def, pl, fem, gen).


%% pronouns
pronoun(t(pron, [w(Word)]), PERS, NUM, GEN, CASE) --> [Word], {l_pron(Word, PERS, NUM, GEN, CASE)}.
pronoun(t(pron, [w(Word)]), p3, NUM, GEN, CASE) --> [Word], {l_det(Word, def, NUM, GEN, CASE)}.

clitic(t(clit, [w(Word)]), PERS, NUM, GEN, CASE) --> [Word], {l_pron(Word, PERS, NUM, GEN, CASE)}.

% (PRONOUN, PERS, NUM, GEN, CASE)
l_pron(eu, p1, sg, _, nom).
l_pron(tu, p2, sg, _, nom).
l_pron(el, p3, sg, masc, nom).
l_pron(ea, p3, sg, fem, nom).
l_pron(noi, p1, pl, _, nom).
l_pron(voi, p2, pl, _, nom).
l_pron(ei, p3, pl, masc, nom).
l_pron(ele, p3, pl, fem, nom).

% l_pron(mine, p1, sg, _, acc).
% l_pron(tine, p2, sg, _, acc).
% l_pron(el, p3, sg, masc, acc).
% l_pron(ea, p3, sg, fem, acc).
% l_pron(noi, p1, pl, _, acc).
% l_pron(voi, p2, pl, _, acc).
% l_pron(ei, p3, pl, masc, acc).
% l_pron(ele, p3, pl, fem, acc).

% clitics
l_clit(mă, p1, sg, _, acc).
l_clit(te, p2, sg, _, acc).
l_clit(îl, p3, sg, masc, acc).
l_clit(o, p3, sg, fem, acc).
l_clit(ne, p1, pl, _, acc).
l_clit(vă, p2, pl, _, acc).
l_clit(îi, p3, pl, masc, acc).
l_clit(le, p3, pl, fem, acc).

l_clit(îmi, p1, sg, _, dat).
l_clit(îți, p2, sg, _, dat).
l_clit(îi, p3, sg, _, dat).
l_clit(ne, p1, pl, _, dat).
l_clit(vă, p2, pl, _, dat).
l_clit(le, p3, pl, fem, dat).


%% verbs

% (VERB, PERS, NUM)
% eat
l_verb(mănânc, p1, sg).
l_verb(mănânci, p2, sg).
l_verb(mănâncă, p3, sg).
l_verb(mâncăm, p1, pl).
l_verb(mâncați, p2, pl).
l_verb(mănâncă, p3, pl).