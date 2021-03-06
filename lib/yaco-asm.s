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

	@ save floating point registers (only d8 - d15 need to be saved)
	add r0, r0, #40
	vstm.F64 r0, {d8-d15}
	sub r0, r0, #40

	@ load new stack pointer (base + len, since the stack grows down). Don't store this
	@ in sp yet since sp might have a requirement to be 16-aligned. This will cause sp to
	@ point to the next element that doesn't belong to the stack, which is exactly right
	@ since on armv7, we use use a full-descending stack
	add r12, r3, r12
	@ round the stack pointer down to a multiple of 16
	lsr r12, r12, #4
	lsl sp, r12, #4

	@ call coroutine, whose address is given as our third argument
	@ (no bl since we don't use lr for returning anyway)
	@ we don't need to set any arguments since we can just pass r0
	bx r2

yaco_exit:
	@ restore callee-saved registers and lr
	ldm r0, {r4-r11, sp, lr}

	@ put 0 in r0->lr, to mark the coroutine as done
	eor r1, r1, r1
	str r1, [r0, #36]

	@ return to whoever yielded to the coroutine
	bx lr

yaco_switch:
	@ get a backup of sp for later use
	mov r12, sp

	@ store registers on stack, moving sp between the two places we store registers at
	stmfd sp!, {r4-r11, lr}

	@ here, we need to use r2-r9 instead of r4-r11 so we still have a different
	@ register than r12 free that is above the 8 registers we store most of the
	@ registers in. This is necessary because r12 is already in use and the registers
	@ used with stm/ldm must be in ascending order

	@ load saved registers (use r10 instead of sp, since we still need sp)
	ldm r0, {r2-r9, r10, lr}
	@ and save them to the stack, below the registers we want to swap with.
	@ this store and the corresponding load instruction will cause valgrind to scream at
	@ you; I believe this is because valgrind interprets stores/loads below sp as an
	@ array underflow. This can thus be safely ignored
	stmdb sp, {r2-r9, r10, lr}

	@ now load the registers we need to save again
	ldm sp, {r4-r11, lr}
	@ and save them, using our backup of the original sp in r12
	stm r0, {r4-r11, r12, lr}

	@ now, also switch the floating point registers. To do so, we add 40 to r0 so that
	@ points to r0->preserved_fp_regs and we can use vldm and vstm with it
	add r0, r0, #40

	@ first load the values we want to restore (we restore move them to d8 - d15 later)
	vldm.F64 r0, {d0-d7}

	@ then save the callee-saved registers
	vstm.F64 r0, {d8-d15}

	@ then restore the callee-saved registers from the coroutine we want to switch to
	@ from our backup in d0 - d7
	vmov.F64 d8, d0
	vmov.F64 d9, d1
	vmov.F64 d10, d2
	vmov.F64 d11, d3
	vmov.F64 d12, d4
	vmov.F64 d13, d5
	vmov.F64 d14, d6
	vmov.F64 d15, d7

	@ finally, load the registers we actually want to have from the stack
	ldmdb sp, {r4-r11, r12, lr}
	mov sp, r12

	@ "return" to the function/coroutine/whatever
	bx lr

#else
#	error platform not supported (yet)
#endif
