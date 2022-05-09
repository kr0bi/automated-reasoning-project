from cmath import inf
import os
from unicodedata import name
from math import inf

# clingo -c n=10 --outf=1 inputs/input_10_1.lp progetto_1.lp > output.txt.lp || python3 script_lp.py 10
# minizinc --solver Chuffed -f --time-limit 300000 progetto_1.mzn inputs/input_10_1.dzn

# possible_dimensions = [5]
# possible_dimensions = [35]
# possible_dimensions = [5, 10, 10, 20, 20, 30, 50]
# possible_dimensions = [5, 10, 10, 15, 15, 20, 20, 25, 30]
possible_dimensions = [5, 10, 10, 15, 15, 20, 20, 25, 30, 50, 80, 100]
# possible_dimensions = [50, 80, 100]
# possible_dimensions = [100]
# possible_dimensions = [5, 10, 10, 20, 20, 30, 50, 50, 80, 80, 100, 100]

output_lp = "output.lp.txt"
output_mzn = "output.mzn.txt"

outputs = [output_lp, output_mzn]

# inputs_name_file = ["inputs_generici", "inputs_tutto_pieno", "inputs_tutto_vuoto", "inputs_zig_zag"]
# inputs_name_file = ["inputs_generici"]
inputs_name_file = ["inputs_tutto_pieno", "inputs_tutto_vuoto", "inputs_zig_zag"] 

print("start computating:")

for input_name_file in inputs_name_file:
    for count, n in enumerate(possible_dimensions):
        # count = count + 11
        namefile = input_name_file + "/" + "input_" + str(n) + "_" + str(count)
        outputfile = "inputs/" + input_name_file + "/" + "output.txt"

        namefile_dzn = namefile + ".dzn"
        namefile_lp = namefile + ".lp"

        str_lp = (f"clingo -c n={n} --outf=1 --time-limit=300 inputs/{namefile_lp} progetto_1.lp > output.txt.lp || python3 script_lp.py {n}")

        str_dzn = (f"minizinc --solver Chuffed -f --time-limit 300000 --output-time progetto_1.mzn inputs/{namefile_dzn}")

        os.system(str_lp + " > " + output_lp)
        os.system(str_dzn + " > " + output_mzn)

        values = []
        pavimenti = []
        muri = []
        times = []
        for output in outputs:
            file1 = open(output, 'r').readlines()
            try:
                values.append(file1[0])
                pavimenti.append(file1[1])
                muri.append(file1[2])
                times.append(file1[3])
            except IndexError:
                print("index out of bounds, probably unknown minizinc")
                values[1] = "cost: " + str(inf) + "\n"
                pavimenti[1] = "pavimento: " + str(inf) + "\n"
                muri.append("muri: " + str(inf) + "\n")
                times.append(file1[1])

        
        if values[0] == values[1] and pavimenti[0] == pavimenti[1] and muri[0] == muri[1]:
            message = str(n) + "_" + str(count) + "\n"
            message = message + f"Ok, {values[0]}ASP: {times[0]}MZN: {times[1]}"
            message = message + f"{pavimenti[0]}"
            message = message + f"{muri[0]}"
            print(message)
            with open(outputfile, 'a+') as f:
                print(message, file=f)
        elif values[0] == values[1] and pavimenti[0] == pavimenti[1]:
            message = str(n) + "_" + str(count) + "\n"
            message = message + f"Ok ma numero di muri differente, {values[0]}ASP: {times[0]}MZN: {times[1]}"
            message = message + f"{pavimenti[0]}"
            message = message + f"{muri[0]},{muri[1]}"
            print(message)
            with open(outputfile, 'a+') as f:
                print(message, file=f)    
        elif values[0] == values[1] and muri[0] == muri[1]:
            message = str(n) + "_" + str(count) + "\n"
            message = message + f"Ok ma numero di pavimenti differente, {values[0]}ASP: {times[0]}MZN: {times[1]}"
            message = message + f"{pavimenti[0]},{pavimenti[1]}"
            message = message + f"{muri[0]}"
            print(message)
            with open(outputfile, 'a+') as f:
                print(message, file=f) 
        elif values[0] == values[1]:
            message = str(n) + "_" + str(count) + "\n"
            message = message + f"Ok ma sequenza differente, {values[0]}ASP: {times[0]}MZN: {times[1]}"
            message = message + f"{pavimenti[0]},{pavimenti[1]}"
            message = message + f"{muri[0]},{muri[1]}"
            print(message)
            with open(outputfile, 'a+') as f:
                print(message, file=f)                
        else:
            message = str(n) + "_" + str(count) + "\n"
            message = message + f"Not equal, {values[0]} \t {values[1]}ASP: {times[0]} MZN: {times[1]}"
            message = message + f"{pavimenti[0]},{pavimenti[1]}"
            message = message + f"{muri[0]},{muri[1]}"
            print(message)
            with open(outputfile, 'a+') as f:
                print(message, file=f)
            

        