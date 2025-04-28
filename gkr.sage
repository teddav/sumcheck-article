import math

F = GF(101)
R.<a1,a2, b1,b2, c1,c2> = F[]

def hypercube(n_vars):
    import itertools
    return [list(x) for x in itertools.product([0, 1], repeat=n_vars)]


values_L0 = [33, 79]
values_L1 = [12, 21, 15, 12]
values_L2 = [7, 5, 3, 6]
L0 = values_L0[0] * (1 - b1) + values_L0[1] * b1
L1 = values_L1[0] * (1 - b1) * (1 - b2) + values_L1[1] * (1 - b1) * b2 + values_L1[2] * b1 * (1 - b2) + values_L1[3] * b1 * b2
L2 = values_L2[0] * (1 - b1) * (1 - b2) + values_L2[1] * (1 - b1) * b2 + values_L2[2] * b1 * (1 - b2) + values_L2[3] * b1 * b2

print("L0 =", L0)
print("L1 =", L1)
print("L2 =", L2)

assert L0(b1=0) == values_L0[0]
assert L0(b1=1) == values_L0[1]
assert L1(b1=0, b2=0) == values_L1[0]
assert L1(b1=0, b2=1) == values_L1[1]
assert L1(b1=1, b2=0) == values_L1[2]
assert L1(b1=1, b2=1) == values_L1[3]
assert L2(b1=0, b2=0) == values_L2[0]
assert L2(b1=0, b2=1) == values_L2[1]
assert L2(b1=1, b2=0) == values_L2[2]
assert L2(b1=1, b2=1) == values_L2[3]

def mle(values):
    n = int(math.log2(len(values)))
    def eq(y):
        x = [a1, b1, b2, c1, c2] if n == 5 else [a1, a2, b1, b2, c1, c2]
        beta = F(1)
        for i in range(len(x)):
            beta *= x[i] * y[i] + (1 - x[i]) * (1 - y[i])
        return beta
    return sum(values[i] * eq(c) for i,c in enumerate(hypercube(n)))

print("\nLAYER 0")
# we compute the MLEs for layer 0
# layer 0 has 2 values, so we need 1 bit to represent it
# layer 1 has 4 values, so we need 2 bits to represent each value
# -> we have 5 variables: a1, b1, b2, c1, c2
add_vals0 = [0] * 2**5
add_vals0[0b00001] = 1
add0 = mle(add_vals0)

mul_vals0 = [0] * 2**5
mul_vals0[0b11011] = 1
mul0 = mle(mul_vals0)
f0 = add0 * (L1 + L1(b1=c1,b2=c2)) + mul0 * L1 * L1(b1=c1,b2=c2)

assert f0(a1=0, b1=0, b2=0, c1=0, c2=0) == 0
assert f0(a1=0, b1=0, b2=0, c1=0, c2=1) == values_L0[0]
assert f0(a1=0, b1=0, b2=0, c1=1, c2=0) == 0
assert f0(a1=0, b1=0, b2=0, c1=1, c2=1) == 0
assert f0(a1=0, b1=0, b2=1, c1=0, c2=0) == 0
assert f0(a1=0, b1=0, b2=1, c1=0, c2=1) == 0
assert f0(a1=0, b1=0, b2=1, c1=1, c2=0) == 0
assert f0(a1=0, b1=0, b2=1, c1=1, c2=1) == 0
assert f0(a1=0, b1=1, b2=0, c1=0, c2=0) == 0
assert f0(a1=0, b1=1, b2=0, c1=0, c2=1) == 0
assert f0(a1=0, b1=1, b2=0, c1=1, c2=0) == 0
assert f0(a1=0, b1=1, b2=0, c1=1, c2=1) == 0
assert f0(a1=0, b1=1, b2=1, c1=0, c2=0) == 0
assert f0(a1=0, b1=1, b2=1, c1=0, c2=1) == 0
assert f0(a1=0, b1=1, b2=1, c1=1, c2=0) == 0
assert f0(a1=0, b1=1, b2=1, c1=1, c2=1) == 0
assert f0(a1=1, b1=0, b2=0, c1=0, c2=0) == 0
assert f0(a1=1, b1=0, b2=0, c1=0, c2=1) == 0
assert f0(a1=1, b1=0, b2=0, c1=1, c2=0) == 0
assert f0(a1=1, b1=0, b2=0, c1=1, c2=1) == 0
assert f0(a1=1, b1=0, b2=1, c1=0, c2=0) == 0
assert f0(a1=1, b1=0, b2=1, c1=0, c2=1) == 0
assert f0(a1=1, b1=0, b2=1, c1=1, c2=0) == 0
assert f0(a1=1, b1=0, b2=1, c1=1, c2=1) == 0
assert f0(a1=1, b1=1, b2=0, c1=0, c2=0) == 0
assert f0(a1=1, b1=1, b2=0, c1=0, c2=1) == 0
assert f0(a1=1, b1=1, b2=0, c1=1, c2=0) == 0
assert f0(a1=1, b1=1, b2=0, c1=1, c2=1) == values_L0[1]
assert f0(a1=1, b1=1, b2=1, c1=0, c2=0) == 0
assert f0(a1=1, b1=1, b2=1, c1=0, c2=1) == 0
assert f0(a1=1, b1=1, b2=1, c1=1, c2=0) == 0
assert f0(a1=1, b1=1, b2=1, c1=1, c2=1) == 0

