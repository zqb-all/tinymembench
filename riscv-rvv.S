/*
 * RISC-V Vector Extension (RVV 1.0) optimized memory operations
 * Based on tinymembench aarch64-asm.S
 *
 * Calling convention (matches util.h bench functions):
 *   a0 = dst, a1 = src, a2 = size (bytes)
 * size is always the benchmark blocksize (2048) or the framebuffer size,
 * both multiples of any RVV vlmax on conforming hardware. Loops still use
 * unsigned-safe termination so a non-multiple size cannot underflow.
 */

#ifdef __riscv_vector

    .text
    .align 2

.macro asm_function function_name
    .global \function_name
    .type \function_name,@function
\function_name:
.endm

/*
 * Block copy, LMUL=8, single vector group per iteration.
 */
asm_function aligned_block_copy_vle8_vse8_rvv
1:
    vsetvli t0, a2, e8, m8, ta, ma
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t0
    bnez    a2, 1b
    ret
.size aligned_block_copy_vle8_vse8_rvv, .-aligned_block_copy_vle8_vse8_rvv

/*
 * Block copy, LMUL=4, 2-way unrolled. Main loop runs at vlmax; a variable-vl
 * tail drains any remainder so a non-multiple size cannot underflow a2.
 */
asm_function aligned_block_copy_vle8_vse8_x2_rvv
    vsetvli t0, zero, e8, m4, ta, ma
    slli    t1, t0, 1                    /* bytes per unrolled iteration */
1:
    bltu    a2, t1, 2f
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vle8.v  v4, (a1)
    add     a1, a1, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    vse8.v  v4, (a0)
    add     a0, a0, t0
    sub     a2, a2, t1
    j       1b
2:
    beqz    a2, 3f
    vsetvli t0, a2, e8, m4, ta, ma
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t0
    bnez    a2, 2b
3:
    ret
.size aligned_block_copy_vle8_vse8_x2_rvv, .-aligned_block_copy_vle8_vse8_x2_rvv

/*
 * Block copy, LMUL=2, 4-way unrolled.
 */
asm_function aligned_block_copy_vle8_vse8_x4_rvv
    vsetvli t0, zero, e8, m2, ta, ma
    slli    t1, t0, 2                    /* bytes per unrolled iteration */
1:
    bltu    a2, t1, 2f
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vle8.v  v2, (a1)
    add     a1, a1, t0
    vle8.v  v4, (a1)
    add     a1, a1, t0
    vle8.v  v6, (a1)
    add     a1, a1, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    vse8.v  v2, (a0)
    add     a0, a0, t0
    vse8.v  v4, (a0)
    add     a0, a0, t0
    vse8.v  v6, (a0)
    add     a0, a0, t0
    sub     a2, a2, t1
    j       1b
2:
    beqz    a2, 3f
    vsetvli t0, a2, e8, m2, ta, ma
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t0
    bnez    a2, 2b
3:
    ret
.size aligned_block_copy_vle8_vse8_x4_rvv, .-aligned_block_copy_vle8_vse8_x4_rvv

/*
 * Block load (read bandwidth), LMUL=8.
 */
asm_function aligned_block_load_vle8_rvv
1:
    vsetvli t0, a2, e8, m8, ta, ma
    vle8.v  v0, (a1)
    add     a1, a1, t0
    sub     a2, a2, t0
    bnez    a2, 1b
    ret
.size aligned_block_load_vle8_rvv, .-aligned_block_load_vle8_rvv

/*
 * Block load, LMUL=4, 2-way unrolled (two independent register groups).
 */
asm_function aligned_block_load_vle8_x2_rvv
    vsetvli t0, zero, e8, m4, ta, ma
    slli    t1, t0, 1
1:
    bltu    a2, t1, 2f
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vle8.v  v4, (a1)
    add     a1, a1, t0
    sub     a2, a2, t1
    j       1b
2:
    beqz    a2, 3f
    vsetvli t0, a2, e8, m4, ta, ma
    vle8.v  v0, (a1)
    add     a1, a1, t0
    sub     a2, a2, t0
    bnez    a2, 2b
3:
    ret
.size aligned_block_load_vle8_x2_rvv, .-aligned_block_load_vle8_x2_rvv

/*
 * Block load, LMUL=2, 4-way unrolled.
 */
asm_function aligned_block_load_vle8_x4_rvv
    vsetvli t0, zero, e8, m2, ta, ma
    slli    t1, t0, 2
1:
    bltu    a2, t1, 2f
    vle8.v  v0, (a1)
    add     a1, a1, t0
    vle8.v  v2, (a1)
    add     a1, a1, t0
    vle8.v  v4, (a1)
    add     a1, a1, t0
    vle8.v  v6, (a1)
    add     a1, a1, t0
    sub     a2, a2, t1
    j       1b
2:
    beqz    a2, 3f
    vsetvli t0, a2, e8, m2, ta, ma
    vle8.v  v0, (a1)
    add     a1, a1, t0
    sub     a2, a2, t0
    bnez    a2, 2b
3:
    ret
.size aligned_block_load_vle8_x4_rvv, .-aligned_block_load_vle8_x4_rvv

/*
 * Block fill (write bandwidth), LMUL=8. The source buffer is pre-filled with
 * the fill pattern by the framework, so we load one vector group of pattern
 * and store it repeatedly. vl is fixed at vlmax for the whole buffer.
 */
asm_function aligned_block_fill_vse8_rvv
    vsetvli t0, zero, e8, m8, ta, ma
    vle8.v  v0, (a1)
1:
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t0
    bnez    a2, 1b
    ret
.size aligned_block_fill_vse8_rvv, .-aligned_block_fill_vse8_rvv

/*
 * Block fill, LMUL=4, 2-way unrolled.
 */
asm_function aligned_block_fill_vse8_x2_rvv
    vsetvli t0, zero, e8, m4, ta, ma
    vle8.v  v0, (a1)
    slli    t1, t0, 1
1:
    bltu    a2, t1, 2f
    vse8.v  v0, (a0)
    add     a0, a0, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t1
    j       1b
2:
    beqz    a2, 3f
    vsetvli t0, a2, e8, m4, ta, ma
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t0
    bnez    a2, 2b
3:
    ret
.size aligned_block_fill_vse8_x2_rvv, .-aligned_block_fill_vse8_x2_rvv

/*
 * Block fill, LMUL=2, 4-way unrolled.
 */
asm_function aligned_block_fill_vse8_x4_rvv
    vsetvli t0, zero, e8, m2, ta, ma
    vle8.v  v0, (a1)
    slli    t1, t0, 2
1:
    bltu    a2, t1, 2f
    vse8.v  v0, (a0)
    add     a0, a0, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t1
    j       1b
2:
    beqz    a2, 3f
    vsetvli t0, a2, e8, m2, ta, ma
    vse8.v  v0, (a0)
    add     a0, a0, t0
    sub     a2, a2, t0
    bnez    a2, 2b
3:
    ret
.size aligned_block_fill_vse8_x4_rvv, .-aligned_block_fill_vse8_x4_rvv

#endif
