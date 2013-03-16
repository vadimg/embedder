UNAME = uname
EGREP = egrep

# objcopy flags
IS_I386 = $(shell $(UNAME) -m 2>&1 | $(EGREP) -i -c "^i386")
IS_X86_64 = $(shell $(UNAME) -m 2>&1 | $(EGREP) -i -c "^x86_64")

ifneq ($(IS_I386),0)
  OBJCOPY_OUTPUT = elf32-i386
  OBJCOPY_ARCH = i386
endif

ifneq ($(IS_X86_64),0)
  OBJCOPY_OUTPUT = elf64-x86-64
  OBJCOPY_ARCH = i386
endif

all: embedded code
	gcc -rdynamic main.o data.o -ldl

code:
	gcc -g -c main.c -o main.o

embedded:
	objcopy --input binary \
            --output $(OBJCOPY_OUTPUT) \
            --binary-architecture $(OBJCOPY_ARCH) data.txt data.o

clean:
	rm -f *.o a.out
