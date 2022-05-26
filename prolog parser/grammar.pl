%%% RULES

% ip -> (Subj), Verb
ip(t(ip, [SUBJ, VP])) --> 
    dp_subj(SUBJ, PERS, NUM, _), 
    vp(VP, PERS, NUM).
ip(t(ip, [VP, SUBJ])) --> 
    vp(VP, PERS, NUM), 
    dp_subj(SUBJ, PERS, NUM, _).
ip(t(ip, [VP])) --> 
    vp(VP, _, _).

% ip -> (Subj), Verb, Obj
ip(t(ip, [SUBJ, VP, OBJ])) --> 
    dp_subj(SUBJ, PERS, NUM, _), 
    vp(VP, PERS, NUM), 
    dp_obj(OBJ, _, _, _, inanim).
ip(t(ip, [VP, SUBJ, OBJ])) --> 
    vp(VP, PERS, NUM), 
    dp_subj(SUBJ, PERS, NUM, _), 
    dp_obj(OBJ, _, _, _, inanim).
ip(t(ip, [VP, OBJ, SUBJ])) --> 
    vp(VP, PERS, NUM), 
    dp_obj(OBJ, _, _, _, inanim), 
    dp_subj(SUBJ, PERS, NUM, _).

ip(t(ip, [VP, OBJ])) --> 
    vp(VP, _, _), 
    dp_obj(OBJ, _, _, _, inanim).
ip(t(ip, [OBJ, VP])) --> 
    dp_obj(OBJ, _, _, _, inanim),
    vp(VP, _, _).

% ip -> (Subj), clit + Verb, (Obj)
ip(t(ip, [SUBJ, VP, OBJ])) --> 
    dp_subj(SUBJ, PERS0, NUM0, _), 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    dp_obj(OBJ, PERS, NUM, GEN, anim).
ip(t(ip, [SUBJ, OBJ, VP])) --> 
    dp_subj(SUBJ, PERS0, NUM0, _), 
    dp_obj(OBJ, PERS, NUM, GEN, anim),
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc).
ip(t(ip, [OBJ, SUBJ, VP])) --> 
    dp_obj(OBJ, PERS, NUM, GEN, anim),
    dp_subj(SUBJ, PERS0, NUM0, _), 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc).
ip(t(ip, [OBJ, VP, SUBJ])) --> 
    dp_obj(OBJ, PERS, NUM, GEN, anim),
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    dp_subj(SUBJ, PERS0, NUM0, _).
ip(t(ip, [VP, SUBJ, OBJ])) --> 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    dp_subj(SUBJ, PERS0, NUM0, _), 
    dp_obj(OBJ, PERS, NUM, GEN, anim).
ip(t(ip, [VP, OBJ, SUBJ])) --> 
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, acc), 
    dp_obj(OBJ, PERS, NUM, GEN, anim),
    dp_subj(SUBJ, PERS0, NUM0, _).

ip(t(ip, [VP, OBJ])) --> 
    vpcl(VP, _, _,PERS, NUM, GEN, acc), 
    dp_obj(OBJ, PERS, NUM, GEN, anim).
ip(t(ip, [OBJ, VP])) --> 
    dp_obj(OBJ, PERS, NUM, GEN, anim),
    vpcl(VP, _, _,PERS, NUM, GEN, acc).

ip(t(ip, [SUBJ, VP])) --> 
    dp_subj(SUBJ, PERS0, NUM0, _), 
    vpcl(VP, PERS0, NUM0, _, _, _, acc).
ip(t(ip, [VP, SUBJ])) -->  
    vpcl(VP, PERS0, NUM0, _, _, _, acc),
    dp_subj(SUBJ, PERS0, NUM0, _).

ip(t(ip, [VP])) -->  
    vpcl(VP, _, _, _, _, _, acc).


%% vp
vp(t(vp, [VERB]), PERS, NUM) --> 
    verb(VERB, PERS, NUM, _).
vpcl(t(vp, [CL, VERB]), PERS0, NUM0, PERS, NUM, GEN, CASE) -->
    clit(CL, PERS, NUM, GEN, CASE),
    verb(VERB, PERS0, NUM0, trans).

%% dp
dp(t(dp, [NOUN]), p3, NUM, GEN, CASE, DEF, ANIM) --> noun(NOUN, DEF, NUM, GEN, CASE, ANIM).
dp(t(dp, [PRONOUN]), PERS, NUM, GEN, nom, def, anim) --> pronoun(PRONOUN, PERS, NUM, GEN, nom).
dp(t(dp, [PRONOUN]), PERS, NUM, GEN, acc, def, anim) --> pronoun(PRONOUN, PERS, NUM, GEN, nom).

dp(t(dp, [DET, NOUN]), p3, NUM, GEN, CASE, indef, ANIM) --> \+ det(DET, indef, sg, fem, gen, _), 
    det(DET, indef, NUM, GEN, CASE, _), noun(NOUN, no, NUM, GEN, nom, ANIM).
dp(t(dp, [DET, NOUN]), p3, NUM, GEN, CASE, def, ANIM) --> \+ det(DET, indef, sg, fem, gen, _), 
    det(DET, def, NUM, GEN, CASE, short), noun(NOUN, no, NUM, GEN, nom, ANIM).
dp(t(dp, [DET, NOUN]), p3, sg, fem, gen, indef, ANIM) --> det(DET, indef, sg, fem, gen, null), 
    noun(NOUN, no, pl, fem, nom, ANIM).
dp(t(dp, [DET, NOUN]), p3, sg, fem, gen, def, ANIM) --> det(DET, def, sg, fem, gen, short), 
    noun(NOUN, no, pl, fem, nom, ANIM).
