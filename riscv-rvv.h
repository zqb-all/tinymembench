/*
 * RISC-V Vector Extension (RVV 1.0) optimized memory operations
 * Header file for tinymembench
 */

#ifndef __RISCV_RVV_ASM_H__
#define __RISCV_RVV_ASM_H__

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Block copy functions - various LMUL and unrolling strategies */
void aligned_block_copy_vle8_vse8_rvv(int64_t * __restrict dst,
                                      int64_t * __restrict src,
                                      int                  size);

void aligned_block_copy_vle8_vse8_x2_rvv(int64_t * __restrict dst,
                                         int64_t * __restrict src,
                                         int                  size);

void aligned_block_copy_vle8_vse8_x4_rvv(int64_t * __restrict dst,
                                         int64_t * __restrict src,
                                         int                  size);

/* Block load functions - read bandwidth tests */
void aligned_block_load_vle8_rvv(int64_t * __restrict dst,
                                 int64_t * __restrict src,
                                 int                  size);

void aligned_block_load_vle8_x2_rvv(int64_t * __restrict dst,
                                    int64_t * __restrict src,
                                    int                  size);

void aligned_block_load_vle8_x4_rvv(int64_t * __restrict dst,
                                    int64_t * __restrict src,
                                    int                  size);

/* Block fill functions - write bandwidth tests */
void aligned_block_fill_vse8_rvv(int64_t * __restrict dst,
                                 int64_t * __restrict src,
                                 int                  size);

void aligned_block_fill_vse8_x2_rvv(int64_t * __restrict dst,
                                    int64_t * __restrict src,
                                    int                  size);

void aligned_block_fill_vse8_x4_rvv(int64_t * __restrict dst,
                                    int64_t * __restrict src,
                                    int                  size);

#ifdef __cplusplus
}
#endif

#endif /* __RISCV_RVV_ASM_H__ */

