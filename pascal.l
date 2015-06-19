%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
%}


%%

"("				{return LP;}
")"				{return RP;}
"["				{return LB;}
"]"				{return RB;}
";"				{return SEMI;}
":"				{return COLON;}
","				{return COMMA;}
"*"				{return MUL;}
"/"				{return DIV;}
"+"				{return PLUS;}
"-"				{return MINUS;}
">="			{return GE;}
">"				{return GT;}
"<="			{return LE;}
"<"				{return LT;}
"="				{return EQUAL;}
"<>"			{return UNEQUAL;}
":="			{return ASSIGN;}
".."			{return DOTDOT;}
"."				{return DOT;}
"and"			{return AND;}
"array"			{return ARRAY;}
"begin"			{return BEGIN;}
"case"			{return CASE;}
"const"			{return CONST;}
"do"			{return DO;}
"downto"		{return DOWNTO;}
"else"			{return ELSE;}
"end"			{return END;}
"for"			{return FOR;}
"function"		{return FUNCTION;}
"goto"			{return GOTO;}
"if"			{return IF;}
"mod"			{return MOD;}
"not"			{return NOT;}
"of"			{return OF;}
"or"			{return OR;}
"proc"			{return PROC;}
"procedure"		{return PROCEDURE;}
"program"		{return PROGRAM;}
"read"			{return READ;}
"record"		{return RECORD;}
"repeat"		{return REPEAT;}
"then"			{return THEN;}
"to"			{return TO;}
"type"			{return TYPE;}
"until"			{return UNTIL;}
"var"			{return VAR;}
"while"			{return WHILE;}
"write" |
"writeln"		{return SYS_PROC;}
"abs" |
"chr" |
"odd" |
"ord" |
"pred" |
"sqr" |
"sqrt" |
"succ"			{return SYS_FUNCT;}
"false" |
"maxint" |
"true"			{return SYS_CON;}
"boolean" |
"char" |
"integer" |
"real"			{return SYS_TYPE;}
%%
