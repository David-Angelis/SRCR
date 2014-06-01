%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%   Universidade do Minho
%   Licenciatura em Engenharia Informatica
%   Sistemas de Representação de Conhecimento e Raciocinio
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
:- op( 500,yfx,'e' ).
:- op( 400,yfx,'ou' ).
:- dynamic '-'/1.
:- dynamic '+'/1.
:- dynamic medicamento/5.
:- dynamic preco/3.
:- dynamic data/3.
:- dynamic tipoFar/2.
:- dynamic excepcao/2.
nulo(interdito).

% ------------ - - -  -  - Excepcao especifica -  -  - - - ------------
-data(IDM,DI,DL) :- nao( data(IDM,DI,DL) ),
nao( excepcao( data(IDM,DI,DL) ) ).

% ---------------- - - -  -  - Invariantes -  -  - - - ----------------
% Garante que ao inserir uma data, existe medicamento na BC
+data(IDM,DI,DL) :: (solucoes( IDM,(medicamento(IDM,_,_,_,_)),L ),
comprimento(L,N), N==1
).

% Garante que so existe um registo de data que contÈm o id do medicamento na BC
+data(IDM,_,_) :: (solucoes( IDM, (data(IDM,_,_)),L ),
comprimento(L,N), N==1
).

% Garante que n„o existe um conhecimento negativo para o que estamos a inserir
+data(IDM,DI,DL) :: (solucoes( IDM,(-data(IDM,DI,DL)),L ),
comprimento(L,N), N=<1
).

% Garante que  não existe um conhecimento positivo para o negativo que estamos a inserir
+(-data(IDM,DI,DL)) :: (solucoes( IDM,(data(IDM,DI,DL)),L ),
comprimento(L,N), N==0
).

% Garante que existe um registo de data que estamos a remover
-data(IDM,DI,DL) :: (solucoes( (IDM,DI,DL),(data(IDM,DI,DL)),L ),
comprimento(L,N), N==1
).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado medicamento: id,principio activo,nome,formato,doença

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

%Conhecimento imperfeito, impreciso
excepcao( medicamento(a010,ambroxol,mucosolvan,xarope,expectoracao) ).
excepcao( medicamento(a011,ambroxol,mucodrenol,xarope,expectoracao) ).

%Conhecimento imperfeito,interdito
medicamento(a012,interdito,memoria,comprimido,memoria).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado data: id,data colocacao,data validade

% Conhecimento perfeito, positivo
data(a001,'01/01/01','01/01/2011').
data(a002,'02/02/02','02/02/2022').

%Conhecimento perfeito, negativo
-data(a003,'03/03/2003','03/04/2003').

%Conhecimento imperfeito, incerto
excepcao( data(a004,'04/04/2004',algum) ).
excepcao( data(a006,algum,'06/06/2016') ).

%Conhecimento imperfeito, impreciso
excepcao( data(a007,'07/07/2007','07/07/2017') ).
excepcao( data(a007,'07/07/2007','08/08/2018') ).

%Conhecimento imperfeito,interdito
data(a008,'08/08/2008',interdito).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado preco: id,tipo,preco
%tipo normal reformado
% Conhecimento perfeito, positivo
preco(a001,normal,5).
preco(a001,reformado,4).
preco(a002,normal,10).
preco(a002,reformado,8).
%Conhecimento perfeito, negativo
-preco(a003,reformado,21).
-preco(a003,normal,25).

%Conhecimento imperfeito, incerto
excepcao( preco(a004,algum,12) ).
excepcao( preco(a005,normal,algum) ).

%Conhecimento imperfeito, impreciso
excepcao( preco(a006,normal,3) ).
excepcao( preco(a006,normal,4) ).
%excepcao( preco(a007,normal,P) ):- P=<15,P >= 10.
%Conhecimento imperfeito,interdito
preco(a009,normal,interdito).

% ---------------- - - -  -  - Invariantes -  -  - - - ----------------
% Garante que n„o existe um conhecimento igual ao que estamos a inserir
+preco(IDM,T,P)::(solucoes( (IDM,T),(preco(IDM,T,_)),L ),
comprimento(L,N), N==1
).

% Garante que para o precovenda existe um medicamento
+preco(IDM,T,P) :: (solucoes( IDM,(medicamento(IDM,_,_,_,_)),L ),
comprimento(L,G), G==1
).

% Garante que os tipos são normal ou reformado.
+preco(IDM,T,P) :: (T == normal; T == reformado).


% Garante que todos os preÁos s„o positivos.
+preco(IDM,T,P) :: P > 0.

% Garante que n„o existe um conhecimento negativo para o que estamos a inserir
+preco(IDM,T,P) :: (solucoes( -preco(IDM,T,_),(-preco(IDM,T,_)),L ),
comprimento(L,N), N=<1
).

