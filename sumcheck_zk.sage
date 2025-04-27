F = GF(101)

R.<x1,x2> = F[]

P = 1 + x2 + x1 + x1*x2

# Compute the sum of P over the Boolean hypercube
H = P(0, 0) + P(0, 1) + P(1, 0) + P(1, 1)
print(f"H = {H}")

# get a random polynomial Q of same degree as P
# Q = R.random_element(degree=P.degree())
Q = -39*x1^2 + 44*x1*x2 + 32*x2^2 + 24*x1 + 4*x2
print(f"Q = {Q}")

# Compute the sum of P over the Boolean hypercube
H_prime = Q(0, 0) + Q(0, 1) + Q(1, 0) + Q(1, 1)
print(f"H_prime = {H_prime}")

# random value rho
# rho = F.random_element()
rho = 36
print(f"rho = {rho}")

S = P + rho * Q
print(f"S = {S}")
SUM = H + rho * H_prime
print(f"Sum of S over the cube = H + rho * H_prime = {SUM}")

# round 1
print("\nround 1")
g1 = S(x2=0) + S(x2=1)
print(f"g1 = {g1}")

# Verifier checks if g1 is correct
print(f"g1(0) + g1(1) = {g1(x1=0) + g1(x1=1)} (should equal {SUM})")
assert g1(x1=0) + g1(x1=1) == SUM
assert g1.degree() <= S.degrees()[0]

# Verifier sends a random challenge r1
r1 = 17

# Prover constructs g2(x) = P(r1, x)
g2 = S(x1=r1)
print(f"g2 = {g2}")

# Verifier checks if g2 is correct
print(f"g2(0) + g2(1) = {g2(x2=0) + g2(x2=1)} ( should equal {g1(x1=r1)})")
assert g2(x2=0) + g2(x2=1) == g1(x1=r1)
assert g2.degree() <= S.degrees()[1]

# Verifier sends a random challenge r2
r2 = 70

# Final verification
assert g2(x2=r2) == S(x1=r1, x2=r2)

# Prover sends H' to verifier (based commitment of Q that should have been done at the beginning)
# Verifier can now get back H
H_final = SUM - rho * H_prime
print(f"H = {H_final}")
