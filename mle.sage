F = GF(101)
R.<a,b> = F[]

def multilinear_lagrange_interpolation(points, values):
    def basis_polynomial(point):
        result = R(1)
        result *= a if point[0] == 1 else (1 - a)
        result *= b if point[1] == 1 else (1 - b)
        return result
    
    interpolation_polynomial = R(0)
    
    for i in range(len(points)):
        interpolation_polynomial += F(values[i]) * basis_polynomial(points[i])
    
    return interpolation_polynomial

points = [(0, 0), (0, 1), (1, 0), (1, 1)]
values = [3, 5, 7, 11]

P = multilinear_lagrange_interpolation(points, values)
print("P: ", P)

assert(P(points[0]) == values[0])
assert(P(points[1]) == values[1])
assert(P(points[2]) == values[2])
assert(P(points[3]) == values[3])