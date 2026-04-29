import random

N = 16
W = 2 * N

NUM_INPUTS = 200
random_inputs = random.sample(range(2, 1 << N), NUM_INPUTS)  # generate 150 random inputs in the range [2, 2^N]

f = open("NR_inputs.txt", "w")
for num in random_inputs:
    f.write(f"{num}\n")
f.close()