dp(t(dp, [NOUN, DET]), p3, NUM, GEN, CASE, def, ANIM) --> noun(NOUN, defm, NUM, GEN, CASE, ANIM), 
    det(DET, def, NUM, GEN, CASE, long).

dp_subj(t(dp,[Tree]), PERS, NUM, GEN) --> \+ dp(Tree, PERS, NUM, GEN, nom, no, _), 
    dp(Tree, PERS, NUM, GEN, nom, _, _).

% inanimate or non-specific nouns
dp_obj(Tree, PERS, NUM, GEN, inanim) --> dp(Tree, PERS, NUM, GEN, acc, _, inanim).
dp_obj(Tree, PERS, NUM, GEN, inanim) --> dp(Tree, PERS, NUM, GEN, acc, indef, anim).

% animate nouns - PE accusative case marker
% exceptions: indefinite NPs & definite nouns
dp_obj(t(dp, [PE, NP]), PERS, NUM, GEN, anim) --> pe(PE), dp(NP, PERS, NUM, GEN, acc, def, anim).
dp_obj(t(dp, [PE, NP]), PERS, NUM, GEN, anim) --> pe(PE), dp(NP, PERS, NUM, GEN, acc, no, anim).

% --------------------------------------------------------------------------------

%%% WORDS

%% determiners
det(t(det, [w(Word)]), DEF, NUM, GEN, CASE, FORM) --> [Word], {l_det(Word, DEF, NUM, GEN, CASE, FORM)}.
det(t(det, [w(Word)]), DEF, NUM, GEN, acc, FORM) --> [Word], {l_det(Word, DEF, NUM, GEN, nom, FORM)}.
det(t(det, [w(Word)]), DEF, NUM, GEN, dat, FORM) --> [Word], {l_det(Word, DEF, NUM, GEN, gen, FORM)}.

% (DET, DEF/INDEF, NUM, GEN, CASE, SHORT/LONG/ONE FORM)
% a/an/some
l_det(o, indef, sg, fem, nom, null).
l_det(un, indef, sg, masc, nom, null).
l_det(niște, indef, pl, _, nom, null).
l_det(unei, indef, sg, fem, gen, null).
l_det(unui, indef, sg, masc, gen, null).
l_det(unor, indef, pl, _, gen, null).

% this
l_det(această, def, sg, fem, nom, short).
l_det(acest, def, sg, masc, nom, short).
l_det(aceste, def, pl, fem, nom, short).
l_det(acești, def, pl, masc, nom, short).
l_det(acestei, def, sg, fem, gen, short).
l_det(acestui, def, sg, masc, gen, short).
l_det(acestor, def, pl, _, gen, short).
l_det(aceasta, def, sg, fem, nom, long).
l_det(acesta, def, sg, masc, nom, long).
l_det(acestea, def, pl, fem, nom, long).
l_det(aceștia, def, pl, masc, nom, long).
l_det(acesteia, def, sg, fem, gen, long).
l_det(acestuia, def, sg, masc, gen, long).
l_det(acestora, def, pl, _, gen, long).


%% nouns
noun(t(noun, [w(Word)]), DEF, NUM, GEN, CASE, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, CASE, ANIM)}.
noun(t(noun, [w(Word)]), DEF, NUM, GEN, acc, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, nom, ANIM)}.
noun(t(noun, [w(Word)]), DEF, NUM, GEN, dat, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, acc, ANIM)}.

% (NOUN, DEF MARKER, NUM, GEN, CASE, ANIMATE/INANIMATE)
% girl
l_noun(fată, no, sg, fem, nom, anim).
l_noun(fete, no, pl, fem, nom, anim).
l_noun(fata, defm, sg, fem, nom, anim).
l_noun(fetele, defm, pl, fem, nom, anim).
l_noun(fetei, defm, sg, fem, gen, anim).
l_noun(fetelor, defm, pl, fem, gen, anim).

% boy
l_noun(băiat, no, sg, masc, nom, anim).
l_noun(băieți, no, pl, masc, nom, anim).
l_noun(băiatul, defm, sg, masc, nom, anim).
l_noun(băieții, defm, pl, masc, nom, anim).
l_noun(băiatului, defm, sg, masc, gen, anim).
l_noun(băieților, defm, pl, masc, gen, anim).

% apple
l_noun(măr, no, sg, masc, nom, inanim).
l_noun(mere, no, pl, fem, nom, inanim).
l_noun(mărul, defm, sg, masc, nom, inanim).
l_noun(merele, defm, pl, fem, nom, inanim).
l_noun(mărului, defm, sg, masc, gen, inanim).
l_noun(merelor, defm, pl, fem, gen, inanim).


%% pronouns
pronoun(t(pron, [w(Word)]), PERS, NUM, GEN, CASE) --> [Word], {l_pron(Word, PERS, NUM, GEN, CASE)}.
pronoun(t(pron, [w(Word)]), p3, NUM, GEN, CASE) --> [Word], {l_det(Word, def, NUM, GEN, CASE, long)}.

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
sentence(10, [pe,acest,băiat,ea,îl,iubește]).
sentence(11, [pe,acest,băiat,îl,iubește,ea]).
sentence(12, [el,iubește,o,fată]).
sentence(13, [măr,mănâncă]).

ungrammatical( 1, [el,iubesc]).
ungrammatical( 2, [eu,o,iubesc,pe,el]).
ungrammatical( 3, [îl,mănânc,pe,măr]).
ungrammatical( 4, [ei,mănâncă,îl]).
ungrammatical( 5, [îl,iubește,pe,băiatul]).
ungrammatical( 6, [fată,mănâncă]).
% ungrammatical( 7, []).
% ungrammatical( 8, []).
% ungrammatical( 9, []).
% ungrammatical(10, []).
