%{
void yyerror(const char *s);
void printerror();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
int errors = 0;
%}

%token logical arithmetic comparison number id string comment assign boolean
%token BREAK CLASS CONTINUE DEF DEL ELIF ELSE EXCEPT EXEC FINALLY FOR FROM GLOBAL IF IMPORT IN PASS PRINT RANGE RETURN WHILE

%%

statement :
  | statement '\n'
  | statement assignment '\n'
  | statement assignment_norec '\n'
  | statement funcdef '\n'
  | statement return '\n'
  | statement if_stmt '\n'
  | statement for_stmt '\n'
  | statement while '\n'
  | statement comment '\n'
  | statement print '\n'
  | statement PASS '\n'
  | statement BREAK '\n'
  | statement CONTINUE '\n'
  | statement error '\n'	{printerror();}
  ;

value : number
  | boolean
  | id 
  | id '[' arithmetic_expr ']'
  | id '[' arithmetic_expr ']' '[' arithmetic_expr ']'
  | id '(' expressions ')'
  ;
  
expression : value
  | string
  | list
  | arithmetic_expr
  | logic_exp
  ;

expressions : 
  | expression exp_rec
  ;

exp_rec :
  | ',' expression exp_rec
  ;

logic_exp : '(' logic_exp ')'
  | value
  | comp_exp
  | logic_exp logical logic_exp
  ;
  
arithmetic_expr :  '(' arithmetic_expr ')'
  | value
  | arithmetic_expr arithmetic arithmetic_expr
  ;

comp_exp : '(' comp_exp ')'
  | arithmetic_expr
  | value
  | comp_exp comparison comp_exp
  ;

assignment : id assign_rec expression
  ;
  
assign_rec : '='
  | ',' id assign_rec expression ','
  ;
  
assignment_norec : '(' assignment_norec ')'
  | value assign value
  ;
  
while : WHILE logic_exp ':'
  ;
  
list : '[' expressions ']'
  ;
  
sequence : list 
  | RANGE '(' expressions ')' 
  | id
  ;

if_stmt : IF logic_exp ':' '\n' statement
  | IF logic_exp ':' '\n' statement ELIF logic_exp ':' '\n' statement ELSE ':' '\n' statement
  | IF logic_exp ':' '\n' statement ELIF logic_exp ':' '\n' statement
  | IF logic_exp ':' '\n' statement ELSE ':' '\n' statement
  ;
  
for_stmt : FOR id IN sequence ':' '\n' statement
  ;

funcdef : DEF id parameters ':' 
  | DEF id parameters ':' '\n' statement
  ;

return : RETURN expression
  | RETURN
  ;

parameters : '(' ')'
  | '(' ids ')'
  ;

ids: id
  | ids ',' id
  ;
  
print : PRINT '(' expressions ')'
  ;

%%
extern FILE *yyin;

void yyerror(const char *s) {
	//fprintf(stderr, "Error: line %d %s\n",yylineno,s);
}

void printerror(const char *s) {
	extern yylineno;
	errors++;
        fprintf(stderr, "Error: line %d\n",yylineno-1);
}

int main(int argc, char *argv[]) {
	if (argc > 1) {
		yyin = fopen(argv[1],"r");
		yyparse();
		if(errors==0)
			fprintf(stderr, "No errors\n");
	} else {
		fprintf(stderr, "Error: No file provided.\n");
	}
	return 0;
}
