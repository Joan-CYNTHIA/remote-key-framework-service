#include <asm.h>

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector
.set CR0_PE_ON,             0x1                     # protected mode enable flag
.set SMAP,                  0x534d4150

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

//BIOS必须在实模式下进行，所以在bootloader进入保护模式前完成这部分工作。
//具体流程：通过BIOS中断获取内存可调用e820h的INT 15H BIOD中断，之后通过系统内存映射地址描述符格式
//来表示系统物理内存布局，并且该地址描述符保存在物理地址0x8000
//物理内存空间的探测：
//1、设置一个存放内存映射地址描述符的物理地址(这里是0x8000)
probe_memory:
    // 在0x8000处存放struct e820map, 并清除e820map中的nr_map
    //对0x8000处的32位单元清零，即给位于0x8000处的struct e820map的成员变量nr_map清零
    movl $0, 0x8000
    
    xorl %ebx, %ebx    //ebx如果是第一次调用或内存区域扫描完毕，则为0
    
    //表示调用 INT 15h BIOS中断后，BIOS返回的映射地址map描述符的起始地址
    //0x8004处将用于存放第一个内存映射地址描述符
    movw $0x8004, %di
  
//2、  将e820作为参数传递给INT 15h中断
start_probe:
    /* 传入0xe820作为INT 15h中断的参数 */
    movl $0xE820, %eax
    
    /* 内存映射地址描述符的大小 */
    //设置地址范围描述符的大小为20字节，其大小等于struct e820map的成员变量map的大小
    movl $20, %ecx
    
    //设置edx为534D4150h（即4个ASCII字符"SMAP"）
    movl $SMAP, %edx
    
    // 调用INT 15h中断，要求BIOS返回一个地址范围描述符表示的内存信息，递增di的值（20的倍数），
    //让BIOS帮我们查找出一个个的内存布局entry，并放入到一个保存地址范围描述符结构的缓冲区的map中
    int $0x15
    
    /* 如果eflags的CF位为0，则表示还有内存段需要探测 */
    jnc cont
    
    //探测有问题就结束探测
    movw $12345, 0x8000
    jmp finish_probe

//3、通过检测eflags的CF位来判断探测是否结束。如果没有结束， 设置存放下一个内存映射地址描述符的物理地址，然后跳到步骤2；如果结束，则程序结束
cont:
    /* 设置下一个内存映射地址描述符的起始地址 */
    addw $20, %di
    
    /* e820map中的nr_map加1 */
    incl 0x8000
    
    // 如果INT0X15返回的ebx为零，表示探测结束，否则还有内存段需要探测则继续探测
    cmpl $0, %ebx
    jnz start_probe
finish_probe:

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin

.data
# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
