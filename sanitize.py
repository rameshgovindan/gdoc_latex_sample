#!/usr/bin/python

import os
import sys
import re
import fileinput

sec = re.compile('^\#')
bib = re.compile('^\# Bibliography')
bibseen = False

with open(sys.argv[1], 'r') as inf:
    for line in inf:
        # Remove non-ascii characters
        line = ''.join(i for i in line if ord(i)<128)
        # Add blank line before section
        if (sec.match(line)):
            sys.stdout.write("")
        # Google doc spits out comments/suggestions etc at the end of the text, remove these
        if not bibseen:
            sys.stdout.write(line)
        if (bib.match(line)):
            bibseen = True

        
