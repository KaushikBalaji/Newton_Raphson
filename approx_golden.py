
W = 16
N = 8

def initial_approx(lod_in):
    approx_out = 0
    found = False

    for j in range(W-1, -1, -1):
        if ((lod_in >> j) & 1) and not found:
            found = True

            # ODD position
            if j % 2 == 1:

                if j >= N:
                    shift = (j - N + 1) >> 1
                    idx = N - shift
                    if 0 <= idx < W:
                        approx_out |= (1 << idx)

                else:
                    shift = (N - j) >> 1
                    idx = N + shift
                    if idx < W:
                        approx_out |= (1 << idx)

            # EVEN position
            else:

                if j >= N:
                    shift = (j - N) >> 1

                    idx1 = N - (shift + 1)
                    idx2 = N - (shift + 2)

                    if 0 <= idx1 < W:
                        approx_out |= (1 << idx1)

                    if 0 <= idx2 < W:
                        approx_out |= (1 << idx2)

                else:
                    shift = (N - j) >> 1
                    idx = N + shift
                    if idx < W:
                        approx_out |= (1 << idx)

    return approx_out


def to_real(val):
    return val / (1 << N)


# -------------------------------
# Test values (same as your TB)
# -------------------------------
test_values = [
    1024, 512, 256, 64,
    2048, 4096, 16384, 300, 700, 1500,
    25600, 36864, 57600,
    255, 256, 257, 511, 513, 1023, 1025, 
    1, 2, 3, 4, 8,
    32768, 40000, 50000, 65535
]


# -------------------------------
# Logging
# -------------------------------
log_file = "approx_log.txt"

with open(log_file, "w") as f:

    # Column header
    header = f"{'Input':>8} | {'Approx':>8} | {'Approx(real)':>14} | {'Expected':>10} | {'Error':>10}\n"
    separator = "-" * len(header) + "\n"

    print(header.strip())
    print(separator.strip())

    f.write(header)
    f.write(separator)

    for a in test_values:
        approx = initial_approx(a)

        real_a = a / 256.0
        expected = 1 / (real_a ** 0.5)
        approx_real = to_real(approx)
        error = abs(approx_real - expected)

        line = f"{a:8d} | {approx:8d} | {approx_real:14.6f} | {expected:10.6f} | {error:10.6f}\n"

        print(line.strip())
        f.write(line)

print(f"\nLog written to: {log_file}")