n. 
size(1..n).
notMuri (0;2;3).

value(0; 1; n*n;).

1 {path(X, Y, V) : value(V) } 1 :- size(X), size(Y).
% 1 {path(X, Y, 0); path(X, Y, (n*n)) } 1 :- edificio(X, Y, 1).

:- edificio(X,Y,0), path(X,Y,(n*n)), size(X), size(Y).
:- edificio(X,Y,1), path(X,Y,1), size(X), size(Y).

:- path(X, Y, C), X < 1.
:- path(X, Y, C), Y < 1.
:- path(X, Y, C), X > n.
:- path(X, Y, C), Y > n.

% imposto la matrice path ad avere preso l'ingresso e l'uscita
path(X, Y, 1) :- edificio(X,Y,2), size(X), size(Y).
path(X, Y, 1) :- edificio(X,Y,3), size(X), size(Y).

% constraint per avere un'unica cella fuori dall'ingresso
1 {path(X-1, Y, (1;(n*n))); 
   path(X, Y-1, (1;(n*n))); 
   path(X+1, Y, (1;(n*n))); 
   path(X, Y+1, (1;(n*n)))} 1 :- path(X, Y, (1;(n*n))), edificio(X,Y,2), size(X), size(Y) .

% constraint per avere un'unica cella fuori dall'uscita
1 {path(X-1, Y, (1;(n*n))); 
   path(X, Y-1, (1;(n*n))); 
   path(X+1, Y, (1;(n*n))); 
   path(X, Y+1, (1;(n*n)))} 1 :- path(X, Y, (1;(n*n))), edificio(X,Y,3), size(X), size(Y) .

% constraint quando abbiamo una cella generica che non e' l'uscita ne' l'ingresso

2 {
    path(X-1, Y, (1;(n*n)));
    path(X, Y-1, (1;(n*n)));
    path(X+1, Y, (1;(n*n)));
    path(X, Y+1, (1;(n*n))) } 2 :- path(X, Y, (1;(n*n))), edificio(X, Y, (0;1)), size(X), size(Y) .

numberOfMuri(N) :- N = #count {Y,X : path(X,Y,(n*n)), edificio(X,Y,1), size(X), size(Y)}.
numberOfPavimento(N) :- N = #count {Y,X : path(X,Y,1), edificio(X,Y,C), size(X), size(Y), notMuri(C)}.

#minimize {C,Y,X : size(X), size(Y), path(X,Y,C)}.
% #minimize {N: numberOfMuri(N)}.
% #maximize {N: numberOfPavimento(N)}.

#show path/3.
#show numberOfMuri/1.
#show numberOfPavimento/1.