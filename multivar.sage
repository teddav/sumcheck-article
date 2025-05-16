F = GF(17)
R.<x, y, z> = PolynomialRing(F, order="lex")

P = 6*x^3*z^3*y - 6*z^2 - x - 2*y + 6
assert(P.degree() == 7)

P = R.random_element(degree=5)
print("deg 5 poly", P)

print("\nP * z = ", P * z)

print("----------")

P = R.random_element(degree=2)
print("random P:", P)
print("P(1,2,3):", P(1,2,3))

print("----------")

# how are terms sorted?
P = 6*x*y - 6*z^2 - x^2 + y^2 - 2*y + 6*x + z + z^3 + x*z + y*z
print(P)
print(P.dict())

print("----------")
print("Ordering 'degrevlex'")
# we can get it sorted in a different order
# here it's degrevlex, which is "degree reverse lexicographic order"
# https://doc.sagemath.org/html/en/reference/polynomial_rings/sage/rings/polynomial/term_order.html
R.<x, y, z> = PolynomialRing(F, order="degrevlex")

# let's use the same polynomial
# P = 6*x*y - 6*z^2 - x^2 + y^2 - 2*y + 6*x + z + z^3 + x*z + y*z
print("P = ", R(P))

print("\nOther example, with multilinear terms")
print(5*x*y + 7*y + x*y*z + 7)
