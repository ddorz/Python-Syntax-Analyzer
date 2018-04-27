%{
#include "y.tab.h"
%}

%option yylineno

digits		[0-9]
integer		[-]?{digits}+
long		{digits}+[Ll]
exp		[Ee][-+]?{digits}+
intdecimal	[-+]?{digits}+"."{digits}*({exp})?
nointdec	[-+]?{digits}*"."{digits}+({exp})?
intnodec	[-+]?{digits}+{exp}
float		{intdecimal}|{nointdec}|{intnodec}
complex		({integer}|{float})[Jj]
letter		[a-zA-Z]
id		({letter}|"_")({letter}|{digits}|"_")*
iderror		({integer}|{float}|{long}|{complex}){id}
str		(\'|\")[^\'|\"]*(\'|\")
comment		"#".*
space		[ \t\n]+
charallow	[a-zA-Z0-9\+\-\!\|\#\%\&/\(\)\=\^\[\]\.\,\;\:\<\>\_\~\*\'\"]
charnallow	[^a-zA-Z0-9\+\-\!\|\#\%\&/\(\)\=\^\[\]\.\,\;\:\<\>\_\~\*\'\" \n\t]
lexerror	({charallow}*{charnallow}+{charallow}*)+

%%

break		{return BREAK;}
class		{return CLASS;}
continue	{return CONTINUE;}
def		{return DEF;}
del		{return DEL;}
elif		{return ELIF;}
else		{return ELSE;}
except		{return EXCEPT;}
exec		{return EXEC;}
finally		{return FINALLY;}
for		{return FOR;}
from		{return FROM;}
global		{return GLOBAL;}
if		{return IF;}
import		{return IMPORT;}
in		{return IN;}
pass		{return PASS;}
print		{return PRINT;}
range		{return RANGE;}
return		{return RETURN;}
while		{return WHILE;}

and		{return logical;}
is		{return logical;}
not		{return logical;}
or		{return logical;}
True		{return boolean;}
False		{return boolean;}

"+"		{return arithmetic;}
"-"		{return arithmetic;}
"*"		{return arithmetic;}
"/"		{return arithmetic;}
"%"		{return arithmetic;}
"**"		{return arithmetic;}
"//"		{return arithmetic;}

"=="		{return comparison;}
"!="		{return comparison;}
"<>"		{return comparison;}
">"		{return comparison;}
"<"		{return comparison;}
">="		{return comparison;}
"<="		{return comparison;}

{id}		{return id;}
{integer}	{return number;}
{long}		{return number;}
{complex}	{return number;}
{float}		{return number;}
{str}		{return string;}
{comment}	{return comment;}

"("		{return yytext[0];}
")"		{return yytext[0];}
"["		{return yytext[0];}
"]"		{return yytext[0];}
"="		{return yytext[0];}
";"		{return yytext[0];}
","		{return yytext[0];}
":"		{return yytext[0];}
"."		{return yytext[0];}

"+="		{return assign;}
"-="		{return assign;}
"*="		{return assign;}
"/="		{return assign;}
"%="		{return assign;}
"**="		{return assign;}
"//="		{return assign;}

[ \t]		;
[\n]		{return yytext[0];}


{iderror}	{;}
{lexerror}	{;}
.		{;}

%%

int yywrap(void) {return 1;}
