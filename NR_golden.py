def inv_sqrt_hw(a, N=16, W=32, ITER=4):
    maskW  = (1 << W) - 1
    mask2W = (1 << (2 * W)) - 1

    if a == 0:
        return 0

    # LOD (Leading One Detection)
    i = 0
    for k in reversed(range(W)):
        if (a >> k) & 1:
            i = k
            break

    # initial_approximation
    approx_raw = 0

    if i % 2 == 1:
        idx = N - ((i + 1) >> 1)
        if 0 <= idx < W:
            approx_raw |= (1 << idx)
    else:
        idx1 = N - (i >> 1) - 1
        idx2 = N - (i >> 1) - 2
        if 0 <= idx1 < W:
            approx_raw |= (1 << idx1)
        if 0 <= idx2 < W:
            approx_raw |= (1 << idx2)

    x = (approx_raw << (N // 2)) & maskW

    # NR iterations
    for _ in range(ITER):

        x = x & maskW
        a = a & maskW

        # x^2
        x_sq_full = (x * x) & mask2W
        x_sq_full = (x_sq_full + (1 << (N - 1))) & mask2W
        x_sq = (x_sq_full >> N) & maskW

        # a * x^2
        ax2_full = (a * x_sq) & mask2W
        ax2 = (ax2_full >> N) & maskW

        # term - > (3 - a * x^2)
        term = (3 << N) - ax2
        term = term & maskW

        # x * term
        mult_full = (x * term) & mask2W
        mult_full = (mult_full + (1 << N)) & mask2W

        x = (mult_full >> (N + 1)) & maskW
    return x


f = open("NR_inputs.txt", "r")
inputs = [int(line.strip()) for line in f if line.strip()]

f.close()

f = open("NR_golden_values.txt", "w")
for a in inputs:
    q = inv_sqrt_hw(a)
    # print(q)
    f.write(f"{q}\n")

f.close()