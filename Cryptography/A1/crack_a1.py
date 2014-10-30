import os
import string
import json

output_joiner = '    |    '

cipher_file = "cipher_correct"

CURRENT_CIPHER = json.loads(open("ciphers\\%s" % cipher_file, "r").read())
CURRENT_CIPHER['\n'] = '\n'
CURRENT_CIPHER[' '] = ' '

def display_word(da_word):
    """
    da_word='CRYPTOGRAPHY'
    output=
      1  2  3  4  5  6  7  8  9 10 11 12
      C  R  Y  P  T  O  G  R  A  P  H  Y
    """
    int_str = ''.join([str(i+1).rjust(3) for i in range(len(da_word))])
    let_str = ''.join([i.rjust(3) for i in list(da_word)])
    print "=" * len(int_str)
    print '\n'.join((int_str, let_str))
    print "=" * len(int_str)

def check_repeat_substrings(the_string, l):
    """
    Searches through a string and returns a dictionary of all the l-length substrings, and their number of occurrences
    """
    repeat_count = {}
    for i in range(len(the_string) - (l - 1)):
        substr = the_string[i:i + l:]
        if not substr in repeat_count.keys():
            repeat_count[substr] = 0
        repeat_count[substr] += 1
    sorted_res = sorted(repeat_count.items(), key=lambda x: x[1], reverse=True)
    write_sorted_to_file("stats" + os.sep + "Repeats_len_%s.txt" % l, sorted_res)
    return sorted_res

def check_repeats():
    repeat_count = {}
    for i in range(len(cipher_text) - 1):
        if cipher_text[i + 1] == cipher_text[i]:
            if not cipher_text[i] * 2 in repeat_count.keys():
                repeat_count[cipher_text[i] * 2] = 0
            repeat_count[cipher_text[i] * 2] += 1
    sorted_res = sorted(repeat_count.items(), key=lambda x: x[1], reverse=True)
    write_sorted_to_file("stats" + os.sep + "RepeatLetters.txt", sorted_res)
    return sorted_res

def make_replacements(msg):
    characters = list(msg)
    for i in range(len(characters)):
        characters[i] = CURRENT_CIPHER[characters[i]]
    decrypted = ''.join(characters)
    return decrypted

def count_characters(s):
    """
    Counts the frequencies of the letters in given string
    """
    char_count = {}
    for c in s:
        if not c in char_count.keys():
            char_count[c] = 0
        char_count[c] += 1
    for c in char_count.keys():
        char_count[c] = (float(char_count[c]) / len(s)) * 100.0
    sorted_res = sorted(char_count.items(), key=lambda x: x[1], reverse=True)
    write_sorted_to_file("stats" + os.sep + "Frequencies.txt", sorted_res)

def write_sorted_to_file(filename, s):
    with open(filename, "w") as o:
        for item in s:
            o.write("%s:%s\n" % (item[0], item[1]))

def check_stats():
    global big_line
    check_repeats()
    count_characters(big_line)
    check_repeat_substrings(big_line, len("ASSIGNMENT"))
    check_repeat_substrings(big_line, len("CRYPTOGRAPHY"))


if __name__ == "__main__":
    cipher_text = open("a1.cipher", "r").read()
    encrypted_lines = cipher_text.splitlines()
    longest_line = len(encrypted_lines[0])
    big_line = ''.join(encrypted_lines)

    check_stats()

    decrypted = make_replacements(cipher_text)

    with open("a1.plaintext", "w") as o:
        o.write(decrypted)

    decrypted_lines = decrypted.splitlines()

    zipped = zip(decrypted_lines, encrypted_lines)
    print output_joiner.join(("Decrypted Text".center(longest_line), "Encrypted Text".center(longest_line)))
    for z in zipped:
        print output_joiner.join((z[0].ljust(longest_line), z[1].ljust(longest_line)))

    print "Done"