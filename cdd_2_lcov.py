#!/usr/bin/env python3
import re, sys, os

DB_TYPE_SIGNAL        = 1
DB_TYPE_EXPRESSION    = 2
DB_TYPE_FUNIT         = 3
DB_TYPE_STATEMENT     = 4
DB_TYPE_INFO          = 5
DB_TYPE_FSM           = 6
DB_TYPE_RACE          = 7
DB_TYPE_SCORE_ARGS    = 8
DB_TYPE_SU_START      = 9
DB_TYPE_SU_END        = 10
DB_TYPE_MESSAGE       = 11
DB_TYPE_MERGED_CDD    = 12
DB_TYPE_EXCLUDE       = 13
DB_TYPE_FUNIT_VERSION = 14
DB_TYPE_INST_ONLY     = 15

EXP_OP_STATIC           =  0
EXP_OP_SIG              =  1
EXP_OP_XOR              =  2
EXP_OP_MULTIPLY         =  3
EXP_OP_DIVIDE           =  4
EXP_OP_MOD              =  5
EXP_OP_ADD              =  6
EXP_OP_SUBTRACT         =  7
EXP_OP_AND              =  8
EXP_OP_OR               =  9
EXP_OP_NAND             = 10
EXP_OP_NOR              = 11
EXP_OP_NXOR             = 12
EXP_OP_LT               = 13
EXP_OP_GT               = 14
EXP_OP_LSHIFT           = 15
EXP_OP_RSHIFT           = 16
EXP_OP_EQ               = 17
EXP_OP_CEQ              = 18
EXP_OP_LE               = 19
EXP_OP_GE               = 20
EXP_OP_NE               = 21
EXP_OP_CNE              = 22
EXP_OP_LOR              = 23
EXP_OP_LAND             = 24
EXP_OP_COND             = 25
EXP_OP_COND_SEL         = 26
EXP_OP_UINV             = 27
EXP_OP_UAND             = 28
EXP_OP_UNOT             = 29
EXP_OP_UOR              = 30
EXP_OP_UXOR             = 31
EXP_OP_UNAND            = 32
EXP_OP_UNOR             = 33
EXP_OP_UNXOR            = 34
EXP_OP_SBIT_SEL         = 35
EXP_OP_MBIT_SEL         = 36
EXP_OP_EXPAND           = 37
EXP_OP_CONCAT           = 38
EXP_OP_PEDGE            = 39
EXP_OP_NEDGE            = 40
EXP_OP_AEDGE            = 41
EXP_OP_LAST             = 42
EXP_OP_EOR              = 43
EXP_OP_DELAY            = 44
EXP_OP_CASE             = 45
EXP_OP_CASEX            = 46
EXP_OP_CASEZ            = 47
EXP_OP_DEFAULT          = 48
EXP_OP_LIST             = 49
EXP_OP_PARAM            = 50
EXP_OP_PARAM_SBIT       = 51
EXP_OP_PARAM_MBIT       = 52
EXP_OP_ASSIGN           = 53
EXP_OP_DASSIGN          = 54
EXP_OP_BASSIGN          = 55
EXP_OP_NASSIGN          = 56
EXP_OP_IF               = 57
EXP_OP_FUNC_CALL        = 58
EXP_OP_TASK_CALL        = 59
EXP_OP_TRIGGER          = 60
EXP_OP_NB_CALL          = 61
EXP_OP_FORK             = 62
EXP_OP_JOIN             = 63
EXP_OP_DISABLE          = 64
EXP_OP_REPEAT           = 65
EXP_OP_WHILE            = 66
EXP_OP_ALSHIFT          = 67
EXP_OP_ARSHIFT          = 68
EXP_OP_SLIST            = 69
EXP_OP_EXPONENT         = 70
EXP_OP_PASSIGN          = 71
EXP_OP_RASSIGN          = 72
EXP_OP_MBIT_POS         = 73
EXP_OP_MBIT_NEG         = 74
EXP_OP_PARAM_MBIT_POS   = 75
EXP_OP_PARAM_MBIT_NEG   = 76
EXP_OP_NEGATE           = 77
EXP_OP_NOOP             = 78
EXP_OP_ALWAYS_COMB      = 79
EXP_OP_ALWAYS_LATCH     = 80
EXP_OP_IINC             = 81
EXP_OP_PINC             = 82
EXP_OP_IDEC             = 83
EXP_OP_PDEC             = 84
EXP_OP_DLY_ASSIGN       = 85
EXP_OP_DLY_OP           = 86
EXP_OP_RPT_DLY          = 87
EXP_OP_DIM              = 88
EXP_OP_WAIT             = 89
EXP_OP_SFINISH          = 90
EXP_OP_SSTOP            = 91
EXP_OP_ADD_A            = 92
EXP_OP_SUB_A            = 93
EXP_OP_MLT_A            = 94
EXP_OP_DIV_A            = 95
EXP_OP_MOD_A            = 96
EXP_OP_AND_A            = 97
EXP_OP_OR_A             = 98
EXP_OP_XOR_A            = 99
EXP_OP_LS_A             =100
EXP_OP_RS_A             =101
EXP_OP_ALS_A            =102
EXP_OP_ARS_A            =103
EXP_OP_FOREVER          =104
EXP_OP_STIME            =105
EXP_OP_SRANDOM          =106
EXP_OP_PLIST            =107
EXP_OP_SASSIGN          =108
EXP_OP_SSRANDOM         =109
EXP_OP_SURANDOM         =110
EXP_OP_SURAND_RANGE     =111
EXP_OP_SR2B             =112
EXP_OP_SB2R             =113
EXP_OP_SSR2B            =114
EXP_OP_SB2SR            =115
EXP_OP_SI2R             =116
EXP_OP_SR2I             =117
EXP_OP_STESTARGS        =118
EXP_OP_SVALARGS         =119
EXP_OP_SSIGNED          =120
EXP_OP_SUNSIGNED        =121
EXP_OP_SCLOG2           =122

