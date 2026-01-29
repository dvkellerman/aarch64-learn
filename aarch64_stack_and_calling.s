// ============================================================================
// AARCH64 STACK, CALLING CONVENTIONS, AND FRAME MANAGEMENT
// ============================================================================
// This file explains and demonstrates:
// - Stack prelude/epilogue patterns
// - Frame pointer (x29/fp) and link register (x30/lr)
// - Calling conventions
// - Stack frame layout
// - Leaf vs non-leaf functions

.global _main
.align 2

// ============================================================================
// REGISTER ROLES IN FUNCTION CALLS
// ============================================================================
//
// LINK REGISTER (x30 / lr):
//   - Stores the return address when BL/BLR is executed
//   - BL instruction: lr = PC + 4, then jumps to target
//   - RET instruction: PC = lr (return to caller)
//   - Must be saved if function calls other functions
//
// FRAME POINTER (x29 / fp):
//   - Points to the current function's stack frame
//   - Allows debuggers to walk the call stack
//   - Enables access to local variables at fixed offsets
//   - Optional but strongly recommended for debugging
//
// STACK POINTER (sp):
//   - Always points to the top of the stack
//   - Must be 16-byte aligned at function entry/exit
//   - Grows downward (toward lower addresses)
//
// PARAMETER REGISTERS (x0-x7, v0-v7):
//   - x0-x7: First 8 integer/pointer arguments
//   - v0-v7: First 8 floating-point arguments
//   - Additional args passed on stack
//
// RETURN VALUE REGISTERS:
//   - x0: Integer/pointer return value
//   - v0: Floating-point return value
//
// CALLEE-SAVED REGISTERS (must preserve):
//   - x19-x28: General purpose
//   - x29 (fp): Frame pointer
//   - x30 (lr): Link register
//   - v8-v15: Lower 64 bits of SIMD registers
//   - sp: Stack pointer
//
// CALLER-SAVED REGISTERS (can be clobbered):
//   - x0-x18: General purpose and parameters
//   - v0-v7, v16-v31: SIMD registers
//
// ============================================================================

.text

