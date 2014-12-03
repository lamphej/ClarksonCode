from datetime import datetime
from Crypto.Util.number import bignum
from progressbar import ProgressBar

if __name__ == "__main__":
    p = 14674584631911578835797418783385886014282097732848477104726443478638332485502347247543655947605449957396117669498208741164913923801974405155475348168889579

    q = 7337292315955789417898709391692943007141048866424238552363221739319166242751173623771827973802724978698058834749104370582456961900987202577737674084444789

    g = 4982841904814869672085039202622244483970253128052169343896265812258636257432659143378521974063258583724954123861596060493488326314054712412448027305717254

    g_squared_modp = 4512332801204145837647149816192207114690569993766496571525710001167915985214512678196010903604329224278200626019048368054570643789087312844115891682754848

    g_qd_modp = 14674584631911578835797418783385886014282097732848477104726443478638332485502347247543655947605449957396117669498208741164913923801974405155475348168889578

    a = 8385809758725413340345527512446047025233684014661139532797265337676097725723596969305230319151167266083830582325785380987669989704814122581554084050167540

    b = 9111900488916451317627454621907193345267024264535396935398533304218215650993309410206906051098315918657553576294918817950897114918977375048148520131923664

    decrypt_exponent = p - 1 - a

    print "p: %s, %s digits" % (p, len(str(p)))
    print "g: %s, %s digits" % (g, len(str(g)))
    print "b: %s, %s digits" % (b, len(str(b)))

    cipher_lines =  open("a3.cipher", "r").read().splitlines()
    cipher_lines  = [line.split(',') for line in cipher_lines]

    plain_text = ''
    for line in cipher_lines:
        halfmask = bignum(line[0])
        cipher = bignum(line[1])
        m = pow(halfmask, decrypt_exponent, p) * cipher % p
        plain_text += chr(m)
    print "Done"
    with open("a3.plain", "w") as o:
        o.write(plain_text)
    print plain_text