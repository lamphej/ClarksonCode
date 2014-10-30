import os
from crack_a1 import display_word

stats_path = 'stats'

def find_assignment():
    display_word("ASSIGNMENT")
    matches = [l.split(':')[0] for l in open(stats_path + os.sep + "Repeats_len_10.txt", "r").read().splitlines()]
    matches = [l for l in matches if l[1] == l[2]]
    matches = [l for l in matches if l[5] == l[8]]
    matches = [l for l in matches if not l[0] in l[1:]]
    matches = [l for l in matches if not l[3] in l[4:]]
    for l in matches:
        display_word(l)


def find_cryptography():
    display_word("CRYPTOGRAPHY")
    matches = [l.split(':')[0] for l in open(stats_path + os.sep + "Repeats_len_12.txt", "r").read().splitlines()]
    matches = [l for l in matches if l[2] == l[11]]
    matches = [l for l in matches if l[1] == l[7]]
    matches = [l for l in matches if l[3] == l[9]]
    matches = [l for l in matches if not l[0] in l[1:]]
    for l in matches:
        display_word(l)


if __name__ == "__main__":
    find_cryptography()
    #find_assignment()