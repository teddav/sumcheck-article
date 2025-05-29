import math
import itertools

F = GF(101)
R.<a1,a2, b1,b2, c1,c2> = F[]

def hypercube(n_vars):
    return [list(x) for x in itertools.product([0, 1], repeat=n_vars)]

def mle(values):
    n = int(math.log2(len(values)))
    def eq(y):
        # we'll have either 5 or 6 variables, depending on the layer
        # layer 0 has 5 variables
        # layer 1 has 6 variables
        x = [a1, b1, b2, c1, c2] if n == 5 else [a1, a2, b1, b2, c1, c2]
        beta = F(1)
        for i in range(len(x)):
            beta *= x[i] * y[i] + (1 - x[i]) * (1 - y[i])
        return beta
    return sum(values[i] * eq(c) for i,c in enumerate(hypercube(n)))

# values at each layer
values_l0 = [33, 79]
values_l1 = [12, 21, 15, 12]
values_l2 = [7, 5, 3, 6]

# we compute the MLE for each layer
l0 = values_l0[0] * (1 - b1) + values_l0[1] * b1
l1 = values_l1[0] * (1 - b1) * (1 - b2) + values_l1[1] * (1 - b1) * b2 + values_l1[2] * b1 * (1 - b2) + values_l1[3] * b1 * b2
l2 = values_l2[0] * (1 - b1) * (1 - b2) + values_l2[1] * (1 - b1) * b2 + values_l2[2] * b1 * (1 - b2) + values_l2[3] * b1 * b2

print("l0 =", l0)
print("l1 =", l1)
print("l2 =", l2)

# we check that the MLEs are correct
assert l0(b1=0) == values_l0[0]
assert l0(b1=1) == values_l0[1]

assert l1(b1=0, b2=0) == values_l1[0]
assert l1(b1=0, b2=1) == values_l1[1]
assert l1(b1=1, b2=0) == values_l1[2]
assert l1(b1=1, b2=1) == values_l1[3]

assert l2(b1=0, b2=0) == values_l2[0]
assert l2(b1=0, b2=1) == values_l2[1]
assert l2(b1=1, b2=0) == values_l2[2]
assert l2(b1=1, b2=1) == values_l2[3]

# we start with layer 0
print("\nLAYER 0")

# we compute the add and mul MLEs for layer 0
# layer 0 has 2 gates, so we need 1 bit to represent it
# layer 1 has 4 gates, so we need 2 bits to represent each one
# -> we have 5 variables: a1, b1, b2, c1, c2
add_vals0 = [0] * 2**5
# the add gate is: a = 0, b = 00, c = 01
add_vals0[0b00001] = 1
add0 = mle(add_vals0)

mul_vals0 = [0] * 2**5
# the mul gate is: a = 1, b = 10, c = 11
mul_vals0[0b11011] = 1
mul0 = mle(mul_vals0)

# now we can compute the layer 0's MLE
# This is what the prover will send to the verifier
# The GKR protocol is trying to verify that this MLE is correct
L0 = add0 * (l1 + l1(b1=c1,b2=c2)) + mul0 * l1 * l1(b1=c1,b2=c2)

