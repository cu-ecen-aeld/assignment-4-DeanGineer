CC ?= gcc
CFLAGS = -Wall -Wextra -g

# Set cross-compiler if CROSS_COMPILE is defined
ifeq ($(CROSS_COMPILE),)
    CROSS_CC = $(CC)
else
	CROSS_CC = $(CROSS_COMPILE)gcc
endif


all: writer

writer: writer.o
	$(CROSS_CC) -o writer writer.o

writer.o: writer.c
	$(CROSS_CC) $(CFLAGS) -c writer.c
	
clean:
	rm -f writer writer.o
	
