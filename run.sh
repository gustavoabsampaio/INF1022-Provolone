set -e
yacc -d parser.y --report=all -v
flex parser.l
gcc -o parser lex.yy.c y.tab.c -ll
./parser $1