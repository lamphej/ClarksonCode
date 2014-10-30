# Cryptography Assignment 1

This is my Code I wrote for the decryption of Assignment 1 in my Cryptography class.
The "Substitution Table" that I used for my decryption is located in ciphers/cipher_correct.

I cracked this assignment by first writing functions to find substrings of a given length in a string.
My plan was to use this function to find large, unique looking words in the assignment, and then work on the cipher from
there.  For these words, I chose 2 that I felt HAD to be there, "CRYPTOGRAPHY" and "ASSIGNMENT".  I then wrote my helper
script (helper.py) which would look in these files, and find any of the strings that "matched" the real word I was after
ie: characters 2 and 3 would have to be the same in "ASSIGNMENT" as well as characters 7 and 10.  I applied more of 
these "rules" until I only had 1 match for each. 

```
==============================
  1  2  3  4  5  6  7  8  9 10
  A  S  S  I  G  N  M  E  N  T
==============================
==============================
  1  2  3  4  5  6  7  8  9 10
  T  Y  Y  G  I  U  Q  F  U  C
==============================
```

and

```
====================================
  1  2  3  4  5  6  7  8  9 10 11 12
  C  R  Y  P  T  O  G  R  A  P  H  Y
====================================
====================================
  1  2  3  4  5  6  7  8  9 10 11 12
  L  M  X  Z  C  J  I  M  T  Z  N  X
====================================
```

I took these letters, and used them as the start for my substitution table, from there it became easy to find more 
letters because my scripts allowed me to quickly alter my cipher and run it again, while easily seeing the differences.

Example output is below
```
        Decrypted Text            |            Encrypted Text        
IFYOUAREREADINGTHISINENGLISHTH    |    GOXJPTMFMFTRGUICNGYGUFUIBGYNCN
ENYOUAREREADINGTHEPLAINTEXTOFT    |    FUXJPTMFMFTRGUICNFZBTGUCFECJOC
HEFIRSTASSIGNMENTINOURCRYPTOGR    |    NFOGMYCTYYGIUQFUCGUJPMLMXZCJIM
APHYCOURSETHISASSIGNMENTWASSUP    |    TZNXLJPMYFCNGYTYYGIUQFUCWTYYPZ
POSEDLYPOSTEDTWODAYSBEFORETHEE    |    ZJYFRBXZJYCFRCWJRTXYHFOJMFCNFF
NDOFTHEEIGHTHMONTHINTHEYEAROFT    |    URJOCNFFGINCNQJUCNGUCNFXFTMJOC
WENTYFOURTEENASYOUHAVEDISCOVER    |    WFUCXOJPMCFFUTYXJPNTSFRGYLJSFM
EDBYCRACKINGTHISASSIGNMENTITWA    |    FRHXLMTLVGUICNGYTYYGIUQFUCGCWT
SENCRYPTEDUSINGASIMPLEMONOALPH    |    YFULMXZCFRPYGUITYGQZBFQJUJTBZN
ABETICSUBSTITUTIONCIPHERFORTHI    |    THFCGLYPHYCGCPCGJULGZNFMOJMCNG
SASSIGNMENTSUBMITTHEFOLLOWINGI    |    YTYYGIUQFUCYPHQGCCNFOJBBJWGUIG
TEMSBYEMAILATLEASTBEFORETHETHI    |    CFQYHXFQTGBTCBFTYCHFOJMFCNFCNG
RDWEEKOFTHEFOLLOWINGMONTHFIRST    |    MRWFFVJOCNFOJBBJWGUIQJUCNOGMYC
PROVIDETHESUBSTITUTIONTABLEUSE    |    ZMJSGRFCNFYPHYCGCPCGJUCTHBFPYF
DFORTHELETTERSPRESENTINTHEPLAI    |    ROJMCNFBFCCFMYZMFYFUCGUCNFZBTG
NTEXTSECONDDESCRIBEHOWYOUBROKE    |    UCFECYFLJURRFYLMGHFNJWXJPHMJVF
THISCIPHERTHIRDDESCRIBEANDIMPL    |    CNGYLGZNFMCNGMRRFYLMGHFTURGQZB
EMENTYOUROWNCIPHERSYSTEMFORENC    |    FQFUCXJPMJWULGZNFMYXYCFQOJMFUL
RYPTINGANDDECRYPTINGTEXTFILESY    |    MXZCGUITURRFLMXZCGUICFECOGBFYX
OUMAYUSEANYPROGRAMMINGLANGUAGE    |    JPQTXPYFTUXZMJIMTQQGUIBTUIPTIF
OFYOURCHOICEASPARTOFTHESUBMISS    |    JOXJPMLNJGLFTYZTMCJOCNFYPHQGYY
IONFORTHETHIRDPARTPROVIDEALIVE    |    GJUOJMCNFCNGMRZTMCZMJSGRFTBGSF
DEMONSTRATIONOFYOURSYSTEMFOURT    |    RFQJUYCMTCGJUJOXJPMYXYCFQOJPMC
HWRITEASHORTREPORTONTHESTATIST    |    NWMGCFTYNJMCMFZJMCJUCNFYCTCGYC
ICALLETTERFREQUENCIESOFENGLISH    |    GLTBBFCCFMOMFDPFULGFYJOFUIBGYN
INCOMPARISONWITHOTHERLANGUAGES    |    GULJQZTMGYJUWGCNJCNFMBTUIPTIFY
DETERMINEIFENGLISHISCONSIDERED    |    RFCFMQGUFGOFUIBGYNGYLJUYGRFMFR
THELEASTRANDOMOFMOSTNATURALLAN    |    CNFBFTYCMTURJQJOQJYCUTCPMTBBTU
GUAGES                            |    IPTIFY                        
Done
```