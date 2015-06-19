%{
#include "global.h"
#include "tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
%}

%union {
	char p_char[MAX_NAME_LEN];
	int num;
	tree *p_tree;
}

%start program

%%

program : program_head routine DOT
		{
			t = new_tree(0, $1, $2);
		}
		;
program_head : PROGRAM ID SEMI
		{
			
		}
		;
routine : routine_head routine_body
		{
			t = new_tree(0, $1, $2);
		}		
		;
sub_routine : routine_head routine_body
		{
			t = new_tree(0, $1, $2);
		}		
		;
routine_head : label_part const_part type_part var_part routine_part
		{
			
		}
		;
label_part : 
		{
		}
		;
const_part : CONST const_expr_list 
		{
			$$ = $2;
		}
		| ;
const_expr_list : const_expr_list NAME EQUAL const_value SEMI
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->sibling = $4;
			$4->sibling = NULL;
			$$ = $1;
		}
		| NAME EQUAL const_value SEMI
		{
			$$ = $3;
		}
		;
const_value : INTEGER 
		{
			$$ = new_tree(0, NULL, NULL);
		}
		| REAL
		{
			$$ = new_tree(0, NULL, NULL);
		}
		| CHAR 
		{
			$$ = new_tree(0, NULL, NULL);
		}
		| STRING 
		{
			$$ = new_tree(0, NULL, NULL);
		}
		| SYS_CON
		{
			$$ = new_tree(0, NULL, NULL);
		}
		;
type_part : TYPE type_decl_list 
		{
			$$ = $2;
		}
		| ;
type_decl_list : type_decl_list type_definition 
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->sibling = $2;
			$2->sibling = NULL;
			$$ = $1;
		}
		| type_definition
		{
			$$ = $1;
		}
		;
type_definition : NAME EQUAL type_decl SEMI
		{
			$$ = $3;
		}		
		;
type_decl : simple_type_decl 
		{
			$$ = $1;
		}	
		| array_type_decl 
		{
			$$ = $1;
		}
		| record_type_decl
		{
			$$ = $1;
		}
		;
simple_type_decl : SYS_TYPE 
		{}
		| NAME 
		{}
		| LP name_list RP
		{
			$$ = $2;
		}
		| const_value DOTDOT const_value
		{
			$$ = new_tree(0, $1, $3);
		}
		| MINUS const_value DOTDOT const_value
		{
			$$ = new_tree(0, $2, $4);
		}
		| MINUS const_value DOTDOT MINUS const_value
		{
			$$ = new_tree(0, $3, $5);
		}
		| NAME DOTDOT NAME
		{}
		;
array_type_decl : ARRAY LB simple_type_decl RB OF type_decl
		{
			$$ = new_tree(0, $3, $6);
		};
record_type_decl : RECORD field_decl_list END
		{
			$$ = $2;
		};
field_decl_list : field_decl_list field_decl 
		{
			tree *t = $1;
			for(t; t->sibling; t = t->sibling);
			t->sibling = $2;
			$2-sibling = NULL;
			$$ = $1;
		}
		| field_decl
		{
			$$ = $1;
		}
		;
field_decl : name_list COLON type_decl SEMI
		{
			$$ = new_tree(0, $1, $3);
		};
name_list : name_list COMMA ID 
		{
			tree *t = $1;
			tree *r = new_tree_symbol(TYPE_VAR, $3, NULL, NULL);
			for (t; t->sibling; t = t->sibling);
			t->sibling = r;
			r->next = NULL;
			$$ = $1;
		}		
		| ID
		{
			tree *r = new_tree_symbol(TYPE_VAR, $1, NULL, NULL);
			$$ = t;
		}
		;
var_part : VAR var_decl_list 
		{
			$$ = $2;
		}
		| 
		;
var_decl_list : var_decl_list var_decl 
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->sibling = $2;
			$2->sibling = NULL;
			$$ = $1;
		}		
		| var_decl
		{
			$$ = $1;
		}
		;
var_decl : name_list COLON type_decl SEMI
		{
			$$ = new_tree(0, $1, $3);
		}
		;
