n. 
size(1..n).

value(0; 1; n*n;).
% malus(n*n).

% input_door(X, Y) :- ix(X), iy(Y).
% output_door(X, Y) :- ox(X), oy(Y).

1 {path(X, Y, V) : value(V) } 1 :- size(X), size(Y).
1 {path(X, Y, 0); path(X, Y, (n*n)) } 1 :- edificio(X, Y, 1).

:- path(X, Y, C), X < 1.
:- path(X, Y, C), Y < 1.
:- path(X, Y, C), X > n.
:- path(X, Y, C), Y > n.

path(X, Y, 1) :- edificio(X,Y,2).
path(X, Y, 1) :- edificio(X,Y,3).

% constraint per avere un'unica cella fuori dall'ingresso
1 {path(X-1, Y, (1;(n*n))); 
   path(X, Y-1, (1;(n*n))); 
   path(X+1, Y, (1;(n*n))); 
   path(X, Y+1, (1;(n*n))) } 1 :- path(X, Y, 1), edificio(X,Y,2), X >= 1, X <= n, Y >= 1, Y <= n .

% constraint per avere un'unica cella fuori dall'uscita
1 {path(X-1, Y, (1;(n*n))); 
   path(X, Y-1, (1;(n*n))); 
   path(X+1, Y, (1;(n*n))); 
   path(X, Y+1, (1;(n*n))) } 1 :- path(X,Y, 1), edificio(X,Y,3), X >= 1, X <= n, Y >= 1, Y <= n .

2 {
    path(X-1, Y,   (1;(n*n))); 
    path(X,   Y-1, (1;(n*n)));
    path(X,   Y+1, (1;(n*n)));
    path(X+1, Y,   (1;(n*n)))
    } 2 :- path(X,Y, 1), edificio(X, Y, 0), X >= 1, X <= n, Y >= 1, Y <= n .

2 {
    path(X-1, Y,   (1;(n*n))); 
    path(X,   Y-1, (1;(n*n)));
    path(X,   Y+1, (1;(n*n)));
    path(X+1, Y,   (1;(n*n)))
    } 2 :- path(X,Y, (n*n)), edificio(X, Y, 1), X >= 1, X <= n, Y >= 1, Y <= n .

#minimize {C, Y, X : size(X), path(X,Y,C)}.
#show path/3.