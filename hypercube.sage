import itertools

dimension = 3
cube = list(itertools.product([0, 1], repeat=dimension))

F = GF(17)
R.<a, b, c> = F[]

P = 6*a*b*c + 5*a*b + 4*a*c + 3*a + 2*b*c + b + 7
# we can check the degrees of each variable
assert(P.degrees() == (1,1,1))
print("P:", P)

# we can evaluate the polynomial over the hypercube
S = sum([P(i) for i in cube])
print("Sum of the polynomial over the hypercube:", S)