%--------------------------------- - - - - - - - - - -  -  -  -  -   -                                                             
%   Universidade do Minho
%   Licenciatura em Engenharia Informática
%   Sistemas de Representação de Conhecimento e Raciocínio
%
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   Grupo 11:
%       60990 David Angelis
%       61023 Marcos Ramos
%       61024 Sérgio Oliveira
% 
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   Exercício 2 - Conhecimento imperfeito
%   Maio de 2014
%
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais
:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais
:- op( 900,xfy,'::' ).
:- dynamic '-'/1.
:- dynamic '+'/1.
:- dynamic medicamento/6.
:- dynamic preco/3.
:- dynamic datas/3.
:- dynamic excepcao/2.
nulo(interdito).

%Extensao do predicado datas: Id Medicamento,Data Introducao,Data Limite -> {V,F,D}

%Conhecimento perfeito, do tipo positivo
datas(m001,'01-01-01','01-01-11').
datas(m002,'02-02-02','02-02-22').

% Conhecimento perfeito, do tipo negativo
% Data limite errada
-datas(m003,'03-03-03','03-04-03').

% Conhecimento imperfeito, do tipo incerto
datas(m004,'04-04-04',algum).
datas(m006,algum,'06-06-16').
datas(algum,'12-12-12','12-12-22').

% Conhecimento imperfeito, do tipo impreciso
excepcao( datas(m007,'07-07-07','07-07-17') ).
excepcao( datas(m007,'07-07-07','08-08-18') ).

% Conhecimento imperfeito do tipo interdito
datas(m008,'08-08-08',interdito).
% ----------------- - - -  -  - Excepcao -  -  - - - -----------------
excepcao( datas(IDM,DI,DL) ) :- datas(IDM,DI,algum).
excepcao( datas(IDM,DI,DL) ) :- datas(IDM,algum,DL).
excepcao( datas(IDM,DI,DL) ) :- datas(algum,DI,DL).
excepcao( datas(IDM,DI,DL) ) :- datas(algum,algum,DL).
excepcao( datas(IDM,DI,DL) ) :- datas(algum,DI,algum).
excepcao( datas(IDM,DI,DL) ) :- datas(IDM,algum,algum).
excepcao( datas(IDM,DI,DL) ) :- datas(algum,algum,algum).

excepcao( datas(IDM,DI,DL) ) :- datas(IDM,DI,interdito).
excepcao( datas(IDM,DI,DL) ) :- datas(IDM,interdito,DL).
excepcao( datas(IDM,DI,DL) ) :- datas(interdito,DI,DL).
excepcao( datas(IDM,DI,DL) ) :- datas(interdito,interdito,DL).
excepcao( datas(IDM,DI,DL) ) :- datas(interdito,DI,interdito).
excepcao( datas(IDM,DI,DL) ) :- datas(IDM,interdito,interdito).
excepcao( datas(IDM,DI,DL) ) :- datas(interdito,interdito,interdito).

% ------------ - - -  -  - ExcepÁ„o especÌfica -  -  - - - ------------
-datas(IDM,DI,DL) :- nao( datas(IDM,DI,DL) ),
nao( excepcao( datas(IDM,DI,DL) ) ).

% ---------------- - - -  -  - Invariantes -  -  - - - ----------------
% Garante que ao inserir uma data, existe medicamento na BC
+datas(IDM,_,_) :: (solucoes( IDM,(medicamento(IDM,_,_,_,_,_)),L ),
comprimento(L,N), N==1
).

% Garante que so existe um registo de data que contÈm o id do medicamento na BC
+datas(IDM,_,_) :: (solucoes( IDM, (datas(IDM,_,_)),L ),
comprimento(L,N), N==1
).

% Garante que n„o existe um conhecimento negativo para o que estamos a inserir
+datas(IDM,DI,DL) :: (solucoes( IDM,(-datas(IDM,DI,DL)),L ),
comprimento(L,N), S==0
).

% Garante que existe um conhecimento positivo para o negativo que estamos a inserir
+(-datas(IDM,DI,DL)) :: (solucoes( IDM,(datas(IDM,DI,DL)),L ),
comprimento(L,N), S==0
).

% Garante que existe um registo de data que estamos a remover
-datas(IDM,DI,DL) :: (solucoes( (IDM,DI,DL),(datas(IDM,DI,DL)),L ),
comprimento(L,N), N==1
).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extenção do predicado medicamento: id,principio activo,nome,formato,doença

% Conhecimento perfeito, positivo
medicamento(a001,ibuprofeno,brufen,comprimido,febre).
medicamento(a002,butilescopolamina,buscopan,comprimido,'dor abdominal').
medicamento(a003,iodopovidona,betadine,pomada,feridas).
medicamento(a004,'oxido de zinco',halibut,pomada,queimaduras).
medicamento(a005,bnzidamina,'tantum verde',pastilha,'dores de garganta').

%Conhecimento perfeito, negativo
-medicamento(a006,valeriana,livetan,comprimido,diarreia).
-medicamento(a007,dietilamina,assagim,creme,gripe).

%Conhecimento imperfeito, incerto
excepcao( medicamento(a008,sodio,maxfluor,comprimido,algum) ).
excepcao( medicamento(a009,tirotricina,mebocaina,algum,gripe) ).

