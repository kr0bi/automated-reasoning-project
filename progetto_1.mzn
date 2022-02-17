% Codifica del progetto del percorso minimo di
% Daniele Ferroli 137357

int: free = 0;
int: wall = 1;
int: ingresso = 2;
int: uscita = 3;

% par int: n = 6;
par int: n;

set of int: tipo = {free, wall, ingresso, uscita};

array[1..n, 1..n] of tipo: edificio;

% edificio = [| 2, 0, 0, 0, 0, 1,
%             | 0, 0, 0, 1, 0, 0,
%             | 1, 0, 0, 1, 1, 0,
%             | 1, 0, 0, 1, 0, 0,
%             | 1, 0, 0, 1, 0, 1,
%             | 1, 0, 1, 1, 0, 3|];
            
% edificio = [| 0, 0, 0, 1, 0, 0,
%            | 0, 0, 0, 1, 0, 0,
%            | 1, 0, 0, 0, 0, 0,
%            | 1, 0, 0, 1, 0, 0,
%            | 1, 0, 0, 1, 0, 1,
%            | 2, 0, 1, 1, 0, 3|];
            
array[1..1, 1..2] of int: input_door;
% input_door = [|n,n-1|];

array[1..1, 1..2] of int: output_door;            
% output_door = [|n,1|];

int: malus = n * n;
set of int: tipo_percorso = {0, 1, malus};
array[1..n, 1..n] of var tipo_percorso: path;

constraint path[input_door[1,1],input_door[1,2]] = 1;
constraint path[output_door[1,1],output_door[1,2]] = 1;

constraint forall(i, j in 1..n) (edificio[i,j] = wall -> (path[i,j] = 0 \/ path[i,j] = malus));

predicate possible_adjacent_moves (int: i, int: j) =
  ((path[i,j] = 1 \/ path[i,j] = malus) ->
    mossa(i,j)
    );

predicate mossa (int: i, int: j) =
  if (input_door[1,1] = i /\ input_door[1,2] = j) \/
     (output_door[1,1] = i /\ output_door[1,2] = j)
     
  then check_mossa(i-1,j) xor check_mossa(i,j-1) xor check_mossa(i+1,j) xor check_mossa(i,j+1)
  
  else (check_mossa(i-1,j) /\ check_mossa(i,j-1)) \/ 
       (check_mossa(i-1,j) /\ check_mossa(i,j+1)) \/
       (check_mossa(i-1,j) /\ check_mossa(i+1,j)) \/
       
       (check_mossa(i,j-1) /\ check_mossa(i,j+1)) \/
       (check_mossa(i,j-1) /\ check_mossa(i+1,j)) \/ 
       
       (check_mossa(i+1,j) /\ check_mossa(i, j+1))
  endif;
  
predicate check_mossa(int: i, int: j) = 
  i >= 1 /\ i <= n /\ j >= 1 /\ j <= n /\ (path[i,j] = 1 \/ path[i,j] = malus);
    
            
constraint forall(i, j in 1..n) (possible_adjacent_moves(i,j));

output 
  ["edificio"] ++ 
  [if j = 1 then "\n" else " " endif 
  ++
  show(edificio[i,j]) ++ "  " 
  | i, j in 1..n
] ++ ["\n\n"];

var int: p = sum (i,j in 1..n)(path[i,j]);

solve minimize p;

output 
  ["route"] ++
  [if j = 1 then "\n" else "\t" endif 
  ++
  show(path[i,j]) ++ "  " 
  | i, j in 1..n
] ++ ["\n\n" ++ "cost: " ++ show(p)];