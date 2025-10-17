%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "./y.tab.h"

%}

digit [0-9]
letter [a-zA-Z]
id {letter}({letter}|{digit})*
num {digit}+
relop "<"|">"|"<="|">="|"=="|"!="

%%

"BcsMain"       {return BcsMain;}

"if"            {return IF;}

"else"          {return ELSE;}

"while"         {return WHILE;}

"int"           {return INT;}

"bool"          {return BOOL;}

{num}           {yylval.s = strdup(yytext); return NUM;}

{id}            {yylval.s = strdup(yytext); return ID;}

{relop}         {return RELOP;}

[{}();=+*]      {return *yytext;}

[ \t\n]+        {}

.               {return -1;}

%%

int yywrap() {
    return 1;
}