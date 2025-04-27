F = GF(101)
R.<x1,x2,y1,y2> = F[]

cube = [(0,0),(0,1),(1,0),(1,1)]

def eq(y):
    beta = F(1)
    beta *= x1 * y[0] + (1 - x1) * (1 - y[0])
    beta *= x2 * y[1] + (1 - x2) * (1 - y[1])
    return beta

def mle(values):
    return sum(values[i] * eq(c) for i,c in enumerate(cube))

a = [2,5,11,7]
b = [3,2,8,7]
c = [6,10,88,49]

# we interpolate a polynomial for the values of a, b, c
A = mle(a)
B = mle(b)
C = mle(c)

# we construct our constraint polynomial
# it is zero for all points in the cube
P = A * B - C
print("P =", P)

assert P(x1=0,x2=0) == 0
assert P(x1=0,x2=1) == 0
assert P(x1=1,x2=0) == 0
assert P(x1=1,x2=1) == 0

# we compute the MLE of P
# since P is zero for all points in the cube, the MLE is zero
P_mle = sum(P(x1=c[0],x2=c[1]) * eq([c[0],c[1]]) for c in cube)
print("P_mle =", P_mle)
assert P_mle == 0

# pick a random point in F
# we ultimately want to prove that P_mle(r) = 0
r = [29, 43] # random

# first we compute the "equality function" at r
eq_r = eq(r)
print("eq_r =", eq_r)

# then we compute the product of P and eq_r
S = P * eq_r
print("S =", S)

# S is zero for all points in the cube
assert S(x1=0,x2=0) == 0
assert S(x1=0,x2=1) == 0
assert S(x1=1,x2=0) == 0
assert S(x1=1,x2=1) == 0

# and obviously the sum of S over the cube is zero
H = sum(S(x1=c[0],x2=c[1]) for c in cube)
print("SUM:", H)
assert H == 0

print("===== SUMCHECK =====")
# randomness needed for the sumcheck
r_prime = [41, 79]

# remember that we need to bound the degree of the polynomials g1 and g2
(g1_deg_bound, g2_deg_bound, *_) = S.degrees()
print("g1_deg_bound =", g1_deg_bound)
print("g2_deg_bound =", g2_deg_bound)

# round 1
g1 = R(S(x2=0) + S(x2=1))
print("g1 =", g1)
assert g1(x1=0) + g1(x1=1) == H
assert g1.degree() <= g1_deg_bound

# round 2
g2 = R(S(x1=r_prime[0]))
print("g2 =", g2)
assert g2(x2=0) + g2(x2=1) == g1(x1=r_prime[0])
assert g2.degree() <= g2_deg_bound

print("Verifier recomputes S")
print("we receive P(x1=r_prime[0], x2=r_prime[1]) from polynomial commitment")
print("and the verifier can easily recompute eq_r himself")
S_prime = P(x1=r_prime[0], x2=r_prime[1]) * eq_r(x1=r_prime[0], x2=r_prime[1])
assert g2(x2=r_prime[1]) == S_prime
print("sumcheck passed")
