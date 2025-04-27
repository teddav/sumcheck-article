F = GF(101)

# Define a univariate polynomial ring (for later reductions)
# it just makes it more clear what we're doing
Rx.<x> = F[]

print("2 variables")
# Define a polynomial ring with two variables
R.<x1,x2> = F[]

# Define a random multilinear polynomial
P = 1 + x2 + x1 + x1*x2

# Compute the sum of P over the Boolean hypercube
H = P(0, 0) + P(0, 1) + P(1, 0) + P(1, 1)
print(f"H = {H}")

# Prover constructs g1(x) = P(x,0) + P(x,1)
g1 = P(x1,0) + P(x1,1)

# Convert g1 to a univariate polynomial in x (just for clarity)
g1 = Rx(g1(x, 0))
print(f"g1 = {g1}")

# Verifier checks if g1 correctly sums to H
print(f"g1(0) + g1(1) = {g1(0) + g1(1)} (should equal {H})")
assert g1(0) + g1(1) == H
assert g1.degree() <= 1

# Verifier sends a random challenge r1
r1 = 31

# Prover constructs g2(x) = P(r1, x)
g2 = P(r1, x2)

# Convert g2 to a univariate polynomial in x (for clarity)
g2 = Rx(g2(0, x))
print(f"g2 = {g2}")

# Verifier checks if g2 correctly sums to g1(r1)
print(f"g2(0) + g2(1) = {g2(0) + g2(1)} ( should equal {g1(r1)})")
assert g2(0) + g2(1) == g1(r1)
assert g2.degree() <= 1

r2 = 43

# Final verification
assert g2(r2) == P(r1, r2)


print("===================")
print("3 variables")
# with 3 variables
R.<x1,x2,x3> = F[]

# Again, define a random multilinear polynomial
P = 75*x1*x2 + 3*x2*x3 + x3 + 43*x1*x3 + 10*x2 + 11*x3 + 1
H = P(0, 0, 0) + P(0, 0, 1) + P(0, 1, 0) + P(0, 1, 1) + P(1, 0, 0) + P(1, 0, 1) + P(1, 1, 0) + P(1, 1, 1)
print(f"H = {H}")

g1 = P(x1, 0, 0) + P(x1, 0, 1) + P(x1, 1, 0) + P(x1, 1, 1)
g1 = Rx(g1(x, 0, 0))
print(f"g1 = {g1}")
print(f"g1(0) + g1(1) = {g1(0) + g1(1)} (should equal {H})")
assert g1(0) + g1(1) == H
assert g1.degree() <= 1

r1 = 20

g2 = P(r1, x2, 0) + P(r1, x2, 1)
g2 = Rx(g2(0, x, 0))
print(f"g2 = {g2}")
print(f"g2(0) + g2(1) = {g2(0) + g2(1)} (should equal {g1(r1)})")
assert g2(0) + g2(1) == g1(r1)
assert g2.degree() <= 1

r2 = 30

g3 = P(r1, r2, x3)
g3 = Rx(g3(0, 0, x))
print(f"g3 = {g3}")
print(f"g3(0) + g3(1) = {g3(0) + g3(1)} (should equal {g2(r2)})")
assert g3(0) + g3(1) == g2(r2)
assert g3.degree() <= 1

r3 = 40
assert g3(r3) == P(r1, r2, r3)
