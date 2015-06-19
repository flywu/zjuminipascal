#include "tree.h"
#include "utils.h"
#include <malloc.h>

tree *new_tree(int op, tree *_left, tree *_right)
{
	tree *t;
	t = (tree *)malloc(sizeof(tree));
	if (t == NULL) {
		err_quit("malloc error");
	}
	t->op = op;
	t->left = _left;
	t->right = _right;
	return t;
}

tree *new_tree_symbol(sbtype type, char *name, tree *_left, tree *right)
{
	tree *t;
	t = (tree *)malloc(sizeof(tree));
	if (t == NULL) {
		err_quit("malloc error");
	}
	
	strncppy(t->name, name, MAX_NAME_LEN);
	t->u.usymbol.type = type;
	t->left = _left;
	t->right = _right;
	return t;
}

tree *new_tree_cond(cstype _type, tree *_cond, tree *_left, tree *_right)
{
	tree *t;
	t = (tree *)malloc(sizeof(tree));
	if (t == NULL) {
		err_quit("malloc error");
	}
	t->u.ucond.cond = cond;
	t->u.ucond.type = _type;
}

tree *new_tree_type(ttype _type, void *_value, tree *_left, tree *_right)
{
	tree *t;
	t = (tree *)malloc(sizeof(tree));
	if (t == NULL) {
		err_quit("malloc error");
	}
	t->u.utype.type = _type;
	switch (_type) {
		case TYPE_ENUM:
		case TYPE_SUBRANGE:
			break;
		case TYPE_INTEGER:
		case TYPE_CHAR:
		case TYPE_BOOLEAN:
		case TYPE_READ:
			t->u.utype.value = value;
			break;
		case TYPE_STRING:
			strncpy(u->u.utype.value.s, _value, MAX_NAME_LEN);
			break;
		default:
			break;
	}
	return t;
}

tree *new_tree_comp(ctype _type, tree *_left, tree *_right)
{
	tree *t;
	t = (tree *)malloc(sizeof(tree));
	if (t == NULL) {
		err_quit("malloc error");
	}
	t->u.ucomp.type = _type;
	return t;
}


