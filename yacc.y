%{
    #include <stdio.h>
    int yyerror();
    int yylex();
    FILE* yyin;
%}

%token NUM
%token ID
%token RELOP
%token BcsMain
%token INT
%token BOOL
%token IF
%token ELSE
%token WHILE

%left '+'
%left '*'

%%

program: BcsMain '{' declist stmtlist '}'
       ;

declist: declist decl
       | decl
       ;

decl: type ID ';'
    ;

type: INT
    | BOOL
    ;

stmtlist: stmtlist ';' stmt
        | stmt

stmt: ID '=' aexpr
    | IF '(' expr ')' '{' stmtlist '}' ELSE '{' stmtlist '}' 
    | WHILE '(' expr ')' '{' stmtlist '}' 
    ;

expr: aexpr RELOP aexpr 
    | aexpr
    ;

aexpr: aexpr '+' aexpr 
     | term
     ;

term: term '*' factor
    | factor
    ;

factor: ID
      | NUM
      ;

%%


int yyerror() {
    printf("Syntax Error\n");
    return 1;
}

int main(int argc, char** argv) {
    yyin = fopen(argv[1], "r");
    int res = yyparse();
    if(res == 0)
        printf("Parsing Successful\n");
    return 0;
}