% Use this editor as a MiniZinc scratch book

int: free = 0;
int: wall = 1;
int: ingresso = 2;
int: uscita = 3;

par int: n = 6;

set of int: tipo = {free, wall, ingresso, uscita};

array[1..n, 1..n] of var tipo: edificio;

constraint edificio = 
            [| 2, 0, 0, 0, 0, 1,
            | 0, 0, 0, 1, 0, 0,
            | 1, 0, 0, 1, 1, 0,
            | 1, 0, 0, 0, 0, 0,
            | 1, 0, 0, 0, 1, 1,
            | 1, 0, 1, 1, 0, 3|];

int: malus = n * n;
set of int: tipo_percorso = {0, 1, malus};
array[1..n, 1..n] of var tipo_percorso: path;

constraint path[1,1] = 1;
constraint path[n,n] = 1;

constraint forall(i, j in 1..n) (edificio[i,j] = wall -> (path[i,j] = 0 \/ path[i,j] = malus));

predicate possible_adjacent_moves (int: i, int: j) =
  ((path[i,j] = 1 \/ path[i,j] = malus) ->
    if i = n /\ j = 1 then (path[i-1,j] + path[i,j+1] = 2) \/ (path[i-1, j] + path[i,j+1] = 1 + malus) \/ (path[i-1, j] + path[i,j+1] = 2*malus)
    elseif i = n /\ j = n then (path[i-1,j] + path[i,j-1] = 1) \/ (path[i-1, j] + path[i,j-1] = malus)
    elseif i = 1 /\ j = 1 then (path[i+1,j] + path[i,j+1] = 1) \/ (path[i+1, j] + path[i,j+1] = malus)
    elseif i = 1 /\ j = n then (path[i+1,j] + path[i,j-1] = 2) \/ (path[i+1, j] + path[i,j-1] = 1 + malus) \/ (path[i+1,j] + path[i,j-1] = 2*malus)
    elseif i = 1 then (path[i,j-1] + path[i+1,j] + path[i,j+1] = 2)  \/ 
                      (path[i,j-1] + path[i+1,j] + path[i,j+1] = 1 + malus) \/ 
                      (path[i,j-1] + path[i+1,j] + path[i,j+1] = 2*malus)
    elseif j = 1 then (path[i-1,j] + path[i+1,j] + path[i,j+1] = 2) \/
                      (path[i-1,j] + path[i+1,j] + path[i,j+1] = 1 + malus) \/ 
                      (path[i-1,j] + path[i+1,j] + path[i,j+1] = 2*malus)
    elseif i = n then (path[i,j-1] + path[i-1,j] + path[i,j+1] = 2) \/
                      (path[i,j-1] + path[i-1,j] + path[i,j+1] = 1 + malus) \/
                      (path[i,j-1] + path[i-1,j] + path[i,j+1] = 2*malus) 
    elseif j = n then (path[i,j-1] + path[i-1,j] + path[i+1,j] = 2) \/
                      (path[i,j-1] + path[i-1,j] + path[i+1,j] = 1 + malus) \/
                      (path[i,j-1] + path[i-1,j] + path[i+1,j] = 2*malus)
    else (path[i-1,j] + path[i,j-1] + path[i+1,j] + path[i,j+1] = 2) \/
         (path[i-1,j] + path[i,j-1] + path[i+1,j] + path[i,j+1] = 1 + malus) \/
         (path[i-1,j] + path[i,j-1] + path[i+1,j] + path[i,j+1] = 2*malus) 
    endif );
    
constraint forall(i, j in 1..n ) (possible_adjacent_moves(i,j));

% output 
%   [if j = 1 then "\n" else " " endif 
%   ++
%   show(edificio[i,j]) ++ "  " 
%   | i, j in 1..n
% ] ++ ["\n"];

var int: p = sum (i,j in 1..n)(path[i,j]);

solve minimize p;

% constraint edificio[4,4] = wall;
% constraint edificio[5,4] = wall;

output 
  [if j = 1 then "\n" else "\t" endif 
  ++
  show(path[i,j]) ++ "  " 
  | i, j in 1..n
] ++ ["\n\n" ++ "cost: " ++ show(p)];