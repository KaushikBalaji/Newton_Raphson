import math

inputs = [
    254, 255, 256, 257,
    1, 4, 16, 64, 256, 1024, 4096, 16384, 32768,
    576, 2304, 6400, 16384, 36864,
    511, 512, 513, 2047, 2048, 2049,
    43690, 21845, 12345, 54321, 65535,
    2, 3, 5, 7
]

def to_q8_8(x):
    return int(round(x * 256))

f = open("NR_golden_values.txt", "w")


for a in inputs:
    val = a / 256.0   # convert from Q8.8 to float
    inv_sqrt = 1 / math.sqrt(val)
    q = to_q8_8(inv_sqrt)
    print(q)
    f.write(f"{q}\n")

f.close()
