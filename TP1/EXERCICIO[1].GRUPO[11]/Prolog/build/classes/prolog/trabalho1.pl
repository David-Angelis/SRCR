%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                 %
%   Universidade do Minho                                         %
%   Licenciatura em Engenharia Informática                        %
%   Sistemas de Representação de Conhecimento e Raciocínio        %
%                                                                 %
%   Grupo 11:                                                     %
%                       										  %
%                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Nodo:Nome,X,Y,Producao,Consumo -> {V,F}
 %Casas
 nodo(a,3,2,0,2).
 nodo(b,1,5,0,3).
 nodo(c,10,8,0,5).

%Centrais
 nodo(d,2,10,7,0).
 nodo(e,7,4,5,0).

 %Predios
 nodo(f,5,6,1,4).
 nodo(g,6,1,2,3).


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Arco:Nodo,Nodo -> {V,F}


arco(nodo(a,3,2,0,2),nodo(b,1,5,0,3)).
arco(nodo(b,1,5,0,3),nodo(d,2,10,7,0)).
arco(nodo(d,2,10,7,0),nodo(f,5,6,1,4)).
arco(nodo(f,5,6,1,4),nodo(c,10,8,0,5)).
arco(nodo(c,10,8,0,5),nodo(e,7,4,5,0)).
arco(nodo(e,7,4,5,0),nodo(g,6,1,2,3)).
arco(nodo(g,6,1,2,3),nodo(a,3,2,0,2)).
arco(nodo(a,3,2,0,2),nodo(f,5,6,1,4)).
arco(nodo(f,5,6,1,4),nodo(e,7,4,5,0)).

% Extensao do predicado Connected:Nodo,Nodo -> {V,F}
connected(X,Y) :- arco(X,Y).
connected(X,Y) :- arco(Y,X).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Distancia:Nodo,Nodo,D -> {V,F}
distancia(nodo(N,X,Y,P,C),nodo(N2,X2,Y2,P2,C2),D):-D is sqrt(exp((X2-X),2)+(exp((Y2-Y),2))).
%distancia(nodo(N,X,Y,P,C),nodo(N2,X2,Y2,P2,C2),D):-distancia(nodo(N2,X2,Y2,P2,C2),nodo(N,X,Y,P,C),D).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Casa:Nodo-> {V,F}
casa(nodo(N,X,Y,P,C)):-P==0,C>0.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Predio:Nodo-> {V,F}
predio(nodo(N,X,Y,P,C)):-P>0,C>0.
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Central:Nodo-> {V,F}
central(nodo(N,X,Y,P,C)):-P>0,C==0.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Regiao:Coordenadas,Coordenadas,Coordenadas,Coordenadas,Nodo-> {V,F}

regiao((X0,Y0),(X1,Y1),(X2,Y2),(X3,Y3),nodo(N,X,Y,P,C)):- nodo(N,X,Y,P,C),X>=X0,Y=<Y0,X=<X1,Y=<Y1,X=<X2,Y>=Y2,X>=X3,Y>=Y3.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado EncontraPontosRegiao:Coordenadas,Coordenadas,Coordenadas,Coordenadas,[Nodos]-> {V,F}
encontrapontosregiao((X0,Y0),(X1,Y1),(X2,Y2),(X3,Y3),S):-findall(nodo(N,X,Y,P,C),regiao((X0,Y0),(X1,Y1),(X2,Y2),(X3,Y3),nodo(N,X,Y,P,C)),S).
%--------------------------------- - - - - - - - - - -  -  -  -  -   

% Extensao do predicado DistPontos:[nodos],nodoI,R -> {V,F}
%distpontos([],_Last,0).
%distpontos([nodo(N,X,Y,P,C)],nodo(N1,X1,Y1,P1,C1),R):-distancia(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),D),R is D.
%distpontos([nodo(N,X,Y,P,C)|T],nodo(N1,X1,Y1,P1,C1),R):-distancia(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),D),distpontos(T,nodo(N,X,Y,P,C),R1),R is R1+D.
distpontos([nodo(N,X,Y,P,C)],0).
distpontos([nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1)|T],R):-distancia(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),D),distpontos([nodo(N1,X1,Y1,P1,C1)|T],R1),R is R1+D.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado concatenar: Lista1,Lista2,Resultado -> {V,F}

concatenar( [],L2,L2 ).
concatenar( [X|R],L2,[X|L] ) :-
concatenar( R,L2,L ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado inverter: Lista,Resultado -> {V,F}

inverter( [],[] ).
inverter( [X|R],NL ) :-
inverter( R,L ),
concatenar( L,[X],NL ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado Path: nodo,nodo,[nodo] -> {V,F}

path(A,B,Path):-
travel(A,B,[A],Q),
inverter(Q,Path).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do predicado travel:nodo,nodo,[nodoVisitado][nodo] -> {V,F}
 travel(A,B,P,[B|P]) :-connected(A,B).
travel(A,B,Visited,Path) :-connected(A,C),C \== B,\+member(C,Visited),travel(C,B,[C|Visited],Path).

%----------------------------------- - - -  - - - - - - -  - - -  -  - - -
% Extensao do predicado caminhos:nodo,nodo,[Caminho],Custo -> {V,F}
caminhos(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),Caminho,Custo):-path(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),Caminho),distpontos(Caminho,S), Custo is S.

min([(X,Y)],X,Y).
min([(X,Y),(X1,Y1)|T],L,C):-Y =< Y1, min([(X,Y)|T],L,C).
min([(X,Y),(X1,Y1)|T],L,C):-Y > Y1, min([(X1,Y1)|T],L,C).

%----------------------------------- - - -  - - - - - - -  - - -  -  - - -
% Extensao do predicado cmc:nodo,nodo,[Caminho],Custo -> {V,F}
cmc(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),CamFinal,CustMin):-findall((Caminho,Custo),caminhos(nodo(N,X,Y,P,C),nodo(N1,X1,Y1,P1,C1),Caminho,Custo),S),min(S,CamFinal,CustMin).






