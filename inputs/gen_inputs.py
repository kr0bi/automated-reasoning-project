import sys
import random
import numpy as np

# possible_dimensions = [5]
possible_dimensions = [5, 10, 10, 20, 20, 30, 50, 50, 80, 80, 100, 100]
 
if len(sys.argv) != 2:
    raise Exception("chiama con 1 parametro aggiuntivo tra: 0, 1 o 2")

def crea_matrix(dimension):
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

    for i in range(dimension):
        for j in range(dimension):
            if matrix[i,j] == 2 or matrix[i,j] == 3:
                pass
            elif random.random() < 0.45:
                matrix[i,j] = random.randint(0,1)
    
    return matrix, ix, iy, jx, jy


def funz():
    for count, dimension in enumerate(possible_dimensions):
        namefile = []
        if sys.argv[1] == '0':
            namefile.append("input_" + str(dimension) + "_" + str(count) + ".dzn")
        elif sys.argv[1] == '1':
            namefile.append("input_" + str(dimension) + "_" + str(count) + ".lp")
        elif sys.argv[1] == '2': 
            namefile.append("input_" + str(dimension) + "_" + str(count) + ".dzn")
            namefile.append("input_" + str(dimension) + "_" + str(count) + ".lp")
        else :
            raise Exception("Parametri supportati 0,1 e 2")

        matrix, ix, iy, jx, jy = crea_matrix(dimension)
        for name in namefile:
            with open(name, "w+") as f:
                sys.stdout = f

                if name[-3:] == "dzn":
                    print("input_door = [|", ix+1, ",", iy+1, "|];")
                    print("output_door = [|", jx+1, ",", jy+1, "|];")

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
                
                elif name[-2:] == "lp":
                    for i in range(matrix.shape[0]):
                        for j in range(matrix.shape[1]):
                            print("edificio(", i+1, ",", j+1, ",", matrix[i,j], ").")

funz()