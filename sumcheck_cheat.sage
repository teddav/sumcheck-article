F = GF(101)
R.<x1,x2> = F[]
Rx.<x> = F[]

P = 15*x1*x2 + 50*x1 + 11
print(f"P = {P}")

H = P(0, 0) + P(0, 1) + P(1, 0) + P(1, 1)
print(f"H = {H}")

g1 = P(x1,0) + P(x1,1)
g1 = Rx(g1(x, 0))
print(f"g1 = {g1}")
assert g1(0) + g1(1) == H

# Now, let's try to trick the verifier
# Fake g1 using Lagrange interpolation
fake_g1 = Rx.lagrange_polynomial([(0, 1), (1, H-1)])
print(f"fake_g1 = {fake_g1}")

# The fake g1 passes the check!
assert fake_g1(0) + fake_g1(1) == H

# Verifier sends a random challenge r1
r1 = 71

g2 = P(r1, x2)
g2 = Rx(g2(0, x))
print(f"g2 = {g2}")
assert g2(0) + g2(1) == g1(r1)

# Let's check if the fake g1 still works
print(f"g2(0) + g2(1) == fake_g1(r1)? {g2(0) + g2(1) == fake_g1(r1)}")

# The fake g1 will fail at this step
assert g2(0) + g2(1) != fake_g1(r1)


print("\nAllow g1 to be a higher degree polynomial")
# Now, let's try to trick the verifier with a higher degree polynomial
points = [(0, 1), (1, H-1)]

# we interpolate a polynomial where the condition is verified for every point in the field
points += [(i, P(i, 0) + P(i, 1)) for i in range(2, 101)]
fake_g1 = Rx.lagrange_polynomial(points)
print(f"fake_g1 degree: {fake_g1.degree()}")

# The fake g1 passes the check!
assert g2(0) + g2(1) == fake_g1(r1)