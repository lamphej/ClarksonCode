from edecc.ecc import EllipticCurve

if __name__ == "__main__":
    cipher_lines = open("a4.cipher", "r").read().splitlines()
    cipher_lines = [line.split(' ') for line in cipher_lines]
    #([cipher pair], [half mask pair])
    cipher_lines = [(line[0:2], line[2:]) for line in cipher_lines]
    print cipher_lines[0]

    q = 206847873818812937167517372204272345747

    A = 283939956464285692379899333706992027275

    B = 308586428300645422408688881682031972186

    G = [86782108332173850812180795548971859602, 49789110821407843311524449565277112173]

    P = [14006877160884410441050860525173635965, 47025768175767281141122021960626732662]

    N = 184108911298737193426131181814580033609

    discriminant = (4*pow(A,3)+27*pow(B,2)) % q
    print "discriminant: %s" % discriminant

    curve = EllipticCurve(A, B, q, N, discriminant, G[0], G[1])

    for line in cipher_lines:
        cipher_pair = line[0]
        half_mask = line[1]
        #F = N*H
        print curve.decode()