%%% RULES

%% ip -> (Subj), Verb                                    
ip(t(ip, [SUBJ, VP])) --> 
    dp_subj(SUBJ, PERS, NUM, _), 
    vp(VP, PERS, NUM, _).

ip(t(ip, [VP, SUBJ])) --> 
    vp(VP, PERS, NUM, _), 
    dp_subj(SUBJ, PERS, NUM, _).
    
ip(t(ip, [VP])) --> 
    vp(VP, _, _, _).

% ip containing clitics
ip(t(ip, [SUBJ, VP])) --> 
    dp_subj(SUBJ, PERS0, NUM0, _), 
    vp2(VP, PERS0, NUM0, _, _, _, acc).

ip(t(ip, [VP, SUBJ])) -->  
    vp2(VP, PERS0, NUM0, _, _, _, acc),
    dp_subj(SUBJ, PERS0, NUM0, _).

ip(t(ip, [VP])) -->  
    vp2(VP, _, _, _, _, _, acc).


%% vp
vp(t(vp, [VERB]), PERS, NUM, TRANS) --> 
    verb(VERB, PERS, NUM, TRANS).

vp(t(vp, [VERB, OBJ]), PERS, NUM, trans) --> 
    verb(VERB, PERS, NUM, trans),
    dp_obj(OBJ).

vp(t(vp, [OBJ, VERB]), PERS, NUM, trans) --> 
    dp_obj(OBJ),
    verb(VERB, PERS, NUM, trans).


%% vp2 (with clitics)
vpcl(t(vp, [CL, VERB]), PERS0, NUM0, PERS, NUM, GEN, CASE) -->
    clit(CL, PERS, NUM, GEN, CASE),
    verb(VERB, PERS0, NUM0, trans).

vcl(t(vp, [VERB, OBJ]), PERS0, NUM0, PERS, NUM, GEN, acc) -->
    verb(VERB, PERS0, NUM0, trans),
    dp_obj_cl(OBJ, PERS, NUM, GEN, anim).

vp2(VP, PERS0, NUM0, PERS, NUM, GEN, CASE) -->
    vpcl(VP, PERS0, NUM0, PERS, NUM, GEN, CASE).

vp2(t(vp, [CL, VP]), PERS0, NUM0, PERS, NUM, GEN, CASE) -->
    clit(CL, PERS, NUM, GEN, CASE),
    vcl(VP, PERS0, NUM0, PERS, NUM, GEN, CASE).


%% dp
dp(t(dp, [NOUN]), p3, NUM, GEN, CASE, DEF, ANIM) --> noun(NOUN, DEF, NUM, GEN, CASE, ANIM).
dp(t(dp, [PRONOUN]), PERS, NUM, GEN, CASE, def, anim) --> pronoun(PRONOUN, PERS, NUM, GEN, CASE).
dp(t(dp, [PROPN]), p3, NUM, GEN, CASE, def, ANIM) --> propn(PROPN, NUM, GEN, CASE, ANIM).

dp(t(dp, [DET, NOUN]), p3, NUM, GEN, CASE, indef, ANIM) --> det(DET, indef, NUM, GEN, CASE, _), 
    noun(NOUN, no, NUM, GEN, nom, ANIM).
dp(t(dp, [DET, NOUN]), p3, NUM, GEN, CASE, def, ANIM) --> det(DET, def, NUM, GEN, CASE, short), 
    noun(NOUN, no, NUM, GEN, nom, ANIM).
dp(t(dp, [NOUN, DET]), p3, NUM, GEN, CASE, def, ANIM) --> noun(NOUN, defm, NUM, GEN, CASE, ANIM), 
    det(DET, def, NUM, GEN, CASE, long).

dp_subj(t(subj, [Tree]), PERS, NUM, GEN) --> \+ dp(Tree, PERS, NUM, GEN, nom, no, _), 
    dp(Tree, PERS, NUM, GEN, nom, _, _).

% inanimate or non-specific nouns
dp_obj(t(dobj, [Tree])) --> dp(Tree, _, _, _, acc, _, inanim).
dp_obj(t(dobj, [Tree])) --> dp(Tree, _, _, _, acc, indef, anim).
dp_obj(t(dobj, [Tree])) --> dp(Tree, _, _, _, acc, defm, anim).

