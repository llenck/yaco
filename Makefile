test: test.c yaco.c yaco-asm.s
	gcc -Wall -Wextra test.c yaco.c yaco-asm.s -o test -Og -g
