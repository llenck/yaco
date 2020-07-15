#include <assert.h>
#include <stdio.h>
#include <time.h>

#include <yaco.h>

void YACO_ATTRIBUTES count_down(struct yaco_coro_state* self) {
	long int* counter = self->data;
	while (--*counter > 0) {
		yaco_switch(self);
	}

	yaco_exit(self);
}

int main() {
	struct yaco_stack stk;
	struct yaco_coro_state co;
	struct timespec cur_time;
	long int x = 5000000;
	long int counter = x;

	assert(clock_gettime(CLOCK_THREAD_CPUTIME_ID, &cur_time) == 0);
	long int start_usec = cur_time.tv_sec * 1000000 + cur_time.tv_nsec / 1000;

	co.data = &counter;
	assert(yaco_create_stack(&stk, 4096 << 2));
	yaco_create(&co, &stk, count_down);

	do {
		yaco_switch(&co);
	} while (counter > 0);

	assert(yaco_is_finished(&co));
	yaco_destroy_stack(&stk);

	assert(clock_gettime(CLOCK_THREAD_CPUTIME_ID, &cur_time) == 0);
	long int end_usec = cur_time.tv_sec * 1000000 + cur_time.tv_nsec / 1000;
	long int diff_usec = end_usec - start_usec;

	printf("Performed %ld context switches in %ld.%06lds\n", x * 2, diff_usec / 1000000,
	       diff_usec % 1000000);

	return 0;
}
