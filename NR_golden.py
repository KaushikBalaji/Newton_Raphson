import math

N = 16
W = 2 * N

with open("NR_inputs.txt", "r") as f:
    inputs = [int(line.strip()) for line in f if line.strip()]

def to_qN_N(x):
    return int(round(x * math.pow(2, N)))

f = open("NR_golden_values.txt", "w")


for a in inputs:
    val = a / float(math.pow(2, N))
    inv_sqrt = 1 / math.sqrt(val)
    q = to_qN_N(inv_sqrt)
    # print(q)
    f.write(f"{q}\n")
f.close()

