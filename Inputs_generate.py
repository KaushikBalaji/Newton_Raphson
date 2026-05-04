import random

N = 16
W = 2 * N

NUM_INPUTS = 200
# random_inputs = random.sample(range(2, 1 << N), NUM_INPUTS)  # generate 150 random inputs in the range [2, 2^N]
pre_values = [2**i for i in range(1, N)]
# pre_values = []

input_values = pre_values

while len(set(input_values)) < NUM_INPUTS:
    new_input = random.randint(2, (1 << N) - 1)
    input_values.append(new_input)

f = open("NR_inputs.txt", "w")

# print("Total unique inputs:", len(set(input_values)))

input_values = sorted(set(input_values))  # sort and remove duplicates

for num in input_values:
    f.write(f"{num}\n")
f.close()
