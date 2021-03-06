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
l_det(ni??te, indef, pl, _, nom, null).

% this
l_det(aceast??, def, sg, fem, nom, short).
l_det(acest, def, sg, masc, nom, short).
l_det(aceste, def, pl, fem, nom, short).
l_det(ace??ti, def, pl, masc, nom, short).

l_det(aceasta, def, sg, fem, nom, long).
l_det(acesta, def, sg, masc, nom, long).
l_det(acestea, def, pl, fem, nom, long).
l_det(ace??tia, def, pl, masc, nom, long).



%% nouns
noun(t(noun, [w(Word)]), DEF, NUM, GEN, CASE, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, CASE, ANIM)}.
noun(t(noun, [w(Word)]), DEF, NUM, GEN, acc, ANIM) --> [Word], {l_noun(Word, DEF, NUM, GEN, nom, ANIM)}.

% (NOUN, DEF MARKER, NUM, GEN, CASE, ANIMATE/INANIMATE, NTYPE)
% girl
l_noun(fat??, no, sg, fem, nom, anim).
l_noun(fete, no, pl, fem, nom, anim).
l_noun(fata, defm, sg, fem, nom, anim).
l_noun(fetele, defm, pl, fem, nom, anim).

% boy
l_noun(b??iat, no, sg, masc, nom, anim).
l_noun(b??ie??i, no, pl, masc, nom, anim).
l_noun(b??iatul, defm, sg, masc, nom, anim).
l_noun(b??ie??ii, defm, pl, masc, nom, anim).

% apple
l_noun(m??r, no, sg, masc, nom, inanim).
l_noun(mere, no, pl, fem, nom, inanim).
l_noun(m??rul, defm, sg, masc, nom, inanim).
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
l_clit(??l, p3, sg, masc, acc).
l_clit(o, p3, sg, fem, acc).


%% verbs
verb(t(verb, [w(Word)]), PERS, NUM, TRANS) --> [Word], {l_verb(Word, PERS, NUM, TRANS)}.

% (VERB, PERS, NUM, TRANSITIVE)
% eat
l_verb(m??n??nc??, p3, sg, trans).

% love
l_verb(iube??te, p3, sg, trans).

% dance
l_verb(dansez, p1, sg, intrans).
l_verb(dansezi, p2, sg, intrans).
l_verb(danseaz??, p3, sg, intrans).
l_verb(dans??m, p1, pl, intrans).
l_verb(dansa??i, p2, pl, intrans).
l_verb(danseaz??, p3, pl, intrans).


%% prepositions
pe(t('PE', [w(pe)])) --> [pe], {l_prep(pe)}.
prep(t(prep, [w(Word)])) --> [Word], {l_prep(Word)}.

l_prep(pe).

sentence( 1, [o,fat??,m??n??nc??]).
sentence( 2, [fata,m??n??nc??,un,m??r]).
sentence( 3, [fata,m??n??nc??,acest,m??r]).
sentence( 4, [fata,m??n??nc??,m??rul,acesta]).
sentence( 5, [fata,m??n??nc??,m??rul]).
sentence( 6, [fata,m??n??nc??,ni??te,mere]).
sentence( 7, [andrei,danseaz??]).
sentence( 8, [aceast??,fat??,danseaz??]).
sentence( 9, [danseaz??,fata]).
sentence(10, [andrei,m??n??nc??,un,m??r]).
sentence(11, [andrei,??l,m??n??nc??]).
sentence(12, [andrei,o,iube??te,pe,ana]).
sentence(13, [fata,??l,iube??te,pe,andrei]).
sentence(14, [fata,iube??te,b??iatul]).
sentence(15, [fata,iube??te,un,b??iat]).
sentence(16, [fata,??l,iube??te,pe,acest,b??iat]).
sentence(17, [fata,??l,iube??te,pe,b??iatul,acesta]).
sentence(18, [ana,o,iube??te,pe,fata,aceasta]).
sentence(19, [fata,iube??te,fata]).
sentence(20, [iube??te,b??iatul]).
sentence(21, [o,iube??te,o,fat??]).
sentence(22, [iube??te,aceast??,fat??]).
sentence(23, [o,iube??te,aceast??,fat??]).
sentence(24, [iube??te,andrei]).
sentence(25, [??l,iube??te,andrei]).
sentence(26, [??l,iube??te,b??iatul]).


ungrammatical( 1, [andrei,acesta,danseaz??]).
ungrammatical( 2, [un,fat??,danseaz??]).
ungrammatical( 3, [un,b??iatul,danseaz??]).
ungrammatical( 4, [acest,b??iatul,danseaz??]).
ungrammatical( 5, [acest,un,b??iat,danseaz??]).
ungrammatical( 6, [aceast??,b??iat,danseaz??]).
ungrammatical( 7, [aceast??,b??iatul,danseaz??]).
ungrammatical( 8, [un,b??iat,acesta,danseaz??]).
ungrammatical( 9, [b??iatul,aceasta,danseaz??]).
ungrammatical(10, [fata,m??n??nc??,aceast??,m??r]).
ungrammatical(11, [fata,m??n??nc??,ace??ti,mere]).
ungrammatical(12, [fata,m??n??nc??,pe,m??rul,acesta]).
ungrammatical(13, [fata,iube??te,pe,b??iatul]).
ungrammatical(14, [fata,iube??te,pe,un,b??iat]).
ungrammatical(15, [fetele,m??n??nc,merele]).
ungrammatical(16, [fat??,m??n??nc??]).
ungrammatical(17, [fata,dansez]).
ungrammatical(18, [andrei,??l,m??n??nc??,un,m??r]).
ungrammatical(19, [andrei,??l,m??n??nc??,pe,m??r]).
ungrammatical(20, [fata,??l,iube??te,andrei]).
ungrammatical(21, [fata,??l,iube??te,pe,un,b??iat]).
ungrammatical(22, [fata,??l,iube??te,un,b??iat]).
ungrammatical(23, [fata,??l,iube??te,pe,ana]).
ungrammatical(24, [fata,??l,danseaz??]).
ungrammatical(25, [fata,??l,iube??te,b??iatul]).
ungrammatical(26, [fata,??l,iube??te,pe,b??iatul]).
ungrammatical(27, [fata,iube??te,pe,un,b??iat]).
ungrammatical(28, [fata,iube??te,pe,b??iatul]).
ungrammatical(29, [andrei,m??n??nc??,pe,m??r]).
ungrammatical(30, [fata,iube??te,pe,un,b??iat]).
ungrammatical(31, [pe,aceast??,fat??,danseaz??]).
ungrammatical(32, [fata,iube??te,pe,andrei]).
ungrammatical(33, [fata,iube??te,pe,acest,b??iat]).
ungrammatical(34, [m??n??nc??,pe,un,m??r]).
ungrammatical(35, [m??n??nc??,pe,acest,m??r]).
ungrammatical(36, [??l,m??n??nc??,pe,acest,m??r]).
ungrammatical(37, [fata,??l,m??n??nc??,acest,m??r]).
ungrammatical(38, [iube??te,pe,o,fat??]).
ungrammatical(39, [o,iube??te,pe,o,fat??]).
ungrammatical(40, [iube??te,pe,aceast??,fat??]).
ungrammatical(41, [iube??te,pe,andrei]).
ungrammatical(42, [iube??te,pe,b??iatul]).
ungrammatical(43, [??l,iube??te,pe,b??iatul]).
ungrammatical(44, [fata,??l,iube??te,b??iatul]).