import random

__author__ = 'James Lamphere'
import sys


def is_prime(n):
    if n == 2 or n == 3: return True
    if n < 2 or n % 2 == 0: return False
    if n < 9: return True
    if n % 3 == 0: return False
    r = int(n ** 0.5)
    f = 5
    while f <= r:
        if n % f == 0: return False
        if n % (f + 2) == 0: return False
        f += 6
    return True


def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)

def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('modular inverse does not exist')
    else:
        return x % m


if __name__ == "__main__":
    if len(sys.argv) != 5:
        print "[-] Usage: "
        print "[-] python my_rsa.py plaintext_file cipher_file decrypted_file bit_length"
        exit()

    plain_file = sys.argv[1]
    cipher_file = sys.argv[2]
    decrypted_file = sys.argv[3]
    bit_length = long(sys.argv[4])

    print "[+] Generating two %s bit primes" % bit_length
    p = 0
    q = 0
    while True:
        p = random.getrandbits(bit_length)
        if is_prime(p):
            q = random.getrandbits(bit_length)
            if is_prime(q) and q > p:
                break
    n = p * q
    phi = (p - 1) * (q - 1)
    print "[+] p: %s" % p
    print "[+] q: %s" % q
    print "[+] n: %s" % n
    print "[+] phi: %s" % phi
    e = 0
    while True:
        e = random.randint(2, phi - 1)
        the_gcd = egcd(phi, e)
        if the_gcd[0] == 1:
            break
    print "[+] e: %s" % e
    d = modinv(e, phi)
    print "[+] d: %s" % d
    public_key = (n, e)
    private_key = (n, d, p, q, phi)

    with open("pub_key", "w") as o:
        o.write(':'.join([str(a) for a in public_key]))
    with open("priv_key", "w") as o:
        o.write(':'.join([str(a) for a in private_key]))

    print "[+] Encrypting the file '%s'" % plain_file

    with open(cipher_file, "w") as o:
        for character in open(plain_file, "r").read():
            ascii_code = ord(character)
            o.write("%s\n" % pow(ascii_code, e, n))

    print "[+] Encryption finished, testing decryption"

    with open(decrypted_file, "w") as o:
        for l in open(cipher_file, "r").read().splitlines():
            l = long(l)
            o.write(chr(pow(l, d, n)))

    print "[+] Decryption Finished"