%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"

    int err_line = 1;
    int indent_level = 1;
%}

%%
ENTRADA     { yylval.id=strdup(yytext); return (ENTRADA);}
SAIDA       { yylval.id=strdup(yytext); return (SAIDA); }
ENQUANTO    { yylval.id=strdup(yytext); return (ENQUANTO); }
FACA        { yylval.id=strdup(yytext); indent_level++; return (FACA); }
VEZES       { yylval.id=strdup(yytext); return (VEZES); }
INC         { yylval.id=strdup(yytext); return (INC); }
DEC         { yylval.id=strdup(yytext); return (DEC); }
ZERA        { yylval.id=strdup(yytext); return (ZERA); }
FIM         { yylval.id=strdup(yytext); indent_level--; return (FIM); }
FIMIF       { yylval.id=strdup(yytext); indent_level--; return (FIMIF); }
SE          { yylval.id=strdup(yytext); indent_level++; return (SE); }
ENTAO       { yylval.id=strdup(yytext); return (ENTAO); }
SENAO       { yylval.id=strdup(yytext); return (SENAO); }
"("         { yylval.id=strdup(yytext); return (ABREPAR); }
")"         { yylval.id=strdup(yytext); return (FECHAPAR); }
"="         { yylval.id=strdup(yytext); return (IGUAL); }
(>=)        { yylval.id=strdup(yytext); return (MAIORI); }
(<=)        { yylval.id=strdup(yytext); return (MENORI); }
(>)         { yylval.id=strdup(yytext); return (MAIOR); }
(<)         { yylval.id=strdup(yytext); return (MENOR); }
(==)        { yylval.id=strdup(yytext); return (IGUALA); }
(!=)        { yylval.id=strdup(yytext); return (DIFERENTE); }
[_a-zA-Z][_a-zA-Z0-9]*    { yylval.id=strdup(yytext); return(ID); }
[0-9]+      { yylval.id=strdup(yytext); return(NUM); }
[\n]        { err_line++; }
[ \t]         {}
"+"        { yylval.id=strdup(yytext); return (MAIS); }
"-"        { yylval.id=strdup(yytext); return (MENOS); }   
"*"        { yylval.id=strdup(yytext); return (MULT); }
"/"        { yylval.id=strdup(yytext); return (DIVIDE); }
%%