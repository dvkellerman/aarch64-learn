```
            ╔═══════════════════════════════════════════════╗
            ║   ARM 64-bit Assembly Learning Repository    ║
            ╚═══════════════════════════════════════════════╝
```
```
  ----------------                                Arch: aarch64 (ARM64)
                                                  Lang: Assembly
  📦 Project       AArch64 Assembly Examples      Type: Educational
  🎯 Purpose       Learn ARM 64-bit Assembly      
  🔧 Toolchain     Apple Clang + as/ld            Files: 5 .s files
  📚 Topics        System calls, Stack, SIMD      Lines: ~65K+ asm
  
  📁 Project Structure
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  📄 hello_aarch64.s               ░░░░░░░░░░ (1KB)
     → Your first program: Hello World
     → Basic syscalls and register usage
  
  📄 aarch64_examples.s            ████████░░ (18KB) 
     → Comprehensive instruction reference
     → Data movement, arithmetic, logical ops
     → Bit manipulation, branches, comparisons
  
  📄 aarch64_stack_and_calling.s   ████████░░ (16KB)
     → Function calling conventions (AAPCS64)
     → Stack frame management (FP, LR)
     → Leaf vs non-leaf functions
     → Parameter passing & return values
  
  📄 aarch64_floating_point.s      ███████░░░ (14KB)
     → FP arithmetic (FADD, FSUB, FMUL, FDIV)
     → SIMD operations (NEON vectors)
     → Vector instructions & registers
  
  📄 aarch64_advanced.s            ████████░░ (17KB)
     → Advanced instruction patterns
     → Performance optimization techniques
     → Complex algorithms in assembly
  
  📖 Documentation
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  📝 AARCH64_LEARNING_GUIDE.txt
     Complete reference guide with instruction tables
     
  📝 STACK_AND_CALLING_EXPLAINED.txt  
     Deep dive into stack operations and calling conventions
  
  🚀 Quick Start
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  # Assemble and link
  as -o hello_aarch64.o hello_aarch64.s
  ld -o hello_aarch64 hello_aarch64.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _main -arch arm64
  
  # Run
  ./hello_aarch64
  
  🎓 Learning Path
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  1. hello_aarch64.s              ⭐ Start here!
  2. aarch64_examples.s           ⭐⭐ Core instructions
  3. aarch64_stack_and_calling.s  ⭐⭐⭐ Functions & ABI
  4. aarch64_floating_point.s     ⭐⭐⭐ FP & SIMD
  5. aarch64_advanced.s           ⭐⭐⭐⭐ Advanced topics
  
  💡 Key Concepts Covered
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  ✓ Register Usage      x0-x30, w0-w30, sp, fp, lr
  ✓ System Calls        macOS syscall interface (svc #0x80)
  ✓ Memory Ops          LDR, STR, LDP, STP + addressing modes
  ✓ Arithmetic          ADD, SUB, MUL, DIV, shifts
  ✓ Logical Ops         AND, ORR, EOR, bit manipulation
  ✓ Branches            B, BL, BR, conditional branches
  ✓ Stack Frames        FP/LR management, AAPCS64
  ✓ Function Calls      Parameter passing, return values
  ✓ Floating Point      FADD, FMUL, vector registers v0-v31
  ✓ SIMD/NEON          Vector operations, lane access
  
  🔗 References
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  
  • ARM Architecture Reference Manual (ARMv8)
  • AAPCS64: Procedure Call Standard for ARM 64-bit
  • Apple Silicon macOS syscall conventions
  
  ═══════════════════════════════════════════════════════════════
  Happy hacking at the hardware level! 🛠️ ⚡
  ═══════════════════════════════════════════════════════════════
```
