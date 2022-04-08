from os import sep


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

file1 = open("output.txt", "r")
lines = file1.readlines()

for line in lines:
    for character in line:
        if character == '1':
            print(bcolors.OKBLUE, character, bcolors.ENDC, end = '', sep="")
        elif character == '2': 
            print(bcolors.FAIL, character, bcolors.ENDC, end = '', sep="")
        elif character == '3':
            print(bcolors.WARNING, character, bcolors.ENDC, end = '', sep="")
        else:
            print(character, end = '', sep="")
    print("\n", end = '', sep="")