% Garante que não existe um conhecimento positivo para o negativo que estamos a inserir
+(-preco(IDM,T,P)) :: (solucoes(IDM,(preco(IDM,T,_)),L ),
comprimento(L,N),  N==0
).

% Garante que o conhecimento que estamos a eliminar existe
-(preco(IDM,T,P)) :- (solucoes( (IDM,T,P),(preco(IDM,T,P)),L ),
comprimento(L,N), N==1
).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado tipoFar: id,tipo de farmacia

% Conhecimento perfeito, positivo
tipoFar(a001,local).
tipoFar(a002,hospital).

%Conhecimento perfeito, negativo
-tipoFar(a003,local).
-tipoFar(a004,hospital).

%Conhecimento imperfeito, incerto
excepcao( tipoFar(a005,algum) ).

%Conhecimento imperfeito, impreciso
excepcao( tipoFar(a006,local) ).
excepcao( tipoFar(a006,hospital) ).

% ---------------- - - -  -  - Invariantes -  -  - - - ----------------
%Garante que nao estamos a inserir duas farmacia por medicamento
+tipoFar(IDM,Tipo) :: (solucoes(IDM, tipoFar(IDM,Tipo), L),
comprimento(L,G), G==1).

% Garante que existe o medicamento
+tipoFar(IDM,Tipo)::(solucoes(IDM,(medicamento(IDM,_,_,_,_)),L ),
comprimento(L,N), N==1).

% ------------ - - -  -  - Excepcao especifica -  -  - - - ------------
-medicamento(ID,N,P,APR,I,APL) :- nao( medicamento(ID,N,P,APR,I,APL) ),
nao( excepcao( medicamento(ID,N,P,APR,I,APL) ) ).

% ---------------- - - -  -  - Invariantes -  -  - - - ----------------

% Garante que nao estamos a inserir um medicamento com ID repetido
+medicamento(ID,P,N,F,D) :: (solucoes(ID, medicamento(ID,_,_,_,_), L),
comprimento(L,G), G==1).

% Garante que n„o existe conhecimento negativo para o positivo que estamos a inserir
+medicamento(ID,P,N,F,D) :: (solucoes(ID, (-medicamento(ID,P,N,F,D)), L),
comprimento(L,G), G=<1
).

% Garante que n„o existe conhecimento positivo para o negativo que estamos a inserir
+(-medicamento(ID,P,N,F,D)) :: (solucoes(ID, (medicamento(ID,P,N,F,D)), L),
comprimentos(L,G), G==0
).

% Garante que se est· a remover um medicamento que existe
-medicamento(ID,P,N,F,D) :: (solucoes(ID,(medicamento(ID,P,N,F,D)), L),
comprimento(L,G), G==0
).

% Extensao do predicado que permite a evolucao do conhecimento
evolucaonormal( Termo ) :-
solucoes( Invariante,(+Termo::Invariante),Lista ),
insercao( Termo ),
teste( Lista ).

% Predicado Medicamento
evolucao( medicamento(ID,P,N,F,D) ) :-
solucoes( (medicamento(ID,P,algum,F,D)),(medicamento(ID,P,algum,F,D)),L1 ),
solucoes( (medicamento(ID,algum,N,F,D)),(medicamento(ID,algum,N,F,D)),L2 ),
solucoes( (medicamento(ID,P,N,algum,D)),(medicamento(ID,P,N,algum,D)),L3 ),
solucoes( (medicamento(ID,P,N,F,algum)),(medicamento(ID,P,N,F,algum)),L4 ),
solucoes( (excepcao(medicamento(ID,P,N,F,D))),(excepcao(medicamento(ID,P,N,F,D))),L5 ),
junta( L1,L2,R1 ), junta( R1,L3,R2 ), junta( R2,L4,R3 ), junta( R3,L5,RF ),
comprimento( RF,G), G>=0,
evolucaonormal( medicamento(ID,P,N,F,D)).

% Predicado Data
evolucao( data(IDM,DI,DL) ) :-
solucoes( (data(IDM,algum,DL)),(data(IDM,algum,DL)),L1 ),
solucoes( (data(IDM,DI,algum)),(data(IDF,DI,algum)),L2 ),
solucoes( (excepcao( data(IDM,DI,DL) )),(excepcao( data(IDM,DI,DL) )),L3 ),
junta( L1,L2,R1 ),junta( R1,L3,RF ),
comprimento( RF,G ), G>=0,
evolucaonormal( data(IDM,DI,DL)).

% Predicado tipoFar
evolucao( tipoFar(IDM,Tipo) ) :-
solucoes((tipoFar(IDM,algum)),(tipoFar(IDM,algum)),L1 ),
solucoes( (excepcao( tipoFar(IDM,Tipo) )),(excepcao( tipoFar(IDM,Tipo))),L2 ),
junta( L1,L2,RF),
comprimento( RF,G ), G>=0,
evolucaonormal(tipoFar(IDM,Tipo)).

