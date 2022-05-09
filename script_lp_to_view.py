from unittest import skip
from parse import parse
import numpy as np
import sys

# n = 5
n = int(sys.argv[1])

a = np.zeros((n,n), dtype=int)

file1 = open('/Users/daniele/Dev/automated-reasoning-project/output.txt.lp', 'r')
lines = file1.readlines()

assigns = []
times = ""
cost = 0
for line in lines:
    if line.startswith("% Time"):
        times = line
    elif line.startswith("COST"):
        cost = int(line[5:])
    elif line.startswith("%") or line.startswith("ANSWER"):
        skip
    else:
        assigns.append(line)

assigns = assigns[0].split(" ")
assigns[len(assigns)-1] = assigns[len(assigns)-1][:-1]

paths = []
pavimento = 0
muro = 0

for i, _ in enumerate(assigns):
    if (assigns[i].startswith("path")):
        paths.append(parse("path({},{},{}).", assigns[i]).fixed)
    elif (assigns[i].startswith("numberOfMuri")):
        muro = int(parse("numberOfMuri({}).", assigns[i]).fixed[0])
    else:
        pavimento = int(parse("numberOfPavimento({}).", assigns[i]).fixed[0])

for path in paths:
    a[int(path[0])-1][int(path[1])-1] = int(path[2])

for i in range(0, n):
    for j in range(0, n):
        print(a[i,j], sep=" ", end="\t")
    print()

# print(a)

print("cost:", cost)
print("pavimento:", pavimento)
print("muri:", muro)
print(times)