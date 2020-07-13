CFLAGS += -Wall -Wextra -Wpedantic -std=c99
INCLUDEDIRS := -I ../include
LIBS := ../libyaco_static.a

simple: simple.c ../libyaco_static.a
	$(CC) $(CFLAGS) $(INCLUDEDIRS) simple.c $(LIBS) -o simple

clean:
	$(RM) simple
