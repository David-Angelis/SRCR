
% Garante que nao existe conhecimento negativo para o positivo que estamos a inserir
+medicamento(ID,P,N,F,D) :: (solucoes(ID, (-medicamento(ID,P,N,F,D)), L),
comprimento(L,N), N==0
).

% Garante que nao existe conhecimento positivo para o negativo que estamos a inserir
+(-medicamento(ID,P,N,F,D)) :: (solucoes(ID, (medicamento(ID,P,N,F,D)), L),
comprimento(L,N), N==0
).

% Garante que se está remover um medicamento que existe
-medicamento(ID,P,N,F,D) :: (solucoes(ID,(medicamento(ID,P,N,F,D)), L),
comprimento(L,N), N==1
).