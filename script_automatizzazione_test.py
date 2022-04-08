import os
from unicodedata import name

# clingo -c n=10 --outf=1 inputs/input_10_1.lp progetto_1.lp > output.txt.lp || python3 script_lp.py 10
# minizinc --solver Chuffed -f --time-limit 300000 progetto_1.mzn inputs/input_10_1.dzn

# possible_dimensions = [5]
possible_dimensions = [5, 10, 10, 20, 20, 30, 50]
# possible_dimensions = [5, 10, 10, 20, 20, 30, 50, 50, 80, 80, 100, 100]

output_lp = "output.lp.txt"
output_mzn = "output.mzn.txt"

outputs = [output_lp, output_mzn]

for count, n in enumerate(possible_dimensions):
    namefile = "input_" + str(n) + "_" + str(count)

    namefile_dzn = namefile + ".dzn"
    namefile_lp = namefile + ".lp"

    str_lp = (f"clingo -c n={n} --outf=1 --time-limit=300 inputs/{namefile_lp} progetto_1.lp > output.txt.lp || python3 script_lp.py {n}")

    str_dzn = (f"minizinc --solver Chuffed -f --time-limit 300000 --output-time progetto_1.mzn inputs/{namefile_dzn}")

    os.system(str_lp + " > " + output_lp)
    os.system(str_dzn + " > " + output_mzn)

    values = []
    times = []
    for output in outputs:
        file1 = open(output, 'r').readlines()
        values.append(file1[0])
        times.append(file1[1])
    
    if values[0] == values[1]:
        print(f"Ok, {values[0]} ASP: {times[0]} MZN: {times[1]}")
    else:
        print(f"Not equal, {values[0]} \t {values[1]}, times: {times[0]}, {times[1]}")

        