#include <assert.h>
#include <stdio.h>

#include <yaco.h>

void coro(struct yaco_coro_state* self) {
	printf("received message: %s\n", (const char*)self->data);
	yaco_exit(self);
}

int main() {
	struct yaco_stack stk;
	struct yaco_coro_state co;

	assert(yaco_create_stack(&stk, 4096 << 2));

	co.data = "hello, world!";
	yaco_create(&co, &stk, coro);

	yaco_destroy_stack(&stk);
}