# let's make sure that we computed the MLE correctly
assert L0(a1=0, b1=0, b2=0, c1=0, c2=0) == 0
assert L0(a1=0, b1=0, b2=0, c1=0, c2=1) == values_l0[0]
assert L0(a1=0, b1=0, b2=0, c1=1, c2=0) == 0
assert L0(a1=0, b1=0, b2=0, c1=1, c2=1) == 0
assert L0(a1=0, b1=0, b2=1, c1=0, c2=0) == 0
assert L0(a1=0, b1=0, b2=1, c1=0, c2=1) == 0
assert L0(a1=0, b1=0, b2=1, c1=1, c2=0) == 0
assert L0(a1=0, b1=0, b2=1, c1=1, c2=1) == 0
assert L0(a1=0, b1=1, b2=0, c1=0, c2=0) == 0
assert L0(a1=0, b1=1, b2=0, c1=0, c2=1) == 0
assert L0(a1=0, b1=1, b2=0, c1=1, c2=0) == 0
assert L0(a1=0, b1=1, b2=0, c1=1, c2=1) == 0
assert L0(a1=0, b1=1, b2=1, c1=0, c2=0) == 0
assert L0(a1=0, b1=1, b2=1, c1=0, c2=1) == 0
assert L0(a1=0, b1=1, b2=1, c1=1, c2=0) == 0
assert L0(a1=0, b1=1, b2=1, c1=1, c2=1) == 0
assert L0(a1=1, b1=0, b2=0, c1=0, c2=0) == 0
assert L0(a1=1, b1=0, b2=0, c1=0, c2=1) == 0
assert L0(a1=1, b1=0, b2=0, c1=1, c2=0) == 0
assert L0(a1=1, b1=0, b2=0, c1=1, c2=1) == 0
assert L0(a1=1, b1=0, b2=1, c1=0, c2=0) == 0
assert L0(a1=1, b1=0, b2=1, c1=0, c2=1) == 0
assert L0(a1=1, b1=0, b2=1, c1=1, c2=0) == 0
assert L0(a1=1, b1=0, b2=1, c1=1, c2=1) == 0
assert L0(a1=1, b1=1, b2=0, c1=0, c2=0) == 0
assert L0(a1=1, b1=1, b2=0, c1=0, c2=1) == 0
assert L0(a1=1, b1=1, b2=0, c1=1, c2=0) == 0
assert L0(a1=1, b1=1, b2=0, c1=1, c2=1) == values_l0[1]
assert L0(a1=1, b1=1, b2=1, c1=0, c2=0) == 0
assert L0(a1=1, b1=1, b2=1, c1=0, c2=1) == 0
assert L0(a1=1, b1=1, b2=1, c1=1, c2=0) == 0
assert L0(a1=1, b1=1, b2=1, c1=1, c2=1) == 0

# sample a random value
# layer 0 has 2 gates, therefore 1 input (1 bit): so we need only 1 number
r0 = [80]
L0_r0 = L0(a1=r0[0])

