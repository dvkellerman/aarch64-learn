// ============================================================================
// AARCH64 FLOATING-POINT AND SIMD/NEON EXAMPLES
// ============================================================================
// This file demonstrates floating-point and SIMD instructions

.global _main
.align 2

.text
_main:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    bl floating_point_examples
    bl floating_point_conversion
    bl floating_point_compare
    bl simd_vector_examples
    bl simd_arithmetic
    bl simd_logical
    
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// FLOATING-POINT DATA MOVEMENT
// ============================================================================
floating_point_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #32              // Allocate stack space for data
    
    // FMOV - Floating-point move
    fmov s0, #1.0                // Move immediate 1.0 to single precision
    fmov d1, #2.0                // Move immediate 2.0 to double precision
    fmov d2, d1                  // Copy d1 to d2
    fmov s3, s0                  // Copy s0 to s3
    
    // FMOV - Move between FP and general registers
    mov x0, #0x3FF0000000000000  // Double precision 1.0 in binary
    fmov d3, x0                  // Move from general register to FP
    fmov x1, d3                  // Move from FP to general register
    
    mov w2, #0x3F800000          // Single precision 1.0 in binary
    fmov s4, w2                  // Move from 32-bit general to single FP
    fmov w3, s4                  // Move from single FP to 32-bit general
    
    // FABS - Floating-point absolute value
    fmov d4, #-3.5
    fabs d5, d4                  // d5 = |d4| = 3.5
    fabs s6, s0                  // Single precision
    
    // FNEG - Floating-point negate
    fmov d6, #5.0
    fneg d7, d6                  // d7 = -5.0
    fneg s7, s0                  // Single precision
    
    // FSQRT - Floating-point square root
    fmov d8, #4.0
    fsqrt d9, d8                 // d9 = 2.0
    fsqrt s8, s0                 // Single precision
    
    // FADD - Floating-point addition
    fmov d10, #3.0
    fmov d11, #4.0
    fadd d12, d10, d11           // d12 = 7.0
    fadd s9, s0, s3              // Single precision
    
    // FSUB - Floating-point subtraction
    fsub d13, d11, d10           // d13 = 1.0
    fsub s10, s3, s0             // Single precision
    
    // FMUL - Floating-point multiplication
    fmul d14, d10, d11           // d14 = 12.0
    fmul s11, s0, s3             // Single precision
    
    // FDIV - Floating-point division
    fdiv d15, d11, d10           // d15 = 1.333...
    fdiv s12, s3, s0             // Single precision
    
    // FMADD - Floating-point multiply-add (a = b * c + d)
    fmov d16, #2.0
    fmov d17, #3.0
    fmov d18, #4.0
    fmadd d19, d16, d17, d18     // d19 = (2 * 3) + 4 = 10.0
    
    // FMSUB - Floating-point multiply-subtract (a = d - b * c)
    fmsub d20, d16, d17, d18     // d20 = 4 - (2 * 3) = -2.0
    
    // FNMADD - Floating-point negated multiply-add (a = -(b * c + d))
    fnmadd d21, d16, d17, d18    // d21 = -((2 * 3) + 4) = -10.0
    
    // FNMSUB - Floating-point negated multiply-subtract (a = -(d - b * c))
    fnmsub d22, d16, d17, d18    // d22 = -(4 - (2 * 3)) = 2.0
    
    // FMAX/FMIN - Maximum/Minimum
    fmov d23, #7.0
    fmov d24, #3.0
    fmax d25, d23, d24           // d25 = 7.0
    fmin d26, d23, d24           // d26 = 3.0
    
    // FMAXNM/FMINNM - Maximum/Minimum (NaN handling)
    fmaxnm d27, d23, d24         // d27 = 7.0 (ignores NaN)
    fminnm d28, d23, d24         // d28 = 3.0 (ignores NaN)
    
    // FRINT - Floating-point round to integral
    fmov d29, #3.75              // Use representable FP8 value
    frintn d30, d29              // Round to nearest (ties to even)
    frintp d31, d29              // Round to +infinity (ceiling)
    frintm d0, d29               // Round to -infinity (floor)
    frintz d1, d29               // Round to zero (truncate)
    
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// FLOATING-POINT CONVERSION
// ============================================================================
floating_point_conversion:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // FCVT - Convert between precision
    fmov s0, #1.5
    fcvt d0, s0                  // Convert single to double
    fcvt s1, d0                  // Convert double to single
    fcvt h2, s0                  // Convert single to half
    fcvt s2, h2                  // Convert half to single
    
    // SCVTF - Signed integer to floating-point
    mov x0, #42
    scvtf d1, x0                 // Convert 64-bit signed int to double
    scvtf s3, w0                 // Convert 32-bit signed int to single
    scvtf d2, w0                 // Convert 32-bit signed int to double
    
    // UCVTF - Unsigned integer to floating-point
    mov x1, #100
    ucvtf d3, x1                 // Convert 64-bit unsigned int to double
    ucvtf s4, w1                 // Convert 32-bit unsigned int to single
    
    // FCVTZS - Floating-point to signed integer (toward zero)
    fmov d4, #3.875              // Use representable FP8 value (close to 3.9)
    fcvtzs x2, d4                // x2 = 3 (toward zero)
    fcvtzs w3, s3                // 32-bit conversion
    
    // FCVTZU - Floating-point to unsigned integer (toward zero)
    fcvtzu x4, d4                // x4 = 3
    fcvtzu w5, s3                // 32-bit conversion
    
    // FCVTNS - Floating-point to signed integer (nearest)
    fcvtns x6, d4                // x6 = 4 (nearest)
    
    // FCVTNU - Floating-point to unsigned integer (nearest)
    fcvtnu x7, d4                // x7 = 4
    
    // FCVTPS - Floating-point to signed integer (toward +inf)
    fcvtps x8, d4                // x8 = 4 (ceiling)
    
    // FCVTMS - Floating-point to signed integer (toward -inf)
    fcvtms x9, d4                // x9 = 3 (floor)
    
    // FCVTAS - Floating-point to signed integer (ties away from zero)
    fmov d5, #2.5
    fcvtas x10, d5               // x10 = 3 (ties away)
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// FLOATING-POINT COMPARISON
// ============================================================================
floating_point_compare:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // FCMP - Floating-point compare
    fmov d0, #3.0
    fmov d1, #5.0
    fcmp d0, d1                  // Compare d0 with d1 (sets flags)
    b.lt .Lfp_less              // Branch if less
    b .Lfp_continue
    
