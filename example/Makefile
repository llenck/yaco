CFLAGS += -Wall -Wextra -Wpedantic -std=c99
INCLUDEDIRS := -I ../include
LIBS := ../libyaco_static.a

all: simple.out message.out

%.out: %.c ../libyaco_static.a
	$(CC) $(CFLAGS) $(INCLUDEDIRS) $< $(LIBS) -o $@

clean:
	$(RM) *.out
