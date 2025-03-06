
#    musl libc

musl, pronounced like the word "mussel", is an MIT-licensed
implementation of the standard C library targetting the Linux syscall
API, suitable for use in a wide range of deployment environments. musl
offers efficient static and dynamic linking support, lightweight code
and low runtime overhead, strong fail-safe guarantees under correct
usage, and correctness in the sense of standards conformance and
safety. musl is built on the principle that these goals are best
achieved through simple code that is easy to understand and maintain.

The 1.1 release series for musl features coverage for all interfaces
defined in ISO C99 and POSIX 2008 base, along with a number of
non-standardized interfaces for compatibility with Linux, BSD, and
glibc functionality.

For basic installation instructions, see the included INSTALL file.
Information on full musl-targeted compiler toolchains, system
bootstrapping, and Linux distributions built on musl can be found on
the project website:

    http://www.musl-libc.org/

[![Build Status](https://travis-ci.org/kraj/musl.svg?branch=kraj%2Fmaster)](https://travis-ci.org/kraj/musl)
<a href="https://scan.coverity.com/projects/kraj-musl">
  <img alt="Coverity Scan Build Status"
       src="https://scan.coverity.com/projects/12003/badge.svg"/>
</a>
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/kraj/musl/blob/kraj/master/COPYRIGHT)



Commands to run for adding instrumentation to generate an executable of C file
/usr/local/bin/clang -emit-llvm -S hello.c
/usr/local/bin/opt -load /home/kunalpansare/llvm-pass-skeleton/build/skeleton/libSkeletonPass.* -skeleton -S hello.ll -o test_pass.ll
/usr/local/bin/clang -c test_pass.ll
/usr/local/bin/clang -c extras.c
/usr/local/bin/clang extras.o test_pass.o -o test.bin -L/usr/lib -I/usr/local/musl/include -lc -static
./test.bin

Non instrumented version
/usr/local/bin/clang -o helloworld hello.c -L/usr/lib -I/usr/local/musl/include -lc -static
./helloworld

The makefile contains both, compiling musl with clang(instrumented and non-instrumented) version.
Non instrumented version commented at the bottom.
To build run the following commands
cd musl
sudo make clean
sudo make
sudo make install

