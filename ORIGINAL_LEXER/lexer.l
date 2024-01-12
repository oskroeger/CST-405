%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#define YY_DECL int yylex()

int words = 0;
int chars = 0;
int lines = 1;

%}

letter      [a-zA-Z]
digit       [0-9]
ID          {letter}({letter}|{digit})*
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?
ws          [ \t]+

%%

{ws}    { chars += strlen(yytext); }
\r\n|\n|\r  { lines++; chars = 0; }

"/*" {
    int c;
    while ((c = input()) != 0) {
        chars++;
        if (c == '\n') {
            lines++;
            chars = 0;
        } else if (c == '*') {
            if ((c = input()) == '/') {
                chars++;
                break;
            } else {
                unput(c);
            }
        }
    }
}

"int" {
	words++;
	chars += strlen(yytext);
	printf("%s : TYPE\n", yytext);
}

"char" {
	words++;
	chars += strlen(yytext);
	printf("%s : TYPE\n", yytext);
}

"write" {
	words++;
	chars += strlen(yytext);
	printf("%s : KEYWORD\n", yytext);
}

{ID} {
	words++;
	chars += strlen(yytext);
	printf("%s : IDENTIFIER\n", yytext);
}

{NUMBER} {
	words++;
	chars += strlen(yytext);
	printf("%s : NUMBER\n", yytext);
}

";" {
	chars++;
	printf("%s : SEMICOLON\n", yytext);
}

"=" {
	chars++;
	printf("%s : EQ\n", yytext);
}

"+" {
	chars++;
	printf("%s : ADD\n", yytext);
}

"-" {
	chars++;
	printf("%s : SUB\n", yytext);
}

"*" {
	chars++;
	printf("%s : MUL\n", yytext);
}

"/" {
	chars++;
	printf("%s : DIV\n", yytext);
}

"(" {
	chars++;
	printf("%s : LPAREN\n", yytext);
}

")" {
	chars++;
	printf("%s : RPAREN\n", yytext);
}

"{" {
	chars++;
	printf("%s : LBRACE\n", yytext);
}

"}" {
	chars++;
	printf("%s : RBRACE\n", yytext);
}

"<" {
	chars++;
	printf("%s : LANGLEBRACE\n", yytext);
}

">" {
	chars++;
	printf("%s : LANGLEBRACE\n", yytext);
}

"[" {
	chars++;
	printf("%s : LBRACKET\n", yytext);
}

"]" {
	chars++;
	printf("%s : RBRACKET\n", yytext);
}

"," {
	chars++;
	printf("%s : COMMA\n", yytext);
}

. {
	chars++;
	printf("%s - Unrecognized symbol at line %d char %d\n", yytext, lines, chars);
}

%%

int main(int argc, char **argv) {
    #ifdef YYDEBUG
    yydebug = 1;
    #endif

    printf("Compiler started. \n\n");

    if (argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            perror(argv[1]);
            return (1);
        }
    }
    yylex();
}