%Conhecimento imperfeito,interdito
medicamento(a012,interdito,memoria,coprimido,memoria).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,P,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,algum,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,F,algum).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,P,algum,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,algum,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,P,N,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,P,N,F,algum).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,algum,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,algum,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,algum,F,algum).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,N,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,N,F,algum).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,algum,algum).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,algum,algum,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,P,algum,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,P,algum,F,algum).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,algum,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,algum,F,algum).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,N,algum,algum).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,algum,algum,algum,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,algum,algum,F,algum).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,algum,algum,algum,algum).


excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(algum,algum,algum,algum,algum).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,P,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,interdito,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,interdito,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,F,interdito).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,interdito,N,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,P,N,interdito,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,P,N,F,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,interdito,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,interdito,interdito,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,interdito,F,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,N,interdito,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,N,F,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,N,interdito,interdito).


excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,interdito,interdito,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,P,interdito,interdito,F).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,P,interdito,F,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,P,interdito,F,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,interdito,interdito,D).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,interdito,F,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,N,interdito,interdito).


excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,interdito,interdito,F,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,interdito,interdito,interdito,interdito).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(ID,P,interdito,interdito,interdito).

excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,interdito,interdito,interdito,D).
excepcao( medicamento(ID,P,N,F,D) ) :- medicamento(interdito,interdito,interdito,interdito,interdito).

% ------------ - - -  -  - Excepcao especifica -  -  - - - ------------
-medicamento(ID,N,P,APR,I,APL) :- nao( medicamento(ID,N,P,APR,I,APL) ),
nao( excepcao( medicamento(ID,N,P,APR,I,APL) ) ).

% ---------------- - - -  -  - Invariantes -  -  - - - ----------------

% Garante que nao estamos a inserir um medicamento com ID repetido
+medicamento(ID,P,N,F,D) :: (solucoes(ID, (medicamento(ID,_,_,_,_,_)), L),
comprimento(L,N), N==0
).

% Garante que nao existe conhecimento negativo para o positivo que estamos a inserir
+medicamento(ID,P,N,F,D) :: (solucoes(ID, (-medicamento(ID,P,N,F,D)), L),
comprimento(L,N), N==0
).

% Garante que nao existe conhecimento positivo para o negativo que estamos a inserir
+medicamento(ID,P,N,F,D) :: (solucoes(ID, (medicamento(ID,P,N,F,D)), L),
comprimentos(L,N), N==0
).

% Garante que se está remover um medicamento que existe
-medicamento(ID,P,N,F,D) :: (solucoes(ID,(medicamento(ID,P,N,F,D)), L),
comprimento(L,N), N==1
).

% Extens„o do predicado que permite a evolucao do conhecimento
evolucaonormal( Termo ) :-
solucoes( Invariante,(+Termo::Invariante),Lista ),
insercao( Termo ),
teste( Lista ).

% Predicado Medicamento
evolucao( medicamento(ID,P,N,F,D) ) :-
solucoes( (medicamento(ID,P,algum,F,D)),(medicamento(ID,P,algum,F,D)),L1 ),
solucoes( (medicamento(ID,algum,N,F,D)),(medicamento(ID,algum,N,F,D)),L2 ),
solucoes( (medicamento(ID,P,N,algum,D)),(medicamento(ID,P,N,algum,D)),L3 ),
solucoes( (medicamento(ID,P,N,F,algum)),(medicamento(ID,P,N,F,algum)),L5 ),
solucoes( (excepcao(medicamento(ID,P,N,F,D))),(excepcao(medicamento(ID,P,N,F,D))),L6 ),
junta( L1,L2,R1 ), junta( R1,L3,R2 ), junta( R2,L4,R3 ), junta( R3,L5,R4 ),junta( R4,L6,RF ),
comprimento( RF,N ), N>=0,
evolucaonormal( medicamento(ID,N,P,APR,I,APL) ).

% ::::::::::::::::::::::::::::::preco:::::::::::::::::::::::::::::

% Extens„o do predicado preco: Id Medicamento,Tipo,Preco -> {V,F,D}

% Conhecimento perfeito, do tipo positivo
preco(m001,normal,5.55).
preco(m001,reformado,2.5).
preco(m002,normal,6.25).
preco(m002,reformado,3.25).

% Conhecimento perfeito, do tipo negativo
-preco(m003,reformado,4.5).
-preco(m003,normal,5.5).

% Conhecimento imperfeito, do tipo incerto
preco(m005,algum,3.94).
preco(m008,reformado,algum).

% Conhecimento imperfeito, do tipo impreciso
% N„o sei o preÁo ao certo mas È este ou aquele
excepcao( preco(m006,normal,2.5) ).
excepcao( preco(m006,normal,2.85) ).
excepcao( preco(m009,normal,P) ) :- P >= 5, P =< 9.
% N„o sei se este preÁo È para o p˙blico ou para sÛcios
excepcao( preco(m004,normal,4.99) ).
excepcao( preco(m004,reformado,4.99) ).

% Conhecimento imperfeito do tipo interdito
preco(m007,reformado,interdito).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado que procura as soluÁıes do conhecimento
solucoes( X,Y,Z ) :-
findall( X,Y,Z ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
Questao, !, fail.
nao( Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado comprimento: Lista,Comprimento -> {V,F}
comprimento( [],0 ).
comprimento( [X|L],N ) :-
comprimento( L,N1 ),
N is N1+1.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado pertence: Elemento,Lista -> {V,F}
pertence( X,[X|L] ).
pertence( X,[Y|L] ) :-
X \== Y,
pertence( X,L ).

