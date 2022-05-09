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
     
  then bool2int(check_mossa(i-1,j)) + bool2int(check_mossa(i,j-1)) + bool2int(check_mossa(i+1,j)) + bool2int(check_mossa(i,j+1)) = 1
  
  else (bool2int((check_mossa(i-1,j) /\ check_mossa(i,j-1))) +   
       bool2int(check_mossa(i-1,j) /\ check_mossa(i,j+1)) +
       bool2int(check_mossa(i-1,j) /\ check_mossa(i+1,j)) +
       
       bool2int(check_mossa(i,j-1) /\ check_mossa(i,j+1)) +
       bool2int(check_mossa(i,j-1) /\ check_mossa(i+1,j)) + 
       
       bool2int(check_mossa(i+1,j) /\ check_mossa(i, j+1))) = 1
  endif;
  
predicate check_mossa(int: i, int: j) = 
  i >= 1 /\ i <= n /\ j >= 1 /\ j <= n /\ (path[i,j] = 1 \/ path[i,j] = malus);
            
constraint forall(i, j in 1..n) (possible_adjacent_moves(i,j));
   
   
         
% constraint is_reachable(input_door[1,1], input_door[1,2], output_door[1,1], output_door[1,2], 0);
      
% predicate is_reachable (int: i, int: j, int: i_1, int: j_1, int: current_costo) =
% if i > 0 /\ j > 0 /\ i <= n /\ j <= n 
%   /\ (path[i,j] = 1 \/ path[i,j] = malus) /\ 
%   current_costo < malus
% then
%   if is_adiacente(i, j, i_1, j_1) 
%   then true
%   else
%       ((i+1 <= n /\ is_reachable(i+1, j, i_1, j_1, current_costo + 1)) xor 
%        (j+1 <= n /\ is_reachable(i, j+1, i_1, j_1, current_costo + 1)) xor 
%        (i-1 >= 1 /\ is_reachable(i-1, j, i_1, j_1, current_costo + 1)) xor
%        (j-1 >= 1 /\ is_reachable(i, j-1, i_1, j_1, current_costo + 1)))
%   endif
% else
%   false
% endif;
 
% predicate is_adiacente (int: i, int: j, int: i_1, int: j_1) =
%   if ((abs(i - i_1) = 1 /\ abs(j - j_1) = 0) \/ 
%      (abs(i - i_1) = 0 /\ abs(j - j_1) = 1))
%   then true
%   else false
%   endif;
 
% manca un constraint per dire che ci deve essere un percorso dall'inizio alla fine 
 
% output 
%   ["edificio"] ++ 
%   [if j = 1 then "\n" else " " endif 
%   ++
%   show(edificio[i,j]) ++ "  " 
%   | i, j in 1..n
% ] ++ ["\n\n"];

var int: p = sum (i,j in 1..n)(path[i,j]);

var int: numero_muri = count (i,j in 1..n)(path[i,j] == malus /\ edificio[i,j] == 1);
var int: numero_blocchetti = count (i,j in 1..n)(path[i,j] == 1 /\ (edificio[i,j] == 0 \/ edificio[i,j] == 2 \/ edificio[i,j] == 3));

solve :: int_search(path, 
%  input_order, 
%  first_fail,
%  smallest,
 most_constrained,
%  dom_w_deg,

 indomain_min, 
%  indomain_median,
% indomain_random,
% indomain_split,
 
 complete) ::
 
%  restart_constant(50)
%  restart_linear(100)
%   restart_geometric(1.5,n*n)
 restart_luby(42)
%   restart_none
 
 minimize p;

output 
%   ["route"] ++
%   [if j = 1 then "\n" else " " endif 
%   ++
%   show(path[i,j]) ++ "  " 
%   | i, j in 1..n
% ] ++ ["\n\n" ] ++
[
"cost: " ++ show(p) ++ "\n" ++
"pavimento: " ++ show(numero_blocchetti) ++ "\n" ++
"muri: " ++ show(numero_muri)
]
;