.Lfp_less:
    mov x0, #1
    
.Lfp_continue:
    // FCMP with zero
    fcmp d0, #0.0                // Compare with zero
    
    // FCMPE - Floating-point compare with exception on NaN
    fcmpe d0, d1                 // Compare with NaN signaling
    
    // FCCMP - Floating-point conditional compare
    cmp x0, #1
    fccmp d0, d1, #0, eq         // Conditional FP compare
    
    // FCSEL - Floating-point conditional select
    fmov d2, #10.0
    fmov d3, #20.0
    cmp x0, x0
    fcsel d4, d2, d3, eq         // d4 = (eq) ? d2 : d3
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// SIMD/NEON VECTOR OPERATIONS - BASIC
// ============================================================================
simd_vector_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    sub sp, sp, #64
    
    // Load vectors from memory
    // First, set up some data
    mov x0, sp
    mov w1, #1
    mov w2, #2
    mov w3, #3
    mov w4, #4
    str w1, [x0, #0]
    str w2, [x0, #4]
    str w3, [x0, #8]
    str w4, [x0, #12]
    
    // LD1 - Load multiple single elements to one vector
    ld1 {v0.4s}, [x0]            // Load 4 x 32-bit values into v0
    ld1 {v1.2d}, [x0]            // Load 2 x 64-bit values into v1
    ld1 {v2.8h}, [x0]            // Load 8 x 16-bit values into v2
    ld1 {v3.16b}, [x0]           // Load 16 x 8-bit values into v3
    
    // LD2 - Load two-element structures
    ld2 {v4.4s, v5.4s}, [x0]     // Load interleaved data
    
    // ST1 - Store vector to memory
    st1 {v0.4s}, [x0]            // Store v0 to memory
    
    // DUP - Duplicate element to all lanes
    mov w5, #42
    dup v6.4s, w5                // All 4 lanes = 42
    dup v7.2d, x5                // All 2 lanes = 42
    
    // MOV - Move vector register
    mov v8.16b, v0.16b           // Copy v0 to v8
    
    // MOVI - Move immediate to vector
    movi v9.4s, #1               // All lanes = 1
    movi v10.2d, #0xFF           // All lanes = 0xFF
    
    // INS - Insert element from general register
    mov w6, #100
    ins v11.s[0], w6             // Insert into lane 0
    ins v11.s[1], w6             // Insert into lane 1
    
    // UMOV - Move vector element to general register
    umov w7, v0.s[0]             // Extract lane 0 to w7
    umov x8, v1.d[0]             // Extract 64-bit lane 0
    
    // EXT - Extract vector from pair of vectors
    ext v12.16b, v0.16b, v1.16b, #4  // Extract starting at byte 4
    
    // ZIP1/ZIP2 - Zip vectors (interleave)
    zip1 v13.4s, v0.4s, v1.4s    // Interleave lower halves
    zip2 v14.4s, v0.4s, v1.4s    // Interleave upper halves
    
    // UZP1/UZP2 - Unzip vectors (deinterleave)
    uzp1 v15.4s, v0.4s, v1.4s    // Even lanes
    uzp2 v16.4s, v0.4s, v1.4s    // Odd lanes
    
    // TRN1/TRN2 - Transpose vectors
    trn1 v17.4s, v0.4s, v1.4s    // Transpose lower
    trn2 v18.4s, v0.4s, v1.4s    // Transpose upper
    
    // REV - Reverse elements
    rev64 v19.4s, v0.4s          // Reverse in 64-bit groups
    rev32 v20.8h, v2.8h          // Reverse in 32-bit groups
    rev16 v21.16b, v3.16b        // Reverse in 16-bit groups
    
    // TBL - Table lookup
    movi v22.16b, #0x01          // Indices
    tbl v23.16b, {v0.16b}, v22.16b
    
    add sp, sp, #64
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// SIMD ARITHMETIC OPERATIONS
// ============================================================================
simd_arithmetic:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Setup vectors
    movi v0.4s, #10
    movi v1.4s, #5
    movi v2.4s, #2
    
    // ADD - Vector add
    add v3.4s, v0.4s, v1.4s      // v3 = v0 + v1 (lane by lane)
    add v4.2d, v0.2d, v1.2d      // 64-bit lanes
    add v5.8h, v0.8h, v1.8h      // 16-bit lanes
    add v6.16b, v0.16b, v1.16b   // 8-bit lanes
    
    // SUB - Vector subtract
    sub v7.4s, v0.4s, v1.4s      // v7 = v0 - v1
    
    // MUL - Vector multiply
    mul v8.4s, v0.4s, v1.4s      // v8 = v0 * v1
    
    // MLA - Vector multiply-accumulate (a = a + b * c)
    mla v3.4s, v0.4s, v1.4s      // v3 = v3 + (v0 * v1)
    
    // MLS - Vector multiply-subtract (a = a - b * c)
    mls v3.4s, v0.4s, v1.4s      // v3 = v3 - (v0 * v1)
    
    // ADDP - Pairwise add
    addp v9.4s, v0.4s, v1.4s     // Add adjacent pairs
    
    // SMAX/SMIN - Signed maximum/minimum
    smax v10.4s, v0.4s, v1.4s    // Maximum (signed)
    smin v11.4s, v0.4s, v1.4s    // Minimum (signed)
    
    // UMAX/UMIN - Unsigned maximum/minimum
    umax v12.4s, v0.4s, v1.4s    // Maximum (unsigned)
    umin v13.4s, v0.4s, v1.4s    // Minimum (unsigned)
    
    // ADDV - Add across vector
    addv s14, v0.4s              // Sum all lanes to scalar
    
    // SMAXV/SMINV - Maximum/Minimum across vector
    smaxv s15, v0.4s             // Maximum of all lanes
    sminv s16, v0.4s             // Minimum of all lanes
    
    // ABS - Absolute value
    movi v17.4s, #5
    neg v17.4s, v17.4s           // v17 = -5
    abs v18.4s, v17.4s           // v18 = |v17|
    
    // NEG - Negate
    neg v19.4s, v0.4s            // v19 = -v0
    
    // SQADD/SQSUB - Saturating add/subtract
    sqadd v20.4s, v0.4s, v1.4s   // Saturating add (signed)
    sqsub v21.4s, v0.4s, v1.4s   // Saturating subtract
    
    // UQADD/UQSUB - Unsigned saturating add/subtract
    uqadd v22.4s, v0.4s, v1.4s   // Saturating add (unsigned)
    uqsub v23.4s, v0.4s, v1.4s   // Saturating subtract
    
    // SHL/SSHR - Shift left/right
    shl v24.4s, v0.4s, #2        // Shift left by 2
    sshr v25.4s, v0.4s, #1       // Arithmetic shift right by 1
    ushr v26.4s, v0.4s, #1       // Logical shift right by 1
    
    // SSHLL/USHLL - Shift left long (widen)
    movi v27.4h, #10
    sshll v28.4s, v27.4h, #2     // Shift 16-bit to 32-bit
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// SIMD LOGICAL OPERATIONS
// ============================================================================
simd_logical:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Setup vectors
    movi v0.16b, #0xFF
    movi v1.16b, #0x0F
    movi v2.16b, #0xF0
    
    // AND - Vector bitwise AND
    and v3.16b, v0.16b, v1.16b   // v3 = v0 & v1
    
    // ORR - Vector bitwise OR
    orr v4.16b, v1.16b, v2.16b   // v4 = v1 | v2
    
    // EOR - Vector bitwise XOR
    eor v5.16b, v0.16b, v1.16b   // v5 = v0 ^ v1
    
    // BIC - Vector bitwise clear (AND NOT)
    bic v6.16b, v0.16b, v1.16b   // v6 = v0 & ~v1
    
    // ORN - Vector bitwise OR NOT
    orn v7.16b, v0.16b, v1.16b   // v7 = v0 | ~v1
    
    // MVN/NOT - Vector bitwise NOT
    mvn v8.16b, v0.16b           // v8 = ~v0
    not v9.16b, v0.16b           // v9 = ~v0 (same as MVN)
    
    // BSL - Vector bitwise select
    bsl v0.16b, v1.16b, v2.16b   // v0 = (v0 & v1) | (~v0 & v2)
    
    // BIT - Vector bitwise insert if true
    bit v1.16b, v2.16b, v0.16b   // Insert bits from v2 where v0 is true
    
    // BIF - Vector bitwise insert if false
    bif v1.16b, v2.16b, v0.16b   // Insert bits from v2 where v0 is false
    
    // CNT - Count bits set per byte
    cnt v10.16b, v0.16b          // Count 1s in each byte
    
    // CLS - Count leading sign bits
    movi v11.4s, #1
    neg v11.4s, v11.4s           // v11 = -1
    cls v12.4s, v11.4s           // Count leading sign bits
    
    // CLZ - Count leading zeros
    movi v13.4s, #0x00FF
    clz v14.4s, v13.4s           // Count leading zeros per lane
    
    // RBIT - Reverse bits
    rbit v15.16b, v0.16b         // Reverse bits in each byte
    
    ldp x29, x30, [sp], #16
    ret

.data
.align 3
sample_data:
    .word 1, 2, 3, 4, 5, 6, 7, 8
