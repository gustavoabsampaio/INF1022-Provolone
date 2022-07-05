%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int yylex();
    void yyerror();
    extern int err_line;
    extern FILE *yyin;
    extern int indent_level;
%}



%union 
{
    int num; 
    char *id;
}

%token <num> ENTRADA SAIDA FACA INC ZERA ENQUANTO FIM VEZES SE ENTAO SENAO ABREPAR FECHAPAR IGUAL DEC MAIORI MENORI MAIOR MENOR IGUALA DIFERENTE FIMIF
%token <id> ID NUM
%type <id> program varlist cmds cmd cmp atomic
// %left '+' '-'
// %left '*' '/'

%%
program : 
    ENTRADA varlist SAIDA varlist cmds FIM
    {
        FILE *f = fopen("result.c", "w");
        char* codigo = malloc(strlen($2) + strlen($4)*2 + strlen($5) + 49);
        strcpy(codigo, "int provol(int ");
        strcat(codigo, $2);
        strcat(codigo,") \n{\n");
        strcat(codigo,"\tint ");
        strcat(codigo, $4);
        strcat(codigo, ";\n");
        strcat(codigo, $5);
        strcat(codigo, "\n");
        strcat(codigo, "\treturn ");
        strcat(codigo, $4);
        strcat(codigo, ";\n}\n");
        fprintf(f, "%s", codigo);
        fclose(f);
        printf("execução sucedida\n");
    };


varlist:
    varlist ID 
    {
        char* buff = malloc(strlen($1) + strlen($2) + 6);
        strcat(buff, $2);
        strcat(buff, ", int ");
        strcat(buff, $1);
        $$ = buff;
    }
    | ID 
    {
        char *buff = malloc(strlen($1));
        strcat(buff, $1);
        $$ = buff;
    };


cmds:
    cmd cmds 
    {
        char* buff = malloc(strlen($1) + strlen($2));
        strcpy(buff, $1);
        strcat(buff, $2);
        $$ = buff;
    };
    | cmd 
    {
      $$ = $1;
    };


cmd:
    ENQUANTO cmp FACA cmds FIM
    {
        char* buff = malloc(strlen($2) + strlen($4) + 25);
        strcpy(buff, "\n\twhile(");
        strcat(buff, $2);
        strcat(buff, ")\n\t{\n\t");
        strcat(buff, $4);
        strcat(buff, "\t}\n");
        $$ = buff;
    };
    // | FACA cmds ENQUANTO cmp FIM
    // {
    //     char* buff = malloc(strlen($2) + strlen($4) + 29);
    //     strcpy(buff, "\tdo\n\t{\n");
    //     strcat(buff, $4);
    //     strcat(buff, "\n\t}\t");
    //     strcat(buff, "\twhile(");
    //     strcat(buff, $2);
    //     strcat(buff, ")\n");
    //     $$ = buff;
    // };
    | FACA atomic VEZES cmds FIM
    {
        char* buff = malloc(strlen($2) + strlen($4) + 43);
        strcpy(buff, "\n\tfor(int i = 0; i < ");
        strcat(buff, $2);
        strcat(buff, "; i++)\n\t{\n\t");
        strcat(buff, $4);
        strcat(buff, "\t}\n");
        $$ = buff;
    }
    | SE cmp ENTAO FACA cmds FIMIF
    {
        char* buff = malloc(strlen($2) + strlen($5) + 22);
        strcpy(buff, "\tif(");
        strcat(buff, $2);
        strcat(buff, ")\n\t{\n\t");
        strcat(buff, $5);
        strcat(buff, "\t}\n");
        $$ = buff;
    }
    | SE cmp ENTAO FACA cmds SENAO FACA cmds FIMIF
    {
        char* buff = malloc(strlen($2) + strlen($5) + strlen($8) + 44);
        strcpy(buff, "\n\tif(");
        strcat(buff, $2);
        strcat(buff, ")\n\t{\n\t");
        strcat(buff, $5);
        strcat(buff, "\t}\n\telse\n\t{\n\t");
        strcat(buff, $8);
        strcat(buff, "\t}\n");
        $$ = buff;
    }
    | ID IGUAL atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 8);
        strcpy(buff, "\t");
        strcat(buff, $1);
        strcat(buff, " = ");
        strcat(buff, $3);
        strcat(buff, ";\n");
        $$ = buff;
    };
    | INC ABREPAR ID FECHAPAR
    {
        char* buff = malloc(strlen($3) + 5);
        strcpy(buff, "\t");
        strcat(buff, $3);
        strcat(buff, "++;\n");
        $$ = buff;
    };
    | DEC ABREPAR ID FECHAPAR
    {
        char* buff = malloc(strlen($3) + 5);
        strcpy(buff, "\t");
        strcat(buff, $3);
        strcat(buff, "--;\n");
        $$ = buff;
    };
    | ZERA ABREPAR ID FECHAPAR
    {
        char* buff = malloc(strlen($3) + 7);
        strcpy(buff, "\t");
        strcat(buff, $3);
        strcat(buff, " = 0;\n");
        $$ = buff;
    };

