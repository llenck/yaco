#ifndef _YACO_H_INCLUDED
#define _YACO_H_INCLUDED

#include <stdint.h>

struct yaco_stack {
	unsigned char* base;
	uint32_t len;
} __attribute__((packed));

struct yaco_coro_state {
#ifdef __ARM_ARCH_7A__
	uint32_t preserved_regs[8]; // r4 - r11
	uint32_t sp;
	uint32_t lr;
	uint64_t preserved_fp_regs[8]; // d8 - d15
#else
#	error platform not supported (yet)
#endif

	void* data;
} __attribute__((packed));

#define YACO_ATTRIBUTES __attribute__((target("general-regs-only")))
typedef void (*yaco_coro)(struct yaco_coro_state*);

#define yaco_is_finished(x) ((x)->lr == 0)

// creates a stack. returns 0 on failure, and non-zero otherwise
int yaco_create_stack(struct yaco_stack* stk, uint32_t size);
// frees a stack. can't fail
void yaco_destroy_stack(struct yaco_stack* stk);

// creates a coroutine and immediately executes it. doesn't touch co->data,
// so put arguments there
void yaco_create(struct yaco_coro_state* co, struct yaco_stack* stk, yaco_coro coro);

// switch contexts. this works both ways (between the caller and callee of the coroutine)
void yaco_switch(struct yaco_coro_state* co);

// last thing a coroutine executes. using return is not allowed
void __attribute__((noreturn)) yaco_exit(struct yaco_coro_state* co);

#endif