def usage():
    print()
    print("Usage:")
    print("  cdd_2_lcov <filename>")
    print()
    exit(1)

if len(sys.argv) != 2:
    usage()

if not os.path.exists(sys.argv[1]):
    print("%s not found" % sys.argv[1])
    exit(1)

with open(sys.argv[1], "r") as f:
    content = f.readlines()

filename = None
coverage = dict()
for line in content:
    data = line.split()
    if (int(data[0])==DB_TYPE_FUNIT and data[5]!='NA'):
        filename = data[5]
        if not (filename in coverage):
            coverage[filename] = dict()
    if (int(data[0])==DB_TYPE_EXPRESSION and data[5]!='NA'):
        op = int(data[2],16)
        lineno = int(data[3])
        exec_num = int(data[5],16)
        if op not in [EXP_OP_STATIC, EXP_OP_SIG, EXP_OP_PARAM, EXP_OP_PARAM_SBIT, EXP_OP_PARAM_MBIT, EXP_OP_DELAY, EXP_OP_CASE, EXP_OP_CASEX,EXP_OP_CASEZ,EXP_OP_DEFAULT,EXP_OP_NB_CALL,EXP_OP_FORK,EXP_OP_JOIN,EXP_OP_NOOP,EXP_OP_FOREVER,EXP_OP_RASSIGN]:
            if (lineno!=0):
                if not (lineno in coverage[filename]):
                    coverage[filename][lineno] = dict()    
                if not (op in coverage[filename][lineno]):
                    coverage[filename][lineno][op] = 0 
                
                coverage[filename][lineno][op] += exec_num

print("TN:")
for filename in sorted(coverage.keys()):
    print("SF:%s" % filename)
    file_coverage = coverage[filename]
    lines_covered = 0
    for lineno in sorted(file_coverage.keys()):
        if (0 in iter(file_coverage[lineno].values())):
            print("DA:%d,%d" % (lineno,0))
        else:
            print("DA:%d,%d" % (lineno,sum(file_coverage[lineno].values())))
            lines_covered+=1
    print("LF:%d" % len(file_coverage))
    print("LH:%d" % lines_covered)
    print("end_of_record")
