%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yyerror();
    int yylex();
    char* codeGenArith(char*,char*,char);
    void codeGenAssign(char*,char*);
    FILE* yyin;

    int tidx = 0;
%}

%union {
    char* s;
}

%token <s> NUM ID
%token RELOP BcsMain INT BOOL IF ELSE WHILE

%type <s> factor term aexpr

%nonassoc '='
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
          ;

stmt: ID '=' aexpr {
            codeGenAssign($1,$3);
      }|

      IF '(' expr ')' '{' stmtlist '}' ELSE '{' stmtlist '}'
      |

      WHILE '(' expr ')' '{' stmtlist '}'
      ;

expr: aexpr RELOP aexpr 
    | aexpr
    ;

aexpr: aexpr '+' aexpr {
            $$ = codeGenArith($1,$3,'+');
       }| 
  
       term {
            $$ = $1;    
       };

term: term '*' factor {
            $$ = codeGenArith($1,$3,'*');
      }|

      factor {
            $$ = $1;
      };

factor: ID {
            $$ = $1;
        }|

        NUM {
            $$ = $1;
        };

%%

char* codeGenArith(char* x, char* y, char op) {
    tidx++;
    char temp[4] = "t";
    sprintf(temp + strlen(temp), "%d", tidx);
    printf("%s = %s %c %s\n", temp, x, op, y);
    return strdup(temp);
}

void codeGenAssign(char* x, char* y) {
    printf("%s = %s\n\n", x, y);
}


int yyerror() {
    printf("Syntax Error\n");
    return 1;
}

int main(int argc, char** argv) {
    freopen("tac.txt","w",stdout);
    yyin = fopen(argv[1], "r");
    int res = yyparse();
    // if(res == 0)
    //    printf("Parsing Successful\n");
    fclose(stdout);
    return 0;
}