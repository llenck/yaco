#include <assert.h>
#include <stdio.h>

#include <yaco.h>

void printer(struct yaco_coro_state* self) {
	printf("starting coroutine...\n");

	while (1) {
		yaco_switch(self);
		if (self->data == NULL) break;
		printf("received message: %s\n", (const char*)self->data);
	}

	printf("stopping coroutine...\n");

	yaco_exit(self);
}

int main() {
	struct yaco_stack stk;
	struct yaco_coro_state co;

	assert(yaco_create_stack(&stk, 4096 << 2));

	yaco_create(&co, &stk, printer);

	co.data = "Hello there!";
	yaco_switch(&co);
	co.data = "General Kenobi. You are a bold one.";
	yaco_switch(&co);
	co.data = NULL;
	yaco_switch(&co);

	assert(yaco_is_finished(&co));

	yaco_destroy_stack(&stk);
}