# sample a random value
r0 = [80]
f0_r0 = f0(a1=r0[0])

# we run sumcheck on f0
sum_f0_r0 = sum(f0_r0(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
print("sum f0_r0 =", sum_f0_r0)

# the prover claims that SUM(f0_r0) == L0(r0)
# the verifier knows how to compute L0
# then the verifier will verify how f0 was computed
assert sum_f0_r0 == L0(b1=r0[0])

# during the sumcheck, we get these random values from the verifier
r0_b = [61, 35]
r0_c = [10, 20]
c0 = f0_r0(b1=r0_b[0],b2=r0_b[1],c1=r0_c[0],c2=r0_c[1])
print("c0 =", c0)

# prover now needs to prove the values of L1(r0_b) and L1(r0_c)
# first he sends them to the verifier
L1_r0_b = L1(b1=r0_b[0],b2=r0_b[1])
L1_r0_c = L1(b1=r0_c[0],b2=r0_c[1])
print("L1_r0_b =", L1_r0_b)
print("L1_r0_c =", L1_r0_c)

# and the verifier can then recompute and verify c0 by himself
verif_l0 = add0(b1=r0_b[0],b2=r0_b[1],c1=r0_c[0],c2=r0_c[1])*(L1_r0_b + L1_r0_c) + mul0(b1=r0_b[0],b2=r0_b[1],c1=r0_c[0],c2=r0_c[1])*L1_r0_b*L1_r0_c
assert verif_l0(a1=r0[0]) == c0

# now the prover needs to prove that L1_r0_b and L1_r0_c were computed correctly

print("\nLAYER 1")
# let's compute the MLEs for layer 1
add_vals1 = [0] * 2**6
add_vals1[0b000001] = 1
add_vals1[0b111111] = 1
add1 = mle(add_vals1)

mul_vals1 = [0] * 2**6
mul_vals1[0b010010] = 1
mul_vals1[0b100110] = 1
mul1 = mle(mul_vals1)

# we have our layer 1 equation
f1 = add1 * (L2 + L2(b1=c1,b2=c2)) + mul1 * L2 * L2(b1=c1,b2=c2)

# just for understanding, let's check that all values are correct
# it's a bit long...
assert f1(a1=0, a2=0, b1=0, b2=0, c1=0, c2=0) == 0
assert f1(a1=0, a2=0, b1=0, b2=0, c1=0, c2=1) == values_L1[0]
assert f1(a1=0, a2=0, b1=0, b2=0, c1=1, c2=0) == 0
assert f1(a1=0, a2=0, b1=0, b2=0, c1=1, c2=1) == 0
assert f1(a1=0, a2=0, b1=0, b2=1, c1=0, c2=0) == 0
assert f1(a1=0, a2=0, b1=0, b2=1, c1=0, c2=1) == 0
assert f1(a1=0, a2=0, b1=0, b2=1, c1=1, c2=0) == 0
assert f1(a1=0, a2=0, b1=0, b2=1, c1=1, c2=1) == 0
assert f1(a1=0, a2=0, b1=1, b2=0, c1=0, c2=0) == 0
assert f1(a1=0, a2=0, b1=1, b2=0, c1=0, c2=1) == 0
assert f1(a1=0, a2=0, b1=1, b2=0, c1=1, c2=0) == 0
assert f1(a1=0, a2=0, b1=1, b2=0, c1=1, c2=1) == 0
assert f1(a1=0, a2=0, b1=1, b2=1, c1=0, c2=0) == 0
assert f1(a1=0, a2=0, b1=1, b2=1, c1=0, c2=1) == 0
assert f1(a1=0, a2=0, b1=1, b2=1, c1=1, c2=0) == 0
assert f1(a1=0, a2=0, b1=1, b2=1, c1=1, c2=1) == 0

assert f1(a1=0, a2=1, b1=0, b2=0, c1=0, c2=0) == 0
assert f1(a1=0, a2=1, b1=0, b2=0, c1=0, c2=1) == 0
assert f1(a1=0, a2=1, b1=0, b2=0, c1=1, c2=0) == values_L1[1]
assert f1(a1=0, a2=1, b1=0, b2=0, c1=1, c2=1) == 0
assert f1(a1=0, a2=1, b1=0, b2=1, c1=0, c2=0) == 0
assert f1(a1=0, a2=1, b1=0, b2=1, c1=0, c2=1) == 0
assert f1(a1=0, a2=1, b1=0, b2=1, c1=1, c2=0) == 0
assert f1(a1=0, a2=1, b1=0, b2=1, c1=1, c2=1) == 0
assert f1(a1=0, a2=1, b1=1, b2=0, c1=0, c2=0) == 0
assert f1(a1=0, a2=1, b1=1, b2=0, c1=0, c2=1) == 0
assert f1(a1=0, a2=1, b1=1, b2=0, c1=1, c2=0) == 0
assert f1(a1=0, a2=1, b1=1, b2=0, c1=1, c2=1) == 0
assert f1(a1=0, a2=1, b1=1, b2=1, c1=0, c2=0) == 0
assert f1(a1=0, a2=1, b1=1, b2=1, c1=0, c2=1) == 0
assert f1(a1=0, a2=1, b1=1, b2=1, c1=1, c2=0) == 0
assert f1(a1=0, a2=1, b1=1, b2=1, c1=1, c2=1) == 0

assert f1(a1=1, a2=0, b1=0, b2=0, c1=0, c2=0) == 0
assert f1(a1=1, a2=0, b1=0, b2=0, c1=0, c2=1) == 0
assert f1(a1=1, a2=0, b1=0, b2=0, c1=1, c2=0) == 0
assert f1(a1=1, a2=0, b1=0, b2=0, c1=1, c2=1) == 0
assert f1(a1=1, a2=0, b1=0, b2=1, c1=0, c2=0) == 0
assert f1(a1=1, a2=0, b1=0, b2=1, c1=0, c2=1) == 0
assert f1(a1=1, a2=0, b1=0, b2=1, c1=1, c2=0) == values_L1[2]
assert f1(a1=1, a2=0, b1=0, b2=1, c1=1, c2=1) == 0
assert f1(a1=1, a2=0, b1=1, b2=0, c1=0, c2=0) == 0
assert f1(a1=1, a2=0, b1=1, b2=0, c1=0, c2=1) == 0
assert f1(a1=1, a2=0, b1=1, b2=0, c1=1, c2=0) == 0
assert f1(a1=1, a2=0, b1=1, b2=0, c1=1, c2=1) == 0
assert f1(a1=1, a2=0, b1=1, b2=1, c1=0, c2=0) == 0
assert f1(a1=1, a2=0, b1=1, b2=1, c1=0, c2=1) == 0
assert f1(a1=1, a2=0, b1=1, b2=1, c1=1, c2=0) == 0
assert f1(a1=1, a2=0, b1=1, b2=1, c1=1, c2=1) == 0

assert f1(a1=1, a2=1, b1=0, b2=0, c1=0, c2=0) == 0
assert f1(a1=1, a2=1, b1=0, b2=0, c1=0, c2=1) == 0
assert f1(a1=1, a2=1, b1=0, b2=0, c1=1, c2=0) == 0
assert f1(a1=1, a2=1, b1=0, b2=0, c1=1, c2=1) == 0
assert f1(a1=1, a2=1, b1=0, b2=1, c1=0, c2=0) == 0
assert f1(a1=1, a2=1, b1=0, b2=1, c1=0, c2=1) == 0
assert f1(a1=1, a2=1, b1=0, b2=1, c1=1, c2=0) == 0
assert f1(a1=1, a2=1, b1=0, b2=1, c1=1, c2=1) == 0
assert f1(a1=1, a2=1, b1=1, b2=0, c1=0, c2=0) == 0
assert f1(a1=1, a2=1, b1=1, b2=0, c1=0, c2=1) == 0
assert f1(a1=1, a2=1, b1=1, b2=0, c1=1, c2=0) == 0
assert f1(a1=1, a2=1, b1=1, b2=0, c1=1, c2=1) == 0
assert f1(a1=1, a2=1, b1=1, b2=1, c1=0, c2=0) == 0
assert f1(a1=1, a2=1, b1=1, b2=1, c1=0, c2=1) == 0
assert f1(a1=1, a2=1, b1=1, b2=1, c1=1, c2=0) == 0
assert f1(a1=1, a2=1, b1=1, b2=1, c1=1, c2=1) == values_L1[3]

# 
f1_b = f1(a1=r0_b[0],a2=r0_b[1])
sum_f1_b = sum(f1_b(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
assert sum_f1_b == L1_r0_b
# we run sumcheck on f1_b
r1_b = [55, 10]
r1_c = [30, 40]
c1_b = f1_b(b1=r1_b[0],b2=r1_b[1],c1=r1_c[0],c2=r1_c[1])
# we end up with c1_b
# and at the end, the Verifier can now compute c1_b by himself
# since the values in layer 2 are known

# same thing for f1_c
f1_c = f1(a1=r0_c[0],a2=r0_c[1])
sum_f1_c = sum(f1_c(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
assert sum_f1_c == L1_r0_c

# in reality, there's no need to run sumcheck on f1_b and f1_c separately
# we can do it on a linear combination of the two