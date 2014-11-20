from datetime import datetime
from time import time
from Crypto.Util.number import bignum
from math import sqrt


def pulverize(a, b):
    x1 = 1
    y1 = 0
    x2 = 0
    y2 = 1
    q = a / b
    r = a % b
    while r != 0:
        new_a = b
        new_b = r
        new_q = new_a / new_b
        new_r = new_a % new_b
        new_x2 = x1 - q*x2
        new_y2 = y1 - q*y2
        x1 = x2
        y1 = y2
        x2 = new_x2
        y2 = new_y2
        a = new_a
        b = new_b
        q = new_q
        r = new_r
    return y2

def add_points(p1, p2, a, b, n):
    if p1 == p2:
        return double_point(p1, a, b, n)
    m_part1 = (p2[1] - p1[1]) % n
    m_part2 = (p2[0] - p1[0]) % n
    inverse = pulverize(n, m_part2) % n
    m = (m_part1 * inverse) % n
    x = (pow(m, 2) - (p1[0] + p2[0])) % n
    y = (p1[1] + m * (x - p1[0])) % n
    y = -y % n
    return (x, y)

def double_point(p, a, b, n):
    m_part1 = ((3 * pow(p[0], 2)) + a) % n
    m_part2 = (2 * p[1]) % n
    inverse = pulverize(n, m_part2) % n
    m = (m_part1 * inverse) % n
    x = (pow(m, 2) - 2 * p[0]) % n
    y = (p[1] + m * (x - p[0])) % n
    y = -y % n
    return (x, y)

def scalar_multiply_point(p, m, a, b, n):
    o = p
    idx = 2
    while idx <= m:
        o = add_points(o, p, a, b, n)
        idx += 1
        if idx % 500000 == 0:
            print "[%s] - idx: %s" % (datetime.now(), idx)
    return o

def calculate_doubles(m):
    n = 2
    while pow(2, n) <= m:
        n += 1
    return n - 1

def double_point_repeatedly(p, m, a, b, n):
    idx = 1
    o = p
    while idx <= m:
        o = double_point(o, a, b, n)
        idx += 1
    return o

def double_point_into(p, m, a, b, n):
    doubles = calculate_doubles(m)
    o = double_point_repeatedly(p, doubles, a, b, n)
    leftovers = m - pow(2, doubles)
    return o, leftovers

def scalar_multiply_optimized(p, m, a, b, n):
    o = double_point(p, a, b, n)
    o, leftovers = double_point_into(o, m, a, b, n)
    while leftovers > 2:
        o, leftovers = double_point_into(p, leftovers, a, b, n)
    for i in range(leftovers):
        o = add_points(o, p, a, b, n)
    return o

def scalar_multiply_optimized2(p, m, a, b, n):
    point_values = {}
    point_values[1] = p
    o = p
    factors = 1
    while pow(2, factors) <= m:
        point_values[pow(2, factors)] = double_point(o, a, b, n)
        o = point_values[pow(2, factors)]
        factors += 1
    o = p
    used_factors = 1
    while used_factors < m:
        largest_factor = max([x for x in point_values.keys() if used_factors + x <= m])
        o = add_points(o, point_values[largest_factor], a, b, n)
        used_factors += largest_factor
    return o

def decrypt_pairs(cipher, halfmask, N, A, B, q):
    fullmask = scalar_multiply_optimized2(halfmask, N, A, B, q)
    fullmask = (fullmask[0], -fullmask[1] % q)
    m = add_points(cipher, fullmask, A, B, q)
    return m

if __name__ == "__main__":
    print scalar_multiply_point((32, 32), 4, 4, 34, 43)
    print scalar_multiply_optimized((32, 32), 4, 4, 34, 43)
    print scalar_multiply_optimized2((32, 32), 4, 4, 34, 43)

    cipher_lines = open("a4.cipher", "r").read().splitlines()
    cipher_lines = [line.split(' ') for line in cipher_lines]
    #([cipher pair], [half mask pair])
    cipher_lines = [(line[0:2], line[2:]) for line in cipher_lines]

    q = 206847873818812937167517372204272345747

    A = 283939956464285692379899333706992027275

    B = 308586428300645422408688881682031972186

    G = [86782108332173850812180795548971859602, 49789110821407843311524449565277112173]

    P = [14006877160884410441050860525173635965, 47025768175767281141122021960626732662]

    N = 184108911298737193426131181814580033609

    plaintext = ''

    for line in cipher_lines:
        cipher = [bignum(x) for x in line[0]]
        halfmask = [bignum(x) for x in line[1]]
        print "[%s] On line %s/%s" % (datetime.now(), cipher_lines.index(line)+1, len(cipher_lines))
        m = decrypt_pairs(cipher, halfmask, N, A, B, q)
        # res = m == scalar_multiply_point(cipher, 2, A, B, q)
        plaintext += chr(m[0])
    with open("a4.plaintext", "w") as o:
        o.write(plaintext)
    print plaintext