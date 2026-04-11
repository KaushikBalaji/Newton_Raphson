import math

N = 16
W = 2 * N

with open("NR_inputs.txt", "r") as f:
    inputs = [int(line.strip()) for line in f if line.strip()]

def to_q8_8(x):
    return int(round(x * math.pow(2, N)))

f = open("NR_golden_values.txt", "w")


for a in inputs:
    val = a / float(math.pow(2, N))   # convert from Q8.8 to float
    inv_sqrt = 1 / math.sqrt(val)
    q = to_q8_8(inv_sqrt)
    print(q)
    f.write(f"{q}\n")
f.close()

f = open("NR_golden_values.txt", "r")

if f:
    c = 0
    while(f.readline()):
        c += 1
    
    if c != len(inputs):
        print(f"Warning: Expected {len(inputs)} lines, but got {c} lines in the file.")

f.close()
