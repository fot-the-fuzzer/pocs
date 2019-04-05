#!/usr/bin/env python

import os
import sys


def write_to_file(line, out_fpath):
    with open(out_fpath, 'w') as out_f:
        out_f.write(line)

def write_line_to_files(in_fpath, out_dir):
    i = 0
    with open(in_fpath, 'r') as infile:
        for line in infile.readlines():
            out_fpath = os.path.join(out_dir, "{:04}.in".format(i))
            write_to_file(line, out_fpath)
            i += 1
    print("{} files written".format(i))


write_line_to_files(sys.argv[1], sys.argv[2])
