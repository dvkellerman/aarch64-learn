// ============================================================================
// COMPREHENSIVE AARCH64 ASSEMBLY INSTRUCTION EXAMPLES
// ============================================================================
// This file demonstrates most aarch64 instructions organized by category
// Each section is contained in its own function for clarity

.global _main
.align 2

// ============================================================================
// MAIN ENTRY POINT
// ============================================================================
.text
_main:
    stp x29, x30, [sp, #-16]!   // Save frame pointer and link register
    mov x29, sp                 // Set up frame pointer
    
    // Call each example function
    bl data_movement_examples
    bl arithmetic_examples
    bl logical_examples
    bl shift_bit_examples
    bl comparison_examples
    bl branch_examples
    bl load_store_examples
    bl multiply_divide_examples
    bl conditional_examples
    bl bit_field_examples
    
    // Exit
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 1. DATA MOVEMENT INSTRUCTIONS
// ============================================================================
data_movement_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // MOV - Move register to register
    mov x0, #42                  // Move immediate to register
    mov x1, x0                   // Copy x0 to x1
    mov w2, w1                   // 32-bit move
    
    // MOVZ - Move with zero (clears other bits)
    movz x3, #0x1234             // x3 = 0x0000000000001234
    movz x4, #0xABCD, lsl #16    // x4 = 0x00000000ABCD0000
    
    // MOVN - Move with NOT (inverts bits)
    movn x5, #0                  // x5 = 0xFFFFFFFFFFFFFFFF (-1)
    movn w6, #5                  // w6 = 0xFFFFFFFA
    
    // MOVK - Move with keep (preserves other bits)
    movz x7, #0x1111             // x7 = 0x0000000000001111
    movk x7, #0x2222, lsl #16    // x7 = 0x0000000022221111
    movk x7, #0x3333, lsl #32    // x7 = 0x0000333322221111
    movk x7, #0x4444, lsl #48    // x7 = 0x4444333322221111
    
    // MVN - Move NOT (bitwise complement)
    mov x8, #0xFF
    mvn x9, x8                   // x9 = ~x8
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 2. ARITHMETIC INSTRUCTIONS
// ============================================================================
arithmetic_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // ADD - Addition
    mov x0, #10
    mov x1, #20
    add x2, x0, x1               // x2 = x0 + x1 = 30
    add x3, x0, #5               // x3 = x0 + 5 = 15
    add w4, w0, w1               // 32-bit addition
    
    // ADDS - Addition with flags
    adds x5, x0, x1              // x5 = x0 + x1, sets flags (N,Z,C,V)
    
    // ADC - Add with carry
    mov x6, #0xFFFFFFFFFFFFFFFF
    mov x7, #1
    adds x8, x6, x7              // x8 = 0, carry flag set
    adc x9, x0, x1               // x9 = x0 + x1 + carry
    
    // SUB - Subtraction
    mov x10, #50
    mov x11, #20
    sub x12, x10, x11            // x12 = 50 - 20 = 30
    sub x13, x10, #10            // x13 = 50 - 10 = 40
    
    // SUBS - Subtraction with flags
    subs x14, x10, x11           // x14 = 50 - 20, sets flags
    
    // SBC - Subtract with carry
    sbc x15, x10, x11            // x15 = x10 - x11 - !carry
    
    // NEG - Negate (0 - x)
    mov x16, #100
    neg x17, x16                 // x17 = -100
    
    // NEGS - Negate with flags
    negs x18, x16                // x18 = -100, sets flags
    
    // INC/DEC using ADD/SUB with #1
    mov x19, #10
    add x19, x19, #1             // Increment x19
    sub x19, x19, #1             // Decrement x19
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 3. LOGICAL INSTRUCTIONS
// ============================================================================
logical_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // AND - Bitwise AND
    mov x0, #0xFF
    mov x1, #0x0F
    and x2, x0, x1               // x2 = 0x0F
    and x3, x0, #0xF0            // x3 = 0xF0
    
    // ANDS - AND with flags (test bits)
    ands x4, x0, x1              // x4 = 0x0F, sets flags
    
    // ORR - Bitwise OR
    mov x5, #0xF0
    mov x6, #0x0F
    orr x7, x5, x6               // x7 = 0xFF
    orr x8, x5, #0x0F            // x8 = 0xFF
    
    // ORN - OR NOT
    orn x9, x5, x6               // x9 = x5 | ~x6
    
    // EOR - Exclusive OR (XOR)
    mov x10, #0xFF
    mov x11, #0xAA
    eor x12, x10, x11            // x12 = 0x55
    mov x13, #0xAA
    eor x13, x10, x13            // x13 = 0x55
    
    // EON - Exclusive OR NOT
    eon x14, x10, x11            // x14 = x10 ^ ~x11
    
    // BIC - Bit Clear (AND NOT)
    mov x15, #0xFF
    mov x16, #0x0F
    bic x17, x15, x16            // x17 = 0xF0 (clear lower 4 bits)
    
    // BICS - Bit Clear with flags
    bics x18, x15, x16           // x18 = 0xF0, sets flags
    
    // TST - Test (AND but only sets flags, doesn't store result)
    mov x19, #0x80
    tst x19, #0x80               // Test if bit 7 is set (sets flags)
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 4. SHIFT AND BIT MANIPULATION
// ============================================================================
shift_bit_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // LSL - Logical Shift Left
    mov x0, #1
    lsl x1, x0, #4               // x1 = 16 (shift left by 4)
    mov x2, #2
    lsl x3, x0, x2               // x3 = 4 (shift left by x2)
    
    // LSR - Logical Shift Right (unsigned)
    mov x4, #0x80
    lsr x5, x4, #4               // x5 = 0x08
    
    // ASR - Arithmetic Shift Right (preserves sign bit)
    mov x6, #-16
    asr x7, x6, #2               // x7 = -4 (sign extended)
    
    // ROR - Rotate Right
    mov x8, #0x8000000000000001
    ror x9, x8, #1               // x9 = 0xC000000000000000
    
    // REV - Reverse bytes
    movz x10, #0xCDEF
    movk x10, #0x90AB, lsl #16
    movk x10, #0x5678, lsl #32
    movk x10, #0x1234, lsl #48   // x10 = 0x1234567890ABCDEF
    rev x11, x10                 // x11 = 0xEFCDAB9078563412
    rev32 x12, x10               // Reverse bytes in each 32-bit word
    rev16 x13, x10               // Reverse bytes in each 16-bit halfword
    
    // RBIT - Reverse bits
    mov x14, #0xFF00000000000000
    rbit x15, x14                // x15 = 0x00000000000000FF
    
    // CLZ - Count Leading Zeros
    mov x16, #0x0000000000FF0000
    clz x17, x16                 // x17 = 40 (40 leading zeros)
    
    // CLS - Count Leading Sign bits
    mov x18, #-1
    cls x19, x18                 // x19 = 63
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 5. COMPARISON INSTRUCTIONS
// ============================================================================
comparison_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // CMP - Compare (subtracts and sets flags, doesn't store result)
    mov x0, #10
    mov x1, #20
    cmp x0, x1                   // Compare x0 with x1 (sets flags)
    cmp x0, #10                  // Compare x0 with immediate
    
    // CMN - Compare Negative (adds and sets flags)
    mov x2, #-5
    cmn x2, #5                   // Compare x2 with -5 (adds 5 and sets flags)
    
    // TST - Test (AND and sets flags)
    mov x3, #0b1010
    tst x3, #0b0010              // Test if bit 1 is set
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 6. BRANCH AND CONTROL FLOW
// ============================================================================
branch_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Unconditional branch
    b .Lbranch_target1
    mov x0, #999                 // This won't execute
    
.Lbranch_target1:
    mov x0, #1
    
    // Conditional branches (after comparison)
    mov x1, #10
    mov x2, #20
    cmp x1, x2
    
    // B.cond - Branch if condition
    b.eq .Lequal                 // Branch if equal (Z flag set)
    b.ne .Lnot_equal             // Branch if not equal (Z flag clear)
    b.gt .Lgreater               // Branch if greater (signed)
    b.lt .Lless                  // Branch if less (signed)
    b.ge .Lgreater_equal         // Branch if greater or equal (signed)
    b.le .Lless_equal            // Branch if less or equal (signed)
    b.hi .Lhigher                // Branch if higher (unsigned)
    b.lo .Llower                 // Branch if lower (unsigned)
    b.hs .Lhigher_same           // Branch if higher or same (unsigned)
    b.ls .Llower_same            // Branch if lower or same (unsigned)
    b.mi .Lminus                 // Branch if minus (N flag set)
    b.pl .Lplus                  // Branch if plus (N flag clear)
    b.vs .Loverflow              // Branch if overflow (V flag set)
    b.vc .Lno_overflow           // Branch if no overflow (V flag clear)
    
.Lnot_equal:
    mov x3, #1
    b .Lbranch_end
    
.Lequal:
.Lgreater:
.Lless:
.Lgreater_equal:
.Lless_equal:
.Lhigher:
.Llower:
.Lhigher_same:
.Llower_same:
.Lminus:
.Lplus:
.Loverflow:
.Lno_overflow:
    mov x3, #0
    
.Lbranch_end:
    // BL - Branch with Link (function call)
    bl .Lsubroutine
    
    // BR - Branch to register
    adr x4, .Lbranch_target2
    br x4
    
.Lbranch_target2:
    // BLR - Branch with Link to Register
    adr x5, .Lsubroutine
    blr x5
    
    // RET - Return from subroutine
    ldp x29, x30, [sp], #16
    ret
    
.Lsubroutine:
    mov x6, #42
    ret

// ============================================================================
// 7. LOAD/STORE INSTRUCTIONS
// ============================================================================
load_store_examples:
    stp x29, x30, [sp, #-48]!    // Allocate stack space
    mov x29, sp
    
    // Store immediate on stack
    mov x0, #100
    mov x1, #200
    mov x2, #300
    
    // STR - Store Register
    str x0, [sp, #16]            // Store x0 at sp+16
    str w1, [sp, #24]            // Store 32-bit w1
    strh w2, [sp, #28]           // Store halfword (16-bit)
    strb w2, [sp, #30]           // Store byte (8-bit)
    
    // LDR - Load Register
    ldr x3, [sp, #16]            // Load from sp+16 to x3
    ldr w4, [sp, #24]            // Load 32-bit
    ldrh w5, [sp, #28]           // Load halfword (zero-extended)
    ldrb w6, [sp, #30]           // Load byte (zero-extended)
    
    // Signed loads
    ldrsw x7, [sp, #24]          // Load 32-bit sign-extended to 64-bit
    ldrsh x8, [sp, #28]          // Load halfword sign-extended
    ldrsb x9, [sp, #30]          // Load byte sign-extended
    
    // STP/LDP - Store/Load Pair
    mov x10, #111
    mov x11, #222
    stp x10, x11, [sp, #32]      // Store pair
    ldp x12, x13, [sp, #32]      // Load pair
    
    // Pre-indexed addressing
    add x14, sp, #16
    str x0, [x14, #8]!           // Store and update x14 (x14 += 8)
    
    // Post-indexed addressing
    ldr x15, [x14], #-8          // Load then update x14 (x14 -= 8)
    
    // Register offset
    mov x16, #16
    ldr x17, [sp, x16]           // Load from sp+x16
    
    // Scaled register offset
    mov x18, #2
    ldr x19, [sp, x18, lsl #3]   // Load from sp+(x18<<3) = sp+16
    
    ldp x29, x30, [sp], #48
    ret

// ============================================================================
// 8. MULTIPLY AND DIVIDE INSTRUCTIONS
// ============================================================================
multiply_divide_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // MUL - Multiply (32-bit and 64-bit)
    mov x0, #10
    mov x1, #20
    mul x2, x0, x1               // x2 = 200
    mul w3, w0, w1               // 32-bit multiply
    
    // MNEG - Multiply Negate
    mneg x4, x0, x1              // x4 = -(x0 * x1) = -200
    
    // SMULL - Signed Multiply Long (32-bit to 64-bit)
    mov w5, #-10
    mov w6, #20
    smull x7, w5, w6             // x7 = -200 (sign-extended)
    
    // UMULL - Unsigned Multiply Long
    umull x8, w0, w1             // x8 = w0 * w1 (unsigned, 64-bit result)
    
    // SMULH - Signed Multiply High (upper 64 bits)
    mov x9, #0x1000000000000000
    mov x10, #4
    smulh x11, x9, x10           // x11 = high 64 bits of (x9 * x10)
    
    // UMULH - Unsigned Multiply High
    umulh x12, x9, x10           // x12 = high 64 bits (unsigned)
    
    // MADD - Multiply-Add (a = b * c + d)
    mov x13, #5
    mov x14, #6
    mov x15, #7
    madd x16, x13, x14, x15      // x16 = (5 * 6) + 7 = 37
    
    // MSUB - Multiply-Subtract (a = d - b * c)
    msub x17, x13, x14, x15      // x17 = 7 - (5 * 6) = -23
    
    // UDIV - Unsigned Divide
    mov x18, #100
    mov x19, #5
    udiv x20, x18, x19           // x20 = 100 / 5 = 20
    
    // SDIV - Signed Divide
    mov x21, #-100
    mov x22, #5
    sdiv x23, x21, x22           // x23 = -100 / 5 = -20
    
    // Calculate remainder (no direct instruction)
    // remainder = dividend - (quotient * divisor)
    udiv x24, x18, x19           // x24 = quotient
    msub x25, x24, x19, x18      // x25 = remainder
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 9. CONDITIONAL SELECT INSTRUCTIONS
// ============================================================================
conditional_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // CSEL - Conditional Select
    mov x0, #10
    mov x1, #20
    mov x2, #100
    mov x3, #200
    cmp x0, x1
    csel x4, x2, x3, lt          // x4 = (x0 < x1) ? x2 : x3 = 100
    csel x5, x2, x3, gt          // x5 = (x0 > x1) ? x2 : x3 = 200
    csel x6, x2, x3, eq          // x6 = (x0 == x1) ? x2 : x3 = 200
    
    // CSINC - Conditional Select Increment
    csinc x7, x2, x3, lt         // x7 = (x0 < x1) ? x2 : (x3 + 1)
    
    // CSINV - Conditional Select Invert
    csinv x8, x2, x3, lt         // x8 = (x0 < x1) ? x2 : ~x3
    
    // CSNEG - Conditional Select Negate
    csneg x9, x2, x3, lt         // x9 = (x0 < x1) ? x2 : -x3
    
    // CSET - Conditional Set (set to 1 if condition true)
    cmp x0, x1
    cset x10, lt                 // x10 = (x0 < x1) ? 1 : 0
    cset x11, eq                 // x11 = (x0 == x1) ? 1 : 0
    
    // CSETM - Conditional Set Mask (set to -1 if condition true)
    csetm x12, lt                // x12 = (x0 < x1) ? -1 : 0
    
    // CINC - Conditional Increment
    mov x13, #5
    cmp x0, x1
    cinc x14, x13, lt            // x14 = (x0 < x1) ? (x13 + 1) : x13
    
    // CINV - Conditional Invert
    cinv x15, x13, lt            // x15 = (x0 < x1) ? ~x13 : x13
    
    // CNEG - Conditional Negate
    cneg x16, x13, lt            // x16 = (x0 < x1) ? -x13 : x13
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// 10. BIT FIELD INSTRUCTIONS
// ============================================================================
bit_field_examples:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // BFM - Bit Field Move
    movn x0, #0                  // x0 = 0xFFFFFFFFFFFFFFFF
    movz x1, #0xCDEF
    movk x1, #0x90AB, lsl #16
    movk x1, #0x5678, lsl #32
    movk x1, #0x1234, lsl #48    // x1 = 0x1234567890ABCDEF
    bfm x0, x1, #8, #15          // Insert bits 0-15 of x1 into x0 at position 8
    
    // UBFM - Unsigned Bit Field Move (zero extends)
    movz x2, #0xCDEF
    movk x2, #0x90AB, lsl #16
    movk x2, #0x5678, lsl #32
    movk x2, #0x1234, lsl #48    // x2 = 0x1234567890ABCDEF
    ubfm x3, x2, #8, #15         // Extract bits 8-15 (zero extended)
    
    // SBFM - Signed Bit Field Move (sign extends)
    movz x4, #0xCDEF
    movk x4, #0x90AB, lsl #16
    movk x4, #0x5678, lsl #32
    movk x4, #0xF234, lsl #48    // x4 = 0xF234567890ABCDEF
    sbfm x5, x4, #56, #63        // Extract top byte with sign extension
    
    // BFI - Bit Field Insert
    mov x6, #0xFFFFFFFFFFFFFFFF
    mov x7, #0x12
    bfi x6, x7, #8, #8           // Insert 8 bits from x7 into x6 at position 8
    
    // BFXIL - Bit Field Extract and Insert Low
    movn x8, #0                  // x8 = 0xFFFFFFFFFFFFFFFF
    movz x9, #0xCDEF
    movk x9, #0x90AB, lsl #16
    movk x9, #0x5678, lsl #32
    movk x9, #0x1234, lsl #48    // x9 = 0x1234567890ABCDEF
    bfxil x8, x9, #8, #8         // Extract 8 bits from x9[8:15] to x8[0:7]
    
    // UBFIZ - Unsigned Bit Field Insert in Zero
    mov x10, #0xFF
    ubfiz x11, x10, #8, #8       // Insert 8 bits from x10 into x11 at position 8 (zeros rest)
    
    // SBFIZ - Signed Bit Field Insert in Zero
    mov x12, #-1
    sbfiz x13, x12, #8, #8       // Insert 8 bits from x12 into x13 at position 8 (sign extend)
    
    // UBFX - Unsigned Bit Field Extract
    movz x14, #0xCDEF
    movk x14, #0x90AB, lsl #16
    movk x14, #0x5678, lsl #32
    movk x14, #0x1234, lsl #48   // x14 = 0x1234567890ABCDEF
    ubfx x15, x14, #8, #8        // Extract 8 bits starting at position 8 (zero extend)
    
    // SBFX - Signed Bit Field Extract
    movz x16, #0xCDEF
    movk x16, #0x90AB, lsl #16
    movk x16, #0x5678, lsl #32
    movk x16, #0xF234, lsl #48   // x16 = 0xF234567890ABCDEF
    sbfx x17, x16, #56, #8       // Extract 8 bits starting at position 56 (sign extend)
    
    // EXTR - Extract Register
    movz x18, #0xCDEF
    movk x18, #0x90AB, lsl #16
    movk x18, #0x5678, lsl #32
    movk x18, #0x1234, lsl #48   // x18 = 0x1234567890ABCDEF
    movz x19, #0x4321
    movk x19, #0x8765, lsl #16
    movk x19, #0xBA09, lsl #32
    movk x19, #0xFEDC, lsl #48   // x19 = 0xFEDCBA0987654321
    extr x20, x18, x19, #32      // Extract combining x18:x19, starting at bit 32
    
    ldp x29, x30, [sp], #16
    ret
