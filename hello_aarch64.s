// Simple Hello World program in aarch64 assembly for macOS
// This demonstrates basic system calls and register usage

.global _main           // macOS requires _main as entry point
.align 2                // Align code to 4-byte boundary

.text                   // Code section

_main:
    // Write "Hello, aarch64!\n" to stdout (file descriptor 1)
    mov x0, #1          // x0 = file descriptor (1 = stdout)
    adrp x1, message@PAGE       // Load page address of message
    add x1, x1, message@PAGEOFF // Add page offset to get full address
    mov x2, #16         // x2 = message length
    mov x16, #4         // x16 = syscall number (4 = write on macOS)
    svc #0x80           // Make system call (macOS uses 0x80)

    // Exit program with status 0
    mov x0, #0          // x0 = exit status
    mov x16, #1         // x16 = syscall number (1 = exit on macOS)
    svc #0x80           // Make system call

.data                   // Data section
message:
    .ascii "Hello, aarch64!\n"
