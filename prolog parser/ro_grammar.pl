%%% RULES

% s -> (Subj), Verb
s(t(s, [SUBJ, VP])) --> 
    np_subj(SUBJ, PERS, NUM, _), 
    vp(VP, PERS, NUM).
s(t(s, [VP, SUBJ])) --> 
    vp(VP, PERS, NUM), 
    np_subj(SUBJ, PERS, NUM, _).
s(t(s, [VP])) --> 
    vp(VP, _, _).

% s -> (Subj), Verb, Obj
s(t(s, [SUBJ, VP, OBJ])) --> 
    np_subj(SUBJ, PERS, NUM, _), 
    vp(VP, PERS, NUM), 
    np_obj(OBJ, _, _, _, inanim).
s(t(s, [SUBJ, VP, OBJ])) --> 
    vp(VP, PERS, NUM), 
    np_subj(SUBJ, PERS, NUM, _), 
    np_obj(OBJ, _, _, _, inanim).
s(t(s, [SUBJ, VP, OBJ])) --> 
    vp(VP, PERS, NUM), 
    np_obj(OBJ, _, _, _, inanim), 
    np_subj(SUBJ, PERS, NUM, _).

s(t(s, [VP, OBJ])) --> 
    vp(VP, _, _), 
    np_obj(OBJ, _, _, _, inanim).
s(t(s, [VP, OBJ])) --> 
    np_obj(OBJ, _, _, _, inanim),
    vp(VP, _, _).

% s -> (Subj), clit + Verb, (Obj)
s(t(s, [SUBJ, VP, OBJ])) --> 
    np_subj(SUBJ, PERS0, NUM0, _), 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    np_obj(OBJ, PERS, NUM, GEN, anim).
s(t(s, [SUBJ, VP, OBJ])) --> 
    np_subj(SUBJ, PERS0, NUM0, _), 
    np_obj(OBJ, PERS, NUM, GEN, anim),
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc).
s(t(s, [SUBJ, VP, OBJ])) --> 
    np_obj(OBJ, PERS, NUM, GEN, anim),
    np_subj(SUBJ, PERS0, NUM0, _), 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc).
s(t(s, [SUBJ, VP, OBJ])) --> 
    np_obj(OBJ, PERS, NUM, GEN, anim),
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    np_subj(SUBJ, PERS0, NUM0, _).
s(t(s, [SUBJ, VP, OBJ])) --> 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    np_subj(SUBJ, PERS0, NUM0, _), 
    np_obj(OBJ, PERS, NUM, GEN, anim).
s(t(s, [SUBJ, VP, OBJ])) --> 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    np_obj(OBJ, PERS, NUM, GEN, anim),
    np_subj(SUBJ, PERS0, NUM0, _).

s(t(s, [VP, OBJ])) --> 
    vpcl(VP, _, _,PERS, NUM, GEN, acc), 
    np_obj(OBJ, PERS, NUM, GEN, anim).
s(t(s, [VP, OBJ])) --> 
    np_obj(OBJ, PERS, NUM, GEN, anim),
    vpcl(VP, _, _,PERS, NUM, GEN, acc).

s(t(s, [SUBJ, VP])) --> 
    np_subj(SUBJ, PERS0, NUM0, _), 
    vpcl(VP, PERS0, NUM0, _, _, _, acc).
s(t(s, [SUBJ, VP])) -->  
    vpcl(VP, PERS0, NUM0, _, _, _, acc),
    np_subj(SUBJ, PERS0, NUM0, _).

s(t(s, [VP])) -->  
    vpcl(VP, _, _, _, _, _, acc).


%% vp
vp(t(vp, [VERB]), PERS, NUM) --> 
    verb(VERB, PERS, NUM, _).
vpcl(t(vp, [CL, VERB]), PERS0, NUM0, PERS, NUM, GEN, CASE) -->
    clit(CL, PERS, NUM, GEN, CASE),
    verb(VERB, PERS0, NUM0, trans).

%% np
np(t(np, [NOUN]), p3, NUM, GEN, CASE, ANIM) --> noun(NOUN, _, NUM, GEN, CASE, ANIM).
np(t(np, [PRONOUN]), PERS, NUM, GEN, nom, anim) --> pronoun(PRONOUN, PERS, NUM, GEN, nom).
np(t(np, [PRONOUN]), PERS, NUM, GEN, acc, anim) --> pronoun(PRONOUN, PERS, NUM, GEN, nom).

np(t(np, [DET, NOUN]), p3, NUM, GEN, CASE, ANIM) --> \+ det(DET, indef, sg, fem, gen), det(DET, indef, NUM, GEN, CASE), noun(NOUN, indef, NUM, GEN, nom, ANIM).
np(t(np, [DET, NOUN]), p3, sg, fem, gen, ANIM) --> det(DET, indef, sg, fem, gen), noun(NOUN, indef, pl, fem, nom, ANIM).
np(t(np, [NOUN, DET]), p3, NUM, GEN, CASE, ANIM) --> noun(NOUN, def, NUM, GEN, CASE, ANIM), det(DET, def, NUM, GEN, CASE).

np_subj(Tree, PERS, NUM, GEN) --> np(Tree, PERS, NUM, GEN, nom, _).
np_obj(Tree, PERS, NUM, GEN, inanim) --> np(Tree, PERS, NUM, GEN, acc, inanim).
np_obj(t(dp, [PE, NP]), PERS, NUM, GEN, anim) --> pe(PE), np(NP, PERS, NUM, GEN, acc, anim).

% --------------------------------------------------------------------------------

%%% WORDS

