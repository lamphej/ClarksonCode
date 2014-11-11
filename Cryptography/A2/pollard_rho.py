__author__ = 'James Lamphere'

def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def rho(n):
    # this is the most common polynomial I found to use
    g = lambda x: (pow(x, 2) + 1) % n
    x = 2
    y = 2
    d = 1
    while d == 1:
        x = g(x)
        y = g(g(y))
        d = egcd(abs(x-y), n)[0]
    if d == n:
        return False
    return d, n/d


if __name__ == "__main__":
    n = 12
    res = rho(n)
    print "rho(%s)=%s,%s" % (n, res[0], res[1])