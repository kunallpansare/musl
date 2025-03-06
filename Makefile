#
# Makefile for musl (requires GNU make)
#

srcdir = .
exec_prefix = /usr/local
bindir = $(exec_prefix)/bin

prefix = /usr/local/musl
includedir = $(prefix)/include
libdir = $(prefix)/lib
syslibdir = /lib

# MALLOC_DIR = mallocng
# SRC_DIRS = $(addprefix $(srcdir)/,src/* src/malloc/$(MALLOC_DIR) crt ldso $(COMPAT_SRC_DIRS))
# BASE_GLOBS = $(addsuffix /*.c,$(SRC_DIRS))
# ARCH_GLOBS = $(addsuffix /$(ARCH)/*.[csS],$(SRC_DIRS))
# BASE_SRCS = $(sort $(wildcard $(BASE_GLOBS)))
# ARCH_SRCS = $(sort $(wildcard $(ARCH_GLOBS)))
# BASE_OBJS = $(patsubst $(srcdir)/%,%.o,$(basename $(BASE_SRCS)))
# ARCH_OBJS = $(patsubst $(srcdir)/%,%.o,$(basename $(ARCH_SRCS)))
# REPLACED_OBJS = $(sort $(subst /$(ARCH)/,/,$(ARCH_OBJS)))
# ALL_OBJS = $(addprefix obj/, $(filter-out $(REPLACED_OBJS), $(sort $(BASE_OBJS) $(ARCH_OBJS))))

MALLOC_DIR = mallocng
SRC_DIRS = $(addprefix $(srcdir)/,src/* src/malloc/$(MALLOC_DIR) crt ldso $(COMPAT_SRC_DIRS))
BASE_GLOBS = $(addsuffix /*.c,$(SRC_DIRS))
ARCH_GLOBS = $(addsuffix /$(ARCH)/*.[csS],$(SRC_DIRS))
BASE_SRCS = $(filter-out $(srcdir)/src/ldso/dynlink.c, $(sort $(wildcard $(BASE_GLOBS))))
# BASE_SRCS = $(sort $(wildcard $(BASE_GLOBS)))
ARCH_SRCS = $(sort $(wildcard $(ARCH_GLOBS)))
BASE_LLS = $(patsubst $(srcdir)/%,%.ll,$(basename $(BASE_SRCS)))
BASE_OBJS = $(patsubst $(srcdir)/%,%.o,$(basename $(BASE_SRCS)))
ARCH_OBJS = $(patsubst $(srcdir)/%,%.o,$(basename $(ARCH_SRCS)))
REPLACED_OBJS = $(sort $(subst /$(ARCH)/,/,$(ARCH_OBJS)))
ALL_OBJS = $(addprefix obj/, $(filter-out $(REPLACED_OBJS), $(sort $(BASE_OBJS) $(ARCH_OBJS))))

LIBC_OBJS = $(filter obj/src/%,$(ALL_OBJS)) $(filter obj/compat/%,$(ALL_OBJS))
LDSO_OBJS = $(filter obj/ldso/%,$(ALL_OBJS:%.o=%.lo))
CRT_OBJS = $(filter obj/crt/%,$(ALL_OBJS))

AOBJS = $(LIBC_OBJS)
LOBJS = $(LIBC_OBJS:.o=.lo)
GENH = obj/include/bits/alltypes.h obj/include/bits/syscall.h
GENH_INT = obj/src/internal/version.h
IMPH = $(addprefix $(srcdir)/, src/internal/stdio_impl.h src/internal/pthread_impl.h src/internal/locale_impl.h src/internal/libc.h)

LDFLAGS =
LDFLAGS_AUTO =
LIBCC = -lgcc 
#the above this is ok but if you want to make a more compact binary you can use the below given statement as compilerrt is more tightly integrated with Clang and optimized for its features.
#LIBCC = -rtlib=compiler-rt
CPPFLAGS =
CFLAGS =
CFLAGS_AUTO = -Os -pipe
CFLAGS_C99FSE = -std=c99 -ffreestanding -nostdinc 

#This initial setup ensures that the musl build adheres to strict C99 standards and compiles as a self-contained library without relying on external system headers.
CFLAGS_ALL = $(CFLAGS_C99FSE)

#header files
CFLAGS_ALL += -D_XOPEN_SOURCE=700 -I$(srcdir)/arch/$(ARCH) -I$(srcdir)/arch/generic -Iobj/src/internal -I$(srcdir)/src/include -I$(srcdir)/src/internal -Iobj/include -I$(srcdir)/include
#optimization
CFLAGS_ALL += $(CPPFLAGS) $(CFLAGS_AUTO) $(CFLAGS)

# Added macros explicitly to avoid SYSLIBDIR and LIBDIR errors
CFLAGS_ALL += -DSYSLIBDIR=\"$(syslibdir)\" -DLIBDIR=\"$(libdir)\"

LDFLAGS_ALL = $(LDFLAGS_AUTO) $(LDFLAGS)
AR      = $(CROSS_COMPILE)ar
RANLIB  = $(CROSS_COMPILE)ranlib
INSTALL = $(srcdir)/tools/install.sh

ARCH_INCLUDES = $(wildcard $(srcdir)/arch/$(ARCH)/bits/*.h)
GENERIC_INCLUDES = $(wildcard $(srcdir)/arch/generic/bits/*.h)
INCLUDES = $(wildcard $(srcdir)/include/*.h $(srcdir)/include/*/*.h)
ALL_INCLUDES = $(sort $(INCLUDES:$(srcdir)/%=%) $(GENH:obj/%=%) $(ARCH_INCLUDES:$(srcdir)/arch/$(ARCH)/%=include/%) $(GENERIC_INCLUDES:$(srcdir)/arch/generic/%=include/%))