atomic: 
    NUM {
        char* buff = malloc(strlen($1));
        strcpy(buff, $1);
        $$ = buff;
    };
    | ID 
    {
        char* buff = malloc(strlen($1));
        strcpy(buff, $1);
        $$ = buff;
    };


// operacao:
//     atomic '+' atomic
//     {
//         char* buff = malloc(strlen($1) + strlen($3) + 3);
//         strcpy(buff, $1);
//         strcat(buff, " + ");
//         strcat(buff, $3);
//         $$ = buff;
//     };
//     | atomic '-' atomic
//     {
//         char* buff = malloc(strlen($1) + strlen($3) + 3);
//         strcpy(buff, $1);
//         strcat(buff, " - ");
//         strcat(buff, $3);
//         $$ = buff;
//     };
//     | atomic '*' atomic
//     {
//         char* buff = malloc(strlen($1) + strlen($3) + 3);
//         strcpy(buff, $1);
//         strcat(buff, " * ");
//         strcat(buff, $3);
//         $$ = buff;
//     };
//     | atomic '/' atomic
//     {
//         char* buff = malloc(strlen($1) + strlen($3) + 3);
//         strcpy(buff, $1);
//         strcat(buff, " / ");
//         strcat(buff, $3);
//         $$ = buff;
//     };
//     | atomic
//     // | ABREPAR operacao FECHAPAR
//     // {
//     //     char* buff = malloc(strlen($2) + 2);
//     //     strcpy(buff, "(");
//     //     strcat(buff, $2);
//     //     strcat(buff, ")");
//     //     $$ = buff;
//     // };


cmp:
    atomic
    {
        char* buff = malloc(strlen($1));
        strcpy(buff, $1);
        $$ = buff;
    };
    | atomic MAIORI atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 3);
        strcpy(buff, $1);
        strcat(buff, " >= ");
        strcat(buff, $3);
        $$ = buff;
    };
    | atomic MENORI atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 3);
        strcpy(buff, $1);
        strcat(buff, " <= ");
        strcat(buff, $3);
        $$ = buff;
    };
    | atomic MAIOR atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 3);
        strcpy(buff, $1);
        strcat(buff, " > ");
        strcat(buff, $3);
        $$ = buff;
    };
    | atomic MENOR atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 3);
        strcpy(buff, $1);
        strcat(buff, " < ");
        strcat(buff, $3);
    };
    | atomic IGUALA atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 3);
        strcpy(buff, $1);
        strcat(buff, " == ");
        strcat(buff, $3);
    };
    | atomic DIFERENTE atomic
    {
        char* buff = malloc(strlen($1) + strlen($3) + 3);
        strcpy(buff, $1);
        strcat(buff, " != ");
        strcat(buff, $3);
        $$ = buff;
    };


%%

void yyerror(){
  fprintf(stderr, "Syntax error: %d\n", err_line);
};  

int main (int argc, char** argv) {
    if (argc < 1) {
        printf("passe o nome do arquivo a ser lido como argumento\n");
    }
    yyin = fopen(argv[1], "r");
    yyparse();
    fclose(yyin);
    return 0;
}