% animate nouns - PE accusative case marker
% exceptions: indefinite NPs & definite nouns (inflectional)
dp_obj_cl(t(dobj, [PE, Tree]), PERS, NUM, GEN, anim) --> pe(PE), dp(Tree, PERS, NUM, GEN, acc, def, anim).
dp_obj_cl(t(dobj, [PE, Tree]), PERS, NUM, GEN, anim) --> pe(PE), dp(Tree, PERS, NUM, GEN, acc, no, anim).

% --------------------------------------------------------------------------------

%%% WORDS

%% determiners
det(t(det, [w(Word)]), DEF, NUM, GEN, CASE, FORM) --> [Word], {l_det(Word, DEF, NUM, GEN, CASE, FORM)}.
det(t(det, [w(Word)]), DEF, NUM, GEN, acc, FORM) --> [Word], {l_det(Word, DEF, NUM, GEN, nom, FORM)}.

% (DET, DEF/INDEF, NUM, GEN, CASE, SHORT/LONG/ONE FORM)
% a/an/some
l_det(o, indef, sg, fem, nom, null).
l_det(un, indef, sg, masc, nom, null).
l_det(niște, indef, pl, _, nom, null).

% this
l_det(această, def, sg, fem, nom, short).
l_det(acest, def, sg, masc, nom, short).
l_det(aceste, def, pl, fem, nom, short).
l_det(acești, def, pl, masc, nom, short).

l_det(aceasta, def, sg, fem, nom, long).
l_det(acesta, def, sg, masc, nom, long).
l_det(acestea, def, pl, fem, nom, long).
l_det(aceștia, def, pl, masc, nom, long).



%% nouns
noun(t(noun, [w(Word)]), DEF, NUM, GEN, CASE, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, CASE, ANIM)}.
noun(t(noun, [w(Word)]), DEF, NUM, GEN, acc, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, nom, ANIM)}.

% (NOUN, DEF MARKER, NUM, GEN, CASE, ANIMATE/INANIMATE, NTYPE)
% girl
l_noun(fată, no, sg, fem, nom, anim).
l_noun(fete, no, pl, fem, nom, anim).
l_noun(fata, defm, sg, fem, nom, anim).
l_noun(fetele, defm, pl, fem, nom, anim).

% boy
l_noun(băiat, no, sg, masc, nom, anim).
l_noun(băieți, no, pl, masc, nom, anim).
l_noun(băiatul, defm, sg, masc, nom, anim).
l_noun(băieții, defm, pl, masc, nom, anim).

% apple
l_noun(măr, no, sg, masc, nom, inanim).
l_noun(mere, no, pl, fem, nom, inanim).
l_noun(mărul, defm, sg, masc, nom, inanim).
l_noun(merele, defm, pl, fem, nom, inanim).


%% proper nouns
propn(t(propn, [w(Word)]), NUM, GEN, CASE, ANIM) --> [Word], {l_prop_noun(Word, NUM, GEN, CASE, ANIM)}.
propn(t(propn, [w(Word)]), NUM, GEN, acc, ANIM) --> [Word], {l_prop_noun(Word, NUM, GEN, nom, ANIM)}.

l_prop_noun(andrei, sg, masc, nom, anim).
l_prop_noun(ana, sg, fem, nom, anim).


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

% clitics - 3sg
l_clit(îl, p3, sg, masc, acc).
l_clit(o, p3, sg, fem, acc).


%% verbs
verb(t(verb, [w(Word)]), PERS, NUM, TRANS) --> [Word], {l_verb(Word, PERS, NUM, TRANS)}.

% (VERB, PERS, NUM, TRANSITIVE)
% eat
l_verb(mănâncă, p3, sg, trans).

% love
l_verb(iubește, p3, sg, trans).

% dance
l_verb(dansez, p1, sg, intrans).
l_verb(dansezi, p2, sg, intrans).
l_verb(dansează, p3, sg, intrans).
l_verb(dansăm, p1, pl, intrans).
l_verb(dansați, p2, pl, intrans).
l_verb(dansează, p3, pl, intrans).


%% prepositions
pe(t('PE', [w(pe)])) --> [pe], {l_prep(pe)}.
prep(t(prep, [w(Word)])) --> [Word], {l_prep(Word)}.

l_prep(pe).