// ============================================================================
// EXAMPLE 1: MINIMAL MAIN FUNCTION
// ============================================================================
_main:
    // Standard function prologue
    stp x29, x30, [sp, #-16]!    // Push fp and lr onto stack (pre-decrement)
    mov x29, sp                  // Set frame pointer to current stack pointer
    
    // Function body
    mov x0, #0                   // Return value = 0
    
    // Standard function epilogue
    ldp x29, x30, [sp], #16      // Pop fp and lr from stack (post-increment)
    ret                          // Return to caller (PC = lr)

// ============================================================================
// STACK FRAME EXPLANATION
// ============================================================================
//
// Before function call:
// Higher addresses
// ┌─────────────────┐
// │  Caller's data  │
// ├─────────────────┤ ← sp (16-byte aligned)
// │                 │
//
// After "stp x29, x30, [sp, #-16]!":
// ┌─────────────────┐
// │  Caller's data  │
// ├─────────────────┤
// │   Old FP (x29)  │ ← sp + 8
// ├─────────────────┤
// │   Old LR (x30)  │ ← sp (new stack pointer)
// ├─────────────────┤
// │                 │
// Lower addresses
//
// After "mov x29, sp":
// ┌─────────────────┐
// │  Caller's data  │
// ├─────────────────┤
// │   Old FP (x29)  │ ← sp + 8, fp + 8 (points to caller's frame)
// ├─────────────────┤
// │   Old LR (x30)  │ ← sp, fp (current frame base)
// ├─────────────────┤
// │                 │
//
// This creates a linked list of frames:
// Current FP → Previous FP → Previous Previous FP → ... → NULL
//
// ============================================================================

// ============================================================================
// EXAMPLE 2: LEAF FUNCTION (doesn't call other functions)
// ============================================================================
// Leaf functions don't need to save lr if they don't call anyone
leaf_function_simple:
    // No prologue needed - we don't call anyone and use no callee-saved regs
    mov x0, #42                  // Return 42
    ret                          // Simple return

// However, for debugging, it's better to save fp/lr:
leaf_function_with_frame:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    mov x0, #100
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// EXAMPLE 3: NON-LEAF FUNCTION (calls other functions)
// ============================================================================
non_leaf_function:
    // Must save lr because we'll call other functions
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Call another function
    bl leaf_function_simple      // lr is overwritten with return address
    
    // We can call more functions
    bl leaf_function_with_frame  // lr is overwritten again
    
    // lr has been modified, but we saved it in prologue
    ldp x29, x30, [sp], #16
    ret                          // Returns to our caller

// ============================================================================
// EXAMPLE 4: FUNCTION WITH LOCAL VARIABLES
// ============================================================================
function_with_locals:
    // Save fp/lr and allocate stack space for locals
    stp x29, x30, [sp, #-48]!   // Push fp/lr, allocate 48 bytes total
    mov x29, sp                  // fp points to saved fp/lr
    
    // Stack layout:
    // [sp + 40] - [sp + 47] : 8 bytes available
    // [sp + 32] - [sp + 39] : 8 bytes available
    // [sp + 24] - [sp + 31] : 8 bytes available
    // [sp + 16] - [sp + 23] : 8 bytes available
    // [sp +  8] - [sp + 15] : Saved x29 (fp)
    // [sp +  0] - [sp +  7] : Saved x30 (lr)
    
    // Use local variables
    mov x0, #10
    str x0, [sp, #16]           // Local var 1
    mov x1, #20
    str x1, [sp, #24]           // Local var 2
    
    // Access them
    ldr x2, [sp, #16]
    ldr x3, [sp, #24]
    add x0, x2, x3              // Return sum
    
    // Clean up and return
    ldp x29, x30, [sp], #48     // Pop fp/lr, deallocate 48 bytes
    ret

// ============================================================================
// EXAMPLE 5: FUNCTION USING CALLEE-SAVED REGISTERS
// ============================================================================
function_with_callee_saved:
    // Must save any x19-x28 registers we use
    stp x29, x30, [sp, #-48]!   // Save fp/lr
    mov x29, sp
    stp x19, x20, [sp, #16]     // Save x19, x20 (callee-saved)
    stp x21, x22, [sp, #32]     // Save x21, x22 (callee-saved)
    
    // Stack layout:
    // [sp + 40] - [sp + 47] : Available
    // [sp + 32] - [sp + 39] : Saved x21, x22
    // [sp + 24] - [sp + 31] : Available
    // [sp + 16] - [sp + 23] : Saved x19, x20
    // [sp +  8] - [sp + 15] : Saved x29 (fp)
    // [sp +  0] - [sp +  7] : Saved x30 (lr)
    
    // Now we can use x19-x22 freely
    mov x19, #1
    mov x20, #2
    mov x21, #3
    mov x22, #4
    
    // Do work with these registers
    add x0, x19, x20
    add x0, x0, x21
    add x0, x0, x22             // Return 1+2+3+4 = 10
    
    // Restore callee-saved registers in reverse order
    ldp x21, x22, [sp, #32]
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret

// ============================================================================
// EXAMPLE 6: FUNCTION WITH MANY PARAMETERS
// ============================================================================
// First 8 args in x0-x7, rest on stack
function_with_many_params:
    // Parameters:
    // x0 = arg1, x1 = arg2, ..., x7 = arg8
    // [fp, #16] = arg9 (first stack parameter)
    // [fp, #24] = arg10 (second stack parameter)
    
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Access register parameters
    add x0, x0, x1              // arg1 + arg2
    add x0, x0, x2              // + arg3
    add x0, x0, x3              // + arg4
    add x0, x0, x4              // + arg5
    add x0, x0, x5              // + arg6
    add x0, x0, x6              // + arg7
    add x0, x0, x7              // + arg8
    
    // Access stack parameters (if they existed)
    // ldr x8, [fp, #16]        // arg9
    // add x0, x0, x8
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// EXAMPLE 7: CALLING FUNCTION WITH MANY PARAMETERS
// ============================================================================
call_function_with_many_params:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // If we had 10 parameters, we'd do:
    // sub sp, sp, #16           // Allocate space for args 9-10
    // mov x8, #9
    // str x8, [sp, #0]          // arg9
    // mov x8, #10
    // str x8, [sp, #8]          // arg10
    
    // Set up register parameters
    mov x0, #1                   // arg1
    mov x1, #2                   // arg2
    mov x2, #3                   // arg3
    mov x3, #4                   // arg4
    mov x4, #5                   // arg5
    mov x5, #6                   // arg6
    mov x6, #7                   // arg7
    mov x7, #8                   // arg8
    
    bl function_with_many_params
    
    // Clean up stack parameters if we had them
    // add sp, sp, #16
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// EXAMPLE 8: VARIADIC FUNCTION (like printf)
// ============================================================================
// In real variadic functions, you'd need to save all parameter registers
variadic_function_example:
    // Save all parameter registers
    stp x29, x30, [sp, #-96]!   // Save fp/lr, allocate 96 bytes
    mov x29, sp
    
    // Save all 8 parameter registers
    stp x0, x1, [sp, #16]
    stp x2, x3, [sp, #32]
    stp x4, x5, [sp, #48]
    stp x6, x7, [sp, #64]
    
    // x0 typically points to format string
    // x1-x7 are variadic arguments
    // Additional args would be on stack at [fp, #16]...
    
    // Process arguments...
    // (actual implementation would parse format string and process args)
    
    ldp x29, x30, [sp], #96
    ret

// ============================================================================
// EXAMPLE 9: TAIL CALL OPTIMIZATION
// ============================================================================
// When the last thing a function does is call another function,
// we can jump instead of calling, reusing our stack frame
function_that_tail_calls:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Do some work
    mov x0, #42
    
    // Instead of:
    // bl some_function
    // ldp x29, x30, [sp], #16
    // ret
    
    // We can do a tail call:
    ldp x29, x30, [sp], #16
    b leaf_function_simple       // Jump, not call (no lr modification)
    
    // This is equivalent to:
    // 1. Restore our stack frame
    // 2. Jump to target
    // 3. Target will return to OUR caller

// ============================================================================
// EXAMPLE 10: RECURSIVE FUNCTION
// ============================================================================
// Calculate factorial recursively to demonstrate stack frame chains
factorial:
    // factorial(n) = n * factorial(n-1), base case: factorial(0) = 1
    stp x29, x30, [sp, #-32]!
    mov x29, sp
    str x0, [sp, #16]           // Save n
    
    // Base case: if (n <= 1) return 1
    cmp x0, #1
    b.gt .Lfactorial_recursive
    mov x0, #1
    b .Lfactorial_return
    
.Lfactorial_recursive:
    // Recursive case: n * factorial(n-1)
    ldr x0, [sp, #16]           // Load n
    sub x0, x0, #1              // n - 1
    bl factorial                // Call factorial(n-1)
    // x0 now contains factorial(n-1)
    
    ldr x1, [sp, #16]           // Load n
    mul x0, x0, x1              // n * factorial(n-1)
    
.Lfactorial_return:
    ldp x29, x30, [sp], #32
    ret

// ============================================================================
// EXAMPLE 11: DEMONSTRATING THE COMPLETE PATTERN
// ============================================================================
complete_function_example:
    // 1. PROLOGUE: Save state and allocate stack
    stp x29, x30, [sp, #-64]!   // Save fp/lr, allocate 64 bytes
    mov x29, sp                  // Set up frame pointer
    stp x19, x20, [sp, #16]     // Save callee-saved registers
    
    // 2. FUNCTION BODY
    // Use parameters (x0-x7)
    mov x19, x0                  // Save parameter in callee-saved reg
    
    // Use local variables
    mov x0, #100
    str x0, [sp, #32]           // Local var 1
    mov x1, #200
    str x1, [sp, #40]           // Local var 2
    
    // Call other functions
    bl leaf_function_simple
    
    // Use callee-saved registers (preserved across calls)
    add x0, x0, x19             // Use saved parameter
    
    // 3. EPILOGUE: Restore state and return
    ldp x19, x20, [sp, #16]     // Restore callee-saved registers
    ldp x29, x30, [sp], #64     // Restore fp/lr, deallocate stack
    ret                          // Return to caller

// ============================================================================
// EXAMPLE 12: FRAME POINTER CHAIN (for debuggers)
// ============================================================================
// The frame pointer creates a linked list that debuggers can walk:
//
// main's frame:
//   [fp] → previous fp (NULL or _start's fp)
//   [fp+8] → return address to _start or dyld
//
// function_a's frame (called by main):
//   [fp] → main's fp
//   [fp+8] → return address to main
//
// function_b's frame (called by function_a):
//   [fp] → function_a's fp
//   [fp+8] → return address to function_a
//
// Debugger walks the chain:
// current fp → [fp] → [fp] → ... → NULL
// Reading [fp+8] at each step gives the call stack

demonstrate_frame_chain:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // At this point:
    // - x29 (fp) points to saved fp/lr pair
    // - [x29] contains caller's fp
    // - [x29, #8] contains return address
    // - Debugger can walk: current fp → [fp] → [fp] → ...
    
    bl level1_function
    
    ldp x29, x30, [sp], #16
    ret

level1_function:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    bl level2_function
    
    ldp x29, x30, [sp], #16
    ret

level2_function:
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // At this point, the frame chain is:
    // level2 fp → level1 fp → demonstrate_frame_chain fp → ...
    
    ldp x29, x30, [sp], #16
    ret

// ============================================================================
// KEY TAKEAWAYS
// ============================================================================
//
// 1. ALWAYS save x29/x30 at function entry if you:
//    - Call other functions (lr will be overwritten)
//    - Want debuggable code (frame pointer chain)
//    - Use callee-saved registers x19-x28
//
// 2. STACK ALIGNMENT:
//    - Stack pointer must be 16-byte aligned
//    - stp/ldp naturally work with 16-byte alignment
//
// 3. PROLOGUE PATTERN:
//    stp x29, x30, [sp, #-N]!  // N = 16 + locals + saved regs
//    mov x29, sp                // Set frame pointer
//    [save other callee-saved registers]
//
// 4. EPILOGUE PATTERN:
//    [restore other callee-saved registers]
//    ldp x29, x30, [sp], #N    // Restore and deallocate
//    ret
//
// 5. LEAF FUNCTIONS:
//    - Can skip saving lr if they don't call anyone
//    - Still recommended to save for debugging
//
// 6. CALLEE-SAVED vs CALLER-SAVED:
//    - x0-x18: Caller saves if needed (can be clobbered)
//    - x19-x28: Callee must save/restore if used
//    - x29, x30: Always save in non-trivial functions
//
// 7. PARAMETER PASSING:
//    - First 8 integer args: x0-x7
//    - First 8 FP args: v0-v7
//    - Additional args: on stack at [fp, #16], [fp, #24], ...
//
// 8. RETURN VALUES:
//    - Integer/pointer: x0
//    - FP: v0
//    - 128-bit: x0 (low), x1 (high)
//
// ============================================================================

.data
.align 8
dummy_data:
    .quad 0
