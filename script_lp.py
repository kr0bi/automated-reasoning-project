from unittest import skip
from parse import parse
import numpy as np
import sys

n = int(sys.argv[1])

a = np.zeros((n,n))

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

for i, _ in enumerate(assigns):
    assigns[i] = parse("path({},{},{}).", assigns[i]).fixed

for assign in assigns:
    a[int(assign[0])-1][int(assign[1])-1] = int(assign[2])

# print(a)

print("cost:", cost)
print(times)