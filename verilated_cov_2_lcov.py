#!/usr/bin/env python3
import re, sys, os

VL_CIK_COL0="c0"
VL_CIK_COL0_NAME="C0"
VL_CIK_COL1="c1"
VL_CIK_COL1_NAME="C1"
VL_CIK_COL2="c2"
VL_CIK_COL2_NAME="C2"
VL_CIK_COL3="c3"
VL_CIK_COL3_NAME="C3"
VL_CIK_COLUMN="n"
VL_CIK_COMMENT="o"
VL_CIK_FILENAME="f"
VL_CIK_GROUPCMT="O"
VL_CIK_GROUPDESC="d"
VL_CIK_GROUPNAME="g"
VL_CIK_HIER="h"
VL_CIK_LIMIT="L"
VL_CIK_LINENO="l"
VL_CIK_PER_INSTANCE="P"
VL_CIK_ROW0="r0"
VL_CIK_ROW0_NAME="R0"
VL_CIK_ROW1="r1"
VL_CIK_ROW1_NAME="R1"
VL_CIK_ROW2="r2"
VL_CIK_ROW2_NAME="R2"
VL_CIK_ROW3="r3"
VL_CIK_ROW3_NAME="R3"
VL_CIK_TABLE="T"
VL_CIK_THRESH="s"
VL_CIK_TYPE="t"
VL_CIK_WEIGHT="w"

VL_CIK_NUMBER="num"

def usage():
    print()
    print("Usage:")
    print("  verilated_cov_2_lcov <filename>")
    print()
    exit(1)

if len(sys.argv) != 2:
    usage()

if not os.path.exists(sys.argv[1]):
    print("%s not found" % sys.argv[1])
    exit(1)

with open(sys.argv[1], "r") as f:
    header = f.readline()
    if (header.strip() != "# SystemC::Coverage-3"):
        print("Not valid verilated file")
        exit(-1)
    content = f.readlines()
cnt = 2

coverage_data = list()
for line in content:
    if not (line.startswith("C '")):
        print("Error in line %d : %s" % (cnt, line))
        exit(-1)
    data = re.split("\001|\002",line[line.index("'")+2:line.rindex("'")])
    data.append(VL_CIK_NUMBER   )
    data.append(line[line.rindex("'")+1:].strip())

    coverage_data.append(dict(zip(data[::2], data[1::2])))


coverage = dict()
for data in coverage_data:
    filename = data.get(VL_CIK_FILENAME)
    if not (filename in coverage):
        coverage[filename] = dict()
    lineno = int(data.get(VL_CIK_LINENO))
    num = int(data.get(VL_CIK_NUMBER))
    if not (lineno in coverage[filename]):
        coverage[filename][lineno] = 0    
    coverage[filename][lineno] += num

print("TN:")
for filename in sorted(coverage.keys()):
    print("SF:%s" % filename)
    file_coverage = coverage[filename]
    lines_covered = 0
    for lineno in sorted(file_coverage.keys()):
        print("DA:%d,%d" % (lineno, file_coverage[lineno]))
        if file_coverage[lineno]!=0:
            lines_covered+=1
    print("LF:%d" % len(file_coverage))
    print("LH:%d" % lines_covered)
    print("end_of_record")