sentence( 1, [o,fată,mănâncă]).
sentence( 2, [fata,mănâncă,un,măr]).
sentence( 3, [fata,mănâncă,acest,măr]).
sentence( 4, [fata,mănâncă,mărul,acesta]).
sentence( 5, [fata,mănâncă,mărul]).
sentence( 6, [fata,mănâncă,niște,mere]).
sentence( 7, [andrei,dansează]).
sentence( 8, [această,fată,dansează]).
sentence( 9, [dansează,fata]).
sentence(10, [andrei,mănâncă,un,măr]).
sentence(11, [andrei,îl,mănâncă]).
sentence(12, [andrei,o,iubește,pe,ana]).
sentence(13, [fata,îl,iubește,pe,andrei]).
sentence(14, [fata,iubește,băiatul]).
sentence(15, [fata,iubește,un,băiat]).
sentence(16, [fata,îl,iubește,pe,acest,băiat]).
sentence(17, [fata,îl,iubește,pe,băiatul,acesta]).
sentence(18, [ana,o,iubește,pe,fata,aceasta]).
sentence(19, [fata,iubește,fata]).
sentence(20, [iubește,băiatul]).
sentence(21, [o,iubește,o,fată]).
sentence(22, [iubește,această,fată]).
sentence(23, [o,iubește,această,fată]).
sentence(24, [iubește,andrei]).
sentence(25, [îl,iubește,andrei]).
sentence(26, [îl,iubește,băiatul]).


ungrammatical( 1, [andrei,acesta,dansează]).
ungrammatical( 2, [un,fată,dansează]).
ungrammatical( 3, [un,băiatul,dansează]).
ungrammatical( 4, [acest,băiatul,dansează]).
ungrammatical( 5, [acest,un,băiat,dansează]).
ungrammatical( 6, [această,băiat,dansează]).
ungrammatical( 7, [această,băiatul,dansează]).
ungrammatical( 8, [un,băiat,acesta,dansează]).
ungrammatical( 9, [băiatul,aceasta,dansează]).
ungrammatical(10, [fata,mănâncă,această,măr]).
ungrammatical(11, [fata,mănâncă,acești,mere]).
ungrammatical(12, [fata,mănâncă,pe,mărul,acesta]).
ungrammatical(13, [fata,iubește,pe,băiatul]).
ungrammatical(14, [fata,iubește,pe,un,băiat]).
ungrammatical(15, [fetele,mănânc,merele]).
ungrammatical(16, [fată,mănâncă]).
ungrammatical(17, [fata,dansez]).
ungrammatical(18, [andrei,îl,mănâncă,un,măr]).
ungrammatical(19, [andrei,îl,mănâncă,pe,măr]).
ungrammatical(20, [fata,îl,iubește,andrei]).
ungrammatical(21, [fata,îl,iubește,pe,un,băiat]).
ungrammatical(22, [fata,îl,iubește,un,băiat]).
ungrammatical(23, [fata,îl,iubește,pe,ana]).
ungrammatical(24, [fata,îl,dansează]).
ungrammatical(25, [fata,îl,iubește,băiatul]).
ungrammatical(26, [fata,îl,iubește,pe,băiatul]).
ungrammatical(27, [fata,iubește,pe,un,băiat]).
ungrammatical(28, [fata,iubește,pe,băiatul]).
ungrammatical(29, [andrei,mănâncă,pe,măr]).
ungrammatical(30, [fata,iubește,pe,un,băiat]).
ungrammatical(31, [pe,această,fată,dansează]).
ungrammatical(32, [fata,iubește,pe,andrei]).
ungrammatical(33, [fata,iubește,pe,acest,băiat]).
ungrammatical(34, [mănâncă,pe,un,măr]).
ungrammatical(35, [mănâncă,pe,acest,măr]).
ungrammatical(36, [îl,mănâncă,pe,acest,măr]).
ungrammatical(37, [fata,îl,mănâncă,acest,măr]).
ungrammatical(38, [iubește,pe,o,fată]).
ungrammatical(39, [o,iubește,pe,o,fată]).
ungrammatical(40, [iubește,pe,această,fată]).
ungrammatical(41, [iubește,pe,andrei]).
ungrammatical(42, [iubește,pe,băiatul]).
ungrammatical(43, [îl,iubește,pe,băiatul]).
ungrammatical(44, [fata,îl,iubește,băiatul]).