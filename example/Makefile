CFLAGS += -Wall -Wextra -Wpedantic -std=gnu99 -O3
INCLUDEDIRS := -I ../include
LIBS := ../libyaco_static.a

all: simple.out message.out benchmark.out

%.out: %.c ../libyaco_static.a
	$(CC) $(CFLAGS) $(INCLUDEDIRS) $< $(LIBS) -o $@

clean:
	$(RM) *.out
