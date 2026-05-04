max_diff = 0
final_match = 0

with open("logs/verilog/top_output.txt") as f:
    for line in f:
        parts = line.split()
        for i, token in enumerate(parts):
            if token == "Diff:":
                diff = int(parts[i+1])
                max_diff = max(max_diff, diff)
            elif token == "Match:":
                final_match = int(parts[i+1])

print("Max Diff =", max_diff)
print("Final Exact Match =", final_match)