% Predicado Preco
evolucao( preco(IDM,T,P) ) :-
solucoes( (preco(IDM,T,algum)),(preco(IDM,T,algum)),L1 ),
solucoes( (preco(IDM,algum,P)),(preco(IDM,algum,P)),L2 ),
solucoes( (excepcao( preco(IDM,T,P) )),(excepcao( preco(IDM,T,P) )),L3 ),
junta( L1,L2,R1 ), junta( R1,L3,RF ),
comprimento( RF,G ), G>=0,
evolucaonormal( preco(IDM,T,P) ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do meta-predicado demo: Questao,Resposta -> {V,F}

demo( (A e B), falso ) :- demo( A, falso ), demo( B, falso ).
demo( (A e B), falso ) :- demo( A, falso ), demo( B, algum ).
demo( (A e B), falso ) :- demo( A, falso ), demo( B, verdadeiro ).
demo( (A e B), falso ) :- demo( A, algum ), demo( B, falso ).
demo( (A e B), desconhecido ) :- demo( A, algum ), demo( B, algum ).
demo( (A e B), desconhecido ) :- demo( A, algum ), demo( B, verdadeiro ).
demo( (A e B), falso ) :- demo( A, verdadeiro ), demo( B, falso ).
demo( (A e B), desconhecido ) :- demo( A, verdadeiro ), demo( B, algum ).
demo( (A e B), verdadeiro ) :- demo( A, verdadeiro ), demo( B, verdadeiro ).

demo( (A ou B), falso ) :- demo( A, falso ), demo( B, falso ).
demo( (A ou B), desconhecido ) :- demo( A, falso ), demo( B, algum ).
demo( (A ou B), verdadeiro ) :- demo( A, falso ), demo( B, verdadeiro ).
demo( (A ou B), desconhecido ) :- demo( A, algum ), demo( B, falso ).
demo( (A ou B), desconhecido ) :- demo( A, algum ), demo( B, algum ).
demo( (A ou B), verdadeiro ) :- demo( A, algum ), demo( B, verdadeiro ).
demo( (A ou B), verdadeiro ) :- demo( A, verdadeiro ), demo( B, falso ).
demo( (A ou B), verdadeiro ) :- demo( A, verdadeiro ), demo( B, algum ).
demo( (A ou B), verdadeiro ) :- demo( A, verdadeiro ), demo( B, verdadeiro ).
demo(A,verdadeiro) :- A.
demo(A,falso) :- -A.
demo(A,desconhecido) :- nao(A), nao(-A).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado que permite o retrocesso do conhecimento
retrocesso( Termo ) :-
solucoes( Invariante,(-Termo::Invariante),Lista ),
(remocao( Termo ); removedesconhecido( Termo)),
teste( Lista ).

removedesconhecido( medicamento(ID,N,P,F,Do) ) :-
retract( medicamento(ID,A,B,C,D) ),
(A == P ; A == algum),
(B == N ; B == algum),
(C == F ; C == algum),
(D == Do ; D == algum),
(A == algum ; B == algum ;
C == algum ; D == algum).


removedesconhecido( preco(IDM,T,P) ) :-
retract( preco(IDM,A,B) ),
(A == T ; A == algum),
(B == P ; B == algum),
(A == algum ; B == algum).

removedesconhecido( data(IDM,DI,DL) ) :-
retract(data(IDM, A, B)),
(A == DI ; A == algum),
(B == DL ; B == algum),
(A == algum ; B == algum).

removedesconhecido(tipoFar(IDM,T) ) :-
retract(tipoFar(IDM,A)),(A ==T ; A == algum),(A==algum).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Extens„o do predicado que permite a remocao do conhecimento
remocao( Termo ) :-
retract( Termo ).
remocao( Termo ) :-
retract( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado que permite a insercao do conhecimento
insercao( Termo ) :-assert( Termo ).
insercao( Termo ) :-
retract( Termo ),!,fail.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado que permite o teste do conhecimento
teste( [] ).
teste( [R|LR] ) :-
R,
teste( LR ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado que procura as soluÁıes do conhecimento
solucoes( X,Y,Z ) :-
findall( X,Y,Z ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
Questao, !, fail.
nao( Questao ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado comprimento: Lista,Comprimento -> {V,F}
comprimento( [],0 ).
comprimento( [X|L],N ) :-
comprimento( L,N1 ),
N is N1+1.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado pertence: Elemento,Lista -> {V,F}
pertence( X,[X|L] ).
pertence( X,[Y|L] ) :-
X \== Y,
pertence( X,L ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extens„o do predicado que junta listas
junta([],La,La).
junta([X|C], La, [X|L]) :- junta(C,La,L).