EMPTY_LIB_NAMES = m rt pthread crypt util xnet resolv dl
EMPTY_LIBS = $(EMPTY_LIB_NAMES:%=lib/lib%.a)
CRT_LIBS = $(addprefix lib/,$(notdir $(CRT_OBJS)))
STATIC_LIBS = lib/libc.a
SHARED_LIBS = lib/libc.so
#some updates are suggested in the script, we will look into it afterwards
# TOOL_LIBS = lib/musl-gcc.specs
ALL_LIBS = $(CRT_LIBS) $(STATIC_LIBS) $(SHARED_LIBS) $(EMPTY_LIBS) $(TOOL_LIBS)
# ALL_TOOLS = obj/musl-gcc
ALL_TOOLS =

#WRAPCC_GCC = gcc
#WRAPCC_CLANG = clang
WRAPCC_GCC = /usr/local/bin/clang
WRAPCC_CLANG = /usr/local/bin/clang

LDSO_PATHNAME = $(syslibdir)/ld-musl-$(ARCH)$(SUBARCH).so.1

-include config.mak
-include $(srcdir)/arch/$(ARCH)/arch.mak

ifeq ($(ARCH),)

all:
	@echo "Please set ARCH in config.mak before running make."
	@exit 1

else

all: $(ALL_LIBS) $(ALL_TOOLS)

