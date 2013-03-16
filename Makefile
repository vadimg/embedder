UNAME = uname
EGREP = egrep
EMBED_DIR = embedded_files
OBJDIR = obj

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

# embedded files
EMBEDDED_FILES = $(shell sh -c 'ls $(EMBED_DIR)/*')
EMBEDDED_OBJ = $(EMBEDDED_FILES:$(EMBED_DIR)/%=$(OBJDIR)/%.o)

all: embedded code
	gcc -rdynamic main.o $(EMBEDDED_OBJ) -ldl

code:
	gcc -g -c main.c -o main.o

$(OBJDIR)/%.o: embedded_files/% | $(OBJDIR)
	cd $(EMBED_DIR) && objcopy --input binary \
            --output $(OBJCOPY_OUTPUT) \
			--binary-architecture $(OBJCOPY_ARCH) $(<F) ../$@

embedded: $(EMBEDDED_OBJ)

$(OBJDIR):
	test -d $(OBJDIR) || mkdir $(OBJDIR)

clean:
	rm -rf *.o obj a.out
