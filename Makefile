all: target 

target: 
	gcc y.tab.c lex.yy.c -ly -ll -o parser

y.tab.c y.tab.h: syntax_analyzer.y
	bison -d syntax_analyzer.y

lex.yy.c: lexic_analyzer.l 
	lex lexic_analyzer.l
