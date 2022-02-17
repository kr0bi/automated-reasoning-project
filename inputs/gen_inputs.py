import sys
import random
import numpy as np

# possible_dimensions = [5]
possible_dimensions = [5, 10, 10, 20, 20, 30, 50, 50, 80, 80, 100, 100]
 
for count, dimension in enumerate(possible_dimensions):
    namefile = "input_" + str(dimension) + "_" + str(count) + ".dzn"
    with open(namefile, "w+") as f:
        sys.stdout = f

        matrix = np.zeros((dimension, dimension), dtype = int)
        ix = random.randint(0, dimension-1)
        iy = random.randint(0, dimension-1)

        jx = random.randint(0, dimension-1)
        jy = random.randint(0, dimension-1)
        
        while jx == ix and jy == iy:
            jx = random.randint(0, dimension-1)
            jy = random.randint(0, dimension-1)

        matrix[ix, iy] = 2
        matrix[jx, jy] = 3


        # input_door = [|n,n-1|];
        print("input_door = [|", ix+1, ",", iy+1, "|];")
        print("output_door = [|", jx+1, ",", jy+1, "|];")

        for i in range(dimension):
            for j in range(dimension):
                if matrix[i,j] == 2 or matrix[i,j] == 3:
                    pass
                elif random.random() < 0.45:
                    matrix[i,j] = random.randint(0,1)
        

        s = "["
        for i in range(matrix.shape[0]):
            for j in range(matrix.shape[1]):
                if j == 0:
                    s = s + "| " +  str(matrix[i,j]) + ", "
                elif j == dimension - 1 and i == dimension - 1:
                    s = s + str(matrix[i,j]) + " |"
                elif j == dimension-1: 
                    s = s + str(matrix[i,j]) + ", \n"
                else:
                    s = s + str(matrix[i,j]) + ", "
        s = s + "];"

        print("n = ", dimension, ";", sep="")
        print("edificio = \n", s, sep="")