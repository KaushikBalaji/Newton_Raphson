# Golden reference for LOD (Leading One Detector) module

N = 8
W = 16

def lod_golden(lod_in):
    for i in range(W-1, -1, -1):
        if (lod_in >> i) & 1:
            return i
    return 0

def to_real(val):
    return val / (1 << N)