routine_part: routine_part function_decl 
		{
			if ($1 == NULL)
				$$ = $2;
			else {
				tree *t = $1;
				for (t; t->sibling; t = t->sibling);
				t->sibling = $2;
				$2->sibling = NULL;
				$$ = $1;
			}	
		}		
		| routine_part procedure_decl
		{
			if ($1 == NULL)
				$$ = $2;
			else {
				tree *t = $1;
				for (t; t->sibling; t = t->sibling);
				t->sibling = $2;
				$2->sibling = NULL;
				$$ = $1;
			}	
		}	
		| function_decl 
		{
			$$ = $1;
		}
		| procedure_decl 
		{
			$$ = $1;
		}
		|;
function_decl : function_head SEMI sub_routine SEMI
		{
			$$ = new_tree(0, $1, $3);
		};
function_head : FUNCTION ID parameters COLON simple_type_decl
		{
			$$ = new_tree_symbol(TYPE_FUNC, $2, $3, $5);
		}
		;
procedure_decl : procedure_head SEMI sub_routine SEMI
		{
			$$ = new_tree(0, $1, $3);
		}
		;
procedure_head : PROCEDURE ID parameters
		{
			$$ = new_tree_symbol(TYPE_PROC, $2, $3, NULL);
		}		
		;
parameters : LP para_decl_list RP 
		{
			$$ = $2;
		}		
		| ;
para_decl_list : para_decl_list SEMI para_type_list 
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->sibling = $2;
			$2->sibling = NULL;
			$$ = $1;
		}
		| para_type_list
		{
			$$ = $1;
		}
		;
para_type_list : var_para_list COLON simple_type_decl
		{
			$$ = new_tree(0, $1, $3);
		}
		| val_para_list COLON simple_type_decl
		{
			$$ = new_tree(0, $1, $3);
		}
		;
var_para_list : VAR name_list
		{
			$$ = $2;
		}
		;
val_para_list : name_list
		{
			$$ = $1;
		}
		;
routine_body : compound_stmt
		{
			$$ = $1;
		}
		;
compound_stmt : BEGIN stmt_list END
		{
			$$ = $2;
		}
		;
stmt_list : stmt_list stmt SEMI 
		{
			if ($1 == NULL)
				$$ = $2;
			else {
				tree *t = $1;
				for (t; t->sibling; t = t->sibling);
				t->sibling = $2;
				$2->sibling = NULL;
				$$ = $1;
			}
		}		
		| ;
stmt : INTEGER COLON non_label_stmt 
		{
			$$ = $3;
		}
		| non_label_stmt
		{
			$$ = $1;
		}
		;
non_label_stmt : assign_stmt | proc_stmt | compound_stmt | if_stmt | repeat_stmt | while_stmt
| for_stmt | case_stmt | goto_stmt;
assign_stmt : ID ASSIGN expression
		{
			$$ = new_tree(0, $3, NULL);
		}
		;
		| ID LB expression RB ASSIGN expression
		{
			$$ = new_tree(0, $3, $6);
		}
		| ID DOT ID ASSIGN expression
		{
			$$ = new_tree(0, $5, NULL);
		}
		;
proc_stmt : ID
		{
			$$ = new_tree(0, NULL, NULL);
		}
		| ID LP args_list RP
		{
			$$ = new_tree_symbol($1, $3, NULL);
		}
		| SYS_PROC
		{
			$$ = new_tree_symbol(TYPE_PROC, $1, NULL, NULL);
		}
		| SYS_PROC LP expression_list RP
		{
			$$ = new_tree_symbol(TYPE_PROC, $1, $4, NULL);
		}
		| READ LP factor RP
		{
			$$ = new_tree_symbol(TYPE_PROC, "READ", $3, NULL);
		}
if_stmt : IF expression THEN stmt else_clause
		{
			$$ = new_tree_cond(TYPE_IF_ELSE, $2, $4, $5);
		}
		;
else_clause : ELSE stmt 
		{
			$$ = $2;
		}		
		| ;
repeat_stmt : REPEAT stmt_list UNTIL expression
		{
			$$ = new_tree_cond(TYPE_REPEAT, $4, $2, NULL);
		}
		;
while_stmt : WHILE expression DO stmt
		{
			$$ = new_tree_cond(TYPE_WHILE, $2, $4, NULL);
		}		
		;
