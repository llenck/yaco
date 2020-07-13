.text
.global yaco_create
.global yaco_switch
.global yaco_exit

#ifdef __ARM_ARCH_7A__
yaco_create:
	@ a pointer to the stack pointer for the coroutine is given as our second argument;
	@ load it and the size of the stack into r3 and r12 for later use
	ldm r1, {r3, r12}

	@ save previous environment to the coroutine state given as our first argument
	stm r0, {r4-r11, sp, lr}

	@ load new stack pointer (base + len, since the stack grows down). don't store this
	@ in sp yet since sp might have a requirement to be 16-aligned
	add r12, r3, r12
	@ round the stack pointer down to a multiple of 16
	lsl r12, r12, #4
	lsr sp, r12, #4

	@ call coroutine, whose address is given as our third argument
	@ (no bl since we don't use lr for returning anyway)
	@ we don't need to set any arguments since we can just pass r0
	bx r2

yaco_switch:
	

yaco_exit:
	@ restore callee-saved registers and lr
	ldm r0, {r4-r11, sp, lr}

	@ put 0 in r0->lr, to mark the coroutine as done
	eor r1, r1, r1
	str r1, [r0, #36]

	@ return to whoever yielded to the coroutine
	bx lr

#else
#	error platform not supported (yet)
#endif
