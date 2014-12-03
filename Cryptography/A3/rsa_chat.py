import random
import string
from threading import Thread
from ecdsa.numbertheory import is_prime
from socket import *
from Crypto.Cipher import AES
from Crypto import Random

BUFSIZE = 4096

__author__ = 'James Lamphere'
import sys

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

class RSAServer(object):

    known_keys = {}

    @staticmethod
    def generate_rsa_key(bit_length):
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
        e = 0
        while True:
            e = random.randint(2, phi - 1)
            the_gcd = egcd(phi, e)
            if the_gcd[0] == 1:
                break
        d = modinv(e, phi)
        return d, e, n, p, phi, q

    def __init__(self, bit_length=64):
            d, e, n, p, phi, q = self.generate_rsa_key(bit_length)
            self.public_key = (n, e)
            self.private_key = (n, d, p, q, phi)

    def run_server(self):
        serv = socket( AF_INET,SOCK_STREAM)
        ADDR = (lIP, lPort)
        print "[+] Binding and listening on %s:%s" % ADDR
        serv.bind(ADDR)    #the double parens are to create a tuple with one element
        serv.listen(5)    #5 is the maximum number of queued connections we'll allow
        while True:
            conn, addr = serv.accept()
            if conn != None:
                self.known_keys[addr] = []
                t = Thread(target=self.handle_client, args=(conn, addr))
                t.start()

    def handle_client(self, conn, addr):
        conn.send('PUB(%s,%s)' % self.public_key)
        while 1:
            data = conn.recv(BUFSIZE)
            msg_body = data[4:-1:]
            if data[0:3] == "PUB":
                sp = msg_body.split(',')
                self.known_keys[addr] = [int(sp[0]), int(sp[1]), '', '', None]
                print "[+] Recieved public key from %s, (%s,%s)" % (addr[0] + ':' + str(addr[1]), sp[0], sp[1])
            elif data[0:3] == "MSG":
                print "[+] Decoding a message: '%s'" % msg_body
                connection_key = self.known_keys[addr]
                if connection_key[2] == '':
                    plaintext = ''
                    sp = [int(a) for a in msg_body.split(',')]
                    for a in sp:
                        plaintext += chr(pow(a, self.private_key[1], self.private_key[0]))
                    plaintext = plaintext.strip().split(',')
                    connection_key[2] = plaintext[0]
                    connection_key[3] = plaintext[1]
                    print "Received AES key %s" % plaintext
                    obj = AES.new(connection_key[2], AES.MODE_CBC, connection_key[3])
                    self.known_keys[addr][4] = obj
                    conn.send('MSG(%s)' % self.known_keys[addr][4].encrypt("Welcome".ljust(16)))
                else:
                    plaintext = self.known_keys[addr][4].decrypt(msg_body)
                    plaintext = plaintext.strip()
                    if plaintext == "END":
                        print "[+] User Ended Conversation"
                        break
                    print "[+] Recieved '%s' from %s, enter your response: " % (plaintext, addr[0])
                    response = sys.stdin.readline()
                    enc_msg = 'MSG(%s)' % self.known_keys[addr][4].encrypt(response.ljust(16))
                    print "[+] Sending - " + enc_msg
                    conn.send(enc_msg)
        conn.close()

    @staticmethod
    def encrypt_msg(msg, pub_key):
        if msg.strip() == "END":
            return msg
        letters = [ord(a) for a in msg]
        encrypted = ','.join([str(pow(ascii_code, pub_key[1], pub_key[0])) for ascii_code in letters])
        s_encrypted = 'MSG(%s)' % encrypted
        return s_encrypted

class RSAClient(object):
    server_key = ()

    def __init__(self, bit_length):
        d, e, n, p, phi, q = RSAServer.generate_rsa_key(bit_length)
        self.public_key = (n, e)
        self.private_key = (n, d, p, q, phi)
        self.iv = ''.join(random.sample(string.ascii_letters, 16))
        self.aes = AES.new(aesKey, AES.MODE_CBC, self.iv)

    def connect(self):
        cli = socket( AF_INET,SOCK_STREAM)
        ADDR = (rIP, rPort)

        cli.connect((ADDR))

        while True:
            data = cli.recv(BUFSIZE)
            if data[0:3] == "PUB":
                sp = data[4:-1:].split(',')
                self.server_key = (int(sp[0]), int(sp[1]))
                print "[+] Recieved public key from server, (%s,%s)" % (sp[0], sp[1])
                cli.send('PUB(%s,%s)' % self.public_key)
                cli.send(RSAServer.encrypt_msg(aesKey + "," + self.iv, self.server_key))
            elif data[0:3] == "MSG":
                print "[+] Decrypting %s" % data[4:-1:]
                plaintext = self.aes.decrypt(data[4:-1:])
                plaintext = plaintext.strip()
                if plaintext == "END":
                    break
                print "[+] Recieved '%s', enter your response: " % plaintext
                response = sys.stdin.readline()
                enc_msg = 'MSG(%s)' % self.aes.encrypt(response.ljust(16))
                print "[+] Sending - " + enc_msg
                cli.send(enc_msg)
                if response.startswith("END"):
                    break
            elif data[0:3] == "END":
                break
        cli.close()

if __name__ == "__main__":
    if len(sys.argv) >= 4:
        bitLength = int(sys.argv[4])
        if sys.argv[1] == "server":
            lIP = sys.argv[2]
            lPort = int(sys.argv[3])
            rsa = RSAServer(bitLength)
            rsa.run_server()
        elif sys.argv[1] == "connect":
            rIP = sys.argv[2]
            rPort = int(sys.argv[3])
            aesKey = sys.argv[5]
            rsa = RSAClient(bitLength)
            rsa.connect()
    else:
        print "[-] Check Usage"