# we run sumcheck on L0
sum_L0_r0 = sum(L0_r0(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
print("sum L0_r0 =", sum_L0_r0)

# the prover claims that SUM(L0(r0)) == l0(r0)
# the verifier knows how to compute l0
# This is what the Verifier will check through the next steps:
assert sum_L0_r0 == l0(b1=r0[0])

# Writing down the entire sumcheck protocol is a bit long, so we'll just write down the final result.
# During the sumcheck, we get these random values from the verifier for b and c
r0_b = [61, 35]
r0_c = [10, 20]
sum0 = L0_r0(b1=r0_b[0],b2=r0_b[1],c1=r0_c[0],c2=r0_c[1])
print("sum0 =", sum0)

# Prover now needs to prove the values of L1(r0_b) and L1(r0_c)
# First he sends them to the verifier
l1_r0_b = l1(b1=r0_b[0],b2=r0_b[1])
l1_r0_c = l1(b1=r0_c[0],b2=r0_c[1])
print("l1_r0_b =", l1_r0_b)
print("l1_r0_c =", l1_r0_c)

# and the verifier can then recompute and verify sum0 by himself
verif_L0 = add0(b1=r0_b[0],b2=r0_b[1],c1=r0_c[0],c2=r0_c[1])*(l1_r0_b + l1_r0_c) + mul0(b1=r0_b[0],b2=r0_b[1],c1=r0_c[0],c2=r0_c[1])*l1_r0_b*l1_r0_c
assert verif_L0(a1=r0[0]) == sum0

# now the prover needs to prove that l1_r0_b and l1_r0_c were computed correctly
# let's move to layer 1

# =================================================
# =================================================

print("\nLAYER 1")

# first we compute the MLE for layer 1
# by now you should understand how to do this

# just note that layer 1 and 2 both have 4 gates, so we need 2 bits to represent each one
# -> so we now use 6 variables, hence the 2**6
add_vals1 = [0] * 2**6
add_vals1[0b000001] = 1
add_vals1[0b111111] = 1
add1 = mle(add_vals1)

mul_vals1 = [0] * 2**6
mul_vals1[0b010010] = 1
mul_vals1[0b100110] = 1
mul1 = mle(mul_vals1)

# Remember that the wiring of the circuit is known in advance (addition and multiplication gates)
# so the verifier can compute the add and mul MLEs by himself

# we have our layer 1 equation
L1 = add1 * (l2 + l2(b1=c1,b2=c2)) + mul1 * l2 * l2(b1=c1,b2=c2)

# just for understanding, let's check that all values are correct
# it's a bit long...
assert L1(a1=0, a2=0, b1=0, b2=0, c1=0, c2=0) == 0
assert L1(a1=0, a2=0, b1=0, b2=0, c1=0, c2=1) == values_l1[0]
assert L1(a1=0, a2=0, b1=0, b2=0, c1=1, c2=0) == 0
assert L1(a1=0, a2=0, b1=0, b2=0, c1=1, c2=1) == 0
assert L1(a1=0, a2=0, b1=0, b2=1, c1=0, c2=0) == 0
assert L1(a1=0, a2=0, b1=0, b2=1, c1=0, c2=1) == 0
assert L1(a1=0, a2=0, b1=0, b2=1, c1=1, c2=0) == 0
assert L1(a1=0, a2=0, b1=0, b2=1, c1=1, c2=1) == 0
assert L1(a1=0, a2=0, b1=1, b2=0, c1=0, c2=0) == 0
assert L1(a1=0, a2=0, b1=1, b2=0, c1=0, c2=1) == 0
assert L1(a1=0, a2=0, b1=1, b2=0, c1=1, c2=0) == 0
assert L1(a1=0, a2=0, b1=1, b2=0, c1=1, c2=1) == 0
assert L1(a1=0, a2=0, b1=1, b2=1, c1=0, c2=0) == 0
assert L1(a1=0, a2=0, b1=1, b2=1, c1=0, c2=1) == 0
assert L1(a1=0, a2=0, b1=1, b2=1, c1=1, c2=0) == 0
assert L1(a1=0, a2=0, b1=1, b2=1, c1=1, c2=1) == 0

assert L1(a1=0, a2=1, b1=0, b2=0, c1=0, c2=0) == 0
assert L1(a1=0, a2=1, b1=0, b2=0, c1=0, c2=1) == 0
assert L1(a1=0, a2=1, b1=0, b2=0, c1=1, c2=0) == values_l1[1]
assert L1(a1=0, a2=1, b1=0, b2=0, c1=1, c2=1) == 0
assert L1(a1=0, a2=1, b1=0, b2=1, c1=0, c2=0) == 0
assert L1(a1=0, a2=1, b1=0, b2=1, c1=0, c2=1) == 0
assert L1(a1=0, a2=1, b1=0, b2=1, c1=1, c2=0) == 0
assert L1(a1=0, a2=1, b1=0, b2=1, c1=1, c2=1) == 0
assert L1(a1=0, a2=1, b1=1, b2=0, c1=0, c2=0) == 0
assert L1(a1=0, a2=1, b1=1, b2=0, c1=0, c2=1) == 0
assert L1(a1=0, a2=1, b1=1, b2=0, c1=1, c2=0) == 0
assert L1(a1=0, a2=1, b1=1, b2=0, c1=1, c2=1) == 0
assert L1(a1=0, a2=1, b1=1, b2=1, c1=0, c2=0) == 0
assert L1(a1=0, a2=1, b1=1, b2=1, c1=0, c2=1) == 0
assert L1(a1=0, a2=1, b1=1, b2=1, c1=1, c2=0) == 0
assert L1(a1=0, a2=1, b1=1, b2=1, c1=1, c2=1) == 0

assert L1(a1=1, a2=0, b1=0, b2=0, c1=0, c2=0) == 0
assert L1(a1=1, a2=0, b1=0, b2=0, c1=0, c2=1) == 0
assert L1(a1=1, a2=0, b1=0, b2=0, c1=1, c2=0) == 0
assert L1(a1=1, a2=0, b1=0, b2=0, c1=1, c2=1) == 0
assert L1(a1=1, a2=0, b1=0, b2=1, c1=0, c2=0) == 0
assert L1(a1=1, a2=0, b1=0, b2=1, c1=0, c2=1) == 0
assert L1(a1=1, a2=0, b1=0, b2=1, c1=1, c2=0) == values_l1[2]
assert L1(a1=1, a2=0, b1=0, b2=1, c1=1, c2=1) == 0
assert L1(a1=1, a2=0, b1=1, b2=0, c1=0, c2=0) == 0
assert L1(a1=1, a2=0, b1=1, b2=0, c1=0, c2=1) == 0
assert L1(a1=1, a2=0, b1=1, b2=0, c1=1, c2=0) == 0
assert L1(a1=1, a2=0, b1=1, b2=0, c1=1, c2=1) == 0
assert L1(a1=1, a2=0, b1=1, b2=1, c1=0, c2=0) == 0
assert L1(a1=1, a2=0, b1=1, b2=1, c1=0, c2=1) == 0
assert L1(a1=1, a2=0, b1=1, b2=1, c1=1, c2=0) == 0
assert L1(a1=1, a2=0, b1=1, b2=1, c1=1, c2=1) == 0

assert L1(a1=1, a2=1, b1=0, b2=0, c1=0, c2=0) == 0
assert L1(a1=1, a2=1, b1=0, b2=0, c1=0, c2=1) == 0
assert L1(a1=1, a2=1, b1=0, b2=0, c1=1, c2=0) == 0
assert L1(a1=1, a2=1, b1=0, b2=0, c1=1, c2=1) == 0
assert L1(a1=1, a2=1, b1=0, b2=1, c1=0, c2=0) == 0
assert L1(a1=1, a2=1, b1=0, b2=1, c1=0, c2=1) == 0
assert L1(a1=1, a2=1, b1=0, b2=1, c1=1, c2=0) == 0
assert L1(a1=1, a2=1, b1=0, b2=1, c1=1, c2=1) == 0
assert L1(a1=1, a2=1, b1=1, b2=0, c1=0, c2=0) == 0
assert L1(a1=1, a2=1, b1=1, b2=0, c1=0, c2=1) == 0
assert L1(a1=1, a2=1, b1=1, b2=0, c1=1, c2=0) == 0
assert L1(a1=1, a2=1, b1=1, b2=0, c1=1, c2=1) == 0
assert L1(a1=1, a2=1, b1=1, b2=1, c1=0, c2=0) == 0
assert L1(a1=1, a2=1, b1=1, b2=1, c1=0, c2=1) == 0
assert L1(a1=1, a2=1, b1=1, b2=1, c1=1, c2=0) == 0
assert L1(a1=1, a2=1, b1=1, b2=1, c1=1, c2=1) == values_l1[3]

# Now, we want to prove that:
# L1(b) = l1_r0_b
# L1(c) = l1_r0_c
# so we need to run sumcheck on L1(b) and L1(c)
L1_b = L1(a1=r0_b[0],a2=r0_b[1])
L1_c = L1(a1=r0_c[0],a2=r0_c[1])

# we run sumcheck on L1(b)
sum_L1_b = sum(L1_b(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
print("sum L1_b =", sum_L1_b)
assert sum_L1_b == l1_r0_b

# same thing for L1(c)
sum_L1_c = sum(L1_c(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
print("sum L1_c =", sum_L1_c)
assert sum_L1_c == l1_r0_c

print("This means that layer 0 was correct, based on the values of layer 1")
print("Now, we need to verify that layer 1 is correct, based on the values of layer 2")
print("Since layer 2 is the last layer, the verifier can compute the values of layer 2 by himself")
print("")

# sample a random value
r1 = [10, 20]
L1_r1 = L1(a1=r1[0],a2=r1[1])

# we run sumcheck on L1_r1
sum_L1_r1 = sum(L1_r1(b1=b[0],b2=b[1],c1=c[0],c2=c[1]) for b in hypercube(2) for c in hypercube(2))
print("sum L1_r1 =", sum_L1_r1)

# the verifier DOES NOT have access to l1, so he can't compute this himself
# but let's just check for ourselves that the sumcheck is correct
assert sum_L1_r1 == l1(b1=r1[0],b2=r1[1])


r1_b = [55, 10]
r1_c = [30, 40]
sum1 = L1_r1(b1=r1_b[0],b2=r1_b[1],c1=r1_c[0],c2=r1_c[1])
print("sum1 =", sum1)

# this can be computed by the verifier directly
# since the values in layer 2 are known
l2_r1_b = l2(b1=r1_b[0],b2=r1_b[1])
l2_r1_c = l2(b1=r1_c[0],b2=r1_c[1])
print("l2_r1_b =", l2_r1_b)
print("l2_r1_c =", l2_r1_c)

# this can also be computed by the verifier directly
# and the wiring of the circuit is known in advance (add1 and mul1)
verif_L1 = add1(b1=r1_b[0],b2=r1_b[1],c1=r1_c[0],c2=r1_c[1])*(l2_r1_b + l2_r1_c) + mul1(b1=r1_b[0],b2=r1_b[1],c1=r1_c[0],c2=r1_c[1])*l2_r1_b*l2_r1_c

# if this equation holds, the verifier now knows that the entire circuit is correct!
assert verif_L1(a1=r1[0],a2=r1[1]) == sum1
