# tinymembench (RISC-V RVV edition)

Simple benchmark for memory throughput and latency.

This is a fork that adds RISC-V Vector Extension (RVV) support. It is based on
nuumio's fork of tinymembench (repository no longer available), which itself
derived from the original [ssvb/tinymembench](https://github.com/ssvb/tinymembench).

## Overview

This is a simple memory benchmark program, which tries to measure the peak
bandwidth of sequential memory accesses and the latency of random memory
accesses. Bandwidth is measured by running different assembly code for
the aligned memory blocks and attempting different prefetch strategies.

The benchmark results for some hardware can be found in the wiki page:
<https://github.com/ssvb/tinymembench/wiki>

## Building

This program can be compiled in either linux or windows (via mingw32 and msys)
by simply running make:

```sh
make
```

Adding extra optimization options is possible (in linux):

```sh
CFLAGS="-O2 -march=atom -mtune=atom" make
```

## Cross-compiling

Example of crosscompiling for ARM (also in linux):

```sh
CC=arm-linux-gnueabihf-gcc CFLAGS="-O2 -mcpu=cortex-a9" make
```

Example of crosscompiling and running the benchmark on android device:

```sh
CC=arm-linux-gnueabihf-gcc CFLAGS="-O2 -mcpu=cortex-a8 -static" make
adb push tinymembench /data/local/tmp/tinymembench
adb shell /data/local/tmp/tinymembench
```

Example of crosscompiling for RISC-V with the Vector extension (RVV 1.0):

```sh
CC=riscv64-unknown-linux-gnu-gcc CFLAGS="-O2 -march=rv64gcv" make
```

The RVV benchmarks are only compiled in when the target enables the vector
extension (i.e. `v` is present in `-march`).
