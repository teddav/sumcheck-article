F = GF(101)
R.<x1,x2,x3,y1,y2,y3> = F[]

cube = [(0,0,0),(0,0,1),(0,1,0),(0,1,1),(1,0,0),(1,0,1),(1,1,0),(1,1,1)]

def eq(y):
    beta = F(1)
    beta *= x1 * y[0] + (1 - x1) * (1 - y[0])
    beta *= x2 * y[1] + (1 - x2) * (1 - y[1])
    beta *= x3 * y[2] + (1 - x3) * (1 - y[2])
    return beta

def mle(values):
    return sum(values[i] * eq(c) for i,c in enumerate(cube))

a = [83,10,50,5,19,23,90,75]
P = mle(a)
print("P: ", P)

assert P.degrees() == (1, 1, 1, 0, 0, 0)

assert P(x1=cube[0][0],x2=cube[0][1],x3=cube[0][2]) == a[0]
assert P(x1=cube[1][0],x2=cube[1][1],x3=cube[1][2]) == a[1]
assert P(x1=cube[2][0],x2=cube[2][1],x3=cube[2][2]) == a[2]
assert P(x1=cube[3][0],x2=cube[3][1],x3=cube[3][2]) == a[3]
assert P(x1=cube[4][0],x2=cube[4][1],x3=cube[4][2]) == a[4]
assert P(x1=cube[5][0],x2=cube[5][1],x3=cube[5][2]) == a[5]
assert P(x1=cube[6][0],x2=cube[6][1],x3=cube[6][2]) == a[6]