OBJ_DIRS = $(sort $(patsubst %/,%,$(dir $(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(GENH) $(GENH_INT))) obj/include)

#before making any og the lhs, all the dirs in the rhs mentioned above must exists
$(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(ALL_OBJS:%.o=%.lo) $(GENH) $(GENH_INT): | $(OBJ_DIRS)

$(OBJ_DIRS):
	mkdir -p $@

all: $(ALL_LIBS) $(ALL_TOOLS)

# LL_DIRS = $(sort $(patsubst %/,%,$(dir $(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(GENH) $(GENH_INT))) ll/include)
# LL_DIRS = $(sort $(patsubst %/,%,$(dir $(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(GENH) $(GENH_INT))) ll/include ll/crt ll/src)

#before making any og the lhs, all the dirs in the rhs mentioned above must exists
# $(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(ALL_OBJS:%.o=%.lo) $(GENH) $(GENH_INT): | $(LL_DIRS)

# $(LL_DIRS):
# 	mkdir -p $@


obj/include/bits/alltypes.h: $(srcdir)/arch/$(ARCH)/bits/alltypes.h.in $(srcdir)/include/alltypes.h.in $(srcdir)/tools/mkalltypes.sed
	sed -f $(srcdir)/tools/mkalltypes.sed $(srcdir)/arch/$(ARCH)/bits/alltypes.h.in $(srcdir)/include/alltypes.h.in > $@

obj/include/bits/syscall.h: $(srcdir)/arch/$(ARCH)/bits/syscall.h.in
	cp $< $@
	sed -n -e s/__NR_/SYS_/p < $< >> $@

obj/src/internal/version.h: $(wildcard $(srcdir)/VERSION $(srcdir)/.git)
	printf '#define VERSION "%s"\n' "$$(cd $(srcdir); sh tools/version.sh)" > $@

obj/src/internal/version.o obj/src/internal/version.lo: obj/src/internal/version.h

obj/crt/rcrt1.o obj/ldso/dlstart.lo obj/ldso/dynlink.lo: $(srcdir)/src/internal/dynlink.h $(srcdir)/arch/$(ARCH)/reloc.h

obj/crt/crt1.o obj/crt/scrt1.o obj/crt/rcrt1.o obj/ldso/dlstart.lo: $(srcdir)/arch/$(ARCH)/crt_arch.h

obj/crt/rcrt1.o: $(srcdir)/ldso/dlstart.c

obj/crt/Scrt1.o obj/crt/rcrt1.o: CFLAGS_ALL += -fPIC


#scope of using pass over here
OPTIMIZE_SRCS = $(wildcard $(OPTIMIZE_GLOBS:%=$(srcdir)/src/%))
$(OPTIMIZE_SRCS:$(srcdir)/%.c=obj/%.o) $(OPTIMIZE_SRCS:$(srcdir)/%.c=obj/%.lo): CFLAGS += -O3

MEMOPS_OBJS = $(filter %/memcpy.o %/memmove.o %/memcmp.o %/memset.o, $(LIBC_OBJS))
$(MEMOPS_OBJS) $(MEMOPS_OBJS:%.o=%.lo): CFLAGS_ALL += $(CFLAGS_MEMOPS)

NOSSP_OBJS = $(CRT_OBJS) $(LDSO_OBJS) $(filter \
	%/__libc_start_main.o %/__init_tls.o %/__stack_chk_fail.o \
	%/__set_thread_area.o %/memset.o %/memcpy.o \
	, $(LIBC_OBJS))
$(NOSSP_OBJS) $(NOSSP_OBJS:%.o=%.lo): CFLAGS_ALL += $(CFLAGS_NOSSP)

$(CRT_OBJS): CFLAGS_ALL += -DCRT

$(LOBJS) $(LDSO_OBJS): CFLAGS_ALL += -fPIC

CC_CMD = $(CC) $(CFLAGS_ALL) -c -o $@ $<
CC_CMD_LL = $(CC) $(CFLAGS_ALL) -emit-llvm -S $< -o $@
#additional statement
OPT_CMD = $(OPT_PASS) -load /home/kunalpansare/llvm-pass-skeleton/build/skeleton/libSkeletonPass.so -skeleton -S $@ -o $@
#sudo /usr/local/bin/opt -load /home/kunalpansare/llvm-pass-skeleton/build/skeleton/libSkeletonPass.so -skeleton -S Scrt1.ll -o obj/crt/Scrt1.ll
#/usr/local/bin/clang -c test_pass.ll
LL_TO_O_CMD = $(CC) -c $< -o $@
LL_TO_O_CMDFP = $(CC) -fPIC -c $< -o $@

# Choose invocation of assembler to be used
ifeq ($(ADD_CFI),yes)
	AS_CMD = LC_ALL=C awk -f $(srcdir)/tools/add-cfi.common.awk -f $(srcdir)/tools/add-cfi.$(ARCH).awk $< | $(CC) $(CFLAGS_ALL) -x assembler -c -o $@ -
else
	AS_CMD = $(CC_CMD)
endif

obj/%.o: $(srcdir)/%.s
	$(AS_CMD)


obj/%.o: $(srcdir)/%.S
	$(CC_CMD)

#obj/%.o: $(srcdir)/%.c $(GENH) $(IMPH)
#	#$(CC_CMD_LL)
#	#$(OPT_CMD)

# obj/%.o: $(srcdir)/%.c $(GENH) $(IMPH)
# 	$(CC_CMD_LL)  # Compile .c to .ll
# 	$(OPT_CMD)   # Apply opt pass to .ll
# 	$(LL_TO_O_CMD)  # Compile optimized .ll to .o

obj/ldso/dynlink.lo: $(srcdir)/ldso/dynlink.c $(GENH) $(IMPH)
	$(CC_CMD)
	
obj/src/math/atan2.lo: $(srcdir)/src/math/atan2.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/math/atan2f.lo: $(srcdir)/src/math/atan2f.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/math/jnf.lo: $(srcdir)/src/math/jnf.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/locale/iconv.lo: $(srcdir)/src/locale/iconv.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/locale/locale_map.lo: $(srcdir)/src/locale/locale_map.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/locale/strfmon.lo: $(srcdir)/src/locale/strfmon.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/regex/fnmatch.lo: $(srcdir)/src/regex/fnmatch.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/regex/glob.lo: $(srcdir)/src/regex/glob.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/regex/regcomp.lo: $(srcdir)/src/regex/regcomp.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/dirent/readdir.lo: $(srcdir)/src/dirent/readdir.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/exit/_Exit.lo: $(srcdir)/src/exit/_Exit.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/crypt/crypt_des.lo: $(srcdir)/src/crypt/crypt_des.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/crypt/crypt_md5.lo: $(srcdir)/src/crypt/crypt_md5.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/crypt/crypt_sha256.lo: $(srcdir)/src/crypt/crypt_sha256.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/crypt/crypt_sha512.lo: $(srcdir)/src/crypt/crypt_sha512.c $(GENH) $(IMPH)
	$(CC_CMD)


obj/src/misc/getopt_long.lo: $(srcdir)/src/misc/getopt_long.c $(GENH) $(IMPH)
	$(CC_CMD)

# obj/src/network/getserverbyport_r.lo: $(srcdir)/src/network/getservbyport_r.c $(GENH) $(IMPH)
# 	$(CC_CMD)

obj/src/network/getservbyport_r.lo: $(srcdir)/src/network/getservbyport_r.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/network/lookup_serv.lo: $(srcdir)/src/network/lookup_serv.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/network/resolvconf.lo: $(srcdir)/src/network/resolvconf.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/network/lookup_name.lo: $(srcdir)/src/network/lookup_name.c $(GENH) $(IMPH)
	$(CC_CMD)


obj/src/passwd/getgrouplist.lo: $(srcdir)/src/passwd/getgrouplist.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/passwd/getspnam_r.lo: $(srcdir)/src/passwd/getspnam_r.c $(GENH) $(IMPH)
	$(CC_CMD)


obj/src/process/execvp.lo: $(srcdir)/src/process/execvp.c $(GENH) $(IMPH)
	$(CC_CMD)


obj/src/stdio/fprintf.lo: $(srcdir)/src/stdio/fprintf.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/stdio/vfscanf.lo: $(srcdir)/src/stdio/vfscanf.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/stdio/vfwscanf.lo: $(srcdir)/src/stdio/vfwscanf.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/stdio/vfprintf.lo: $(srcdir)/src/stdio/vfprintf.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/thread/pthread_join.lo: $(srcdir)/src/thread/pthread_join.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/src/misc/extras.lo: $(srcdir)/src/misc/extras.c $(GENH) $(IMPH)
	$(CC_CMD)


obj/src/time/strptime.lo: $(srcdir)/src/time/strptime.c $(GENH) $(IMPH)
	$(CC_CMD)

obj/%.ll: $(srcdir)/%.c $(GENH) $(IMPH)
	$(CC_CMD_LL)  # Compile .c to .ll
	$(OPT_CMD)   # Apply opt pass to .ll
#	$(LL_TO_O_CMD)  # Compile optimized .ll to .o

obj/%.o: obj/%.ll $(GENH) $(IMPH)
	$(LL_TO_O_CMD)

obj/%.lo: $(srcdir)/%.s
	$(AS_CMD)

obj/%.lo: $(srcdir)/%.S
	$(CC_CMD)

#obj/%.lo: $(srcdir)/%.c $(GENH) $(IMPH)
#	$(CC_CMD)

# obj/%.lo: $(srcdir)/%.c $(GENH) $(IMPH)
# 	$(CC) $(CFLAGS_ALL) -c -o $@ $<

obj/%.lo: obj/%.ll $(GENH) $(IMPH)
	$(LL_TO_O_CMDFP)


lib/libc.so: $(LOBJS) $(LDSO_OBJS)
	$(CC) $(CFLAGS_ALL) $(LDFLAGS_ALL) -nostdlib -shared \
	-Wl,-e,_dlstart -o $@ $(LOBJS) $(LDSO_OBJS) $(LIBCC)

lib/libc.a: $(AOBJS)
	rm -f $@
	$(AR) rc $@ $(AOBJS)
	$(RANLIB) $@

$(EMPTY_LIBS):
	rm -f $@
	$(AR) rc $@

lib/%.o: obj/crt/$(ARCH)/%.o
	cp $< $@

lib/%.o: obj/crt/%.o
	cp $< $@

lib/musl-gcc.specs: $(srcdir)/tools/musl-gcc.specs.sh config.mak
	sh $< "$(includedir)" "$(libdir)" "$(LDSO_PATHNAME)" > $@

obj/musl-gcc: config.mak
	printf '#!/bin/sh\nexec "$${REALGCC:-$(WRAPCC_GCC)}" "$$@" -specs "%s/musl-gcc.specs"\n' "$(libdir)" > $@
	chmod +x $@

obj/%-clang: $(srcdir)/tools/%-clang.in config.mak
	sed -e 's!@CC@!$(WRAPCC_CLANG)!g' -e 's!@PREFIX@!$(prefix)!g' -e 's!@INCDIR@!$(includedir)!g' -e 's!@LIBDIR@!$(libdir)!g' -e 's!@LDSO@!$(LDSO_PATHNAME)!g' $< > $@
	chmod +x $@

$(DESTDIR)$(bindir)/%: obj/%
	$(INSTALL) -D $< $@

$(DESTDIR)$(libdir)/%.so: lib/%.so
	$(INSTALL) -D -m 755 $< $@

$(DESTDIR)$(libdir)/%: lib/%
	$(INSTALL) -D -m 644 $< $@

$(DESTDIR)$(includedir)/bits/%: $(srcdir)/arch/$(ARCH)/bits/%
	$(INSTALL) -D -m 644 $< $@

$(DESTDIR)$(includedir)/bits/%: $(srcdir)/arch/generic/bits/%
	$(INSTALL) -D -m 644 $< $@

$(DESTDIR)$(includedir)/bits/%: obj/include/bits/%
	$(INSTALL) -D -m 644 $< $@

$(DESTDIR)$(includedir)/%: $(srcdir)/include/%
	$(INSTALL) -D -m 644 $< $@

$(DESTDIR)$(LDSO_PATHNAME): $(DESTDIR)$(libdir)/libc.so
	$(INSTALL) -D -l $(libdir)/libc.so $@ || true

install-libs: $(ALL_LIBS:lib/%=$(DESTDIR)$(libdir)/%) $(if $(SHARED_LIBS),$(DESTDIR)$(LDSO_PATHNAME),)

install-headers: $(ALL_INCLUDES:include/%=$(DESTDIR)$(includedir)/%)

install-tools: $(ALL_TOOLS:obj/%=$(DESTDIR)$(bindir)/%)

install: install-libs install-headers install-tools

musl-git-%.tar.gz: .git
	 git --git-dir=$(srcdir)/.git archive --format=tar.gz --prefix=$(patsubst %.tar.gz,%,$@)/ -o $@ $(patsubst musl-git-%.tar.gz,%,$@)

musl-%.tar.gz: .git
	 git --git-dir=$(srcdir)/.git archive --format=tar.gz --prefix=$(patsubst %.tar.gz,%,$@)/ -o $@ v$(patsubst musl-%.tar.gz,%,$@)

endif

clean:
	rm -rf obj lib

distclean: clean
	rm -f config.mak

.PHONY: all clean install install-libs install-headers install-tools



# ---------------------------------------------------------------------------------------------------------------------


# srcdir = .
# exec_prefix = /usr/local
# bindir = $(exec_prefix)/bin

# prefix = /usr/local/musl
# includedir = $(prefix)/include
# libdir = $(prefix)/lib
# syslibdir = /lib

# MALLOC_DIR = mallocng
# SRC_DIRS = $(addprefix $(srcdir)/,src/* src/malloc/$(MALLOC_DIR) crt ldso $(COMPAT_SRC_DIRS))
# BASE_GLOBS = $(addsuffix /*.c,$(SRC_DIRS))
# ARCH_GLOBS = $(addsuffix /$(ARCH)/*.[csS],$(SRC_DIRS))
# BASE_SRCS = $(sort $(wildcard $(BASE_GLOBS)))
# ARCH_SRCS = $(sort $(wildcard $(ARCH_GLOBS)))
# BASE_OBJS = $(patsubst $(srcdir)/%,%.o,$(basename $(BASE_SRCS)))
# ARCH_OBJS = $(patsubst $(srcdir)/%,%.o,$(basename $(ARCH_SRCS)))
# REPLACED_OBJS = $(sort $(subst /$(ARCH)/,/,$(ARCH_OBJS)))
# ALL_OBJS = $(addprefix obj/, $(filter-out $(REPLACED_OBJS), $(sort $(BASE_OBJS) $(ARCH_OBJS))))

# LIBC_OBJS = $(filter obj/src/%,$(ALL_OBJS)) $(filter obj/compat/%,$(ALL_OBJS))
# LDSO_OBJS = $(filter obj/ldso/%,$(ALL_OBJS:%.o=%.lo))
# CRT_OBJS = $(filter obj/crt/%,$(ALL_OBJS))

# AOBJS = $(LIBC_OBJS)
# LOBJS = $(LIBC_OBJS:.o=.lo)
# GENH = obj/include/bits/alltypes.h obj/include/bits/syscall.h
# GENH_INT = obj/src/internal/version.h
# IMPH = $(addprefix $(srcdir)/, src/internal/stdio_impl.h src/internal/pthread_impl.h src/internal/locale_impl.h src/internal/libc.h)

# LDFLAGS =
# LDFLAGS_AUTO =
# LIBCC = -lgcc
# CPPFLAGS =
# CFLAGS =
# CFLAGS_AUTO = -Os -pipe
# CFLAGS_C99FSE = -std=c99 -ffreestanding -nostdinc 

# CFLAGS_ALL = $(CFLAGS_C99FSE)
# CFLAGS_ALL += -D_XOPEN_SOURCE=700 -I$(srcdir)/arch/$(ARCH) -I$(srcdir)/arch/generic -Iobj/src/internal -I$(srcdir)/src/include -I$(srcdir)/src/internal -Iobj/include -I$(srcdir)/include
# CFLAGS_ALL += $(CPPFLAGS) $(CFLAGS_AUTO) $(CFLAGS)

# # Added macros explicitly to avoid SYSLIBDIR and LIBDIR errors
# CFLAGS_ALL += -DSYSLIBDIR=\"$(syslibdir)\" -DLIBDIR=\"$(libdir)\"

# LDFLAGS_ALL = $(LDFLAGS_AUTO) $(LDFLAGS)

# AR      = $(CROSS_COMPILE)ar
# RANLIB  = $(CROSS_COMPILE)ranlib
# INSTALL = $(srcdir)/tools/install.sh

# ARCH_INCLUDES = $(wildcard $(srcdir)/arch/$(ARCH)/bits/*.h)
# GENERIC_INCLUDES = $(wildcard $(srcdir)/arch/generic/bits/*.h)
# INCLUDES = $(wildcard $(srcdir)/include/*.h $(srcdir)/include/*/*.h)
# ALL_INCLUDES = $(sort $(INCLUDES:$(srcdir)/%=%) $(GENH:obj/%=%) $(ARCH_INCLUDES:$(srcdir)/arch/$(ARCH)/%=include/%) $(GENERIC_INCLUDES:$(srcdir)/arch/generic/%=include/%))

# EMPTY_LIB_NAMES = m rt pthread crypt util xnet resolv dl
# EMPTY_LIBS = $(EMPTY_LIB_NAMES:%=lib/lib%.a)
# CRT_LIBS = $(addprefix lib/,$(notdir $(CRT_OBJS)))
# STATIC_LIBS = lib/libc.a
# SHARED_LIBS = lib/libc.so
# TOOL_LIBS = lib/musl-gcc.specs
# ALL_LIBS = $(CRT_LIBS) $(STATIC_LIBS) $(SHARED_LIBS) $(EMPTY_LIBS) $(TOOL_LIBS)
# ALL_TOOLS = obj/musl-gcc

# WRAPCC_GCC = gcc
# WRAPCC_CLANG = clang

# LDSO_PATHNAME = $(syslibdir)/ld-musl-$(ARCH)$(SUBARCH).so.1

# -include config.mak
# -include $(srcdir)/arch/$(ARCH)/arch.mak

# ifeq ($(ARCH),)

# all:
# 	@echo "Please set ARCH in config.mak before running make."
# 	@exit 1

# else

# all: $(ALL_LIBS) $(ALL_TOOLS)

# OBJ_DIRS = $(sort $(patsubst %/,%,$(dir $(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(GENH) $(GENH_INT))) obj/include)

# $(ALL_LIBS) $(ALL_TOOLS) $(ALL_OBJS) $(ALL_OBJS:%.o=%.lo) $(GENH) $(GENH_INT): | $(OBJ_DIRS)

# $(OBJ_DIRS):
# 	mkdir -p $@

# obj/include/bits/alltypes.h: $(srcdir)/arch/$(ARCH)/bits/alltypes.h.in $(srcdir)/include/alltypes.h.in $(srcdir)/tools/mkalltypes.sed
# 	sed -f $(srcdir)/tools/mkalltypes.sed $(srcdir)/arch/$(ARCH)/bits/alltypes.h.in $(srcdir)/include/alltypes.h.in > $@

# obj/include/bits/syscall.h: $(srcdir)/arch/$(ARCH)/bits/syscall.h.in
# 	cp $< $@
# 	sed -n -e s/__NR_/SYS_/p < $< >> $@

# obj/src/internal/version.h: $(wildcard $(srcdir)/VERSION $(srcdir)/.git)
# 	printf '#define VERSION "%s"\n' "$$(cd $(srcdir); sh tools/version.sh)" > $@

# obj/src/internal/version.o obj/src/internal/version.lo: obj/src/internal/version.h

# obj/crt/rcrt1.o obj/ldso/dlstart.lo obj/ldso/dynlink.lo: $(srcdir)/src/internal/dynlink.h $(srcdir)/arch/$(ARCH)/reloc.h

# obj/crt/crt1.o obj/crt/scrt1.o obj/crt/rcrt1.o obj/ldso/dlstart.lo: $(srcdir)/arch/$(ARCH)/crt_arch.h

# obj/crt/rcrt1.o: $(srcdir)/ldso/dlstart.c

# obj/crt/Scrt1.o obj/crt/rcrt1.o: CFLAGS_ALL += -fPIC

# OPTIMIZE_SRCS = $(wildcard $(OPTIMIZE_GLOBS:%=$(srcdir)/src/%))
# $(OPTIMIZE_SRCS:$(srcdir)/%.c=obj/%.o) $(OPTIMIZE_SRCS:$(srcdir)/%.c=obj/%.lo): CFLAGS += -O3

# MEMOPS_OBJS = $(filter %/memcpy.o %/memmove.o %/memcmp.o %/memset.o, $(LIBC_OBJS))
# $(MEMOPS_OBJS) $(MEMOPS_OBJS:%.o=%.lo): CFLAGS_ALL += $(CFLAGS_MEMOPS)

# NOSSP_OBJS = $(CRT_OBJS) $(LDSO_OBJS) $(filter \
# 	%/__libc_start_main.o %/__init_tls.o %/__stack_chk_fail.o \
# 	%/__set_thread_area.o %/memset.o %/memcpy.o \
# 	, $(LIBC_OBJS))
# $(NOSSP_OBJS) $(NOSSP_OBJS:%.o=%.lo): CFLAGS_ALL += $(CFLAGS_NOSSP)

# $(CRT_OBJS): CFLAGS_ALL += -DCRT

# $(LOBJS) $(LDSO_OBJS): CFLAGS_ALL += -fPIC

# CC_CMD = $(CC) $(CFLAGS_ALL) -c -o $@ $<

# # Choose invocation of assembler to be used
# ifeq ($(ADD_CFI),yes)
# 	AS_CMD = LC_ALL=C awk -f $(srcdir)/tools/add-cfi.common.awk -f $(srcdir)/tools/add-cfi.$(ARCH).awk $< | $(CC) $(CFLAGS_ALL) -x assembler -c -o $@ -
# else
# 	AS_CMD = $(CC_CMD)
# endif

# obj/%.o: $(srcdir)/%.s
# 	$(AS_CMD)

# obj/%.o: $(srcdir)/%.S
# 	$(CC_CMD)

# obj/%.o: $(srcdir)/%.c $(GENH) $(IMPH)
# 	$(CC_CMD)

# obj/%.lo: $(srcdir)/%.s
# 	$(AS_CMD)

# obj/%.lo: $(srcdir)/%.S
# 	$(CC_CMD)

# obj/%.lo: $(srcdir)/%.c $(GENH) $(IMPH)
# 	$(CC_CMD)

# lib/libc.so: $(LOBJS) $(LDSO_OBJS)
# 	$(CC) $(CFLAGS_ALL) $(LDFLAGS_ALL) -nostdlib -shared \
# 	-Wl,-e,_dlstart -o $@ $(LOBJS) $(LDSO_OBJS) $(LIBCC)

# lib/libc.a: $(AOBJS)
# 	rm -f $@
# 	$(AR) rc $@ $(AOBJS)
# 	$(RANLIB) $@

# $(EMPTY_LIBS):
# 	rm -f $@
# 	$(AR) rc $@

# lib/%.o: obj/crt/$(ARCH)/%.o
# 	cp $< $@

# lib/%.o: obj/crt/%.o
# 	cp $< $@

# lib/musl-gcc.specs: $(srcdir)/tools/musl-gcc.specs.sh config.mak
# 	sh $< "$(includedir)" "$(libdir)" "$(LDSO_PATHNAME)" > $@

# obj/musl-gcc: config.mak
# 	printf '#!/bin/sh\nexec "$${REALGCC:-$(WRAPCC_GCC)}" "$$@" -specs "%s/musl-gcc.specs"\n' "$(libdir)" > $@
# 	chmod +x $@

# obj/%-clang: $(srcdir)/tools/%-clang.in config.mak
# 	sed -e 's!@CC@!$(WRAPCC_CLANG)!g' -e 's!@PREFIX@!$(prefix)!g' -e 's!@INCDIR@!$(includedir)!g' -e 's!@LIBDIR@!$(libdir)!g' -e 's!@LDSO@!$(LDSO_PATHNAME)!g' $< > $@
# 	chmod +x $@

# $(DESTDIR)$(bindir)/%: obj/%
# 	$(INSTALL) -D $< $@

# $(DESTDIR)$(libdir)/%.so: lib/%.so
# 	$(INSTALL) -D -m 755 $< $@

# $(DESTDIR)$(libdir)/%: lib/%
# 	$(INSTALL) -D -m 644 $< $@

# $(DESTDIR)$(includedir)/bits/%: $(srcdir)/arch/$(ARCH)/bits/%
# 	$(INSTALL) -D -m 644 $< $@

# $(DESTDIR)$(includedir)/bits/%: $(srcdir)/arch/generic/bits/%
# 	$(INSTALL) -D -m 644 $< $@

# $(DESTDIR)$(includedir)/bits/%: obj/include/bits/%
# 	$(INSTALL) -D -m 644 $< $@

# $(DESTDIR)$(includedir)/%: $(srcdir)/include/%
# 	$(INSTALL) -D -m 644 $< $@

# $(DESTDIR)$(LDSO_PATHNAME): $(DESTDIR)$(libdir)/libc.so
# 	$(INSTALL) -D -l $(libdir)/libc.so $@ || true

# install-libs: $(ALL_LIBS:lib/%=$(DESTDIR)$(libdir)/%) $(if $(SHARED_LIBS),$(DESTDIR)$(LDSO_PATHNAME),)

# install-headers: $(ALL_INCLUDES:include/%=$(DESTDIR)$(includedir)/%)

# install-tools: $(ALL_TOOLS:obj/%=$(DESTDIR)$(bindir)/%)

# install: install-libs install-headers install-tools

# musl-git-%.tar.gz: .git
# 	 git --git-dir=$(srcdir)/.git archive --format=tar.gz --prefix=$(patsubst %.tar.gz,%,$@)/ -o $@ $(patsubst musl-git-%.tar.gz,%,$@)

# musl-%.tar.gz: .git
# 	 git --git-dir=$(srcdir)/.git archive --format=tar.gz --prefix=$(patsubst %.tar.gz,%,$@)/ -o $@ v$(patsubst musl-%.tar.gz,%,$@)

# endif

# clean:
# 	rm -rf obj lib

# distclean: clean
# 	rm -f config.mak

# .PHONY: all clean install install-libs install-headers install-tools