for_stmt : FOR ID ASSIGN expression direction expression DO stmt
		{
			$$ = new_tree_cond(TYPE_FOR, $6, $4, $8);
			$$->u.ucond.direction = direction;
		}
		;
direction : TO 
		{
			$$ = 0;
		}
		| DOWNTO
		{
			$$ = 1;
		}
		;
case_stmt : CASE expression OF case_expr_list END
		{
			$$ = new_tree(0, $2, $4);
		};
case_expr_list : case_expr_list case_expr 
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->siblilng = $2;
			$2->sibling = NULL;
			$$ = $1;
		}
		| case_expr
		{
			$$ = $1;
		}
		;
case_expr : const_value COLON stmt SEMI
		{
			$$ = new_tree(0, $1, $3);
		}
		| ID COLON stmt SEMI
		{
			$$ = new_tree_symbol(TYPE_VAR, $1, $3, NULL): 
		}
		;
goto_stmt : GOTO INTEGER
		{
			$$ = new_tree(0, NULL, NULL);
		}
		;
expression_list : expression_list COMMA expression 
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->sibling = $3;
			$3->sibling = NULL;
			$$ = $1;
		}
		| expression
		{
			$$ = $1;
		}
		;
expression : expression GE expr 
		{
			$$ = new_tree_comp(TYPE_GE, $1, $3);
		}
		| expression GT expr 
		{
			$$ = new_tree_comp(TYPE_GT, $1, $3);
		}
		| expression LE expr
		{
			$$ = new_tree_comp(TYPE_LE, $1, $3);
		}
		| expression LT expr 
		{
			$$ = new_tree_comp(TYPE_LT, $1, $3);
		}
		| expression EQUAL expr
		{
			$$ = new_tree_comp(TYPE_EQUAL, $1, $3);
		}
		| expression UNEQUAL expr 
		{
			$$ = new_tree_comp(TYPE_UNEQUAL, $1, $3);
		}
		| expr
		{
			$$ = $1;
		}
		;
expr : expr PLUS term 
		{
			$$ = new_tree(TYPE_PLUS, $1, $3);
		}
		| expr MINUS term 
		{
			$$ = new_tree(TYPE_MINUS, $1, $3);
		}
		| expr OR term 
		{
			$$ = new_tree(TYPE_OR, $1, $3);
		}
		| term
		{
			$$ = $1;
		}
		;
term : term MUL factor 
		{
			$$ = new_tree(TYPE_MUL, $1, $3);
		}
		| term DIV factor 
		{
			$$ = new_tree(TYPE_DIV, $1, $3);
		}
		| term MOD factor
		{
			$$ = new_tree(TYPE_MOD, $1, $3);
		}
		| term AND factor 
		{
			$$ = new_tree(TYPE_AND, $1, $3);
		}
		| factor
		{
			$$ = $1;
		}
		;
factor : NAME 
		{
			$$ = new_tree_symbol(TYPE_VAR, $1, NULL, NULL);
		}		
		| NAME LP args_list RP 
		{
			$$ = new_tree_symbol(TYPE_FUNC, $1, $3, NULL);
		}
		| SYS_FUNCT
		{
			$$ = new_tree_symbol(TYPE_FUNC, $1, NULL, NULL);
		}
		|SYS_FUNCT LP args_list RP 
		{
			$$ = new_tree_symbol(TYPE_FUNC, $1, $3, NULL);
		}
		| const_value 
		{
			$$ = $1;
		}
		| LP expression RP
		{
			$$ = $1;
		}
		| NOT factor 
		{
			$$ = new_tree(TYPE_NOT, NULL, NULL);
		}
		| MINUS factor 
		{
			$$ = new_tree(TYPE_NEG, NULL, NULL);
		}
		| ID LB expression RB
		{
			$$ = new_tree_symbol(TYPE_VAR, $1, $3, NULL);
		}
		| ID DOT ID
		{		//????
			$$ = new_tree(TYPE_NONE, NULL, NULL);
		}
		;
args_list : args_list COMMA expression 
		{
			tree *t = $1;
			for (t; t->sibling; t = t->sibling);
			t->sibling = $3;
			$3->sibling = NULL;
			$$ = $1;
		}
		| expression
		{
			$$ = $1;
		}
		;
		
		
%%