%% determiners
det(t(det, [w(Word)]), DEF, NUM, GEN, CASE) --> [Word], {l_det(Word, DEF, NUM, GEN, CASE)}.
det(t(det, [w(Word)]), DEF, NUM, GEN, acc) --> [Word], {l_det(Word, DEF, NUM, GEN, nom)}.
det(t(det, [w(Word)]), DEF, NUM, GEN, dat) --> [Word], {l_det(Word, DEF, NUM, GEN, gen)}.

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
noun(t(noun, [w(Word)]), DEF, NUM, GEN, CASE, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, CASE, ANIM)}.
noun(t(noun, [w(Word)]), DEF, NUM, GEN, acc, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, nom, ANIM)}.
noun(t(noun, [w(Word)]), DEF, NUM, GEN, dat, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, acc, ANIM)}.

% (NOUN, DEF/INDEF, NUM, GEN, CASE, ANIMATE/INANIMATE)
% girl
l_noun(fată, indef, sg, fem, nom, anim).
l_noun(fete, indef, pl, fem, nom, anim).
l_noun(fata, def, sg, fem, nom, anim).
l_noun(fetele, def, pl, fem, nom, anim).
l_noun(fetei, def, sg, fem, gen, anim).
l_noun(fetelor, def, pl, fem, gen, anim).

% boy
l_noun(băiat, indef, sg, masc, nom, anim).
l_noun(băieți, indef, pl, masc, nom, anim).
l_noun(băiatul, def, sg, masc, nom, anim).
l_noun(băieții, def, pl, masc, nom, anim).
l_noun(băiatului, def, sg, masc, gen, anim).
l_noun(băieților, def, pl, masc, gen, anim).

% apple
l_noun(măr, indef, sg, masc, nom, inanim).
l_noun(mere, indef, pl, fem, nom, inanim).
l_noun(mărul, def, sg, masc, nom, inanim).
l_noun(merele, def, pl, fem, nom, inanim).
l_noun(mărului, def, sg, masc, gen, inanim).
l_noun(merelor, def, pl, fem, gen, inanim).


%% pronouns
pronoun(t(pron, [w(Word)]), PERS, NUM, GEN, CASE) --> [Word], {l_pron(Word, PERS, NUM, GEN, CASE)}.
pronoun(t(pron, [w(Word)]), p3, NUM, GEN, CASE) --> [Word], {l_det(Word, def, NUM, GEN, CASE)}.

clit(t(clit, [w(Word)]), PERS, NUM, GEN, CASE) --> [Word], {l_clit(Word, PERS, NUM, GEN, CASE)}.

% (PRONOUN, PERS, NUM, GEN, CASE)
l_pron(eu, p1, sg, _, nom).
l_pron(tu, p2, sg, _, nom).
l_pron(el, p3, sg, masc, nom).
l_pron(ea, p3, sg, fem, nom).
l_pron(noi, p1, pl, _, nom).
l_pron(voi, p2, pl, _, nom).
l_pron(ei, p3, pl, masc, nom).
l_pron(ele, p3, pl, fem, nom).

l_pron(mine, p1, sg, _, acc).
l_pron(tine, p2, sg, _, acc).
l_pron(el, p3, sg, masc, acc).
l_pron(ea, p3, sg, fem, acc).
l_pron(noi, p1, pl, _, acc).
l_pron(voi, p2, pl, _, acc).
l_pron(ei, p3, pl, masc, acc).
l_pron(ele, p3, pl, fem, acc).

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
verb(t(verb, [w(Word)]), PERS, NUM, TRANS) --> [Word], {l_verb(Word, PERS, NUM, TRANS)}.

% (VERB, PERS, NUM, TRANSITIVE)
% eat
l_verb(mănânc, p1, sg, trans).
l_verb(mănânci, p2, sg, trans).
l_verb(mănâncă, p3, sg, trans).
l_verb(mâncăm, p1, pl, trans).
l_verb(mâncați, p2, pl, trans).
l_verb(mănâncă, p3, pl, trans).

% love
l_verb(iubesc, p1, sg, trans).
l_verb(iubești, p2, sg, trans).
l_verb(iubește, p3, sg, trans).
l_verb(iubim, p1, pl, trans).
l_verb(iubiți, p2, pl, trans).
l_verb(iubesc, p3, pl, trans).


%% prepositions
pe(t('PE', [w(pe)])) --> [pe], {l_prep(pe)}.
prep(t(prep, [w(Word)])) --> [Word], {l_prep(Word)}.

l_prep(pe).

sentence( 1, [eu,mănânc]).
sentence( 2, [mâncăm,noi]).
sentence( 3, [mâncăm]).
sentence( 4, [fata,mănâncă,un,măr]).
sentence( 5, [el,îl,mănâncă]).
sentence( 6, [mâncați,merele,acestea]).
sentence( 7, [el,o,iubește,pe,această,fată]).
sentence( 8, [ea,îl,iubește]).
sentence( 9, [îl,iubește,ea]).
sentence(10, [pe,un,băiat,ea,îl,iubește]).
sentence(11, [pe,băiat,îl,iubește,ea]).

ungrammatical( 1, [el,iubesc]).
ungrammatical( 2, [eu,o,iubesc,pe,el]).
ungrammatical( 3, [îl,mănânc,pe,măr]).
ungrammatical( 4, [ei,mănâncă,îl]).
% ungrammatical( 5, []).
% ungrammatical( 6, []).
% ungrammatical( 7, []).
% ungrammatical( 8, []).
% ungrammatical( 9, []).
% ungrammatical(10, []).
