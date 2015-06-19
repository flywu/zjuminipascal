#ifdef _TREE_H__
#define _TREE_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
typedef struct tag_node {
	short op;
	
	char *op_name;
	
	short count;
	
	node *left, *right, *sibling;
}node;
*/

typedef enum tag_ttype {		// Const type
	TYPE_NONE,
	TYPE_ENUM,
	TYPE_SUBRANGE,
	TYPE_INTEGER,
	TYPE_CHAR,
	TYPE_BOOLEAN,
	TYPE_REAL,
	TYPE_STRING,
	TYPE_SYSFUNC,
	TYPE_UNKNOWN
} ttype;

typedef enum tag_cstype {		// Condition Jump type
	TYPE_NONE,
	TYPE_IF_ELSE,
	TYPE_REPEAT,
	TYPE_WHILE,
	TYPE_FOR,
	TYPE_UNKNOWN,
} cstype;

typedef enum tag_ctype {		// Compare type
	TYPE_NONE,
	TYPE_GE,
	TYPE_GT,
	TYPE_LE,
	TYPE_LT,
	TYPE_EQUAL,
	TYPE_UNEQUAL,
	TYPE_UNKNOWN
} ctype;

typedef enum tag_optype {		// Operation type
	TYPE_NONE = 0,
	TYPE_PLUS,
	TYPE_MINUS,
	TYPE_OR,
	TYPE_MUL,
	TYPE_DIV,
	TYPE_MOD,
	TYPE_AND,
	TYPE_NOT,
	TYPE_NEG,
	TYPE_UNKNOWN,
} optype;		

typedef enum tag_sbtype {
	TYPE_NONE,
	TYPE_FUNC,
	TYPE_PROC,
	TYPE_VAR,
	TYPE_UNKNOWN
} sbtype;


typdef struct tag_tree {
	optype op;
	char name[MAX_NAME_LEN];
	//ttype mttype;  // Type type
	stype mstype;  // Symbol type
	
	tree_t *left, *right, *sibling;
	
	union {
		struct type {
			int def;
			ttype type;
			union {
				int i;
				char s[MAX_NAME_LEN]
				double r;
				char c;
				short b;
				struct range {
					int low;
					int high;
				} valuerange;
			} value;
		} utype;
		
		struct symbol {
			sbtype type;
		} usymbol;
		
		struct stmt {
			cstype type;
			tree_t *cond;
			short direction;		// 1 for to, 2 for downto
		} ucond;
		
		struct comp {
			ctype type;
		} ucomp;
		
	} u;
} tree;

tree *new_tree(int, tree *, tree *);
tree *new_tree_symbol(sbtype, char *, tree *, tree *);
tree *new_tree_type(tt_type, void *val, tree *, tree *);
tree *new_tree_cond(cs_type, tree *, tree *, tree *);
tree *new_tree_comp(ctype, tree *, tree *);

#endif
