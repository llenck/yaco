#include "yaco.h"

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

int yaco_create_stack(struct yaco_stack* stk, uint32_t size) {
	stk->base = malloc(size);
	stk->len = size;
	return stk->base != NULL;
}

void yaco_destroy_stack(struct yaco_stack* stk) {
	free(stk->base);
}
