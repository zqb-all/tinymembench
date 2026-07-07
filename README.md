# tinymembench (RISC-V RVV edition)

Simple benchmark for memory throughput and latency.

This is a fork that adds RISC-V Vector Extension (RVV) support and modern x86
backends (AVX2 / AVX512) alongside the original SSE2 code. It is based on
nuumio's fork of tinymembench (repository no longer available), which itself
derived from the original [ssvb/tinymembench](https://github.com/ssvb/tinymembench).

On x86-64 the benchmark now reports SSE2, AVX2 and AVX512 results side by side
in a single run, gating each tier on the CPU's actual capabilities (read from
`/proc/cpuinfo`), so older CPUs never execute an unsupported instruction.

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

## Credits

tinymembench is the work of many contributors across the wider community. This
fork tries to gather and preserve that work rather than reinvent it:

- **Siarhei Siamashka** ([ssvb](https://github.com/ssvb/tinymembench)) — original
  author of tinymembench and of the SSE2, ARM/NEON, AArch64 and MIPS backends.
- **nuumio** — fork that added the command-line parser, configurable buffer
  sizes, framebuffer-source and memory-scan tests (upstream repository no longer
  available; this fork is based on it).
- **Joel Luth** ([letrout / jluth](https://github.com/ssvb/tinymembench/pull/23)) —
  author of the AVX2 and AVX512 assembly backends and benchmarks, based on
  ssvb's SSE2 code.
- **Tony Mason** (fsgeek) — gcc AVX512 feature-detection improvements.
- **Travis Downs** ([travisdowns](https://github.com/travisdowns/tinymembench)) —
  hosted and iterated on the x86 AVX branch this integration draws from.

The AVX2/AVX512 sources retain their original copyright headers. If you are one
of the authors above and would like the attribution adjusted, please open an
issue.
