
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 b0 11 c0 	movl   $0xc011b000,(%esp)
c0100059:	e8 ec 5d 00 00       	call   c0105e4a <memset>

    cons_init();                // init the console
c010005e:	e8 ea 15 00 00       	call   c010164d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 e0 5f 10 c0 	movl   $0xc0105fe0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 fc 5f 10 c0 	movl   $0xc0105ffc,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 35 43 00 00       	call   c01043c1 <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 3d 17 00 00       	call   c01017ce <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 c4 18 00 00       	call   c010195a <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 11 0d 00 00       	call   c0100dac <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 8c 16 00 00       	call   c010172c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 03 0c 00 00       	call   c0100cc7 <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	89 ec                	mov    %ebp,%esp
c01000c7:	5d                   	pop    %ebp
c01000c8:	c3                   	ret    

c01000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c9:	55                   	push   %ebp
c01000ca:	89 e5                	mov    %esp,%ebp
c01000cc:	83 ec 18             	sub    $0x18,%esp
c01000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b0 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f6:	89 ec                	mov    %ebp,%esp
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 b7 ff ff ff       	call   c01000c9 <grade_backtrace1>
}
c0100112:	90                   	nop
c0100113:	89 ec                	mov    %ebp,%esp
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <grade_backtrace>:

void
grade_backtrace(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011d:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100129:	ff 
c010012a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100135:	e8 c0 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c010013a:	90                   	nop
c010013b:	89 ec                	mov    %ebp,%esp
c010013d:	5d                   	pop    %ebp
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 01 60 10 c0 	movl   $0xc0106001,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 0f 60 10 c0 	movl   $0xc010600f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 1d 60 10 c0 	movl   $0xc010601d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 2b 60 10 c0 	movl   $0xc010602b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 39 60 10 c0 	movl   $0xc0106039,(%esp)
c01001ea:	e8 67 01 00 00       	call   c0100356 <cprintf>
    round ++;
c01001ef:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
}
c01001fa:	90                   	nop
c01001fb:	89 ec                	mov    %ebp,%esp
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	90                   	nop
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100208:	90                   	nop
c0100209:	5d                   	pop    %ebp
c010020a:	c3                   	ret    

c010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
c010020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100211:	e8 29 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100216:	c7 04 24 48 60 10 c0 	movl   $0xc0106048,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 68 60 10 c0 	movl   $0xc0106068,(%esp)
c0100233:	e8 1e 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_kernel();
c0100238:	e8 c8 ff ff ff       	call   c0100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023d:	e8 fd fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c0100242:	90                   	nop
c0100243:	89 ec                	mov    %ebp,%esp
c0100245:	5d                   	pop    %ebp
c0100246:	c3                   	ret    

c0100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100247:	55                   	push   %ebp
c0100248:	89 e5                	mov    %esp,%ebp
c010024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100251:	74 13                	je     c0100266 <readline+0x1f>
        cprintf("%s", prompt);
c0100253:	8b 45 08             	mov    0x8(%ebp),%eax
c0100256:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025a:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c0100261:	e8 f0 00 00 00       	call   c0100356 <cprintf>
    }
    int i = 0, c;
c0100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010026d:	e8 73 01 00 00       	call   c01003e5 <getchar>
c0100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100279:	79 07                	jns    c0100282 <readline+0x3b>
            return NULL;
c010027b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100280:	eb 78                	jmp    c01002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100286:	7e 28                	jle    c01002b0 <readline+0x69>
c0100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028f:	7f 1f                	jg     c01002b0 <readline+0x69>
            cputchar(c);
c0100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100294:	89 04 24             	mov    %eax,(%esp)
c0100297:	e8 e2 00 00 00       	call   c010037e <cputchar>
            buf[i ++] = c;
c010029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029f:	8d 50 01             	lea    0x1(%eax),%edx
c01002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a8:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
c01002ae:	eb 45                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b4:	75 16                	jne    c01002cc <readline+0x85>
c01002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ba:	7e 10                	jle    c01002cc <readline+0x85>
            cputchar(c);
c01002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002bf:	89 04 24             	mov    %eax,(%esp)
c01002c2:	e8 b7 00 00 00       	call   c010037e <cputchar>
            i --;
c01002c7:	ff 4d f4             	decl   -0xc(%ebp)
c01002ca:	eb 29                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d0:	74 06                	je     c01002d8 <readline+0x91>
c01002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d6:	75 95                	jne    c010026d <readline+0x26>
            cputchar(c);
c01002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002db:	89 04 24             	mov    %eax,(%esp)
c01002de:	e8 9b 00 00 00       	call   c010037e <cputchar>
            buf[i] = '\0';
c01002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e6:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ee:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
c01002f3:	eb 05                	jmp    c01002fa <readline+0xb3>
        c = getchar();
c01002f5:	e9 73 ff ff ff       	jmp    c010026d <readline+0x26>
        }
    }
}
c01002fa:	89 ec                	mov    %ebp,%esp
c01002fc:	5d                   	pop    %ebp
c01002fd:	c3                   	ret    

c01002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002fe:	55                   	push   %ebp
c01002ff:	89 e5                	mov    %esp,%ebp
c0100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100304:	8b 45 08             	mov    0x8(%ebp),%eax
c0100307:	89 04 24             	mov    %eax,(%esp)
c010030a:	e8 6d 13 00 00       	call   c010167c <cons_putc>
    (*cnt) ++;
c010030f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100312:	8b 00                	mov    (%eax),%eax
c0100314:	8d 50 01             	lea    0x1(%eax),%edx
c0100317:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031a:	89 10                	mov    %edx,(%eax)
}
c010031c:	90                   	nop
c010031d:	89 ec                	mov    %ebp,%esp
c010031f:	5d                   	pop    %ebp
c0100320:	c3                   	ret    

c0100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100321:	55                   	push   %ebp
c0100322:	89 e5                	mov    %esp,%ebp
c0100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100335:	8b 45 08             	mov    0x8(%ebp),%eax
c0100338:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100343:	c7 04 24 fe 02 10 c0 	movl   $0xc01002fe,(%esp)
c010034a:	e8 26 53 00 00       	call   c0105675 <vprintfmt>
    return cnt;
c010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100352:	89 ec                	mov    %ebp,%esp
c0100354:	5d                   	pop    %ebp
c0100355:	c3                   	ret    

c0100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100356:	55                   	push   %ebp
c0100357:	89 e5                	mov    %esp,%ebp
c0100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035c:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100365:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100369:	8b 45 08             	mov    0x8(%ebp),%eax
c010036c:	89 04 24             	mov    %eax,(%esp)
c010036f:	e8 ad ff ff ff       	call   c0100321 <vcprintf>
c0100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037a:	89 ec                	mov    %ebp,%esp
c010037c:	5d                   	pop    %ebp
c010037d:	c3                   	ret    

c010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037e:	55                   	push   %ebp
c010037f:	89 e5                	mov    %esp,%ebp
c0100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100384:	8b 45 08             	mov    0x8(%ebp),%eax
c0100387:	89 04 24             	mov    %eax,(%esp)
c010038a:	e8 ed 12 00 00       	call   c010167c <cons_putc>
}
c010038f:	90                   	nop
c0100390:	89 ec                	mov    %ebp,%esp
c0100392:	5d                   	pop    %ebp
c0100393:	c3                   	ret    

c0100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100394:	55                   	push   %ebp
c0100395:	89 e5                	mov    %esp,%ebp
c0100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003a1:	eb 13                	jmp    c01003b6 <cputs+0x22>
        cputch(c, &cnt);
c01003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003ae:	89 04 24             	mov    %eax,(%esp)
c01003b1:	e8 48 ff ff ff       	call   c01002fe <cputch>
    while ((c = *str ++) != '\0') {
c01003b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b9:	8d 50 01             	lea    0x1(%eax),%edx
c01003bc:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bf:	0f b6 00             	movzbl (%eax),%eax
c01003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c9:	75 d8                	jne    c01003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d9:	e8 20 ff ff ff       	call   c01002fe <cputch>
    return cnt;
c01003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003e1:	89 ec                	mov    %ebp,%esp
c01003e3:	5d                   	pop    %ebp
c01003e4:	c3                   	ret    

c01003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003e5:	55                   	push   %ebp
c01003e6:	89 e5                	mov    %esp,%ebp
c01003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003eb:	90                   	nop
c01003ec:	e8 ca 12 00 00       	call   c01016bb <cons_getc>
c01003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f8:	74 f2                	je     c01003ec <getchar+0x7>
        /* do nothing */;
    return c;
c01003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003fd:	89 ec                	mov    %ebp,%esp
c01003ff:	5d                   	pop    %ebp
c0100400:	c3                   	ret    

c0100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100401:	55                   	push   %ebp
c0100402:	89 e5                	mov    %esp,%ebp
c0100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100407:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040a:	8b 00                	mov    (%eax),%eax
c010040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010040f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100412:	8b 00                	mov    (%eax),%eax
c0100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010041e:	e9 ca 00 00 00       	jmp    c01004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c0100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100429:	01 d0                	add    %edx,%eax
c010042b:	89 c2                	mov    %eax,%edx
c010042d:	c1 ea 1f             	shr    $0x1f,%edx
c0100430:	01 d0                	add    %edx,%eax
c0100432:	d1 f8                	sar    %eax
c0100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043d:	eb 03                	jmp    c0100442 <stab_binsearch+0x41>
            m --;
c010043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100448:	7c 1f                	jl     c0100469 <stab_binsearch+0x68>
c010044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010044d:	89 d0                	mov    %edx,%eax
c010044f:	01 c0                	add    %eax,%eax
c0100451:	01 d0                	add    %edx,%eax
c0100453:	c1 e0 02             	shl    $0x2,%eax
c0100456:	89 c2                	mov    %eax,%edx
c0100458:	8b 45 08             	mov    0x8(%ebp),%eax
c010045b:	01 d0                	add    %edx,%eax
c010045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100461:	0f b6 c0             	movzbl %al,%eax
c0100464:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100467:	75 d6                	jne    c010043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010046f:	7d 09                	jge    c010047a <stab_binsearch+0x79>
            l = true_m + 1;
c0100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100474:	40                   	inc    %eax
c0100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100478:	eb 73                	jmp    c01004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100484:	89 d0                	mov    %edx,%eax
c0100486:	01 c0                	add    %eax,%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	c1 e0 02             	shl    $0x2,%eax
c010048d:	89 c2                	mov    %eax,%edx
c010048f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100492:	01 d0                	add    %edx,%eax
c0100494:	8b 40 08             	mov    0x8(%eax),%eax
c0100497:	39 45 18             	cmp    %eax,0x18(%ebp)
c010049a:	76 11                	jbe    c01004ad <stab_binsearch+0xac>
            *region_left = m;
c010049c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a7:	40                   	inc    %eax
c01004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ab:	eb 40                	jmp    c01004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b0:	89 d0                	mov    %edx,%eax
c01004b2:	01 c0                	add    %eax,%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	c1 e0 02             	shl    $0x2,%eax
c01004b9:	89 c2                	mov    %eax,%edx
c01004bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01004be:	01 d0                	add    %edx,%eax
c01004c0:	8b 40 08             	mov    0x8(%eax),%eax
c01004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004c6:	73 14                	jae    c01004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	48                   	dec    %eax
c01004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004da:	eb 11                	jmp    c01004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e2:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f3:	0f 8e 2a ff ff ff    	jle    c0100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fd:	75 0f                	jne    c010050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100502:	8b 00                	mov    (%eax),%eax
c0100504:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100507:	8b 45 10             	mov    0x10(%ebp),%eax
c010050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010050c:	eb 3e                	jmp    c010054c <stab_binsearch+0x14b>
        l = *region_right;
c010050e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100516:	eb 03                	jmp    c010051b <stab_binsearch+0x11a>
c0100518:	ff 4d fc             	decl   -0x4(%ebp)
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100523:	7e 1f                	jle    c0100544 <stab_binsearch+0x143>
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 d0                	mov    %edx,%eax
c010052a:	01 c0                	add    %eax,%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	c1 e0 02             	shl    $0x2,%eax
c0100531:	89 c2                	mov    %eax,%edx
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	01 d0                	add    %edx,%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100542:	75 d4                	jne    c0100518 <stab_binsearch+0x117>
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
}
c010054c:	90                   	nop
c010054d:	89 ec                	mov    %ebp,%esp
c010054f:	5d                   	pop    %ebp
c0100550:	c3                   	ret    

c0100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100551:	55                   	push   %ebp
c0100552:	89 e5                	mov    %esp,%ebp
c0100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055a:	c7 00 8c 60 10 c0    	movl   $0xc010608c,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 8c 60 10 c0 	movl   $0xc010608c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100581:	8b 55 08             	mov    0x8(%ebp),%edx
c0100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100587:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100591:	c7 45 f4 08 73 10 c0 	movl   $0xc0107308,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 5c 2a 11 c0 	movl   $0xc0112a5c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec 5d 2a 11 c0 	movl   $0xc0112a5d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 f5 5f 11 c0 	movl   $0xc0115ff5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b3:	76 0b                	jbe    c01005c0 <debuginfo_eip+0x6f>
c01005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b8:	48                   	dec    %eax
c01005b9:	0f b6 00             	movzbl (%eax),%eax
c01005bc:	84 c0                	test   %al,%al
c01005be:	74 0a                	je     c01005ca <debuginfo_eip+0x79>
        return -1;
c01005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c5:	e9 ab 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005d7:	c1 f8 02             	sar    $0x2,%eax
c01005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e0:	48                   	dec    %eax
c01005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f2:	00 
c01005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100604:	89 04 24             	mov    %eax,(%esp)
c0100607:	e8 f5 fd ff ff       	call   c0100401 <stab_binsearch>
    if (lfile == 0)
c010060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060f:	85 c0                	test   %eax,%eax
c0100611:	75 0a                	jne    c010061d <debuginfo_eip+0xcc>
        return -1;
c0100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100618:	e9 58 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100629:	8b 45 08             	mov    0x8(%ebp),%eax
c010062c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100637:	00 
c0100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100649:	89 04 24             	mov    %eax,(%esp)
c010064c:	e8 b0 fd ff ff       	call   c0100401 <stab_binsearch>

    if (lfun <= rfun) {
c0100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100657:	39 c2                	cmp    %eax,%edx
c0100659:	7f 78                	jg     c01006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	89 d0                	mov    %edx,%eax
c0100662:	01 c0                	add    %eax,%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	c1 e0 02             	shl    $0x2,%eax
c0100669:	89 c2                	mov    %eax,%edx
c010066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066e:	01 d0                	add    %edx,%eax
c0100670:	8b 10                	mov    (%eax),%edx
c0100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100678:	39 c2                	cmp    %eax,%edx
c010067a:	73 22                	jae    c010069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067f:	89 c2                	mov    %eax,%edx
c0100681:	89 d0                	mov    %edx,%eax
c0100683:	01 c0                	add    %eax,%eax
c0100685:	01 d0                	add    %edx,%eax
c0100687:	c1 e0 02             	shl    $0x2,%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068f:	01 d0                	add    %edx,%eax
c0100691:	8b 10                	mov    (%eax),%edx
c0100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100696:	01 c2                	add    %eax,%edx
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a1:	89 c2                	mov    %eax,%edx
c01006a3:	89 d0                	mov    %edx,%eax
c01006a5:	01 c0                	add    %eax,%eax
c01006a7:	01 d0                	add    %edx,%eax
c01006a9:	c1 e0 02             	shl    $0x2,%eax
c01006ac:	89 c2                	mov    %eax,%edx
c01006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b1:	01 d0                	add    %edx,%eax
c01006b3:	8b 50 08             	mov    0x8(%eax),%edx
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bf:	8b 40 10             	mov    0x10(%eax),%eax
c01006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d1:	eb 15                	jmp    c01006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006eb:	8b 40 08             	mov    0x8(%eax),%eax
c01006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f5:	00 
c01006f6:	89 04 24             	mov    %eax,(%esp)
c01006f9:	e8 c4 55 00 00       	call   c0105cc2 <strfind>
c01006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100701:	8b 4a 08             	mov    0x8(%edx),%ecx
c0100704:	29 c8                	sub    %ecx,%eax
c0100706:	89 c2                	mov    %eax,%edx
c0100708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100711:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071c:	00 
c010071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100720:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072e:	89 04 24             	mov    %eax,(%esp)
c0100731:	e8 cb fc ff ff       	call   c0100401 <stab_binsearch>
    if (lline <= rline) {
c0100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073c:	39 c2                	cmp    %eax,%edx
c010073e:	7f 23                	jg     c0100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c0100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100743:	89 c2                	mov    %eax,%edx
c0100745:	89 d0                	mov    %edx,%eax
c0100747:	01 c0                	add    %eax,%eax
c0100749:	01 d0                	add    %edx,%eax
c010074b:	c1 e0 02             	shl    $0x2,%eax
c010074e:	89 c2                	mov    %eax,%edx
c0100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100753:	01 d0                	add    %edx,%eax
c0100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100761:	eb 11                	jmp    c0100774 <debuginfo_eip+0x223>
        return -1;
c0100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100768:	e9 08 01 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100770:	48                   	dec    %eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b5                	jne    c010076d <debuginfo_eip+0x21c>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 99                	je     c010076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 42                	jl     c0100820 <debuginfo_eip+0x2cf>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007fb:	39 c2                	cmp    %eax,%edx
c01007fd:	73 21                	jae    c0100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	89 d0                	mov    %edx,%eax
c0100806:	01 c0                	add    %eax,%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	c1 e0 02             	shl    $0x2,%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100812:	01 d0                	add    %edx,%eax
c0100814:	8b 10                	mov    (%eax),%edx
c0100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100819:	01 c2                	add    %eax,%edx
c010081b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100826:	39 c2                	cmp    %eax,%edx
c0100828:	7d 46                	jge    c0100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c010082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082d:	40                   	inc    %eax
c010082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100831:	eb 16                	jmp    c0100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	8b 40 14             	mov    0x14(%eax),%eax
c0100839:	8d 50 01             	lea    0x1(%eax),%edx
c010083c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100845:	40                   	inc    %eax
c0100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010084f:	39 c2                	cmp    %eax,%edx
c0100851:	7d 1d                	jge    c0100870 <debuginfo_eip+0x31f>
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c a0                	cmp    $0xa0,%al
c010086e:	74 c3                	je     c0100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100875:	89 ec                	mov    %ebp,%esp
c0100877:	5d                   	pop    %ebp
c0100878:	c3                   	ret    

c0100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100879:	55                   	push   %ebp
c010087a:	89 e5                	mov    %esp,%ebp
c010087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010087f:	c7 04 24 96 60 10 c0 	movl   $0xc0106096,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 af 60 10 c0 	movl   $0xc01060af,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 d6 5f 10 	movl   $0xc0105fd6,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 c7 60 10 c0 	movl   $0xc01060c7,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 b0 11 	movl   $0xc011b000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 df 60 10 c0 	movl   $0xc01060df,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c bf 11 	movl   $0xc011bf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 f7 60 10 c0 	movl   $0xc01060f7,(%esp)
c01008d6:	e8 7b fa ff ff       	call   c0100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008db:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c01008e0:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f0:	85 c0                	test   %eax,%eax
c01008f2:	0f 48 c2             	cmovs  %edx,%eax
c01008f5:	c1 f8 0a             	sar    $0xa,%eax
c01008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fc:	c7 04 24 10 61 10 c0 	movl   $0xc0106110,(%esp)
c0100903:	e8 4e fa ff ff       	call   c0100356 <cprintf>
}
c0100908:	90                   	nop
c0100909:	89 ec                	mov    %ebp,%esp
c010090b:	5d                   	pop    %ebp
c010090c:	c3                   	ret    

c010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010090d:	55                   	push   %ebp
c010090e:	89 e5                	mov    %esp,%ebp
c0100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010091d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100920:	89 04 24             	mov    %eax,(%esp)
c0100923:	e8 29 fc ff ff       	call   c0100551 <debuginfo_eip>
c0100928:	85 c0                	test   %eax,%eax
c010092a:	74 15                	je     c0100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100933:	c7 04 24 3a 61 10 c0 	movl   $0xc010613a,(%esp)
c010093a:	e8 17 fa ff ff       	call   c0100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010093f:	eb 6c                	jmp    c01009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100948:	eb 1b                	jmp    c0100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c010094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100950:	01 d0                	add    %edx,%eax
c0100952:	0f b6 10             	movzbl (%eax),%edx
c0100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095e:	01 c8                	add    %ecx,%eax
c0100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100962:	ff 45 f4             	incl   -0xc(%ebp)
c0100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010096b:	7c dd                	jl     c010094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100976:	01 d0                	add    %edx,%eax
c0100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c010097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010097e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100981:	29 d0                	sub    %edx,%eax
c0100983:	89 c1                	mov    %eax,%ecx
c0100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100999:	89 54 24 08          	mov    %edx,0x8(%esp)
c010099d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a1:	c7 04 24 56 61 10 c0 	movl   $0xc0106156,(%esp)
c01009a8:	e8 a9 f9 ff ff       	call   c0100356 <cprintf>
}
c01009ad:	90                   	nop
c01009ae:	89 ec                	mov    %ebp,%esp
c01009b0:	5d                   	pop    %ebp
c01009b1:	c3                   	ret    

c01009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b2:	55                   	push   %ebp
c01009b3:	89 e5                	mov    %esp,%ebp
c01009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009b8:	8b 45 04             	mov    0x4(%ebp),%eax
c01009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c1:	89 ec                	mov    %ebp,%esp
c01009c3:	5d                   	pop    %ebp
c01009c4:	c3                   	ret    

c01009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c5:	55                   	push   %ebp
c01009c6:	89 e5                	mov    %esp,%ebp
c01009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cb:	89 e8                	mov    %ebp,%eax
c01009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009d6:	e8 d7 ff ff ff       	call   c01009b2 <read_eip>
c01009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e5:	e9 84 00 00 00       	jmp    c0100a6e <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c01009ff:	e8 52 f9 ff ff       	call   c0100356 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a07:	83 c0 08             	add    $0x8,%eax
c0100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a14:	eb 24                	jmp    c0100a3a <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
c0100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a23:	01 d0                	add    %edx,%eax
c0100a25:	8b 00                	mov    (%eax),%eax
c0100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2b:	c7 04 24 84 61 10 c0 	movl   $0xc0106184,(%esp)
c0100a32:	e8 1f f9 ff ff       	call   c0100356 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100a37:	ff 45 e8             	incl   -0x18(%ebp)
c0100a3a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3e:	7e d6                	jle    c0100a16 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100a40:	c7 04 24 8c 61 10 c0 	movl   $0xc010618c,(%esp)
c0100a47:	e8 0a f9 ff ff       	call   c0100356 <cprintf>
        print_debuginfo(eip - 1);
c0100a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4f:	48                   	dec    %eax
c0100a50:	89 04 24             	mov    %eax,(%esp)
c0100a53:	e8 b5 fe ff ff       	call   c010090d <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5b:	83 c0 04             	add    $0x4,%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a66:	8b 00                	mov    (%eax),%eax
c0100a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a6b:	ff 45 ec             	incl   -0x14(%ebp)
c0100a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a72:	74 0a                	je     c0100a7e <print_stackframe+0xb9>
c0100a74:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a78:	0f 8e 6c ff ff ff    	jle    c01009ea <print_stackframe+0x25>
    }
}
c0100a7e:	90                   	nop
c0100a7f:	89 ec                	mov    %ebp,%esp
c0100a81:	5d                   	pop    %ebp
c0100a82:	c3                   	ret    

c0100a83 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a83:	55                   	push   %ebp
c0100a84:	89 e5                	mov    %esp,%ebp
c0100a86:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a90:	eb 0c                	jmp    c0100a9e <parse+0x1b>
            *buf ++ = '\0';
c0100a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a95:	8d 50 01             	lea    0x1(%eax),%edx
c0100a98:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	84 c0                	test   %al,%al
c0100aa6:	74 1d                	je     c0100ac5 <parse+0x42>
c0100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aab:	0f b6 00             	movzbl (%eax),%eax
c0100aae:	0f be c0             	movsbl %al,%eax
c0100ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab5:	c7 04 24 10 62 10 c0 	movl   $0xc0106210,(%esp)
c0100abc:	e8 cd 51 00 00       	call   c0105c8e <strchr>
c0100ac1:	85 c0                	test   %eax,%eax
c0100ac3:	75 cd                	jne    c0100a92 <parse+0xf>
        }
        if (*buf == '\0') {
c0100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac8:	0f b6 00             	movzbl (%eax),%eax
c0100acb:	84 c0                	test   %al,%al
c0100acd:	74 65                	je     c0100b34 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100acf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad3:	75 14                	jne    c0100ae9 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adc:	00 
c0100add:	c7 04 24 15 62 10 c0 	movl   $0xc0106215,(%esp)
c0100ae4:	e8 6d f8 ff ff       	call   c0100356 <cprintf>
        }
        argv[argc ++] = buf;
c0100ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aec:	8d 50 01             	lea    0x1(%eax),%edx
c0100aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afc:	01 c2                	add    %eax,%edx
c0100afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b01:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b03:	eb 03                	jmp    c0100b08 <parse+0x85>
            buf ++;
c0100b05:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 8c                	je     c0100a9e <parse+0x1b>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1f:	c7 04 24 10 62 10 c0 	movl   $0xc0106210,(%esp)
c0100b26:	e8 63 51 00 00       	call   c0105c8e <strchr>
c0100b2b:	85 c0                	test   %eax,%eax
c0100b2d:	74 d6                	je     c0100b05 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2f:	e9 6a ff ff ff       	jmp    c0100a9e <parse+0x1b>
            break;
c0100b34:	90                   	nop
        }
    }
    return argc;
c0100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b38:	89 ec                	mov    %ebp,%esp
c0100b3a:	5d                   	pop    %ebp
c0100b3b:	c3                   	ret    

c0100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3c:	55                   	push   %ebp
c0100b3d:	89 e5                	mov    %esp,%ebp
c0100b3f:	83 ec 68             	sub    $0x68,%esp
c0100b42:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4f:	89 04 24             	mov    %eax,(%esp)
c0100b52:	e8 2c ff ff ff       	call   c0100a83 <parse>
c0100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5e:	75 0a                	jne    c0100b6a <runcmd+0x2e>
        return 0;
c0100b60:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b65:	e9 83 00 00 00       	jmp    c0100bed <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b71:	eb 5a                	jmp    c0100bcd <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b73:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b76:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b79:	89 c8                	mov    %ecx,%eax
c0100b7b:	01 c0                	add    %eax,%eax
c0100b7d:	01 c8                	add    %ecx,%eax
c0100b7f:	c1 e0 02             	shl    $0x2,%eax
c0100b82:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b87:	8b 00                	mov    (%eax),%eax
c0100b89:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b8d:	89 04 24             	mov    %eax,(%esp)
c0100b90:	e8 5d 50 00 00       	call   c0105bf2 <strcmp>
c0100b95:	85 c0                	test   %eax,%eax
c0100b97:	75 31                	jne    c0100bca <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9c:	89 d0                	mov    %edx,%eax
c0100b9e:	01 c0                	add    %eax,%eax
c0100ba0:	01 d0                	add    %edx,%eax
c0100ba2:	c1 e0 02             	shl    $0x2,%eax
c0100ba5:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100baa:	8b 10                	mov    (%eax),%edx
c0100bac:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100baf:	83 c0 04             	add    $0x4,%eax
c0100bb2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bb5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc3:	89 1c 24             	mov    %ebx,(%esp)
c0100bc6:	ff d2                	call   *%edx
c0100bc8:	eb 23                	jmp    c0100bed <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bca:	ff 45 f4             	incl   -0xc(%ebp)
c0100bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd0:	83 f8 02             	cmp    $0x2,%eax
c0100bd3:	76 9e                	jbe    c0100b73 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdc:	c7 04 24 33 62 10 c0 	movl   $0xc0106233,(%esp)
c0100be3:	e8 6e f7 ff ff       	call   c0100356 <cprintf>
    return 0;
c0100be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100bf0:	89 ec                	mov    %ebp,%esp
c0100bf2:	5d                   	pop    %ebp
c0100bf3:	c3                   	ret    

c0100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf4:	55                   	push   %ebp
c0100bf5:	89 e5                	mov    %esp,%ebp
c0100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfa:	c7 04 24 4c 62 10 c0 	movl   $0xc010624c,(%esp)
c0100c01:	e8 50 f7 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c06:	c7 04 24 74 62 10 c0 	movl   $0xc0106274,(%esp)
c0100c0d:	e8 44 f7 ff ff       	call   c0100356 <cprintf>

    if (tf != NULL) {
c0100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c16:	74 0b                	je     c0100c23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	89 04 24             	mov    %eax,(%esp)
c0100c1e:	e8 74 0e 00 00       	call   c0101a97 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c23:	c7 04 24 99 62 10 c0 	movl   $0xc0106299,(%esp)
c0100c2a:	e8 18 f6 ff ff       	call   c0100247 <readline>
c0100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c36:	74 eb                	je     c0100c23 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 f2 fe ff ff       	call   c0100b3c <runcmd>
c0100c4a:	85 c0                	test   %eax,%eax
c0100c4c:	78 02                	js     c0100c50 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100c4e:	eb d3                	jmp    c0100c23 <kmonitor+0x2f>
                break;
c0100c50:	90                   	nop
            }
        }
    }
}
c0100c51:	90                   	nop
c0100c52:	89 ec                	mov    %ebp,%esp
c0100c54:	5d                   	pop    %ebp
c0100c55:	c3                   	ret    

c0100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c56:	55                   	push   %ebp
c0100c57:	89 e5                	mov    %esp,%ebp
c0100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c63:	eb 3d                	jmp    c0100ca2 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c68:	89 d0                	mov    %edx,%eax
c0100c6a:	01 c0                	add    %eax,%eax
c0100c6c:	01 d0                	add    %edx,%eax
c0100c6e:	c1 e0 02             	shl    $0x2,%eax
c0100c71:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100c76:	8b 10                	mov    (%eax),%edx
c0100c78:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c7b:	89 c8                	mov    %ecx,%eax
c0100c7d:	01 c0                	add    %eax,%eax
c0100c7f:	01 c8                	add    %ecx,%eax
c0100c81:	c1 e0 02             	shl    $0x2,%eax
c0100c84:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100c89:	8b 00                	mov    (%eax),%eax
c0100c8b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c93:	c7 04 24 9d 62 10 c0 	movl   $0xc010629d,(%esp)
c0100c9a:	e8 b7 f6 ff ff       	call   c0100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9f:	ff 45 f4             	incl   -0xc(%ebp)
c0100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca5:	83 f8 02             	cmp    $0x2,%eax
c0100ca8:	76 bb                	jbe    c0100c65 <mon_help+0xf>
    }
    return 0;
c0100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100caf:	89 ec                	mov    %ebp,%esp
c0100cb1:	5d                   	pop    %ebp
c0100cb2:	c3                   	ret    

c0100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb9:	e8 bb fb ff ff       	call   c0100879 <print_kerninfo>
    return 0;
c0100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc3:	89 ec                	mov    %ebp,%esp
c0100cc5:	5d                   	pop    %ebp
c0100cc6:	c3                   	ret    

c0100cc7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc7:	55                   	push   %ebp
c0100cc8:	89 e5                	mov    %esp,%ebp
c0100cca:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ccd:	e8 f3 fc ff ff       	call   c01009c5 <print_stackframe>
    return 0;
c0100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd7:	89 ec                	mov    %ebp,%esp
c0100cd9:	5d                   	pop    %ebp
c0100cda:	c3                   	ret    

c0100cdb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdb:	55                   	push   %ebp
c0100cdc:	89 e5                	mov    %esp,%ebp
c0100cde:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce1:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100ce6:	85 c0                	test   %eax,%eax
c0100ce8:	75 5b                	jne    c0100d45 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100cea:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100cf1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf4:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cfd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	c7 04 24 a6 62 10 c0 	movl   $0xc01062a6,(%esp)
c0100d0f:	e8 42 f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1b:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1e:	89 04 24             	mov    %eax,(%esp)
c0100d21:	e8 fb f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d26:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0100d2d:	e8 24 f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d32:	c7 04 24 c4 62 10 c0 	movl   $0xc01062c4,(%esp)
c0100d39:	e8 18 f6 ff ff       	call   c0100356 <cprintf>
    print_stackframe();
c0100d3e:	e8 82 fc ff ff       	call   c01009c5 <print_stackframe>
c0100d43:	eb 01                	jmp    c0100d46 <__panic+0x6b>
        goto panic_dead;
c0100d45:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d46:	e8 e9 09 00 00       	call   c0101734 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d52:	e8 9d fe ff ff       	call   c0100bf4 <kmonitor>
c0100d57:	eb f2                	jmp    c0100d4b <__panic+0x70>

c0100d59 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d59:	55                   	push   %ebp
c0100d5a:	89 e5                	mov    %esp,%ebp
c0100d5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d5f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d68:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d73:	c7 04 24 d6 62 10 c0 	movl   $0xc01062d6,(%esp)
c0100d7a:	e8 d7 f5 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d86:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d89:	89 04 24             	mov    %eax,(%esp)
c0100d8c:	e8 90 f5 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100d91:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0100d98:	e8 b9 f5 ff ff       	call   c0100356 <cprintf>
    va_end(ap);
}
c0100d9d:	90                   	nop
c0100d9e:	89 ec                	mov    %ebp,%esp
c0100da0:	5d                   	pop    %ebp
c0100da1:	c3                   	ret    

c0100da2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100da2:	55                   	push   %ebp
c0100da3:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100da5:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100daa:	5d                   	pop    %ebp
c0100dab:	c3                   	ret    

c0100dac <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dac:	55                   	push   %ebp
c0100dad:	89 e5                	mov    %esp,%ebp
c0100daf:	83 ec 28             	sub    $0x28,%esp
c0100db2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100db8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dbc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
}
c0100dc5:	90                   	nop
c0100dc6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dcc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd8:	ee                   	out    %al,(%dx)
}
c0100dd9:	90                   	nop
c0100dda:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100de0:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100de4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100de8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dec:	ee                   	out    %al,(%dx)
}
c0100ded:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dee:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100df5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df8:	c7 04 24 f4 62 10 c0 	movl   $0xc01062f4,(%esp)
c0100dff:	e8 52 f5 ff ff       	call   c0100356 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e0b:	e8 89 09 00 00       	call   c0101799 <pic_enable>
}
c0100e10:	90                   	nop
c0100e11:	89 ec                	mov    %ebp,%esp
c0100e13:	5d                   	pop    %ebp
c0100e14:	c3                   	ret    

c0100e15 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e15:	55                   	push   %ebp
c0100e16:	89 e5                	mov    %esp,%ebp
c0100e18:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e1b:	9c                   	pushf  
c0100e1c:	58                   	pop    %eax
c0100e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e23:	25 00 02 00 00       	and    $0x200,%eax
c0100e28:	85 c0                	test   %eax,%eax
c0100e2a:	74 0c                	je     c0100e38 <__intr_save+0x23>
        intr_disable();
c0100e2c:	e8 03 09 00 00       	call   c0101734 <intr_disable>
        return 1;
c0100e31:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e36:	eb 05                	jmp    c0100e3d <__intr_save+0x28>
    }
    return 0;
c0100e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e3d:	89 ec                	mov    %ebp,%esp
c0100e3f:	5d                   	pop    %ebp
c0100e40:	c3                   	ret    

c0100e41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e4b:	74 05                	je     c0100e52 <__intr_restore+0x11>
        intr_enable();
c0100e4d:	e8 da 08 00 00       	call   c010172c <intr_enable>
    }
}
c0100e52:	90                   	nop
c0100e53:	89 ec                	mov    %ebp,%esp
c0100e55:	5d                   	pop    %ebp
c0100e56:	c3                   	ret    

c0100e57 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 10             	sub    $0x10,%esp
c0100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e67:	89 c2                	mov    %eax,%edx
c0100e69:	ec                   	in     (%dx),%al
c0100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e6d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e73:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e77:	89 c2                	mov    %eax,%edx
c0100e79:	ec                   	in     (%dx),%al
c0100e7a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e7d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e83:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e87:	89 c2                	mov    %eax,%edx
c0100e89:	ec                   	in     (%dx),%al
c0100e8a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e8d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e93:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e97:	89 c2                	mov    %eax,%edx
c0100e99:	ec                   	in     (%dx),%al
c0100e9a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e9d:	90                   	nop
c0100e9e:	89 ec                	mov    %ebp,%esp
c0100ea0:	5d                   	pop    %ebp
c0100ea1:	c3                   	ret    

c0100ea2 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ea2:	55                   	push   %ebp
c0100ea3:	89 e5                	mov    %esp,%ebp
c0100ea5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100ea8:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb2:	0f b7 00             	movzwl (%eax),%eax
c0100eb5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec4:	0f b7 00             	movzwl (%eax),%eax
c0100ec7:	0f b7 c0             	movzwl %ax,%eax
c0100eca:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100ecf:	74 12                	je     c0100ee3 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ed1:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ed8:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100edf:	b4 03 
c0100ee1:	eb 13                	jmp    c0100ef6 <cga_init+0x54>
    } else {
        *cp = was;
c0100ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ee6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eea:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eed:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100ef4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ef6:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100efd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f01:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f05:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f09:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f0d:	ee                   	out    %al,(%dx)
}
c0100f0e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100f0f:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f16:	40                   	inc    %eax
c0100f17:	0f b7 c0             	movzwl %ax,%eax
c0100f1a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f1e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f22:	89 c2                	mov    %eax,%edx
c0100f24:	ec                   	in     (%dx),%al
c0100f25:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100f28:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2c:	0f b6 c0             	movzbl %al,%eax
c0100f2f:	c1 e0 08             	shl    $0x8,%eax
c0100f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f35:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f3c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100f40:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f44:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f48:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f4c:	ee                   	out    %al,(%dx)
}
c0100f4d:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f4e:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f55:	40                   	inc    %eax
c0100f56:	0f b7 c0             	movzwl %ax,%eax
c0100f59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f67:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f6b:	0f b6 c0             	movzbl %al,%eax
c0100f6e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f74:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f7c:	0f b7 c0             	movzwl %ax,%eax
c0100f7f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100f85:	90                   	nop
c0100f86:	89 ec                	mov    %ebp,%esp
c0100f88:	5d                   	pop    %ebp
c0100f89:	c3                   	ret    

c0100f8a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f8a:	55                   	push   %ebp
c0100f8b:	89 e5                	mov    %esp,%ebp
c0100f8d:	83 ec 48             	sub    $0x48,%esp
c0100f90:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f96:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f9a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f9e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100fa2:	ee                   	out    %al,(%dx)
}
c0100fa3:	90                   	nop
c0100fa4:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100faa:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fae:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100fb2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100fb6:	ee                   	out    %al,(%dx)
}
c0100fb7:	90                   	nop
c0100fb8:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100fbe:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100fc6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100fca:	ee                   	out    %al,(%dx)
}
c0100fcb:	90                   	nop
c0100fcc:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd2:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fda:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
}
c0100fdf:	90                   	nop
c0100fe0:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100fe6:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff2:	ee                   	out    %al,(%dx)
}
c0100ff3:	90                   	nop
c0100ff4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100ffa:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ffe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101002:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101006:	ee                   	out    %al,(%dx)
}
c0101007:	90                   	nop
c0101008:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c010100e:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101012:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101016:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010101a:	ee                   	out    %al,(%dx)
}
c010101b:	90                   	nop
c010101c:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101022:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0101026:	89 c2                	mov    %eax,%edx
c0101028:	ec                   	in     (%dx),%al
c0101029:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c010102c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101030:	3c ff                	cmp    $0xff,%al
c0101032:	0f 95 c0             	setne  %al
c0101035:	0f b6 c0             	movzbl %al,%eax
c0101038:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c010103d:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101043:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101047:	89 c2                	mov    %eax,%edx
c0101049:	ec                   	in     (%dx),%al
c010104a:	88 45 f1             	mov    %al,-0xf(%ebp)
c010104d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101053:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101057:	89 c2                	mov    %eax,%edx
c0101059:	ec                   	in     (%dx),%al
c010105a:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010105d:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101062:	85 c0                	test   %eax,%eax
c0101064:	74 0c                	je     c0101072 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0101066:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010106d:	e8 27 07 00 00       	call   c0101799 <pic_enable>
    }
}
c0101072:	90                   	nop
c0101073:	89 ec                	mov    %ebp,%esp
c0101075:	5d                   	pop    %ebp
c0101076:	c3                   	ret    

c0101077 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101077:	55                   	push   %ebp
c0101078:	89 e5                	mov    %esp,%ebp
c010107a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101084:	eb 08                	jmp    c010108e <lpt_putc_sub+0x17>
        delay();
c0101086:	e8 cc fd ff ff       	call   c0100e57 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010108b:	ff 45 fc             	incl   -0x4(%ebp)
c010108e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101094:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101098:	89 c2                	mov    %eax,%edx
c010109a:	ec                   	in     (%dx),%al
c010109b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010109e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01010a2:	84 c0                	test   %al,%al
c01010a4:	78 09                	js     c01010af <lpt_putc_sub+0x38>
c01010a6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010ad:	7e d7                	jle    c0101086 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c01010af:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b2:	0f b6 c0             	movzbl %al,%eax
c01010b5:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c01010bb:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c6:	ee                   	out    %al,(%dx)
}
c01010c7:	90                   	nop
c01010c8:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010ce:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010d2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010d6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010da:	ee                   	out    %al,(%dx)
}
c01010db:	90                   	nop
c01010dc:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c01010e2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010ea:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ee:	ee                   	out    %al,(%dx)
}
c01010ef:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010f0:	90                   	nop
c01010f1:	89 ec                	mov    %ebp,%esp
c01010f3:	5d                   	pop    %ebp
c01010f4:	c3                   	ret    

c01010f5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010f5:	55                   	push   %ebp
c01010f6:	89 e5                	mov    %esp,%ebp
c01010f8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010fb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010ff:	74 0d                	je     c010110e <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101101:	8b 45 08             	mov    0x8(%ebp),%eax
c0101104:	89 04 24             	mov    %eax,(%esp)
c0101107:	e8 6b ff ff ff       	call   c0101077 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010110c:	eb 24                	jmp    c0101132 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c010110e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101115:	e8 5d ff ff ff       	call   c0101077 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010111a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101121:	e8 51 ff ff ff       	call   c0101077 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101126:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010112d:	e8 45 ff ff ff       	call   c0101077 <lpt_putc_sub>
}
c0101132:	90                   	nop
c0101133:	89 ec                	mov    %ebp,%esp
c0101135:	5d                   	pop    %ebp
c0101136:	c3                   	ret    

c0101137 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101137:	55                   	push   %ebp
c0101138:	89 e5                	mov    %esp,%ebp
c010113a:	83 ec 38             	sub    $0x38,%esp
c010113d:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c0101140:	8b 45 08             	mov    0x8(%ebp),%eax
c0101143:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101148:	85 c0                	test   %eax,%eax
c010114a:	75 07                	jne    c0101153 <cga_putc+0x1c>
        c |= 0x0700;
c010114c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101153:	8b 45 08             	mov    0x8(%ebp),%eax
c0101156:	0f b6 c0             	movzbl %al,%eax
c0101159:	83 f8 0d             	cmp    $0xd,%eax
c010115c:	74 72                	je     c01011d0 <cga_putc+0x99>
c010115e:	83 f8 0d             	cmp    $0xd,%eax
c0101161:	0f 8f a3 00 00 00    	jg     c010120a <cga_putc+0xd3>
c0101167:	83 f8 08             	cmp    $0x8,%eax
c010116a:	74 0a                	je     c0101176 <cga_putc+0x3f>
c010116c:	83 f8 0a             	cmp    $0xa,%eax
c010116f:	74 4c                	je     c01011bd <cga_putc+0x86>
c0101171:	e9 94 00 00 00       	jmp    c010120a <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c0101176:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010117d:	85 c0                	test   %eax,%eax
c010117f:	0f 84 af 00 00 00    	je     c0101234 <cga_putc+0xfd>
            crt_pos --;
c0101185:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010118c:	48                   	dec    %eax
c010118d:	0f b7 c0             	movzwl %ax,%eax
c0101190:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101196:	8b 45 08             	mov    0x8(%ebp),%eax
c0101199:	98                   	cwtl   
c010119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010119f:	98                   	cwtl   
c01011a0:	83 c8 20             	or     $0x20,%eax
c01011a3:	98                   	cwtl   
c01011a4:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011aa:	0f b7 15 44 b4 11 c0 	movzwl 0xc011b444,%edx
c01011b1:	01 d2                	add    %edx,%edx
c01011b3:	01 ca                	add    %ecx,%edx
c01011b5:	0f b7 c0             	movzwl %ax,%eax
c01011b8:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011bb:	eb 77                	jmp    c0101234 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c01011bd:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011c4:	83 c0 50             	add    $0x50,%eax
c01011c7:	0f b7 c0             	movzwl %ax,%eax
c01011ca:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011d0:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c01011d7:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c01011de:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01011e3:	89 c8                	mov    %ecx,%eax
c01011e5:	f7 e2                	mul    %edx
c01011e7:	c1 ea 06             	shr    $0x6,%edx
c01011ea:	89 d0                	mov    %edx,%eax
c01011ec:	c1 e0 02             	shl    $0x2,%eax
c01011ef:	01 d0                	add    %edx,%eax
c01011f1:	c1 e0 04             	shl    $0x4,%eax
c01011f4:	29 c1                	sub    %eax,%ecx
c01011f6:	89 ca                	mov    %ecx,%edx
c01011f8:	0f b7 d2             	movzwl %dx,%edx
c01011fb:	89 d8                	mov    %ebx,%eax
c01011fd:	29 d0                	sub    %edx,%eax
c01011ff:	0f b7 c0             	movzwl %ax,%eax
c0101202:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c0101208:	eb 2b                	jmp    c0101235 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010120a:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c0101210:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101217:	8d 50 01             	lea    0x1(%eax),%edx
c010121a:	0f b7 d2             	movzwl %dx,%edx
c010121d:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c0101224:	01 c0                	add    %eax,%eax
c0101226:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101229:	8b 45 08             	mov    0x8(%ebp),%eax
c010122c:	0f b7 c0             	movzwl %ax,%eax
c010122f:	66 89 02             	mov    %ax,(%edx)
        break;
c0101232:	eb 01                	jmp    c0101235 <cga_putc+0xfe>
        break;
c0101234:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101235:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010123c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101241:	76 5e                	jbe    c01012a1 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101243:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101248:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010124e:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101253:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010125a:	00 
c010125b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010125f:	89 04 24             	mov    %eax,(%esp)
c0101262:	e8 25 4c 00 00       	call   c0105e8c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101267:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010126e:	eb 15                	jmp    c0101285 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c0101270:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c0101276:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101279:	01 c0                	add    %eax,%eax
c010127b:	01 d0                	add    %edx,%eax
c010127d:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101282:	ff 45 f4             	incl   -0xc(%ebp)
c0101285:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010128c:	7e e2                	jle    c0101270 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c010128e:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101295:	83 e8 50             	sub    $0x50,%eax
c0101298:	0f b7 c0             	movzwl %ax,%eax
c010129b:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012a1:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012a8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01012ac:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c01012ba:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012c1:	c1 e8 08             	shr    $0x8,%eax
c01012c4:	0f b7 c0             	movzwl %ax,%eax
c01012c7:	0f b6 c0             	movzbl %al,%eax
c01012ca:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c01012d1:	42                   	inc    %edx
c01012d2:	0f b7 d2             	movzwl %dx,%edx
c01012d5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012d9:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012dc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012e0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012e4:	ee                   	out    %al,(%dx)
}
c01012e5:	90                   	nop
    outb(addr_6845, 15);
c01012e6:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01012ed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01012f1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012f9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012fd:	ee                   	out    %al,(%dx)
}
c01012fe:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c01012ff:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101306:	0f b6 c0             	movzbl %al,%eax
c0101309:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c0101310:	42                   	inc    %edx
c0101311:	0f b7 d2             	movzwl %dx,%edx
c0101314:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101318:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010131f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101323:	ee                   	out    %al,(%dx)
}
c0101324:	90                   	nop
}
c0101325:	90                   	nop
c0101326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101329:	89 ec                	mov    %ebp,%esp
c010132b:	5d                   	pop    %ebp
c010132c:	c3                   	ret    

c010132d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010132d:	55                   	push   %ebp
c010132e:	89 e5                	mov    %esp,%ebp
c0101330:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101333:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010133a:	eb 08                	jmp    c0101344 <serial_putc_sub+0x17>
        delay();
c010133c:	e8 16 fb ff ff       	call   c0100e57 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101341:	ff 45 fc             	incl   -0x4(%ebp)
c0101344:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010134a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010134e:	89 c2                	mov    %eax,%edx
c0101350:	ec                   	in     (%dx),%al
c0101351:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101354:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101358:	0f b6 c0             	movzbl %al,%eax
c010135b:	83 e0 20             	and    $0x20,%eax
c010135e:	85 c0                	test   %eax,%eax
c0101360:	75 09                	jne    c010136b <serial_putc_sub+0x3e>
c0101362:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101369:	7e d1                	jle    c010133c <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c010136b:	8b 45 08             	mov    0x8(%ebp),%eax
c010136e:	0f b6 c0             	movzbl %al,%eax
c0101371:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101377:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010137a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010137e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101382:	ee                   	out    %al,(%dx)
}
c0101383:	90                   	nop
}
c0101384:	90                   	nop
c0101385:	89 ec                	mov    %ebp,%esp
c0101387:	5d                   	pop    %ebp
c0101388:	c3                   	ret    

c0101389 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101389:	55                   	push   %ebp
c010138a:	89 e5                	mov    %esp,%ebp
c010138c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010138f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101393:	74 0d                	je     c01013a2 <serial_putc+0x19>
        serial_putc_sub(c);
c0101395:	8b 45 08             	mov    0x8(%ebp),%eax
c0101398:	89 04 24             	mov    %eax,(%esp)
c010139b:	e8 8d ff ff ff       	call   c010132d <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01013a0:	eb 24                	jmp    c01013c6 <serial_putc+0x3d>
        serial_putc_sub('\b');
c01013a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013a9:	e8 7f ff ff ff       	call   c010132d <serial_putc_sub>
        serial_putc_sub(' ');
c01013ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013b5:	e8 73 ff ff ff       	call   c010132d <serial_putc_sub>
        serial_putc_sub('\b');
c01013ba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013c1:	e8 67 ff ff ff       	call   c010132d <serial_putc_sub>
}
c01013c6:	90                   	nop
c01013c7:	89 ec                	mov    %ebp,%esp
c01013c9:	5d                   	pop    %ebp
c01013ca:	c3                   	ret    

c01013cb <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013cb:	55                   	push   %ebp
c01013cc:	89 e5                	mov    %esp,%ebp
c01013ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013d1:	eb 33                	jmp    c0101406 <cons_intr+0x3b>
        if (c != 0) {
c01013d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013d7:	74 2d                	je     c0101406 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013d9:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013de:	8d 50 01             	lea    0x1(%eax),%edx
c01013e1:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c01013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013ea:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013f0:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01013f5:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013fa:	75 0a                	jne    c0101406 <cons_intr+0x3b>
                cons.wpos = 0;
c01013fc:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101403:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101406:	8b 45 08             	mov    0x8(%ebp),%eax
c0101409:	ff d0                	call   *%eax
c010140b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010140e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101412:	75 bf                	jne    c01013d3 <cons_intr+0x8>
            }
        }
    }
}
c0101414:	90                   	nop
c0101415:	90                   	nop
c0101416:	89 ec                	mov    %ebp,%esp
c0101418:	5d                   	pop    %ebp
c0101419:	c3                   	ret    

c010141a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c010141a:	55                   	push   %ebp
c010141b:	89 e5                	mov    %esp,%ebp
c010141d:	83 ec 10             	sub    $0x10,%esp
c0101420:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101426:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010142a:	89 c2                	mov    %eax,%edx
c010142c:	ec                   	in     (%dx),%al
c010142d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101430:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101434:	0f b6 c0             	movzbl %al,%eax
c0101437:	83 e0 01             	and    $0x1,%eax
c010143a:	85 c0                	test   %eax,%eax
c010143c:	75 07                	jne    c0101445 <serial_proc_data+0x2b>
        return -1;
c010143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101443:	eb 2a                	jmp    c010146f <serial_proc_data+0x55>
c0101445:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010144f:	89 c2                	mov    %eax,%edx
c0101451:	ec                   	in     (%dx),%al
c0101452:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101455:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101459:	0f b6 c0             	movzbl %al,%eax
c010145c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010145f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101463:	75 07                	jne    c010146c <serial_proc_data+0x52>
        c = '\b';
c0101465:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010146f:	89 ec                	mov    %ebp,%esp
c0101471:	5d                   	pop    %ebp
c0101472:	c3                   	ret    

c0101473 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101473:	55                   	push   %ebp
c0101474:	89 e5                	mov    %esp,%ebp
c0101476:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101479:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c010147e:	85 c0                	test   %eax,%eax
c0101480:	74 0c                	je     c010148e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101482:	c7 04 24 1a 14 10 c0 	movl   $0xc010141a,(%esp)
c0101489:	e8 3d ff ff ff       	call   c01013cb <cons_intr>
    }
}
c010148e:	90                   	nop
c010148f:	89 ec                	mov    %ebp,%esp
c0101491:	5d                   	pop    %ebp
c0101492:	c3                   	ret    

c0101493 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101493:	55                   	push   %ebp
c0101494:	89 e5                	mov    %esp,%ebp
c0101496:	83 ec 38             	sub    $0x38,%esp
c0101499:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01014a2:	89 c2                	mov    %eax,%edx
c01014a4:	ec                   	in     (%dx),%al
c01014a5:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01014a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014ac:	0f b6 c0             	movzbl %al,%eax
c01014af:	83 e0 01             	and    $0x1,%eax
c01014b2:	85 c0                	test   %eax,%eax
c01014b4:	75 0a                	jne    c01014c0 <kbd_proc_data+0x2d>
        return -1;
c01014b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014bb:	e9 56 01 00 00       	jmp    c0101616 <kbd_proc_data+0x183>
c01014c0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01014c9:	89 c2                	mov    %eax,%edx
c01014cb:	ec                   	in     (%dx),%al
c01014cc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01014cf:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014d3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014d6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014da:	75 17                	jne    c01014f3 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01014dc:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014e1:	83 c8 40             	or     $0x40,%eax
c01014e4:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014e9:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ee:	e9 23 01 00 00       	jmp    c0101616 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c01014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f7:	84 c0                	test   %al,%al
c01014f9:	79 45                	jns    c0101540 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014fb:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101500:	83 e0 40             	and    $0x40,%eax
c0101503:	85 c0                	test   %eax,%eax
c0101505:	75 08                	jne    c010150f <kbd_proc_data+0x7c>
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	24 7f                	and    $0x7f,%al
c010150d:	eb 04                	jmp    c0101513 <kbd_proc_data+0x80>
c010150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101513:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151a:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101521:	0c 40                	or     $0x40,%al
c0101523:	0f b6 c0             	movzbl %al,%eax
c0101526:	f7 d0                	not    %eax
c0101528:	89 c2                	mov    %eax,%edx
c010152a:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010152f:	21 d0                	and    %edx,%eax
c0101531:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101536:	b8 00 00 00 00       	mov    $0x0,%eax
c010153b:	e9 d6 00 00 00       	jmp    c0101616 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101540:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101545:	83 e0 40             	and    $0x40,%eax
c0101548:	85 c0                	test   %eax,%eax
c010154a:	74 11                	je     c010155d <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010154c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101550:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101555:	83 e0 bf             	and    $0xffffffbf,%eax
c0101558:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c010155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101561:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101568:	0f b6 d0             	movzbl %al,%edx
c010156b:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101570:	09 d0                	or     %edx,%eax
c0101572:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101577:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010157b:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c0101582:	0f b6 d0             	movzbl %al,%edx
c0101585:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010158a:	31 d0                	xor    %edx,%eax
c010158c:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101591:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101596:	83 e0 03             	and    $0x3,%eax
c0101599:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c01015a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a4:	01 d0                	add    %edx,%eax
c01015a6:	0f b6 00             	movzbl (%eax),%eax
c01015a9:	0f b6 c0             	movzbl %al,%eax
c01015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015af:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015b4:	83 e0 08             	and    $0x8,%eax
c01015b7:	85 c0                	test   %eax,%eax
c01015b9:	74 22                	je     c01015dd <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c01015bb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015bf:	7e 0c                	jle    c01015cd <kbd_proc_data+0x13a>
c01015c1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015c5:	7f 06                	jg     c01015cd <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01015c7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015cb:	eb 10                	jmp    c01015dd <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01015cd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015d1:	7e 0a                	jle    c01015dd <kbd_proc_data+0x14a>
c01015d3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015d7:	7f 04                	jg     c01015dd <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01015d9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015dd:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01015e2:	f7 d0                	not    %eax
c01015e4:	83 e0 06             	and    $0x6,%eax
c01015e7:	85 c0                	test   %eax,%eax
c01015e9:	75 28                	jne    c0101613 <kbd_proc_data+0x180>
c01015eb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015f2:	75 1f                	jne    c0101613 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c01015f4:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c01015fb:	e8 56 ed ff ff       	call   c0100356 <cprintf>
c0101600:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101606:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010160a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010160e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101611:	ee                   	out    %al,(%dx)
}
c0101612:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101613:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101616:	89 ec                	mov    %ebp,%esp
c0101618:	5d                   	pop    %ebp
c0101619:	c3                   	ret    

c010161a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010161a:	55                   	push   %ebp
c010161b:	89 e5                	mov    %esp,%ebp
c010161d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101620:	c7 04 24 93 14 10 c0 	movl   $0xc0101493,(%esp)
c0101627:	e8 9f fd ff ff       	call   c01013cb <cons_intr>
}
c010162c:	90                   	nop
c010162d:	89 ec                	mov    %ebp,%esp
c010162f:	5d                   	pop    %ebp
c0101630:	c3                   	ret    

c0101631 <kbd_init>:

static void
kbd_init(void) {
c0101631:	55                   	push   %ebp
c0101632:	89 e5                	mov    %esp,%ebp
c0101634:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101637:	e8 de ff ff ff       	call   c010161a <kbd_intr>
    pic_enable(IRQ_KBD);
c010163c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101643:	e8 51 01 00 00       	call   c0101799 <pic_enable>
}
c0101648:	90                   	nop
c0101649:	89 ec                	mov    %ebp,%esp
c010164b:	5d                   	pop    %ebp
c010164c:	c3                   	ret    

c010164d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010164d:	55                   	push   %ebp
c010164e:	89 e5                	mov    %esp,%ebp
c0101650:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101653:	e8 4a f8 ff ff       	call   c0100ea2 <cga_init>
    serial_init();
c0101658:	e8 2d f9 ff ff       	call   c0100f8a <serial_init>
    kbd_init();
c010165d:	e8 cf ff ff ff       	call   c0101631 <kbd_init>
    if (!serial_exists) {
c0101662:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101667:	85 c0                	test   %eax,%eax
c0101669:	75 0c                	jne    c0101677 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010166b:	c7 04 24 1b 63 10 c0 	movl   $0xc010631b,(%esp)
c0101672:	e8 df ec ff ff       	call   c0100356 <cprintf>
    }
}
c0101677:	90                   	nop
c0101678:	89 ec                	mov    %ebp,%esp
c010167a:	5d                   	pop    %ebp
c010167b:	c3                   	ret    

c010167c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010167c:	55                   	push   %ebp
c010167d:	89 e5                	mov    %esp,%ebp
c010167f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101682:	e8 8e f7 ff ff       	call   c0100e15 <__intr_save>
c0101687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010168a:	8b 45 08             	mov    0x8(%ebp),%eax
c010168d:	89 04 24             	mov    %eax,(%esp)
c0101690:	e8 60 fa ff ff       	call   c01010f5 <lpt_putc>
        cga_putc(c);
c0101695:	8b 45 08             	mov    0x8(%ebp),%eax
c0101698:	89 04 24             	mov    %eax,(%esp)
c010169b:	e8 97 fa ff ff       	call   c0101137 <cga_putc>
        serial_putc(c);
c01016a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a3:	89 04 24             	mov    %eax,(%esp)
c01016a6:	e8 de fc ff ff       	call   c0101389 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016ae:	89 04 24             	mov    %eax,(%esp)
c01016b1:	e8 8b f7 ff ff       	call   c0100e41 <__intr_restore>
}
c01016b6:	90                   	nop
c01016b7:	89 ec                	mov    %ebp,%esp
c01016b9:	5d                   	pop    %ebp
c01016ba:	c3                   	ret    

c01016bb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016bb:	55                   	push   %ebp
c01016bc:	89 e5                	mov    %esp,%ebp
c01016be:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016c8:	e8 48 f7 ff ff       	call   c0100e15 <__intr_save>
c01016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016d0:	e8 9e fd ff ff       	call   c0101473 <serial_intr>
        kbd_intr();
c01016d5:	e8 40 ff ff ff       	call   c010161a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016da:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c01016e0:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c01016e5:	39 c2                	cmp    %eax,%edx
c01016e7:	74 31                	je     c010171a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016e9:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016ee:	8d 50 01             	lea    0x1(%eax),%edx
c01016f1:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c01016f7:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c01016fe:	0f b6 c0             	movzbl %al,%eax
c0101701:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101704:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101709:	3d 00 02 00 00       	cmp    $0x200,%eax
c010170e:	75 0a                	jne    c010171a <cons_getc+0x5f>
                cons.rpos = 0;
c0101710:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c0101717:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010171d:	89 04 24             	mov    %eax,(%esp)
c0101720:	e8 1c f7 ff ff       	call   c0100e41 <__intr_restore>
    return c;
c0101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101728:	89 ec                	mov    %ebp,%esp
c010172a:	5d                   	pop    %ebp
c010172b:	c3                   	ret    

c010172c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010172c:	55                   	push   %ebp
c010172d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010172f:	fb                   	sti    
}
c0101730:	90                   	nop
    sti();
}
c0101731:	90                   	nop
c0101732:	5d                   	pop    %ebp
c0101733:	c3                   	ret    

c0101734 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101734:	55                   	push   %ebp
c0101735:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101737:	fa                   	cli    
}
c0101738:	90                   	nop
    cli();
}
c0101739:	90                   	nop
c010173a:	5d                   	pop    %ebp
c010173b:	c3                   	ret    

c010173c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010173c:	55                   	push   %ebp
c010173d:	89 e5                	mov    %esp,%ebp
c010173f:	83 ec 14             	sub    $0x14,%esp
c0101742:	8b 45 08             	mov    0x8(%ebp),%eax
c0101745:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101749:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010174c:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c0101752:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c0101757:	85 c0                	test   %eax,%eax
c0101759:	74 39                	je     c0101794 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c010175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010175e:	0f b6 c0             	movzbl %al,%eax
c0101761:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c0101767:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010176a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101772:	ee                   	out    %al,(%dx)
}
c0101773:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101774:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101778:	c1 e8 08             	shr    $0x8,%eax
c010177b:	0f b7 c0             	movzwl %ax,%eax
c010177e:	0f b6 c0             	movzbl %al,%eax
c0101781:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101787:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010178e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101792:	ee                   	out    %al,(%dx)
}
c0101793:	90                   	nop
    }
}
c0101794:	90                   	nop
c0101795:	89 ec                	mov    %ebp,%esp
c0101797:	5d                   	pop    %ebp
c0101798:	c3                   	ret    

c0101799 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101799:	55                   	push   %ebp
c010179a:	89 e5                	mov    %esp,%ebp
c010179c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010179f:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a2:	ba 01 00 00 00       	mov    $0x1,%edx
c01017a7:	88 c1                	mov    %al,%cl
c01017a9:	d3 e2                	shl    %cl,%edx
c01017ab:	89 d0                	mov    %edx,%eax
c01017ad:	98                   	cwtl   
c01017ae:	f7 d0                	not    %eax
c01017b0:	0f bf d0             	movswl %ax,%edx
c01017b3:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c01017ba:	98                   	cwtl   
c01017bb:	21 d0                	and    %edx,%eax
c01017bd:	98                   	cwtl   
c01017be:	0f b7 c0             	movzwl %ax,%eax
c01017c1:	89 04 24             	mov    %eax,(%esp)
c01017c4:	e8 73 ff ff ff       	call   c010173c <pic_setmask>
}
c01017c9:	90                   	nop
c01017ca:	89 ec                	mov    %ebp,%esp
c01017cc:	5d                   	pop    %ebp
c01017cd:	c3                   	ret    

c01017ce <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017ce:	55                   	push   %ebp
c01017cf:	89 e5                	mov    %esp,%ebp
c01017d1:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017d4:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c01017db:	00 00 00 
c01017de:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c01017e4:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017ec:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01017f0:	ee                   	out    %al,(%dx)
}
c01017f1:	90                   	nop
c01017f2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c01017f8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017fc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101800:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101804:	ee                   	out    %al,(%dx)
}
c0101805:	90                   	nop
c0101806:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010180c:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101810:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101814:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101818:	ee                   	out    %al,(%dx)
}
c0101819:	90                   	nop
c010181a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101820:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101824:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101828:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010182c:	ee                   	out    %al,(%dx)
}
c010182d:	90                   	nop
c010182e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101834:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101838:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010183c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
}
c0101841:	90                   	nop
c0101842:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101848:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010184c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101850:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101854:	ee                   	out    %al,(%dx)
}
c0101855:	90                   	nop
c0101856:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c010185c:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101868:	ee                   	out    %al,(%dx)
}
c0101869:	90                   	nop
c010186a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101870:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101874:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101878:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010187c:	ee                   	out    %al,(%dx)
}
c010187d:	90                   	nop
c010187e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c0101884:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101888:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010188c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101890:	ee                   	out    %al,(%dx)
}
c0101891:	90                   	nop
c0101892:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c0101898:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010189c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01018a0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01018a4:	ee                   	out    %al,(%dx)
}
c01018a5:	90                   	nop
c01018a6:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01018ac:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01018b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01018b8:	ee                   	out    %al,(%dx)
}
c01018b9:	90                   	nop
c01018ba:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01018c0:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018c4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01018c8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01018cc:	ee                   	out    %al,(%dx)
}
c01018cd:	90                   	nop
c01018ce:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c01018d4:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01018dc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01018e0:	ee                   	out    %al,(%dx)
}
c01018e1:	90                   	nop
c01018e2:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c01018e8:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01018ec:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01018f0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01018f4:	ee                   	out    %al,(%dx)
}
c01018f5:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01018f6:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c01018fd:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101902:	74 0f                	je     c0101913 <pic_init+0x145>
        pic_setmask(irq_mask);
c0101904:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c010190b:	89 04 24             	mov    %eax,(%esp)
c010190e:	e8 29 fe ff ff       	call   c010173c <pic_setmask>
    }
}
c0101913:	90                   	nop
c0101914:	89 ec                	mov    %ebp,%esp
c0101916:	5d                   	pop    %ebp
c0101917:	c3                   	ret    

c0101918 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101918:	55                   	push   %ebp
c0101919:	89 e5                	mov    %esp,%ebp
c010191b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010191e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101925:	00 
c0101926:	c7 04 24 40 63 10 c0 	movl   $0xc0106340,(%esp)
c010192d:	e8 24 ea ff ff       	call   c0100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101932:	c7 04 24 4a 63 10 c0 	movl   $0xc010634a,(%esp)
c0101939:	e8 18 ea ff ff       	call   c0100356 <cprintf>
    panic("EOT: kernel seems ok.");
c010193e:	c7 44 24 08 58 63 10 	movl   $0xc0106358,0x8(%esp)
c0101945:	c0 
c0101946:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010194d:	00 
c010194e:	c7 04 24 6e 63 10 c0 	movl   $0xc010636e,(%esp)
c0101955:	e8 81 f3 ff ff       	call   c0100cdb <__panic>

c010195a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010195a:	55                   	push   %ebp
c010195b:	89 e5                	mov    %esp,%ebp
c010195d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101967:	e9 c4 00 00 00       	jmp    c0101a30 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196f:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101976:	0f b7 d0             	movzwl %ax,%edx
c0101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197c:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c0101983:	c0 
c0101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101987:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c010198e:	c0 08 00 
c0101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101994:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c010199b:	c0 
c010199c:	80 e2 e0             	and    $0xe0,%dl
c010199f:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a9:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c01019b0:	c0 
c01019b1:	80 e2 1f             	and    $0x1f,%dl
c01019b4:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c01019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019be:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019c5:	c0 
c01019c6:	80 e2 f0             	and    $0xf0,%dl
c01019c9:	80 ca 0e             	or     $0xe,%dl
c01019cc:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019d6:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019dd:	c0 
c01019de:	80 e2 ef             	and    $0xef,%dl
c01019e1:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019eb:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c01019f2:	c0 
c01019f3:	80 e2 9f             	and    $0x9f,%dl
c01019f6:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a00:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101a07:	c0 
c0101a08:	80 ca 80             	or     $0x80,%dl
c0101a0b:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a15:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101a1c:	c1 e8 10             	shr    $0x10,%eax
c0101a1f:	0f b7 d0             	movzwl %ax,%edx
c0101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a25:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c0101a2c:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101a2d:	ff 45 fc             	incl   -0x4(%ebp)
c0101a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a33:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a38:	0f 86 2e ff ff ff    	jbe    c010196c <idt_init+0x12>
c0101a3e:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a48:	0f 01 18             	lidtl  (%eax)
}
c0101a4b:	90                   	nop
    }
    lidt(&idt_pd);
}
c0101a4c:	90                   	nop
c0101a4d:	89 ec                	mov    %ebp,%esp
c0101a4f:	5d                   	pop    %ebp
c0101a50:	c3                   	ret    

c0101a51 <trapname>:

static const char *
trapname(int trapno) {
c0101a51:	55                   	push   %ebp
c0101a52:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a57:	83 f8 13             	cmp    $0x13,%eax
c0101a5a:	77 0c                	ja     c0101a68 <trapname+0x17>
        return excnames[trapno];
c0101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5f:	8b 04 85 c0 66 10 c0 	mov    -0x3fef9940(,%eax,4),%eax
c0101a66:	eb 18                	jmp    c0101a80 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a68:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a6c:	7e 0d                	jle    c0101a7b <trapname+0x2a>
c0101a6e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a72:	7f 07                	jg     c0101a7b <trapname+0x2a>
        return "Hardware Interrupt";
c0101a74:	b8 7f 63 10 c0       	mov    $0xc010637f,%eax
c0101a79:	eb 05                	jmp    c0101a80 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a7b:	b8 92 63 10 c0       	mov    $0xc0106392,%eax
}
c0101a80:	5d                   	pop    %ebp
c0101a81:	c3                   	ret    

c0101a82 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a82:	55                   	push   %ebp
c0101a83:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a8c:	83 f8 08             	cmp    $0x8,%eax
c0101a8f:	0f 94 c0             	sete   %al
c0101a92:	0f b6 c0             	movzbl %al,%eax
}
c0101a95:	5d                   	pop    %ebp
c0101a96:	c3                   	ret    

c0101a97 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a97:	55                   	push   %ebp
c0101a98:	89 e5                	mov    %esp,%ebp
c0101a9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa4:	c7 04 24 d3 63 10 c0 	movl   $0xc01063d3,(%esp)
c0101aab:	e8 a6 e8 ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c0101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab3:	89 04 24             	mov    %eax,(%esp)
c0101ab6:	e8 8f 01 00 00       	call   c0101c4a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abe:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac6:	c7 04 24 e4 63 10 c0 	movl   $0xc01063e4,(%esp)
c0101acd:	e8 84 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101add:	c7 04 24 f7 63 10 c0 	movl   $0xc01063f7,(%esp)
c0101ae4:	e8 6d e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af4:	c7 04 24 0a 64 10 c0 	movl   $0xc010640a,(%esp)
c0101afb:	e8 56 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b03:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0b:	c7 04 24 1d 64 10 c0 	movl   $0xc010641d,(%esp)
c0101b12:	e8 3f e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1a:	8b 40 30             	mov    0x30(%eax),%eax
c0101b1d:	89 04 24             	mov    %eax,(%esp)
c0101b20:	e8 2c ff ff ff       	call   c0101a51 <trapname>
c0101b25:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b28:	8b 52 30             	mov    0x30(%edx),%edx
c0101b2b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b2f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b33:	c7 04 24 30 64 10 c0 	movl   $0xc0106430,(%esp)
c0101b3a:	e8 17 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b42:	8b 40 34             	mov    0x34(%eax),%eax
c0101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b49:	c7 04 24 42 64 10 c0 	movl   $0xc0106442,(%esp)
c0101b50:	e8 01 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b58:	8b 40 38             	mov    0x38(%eax),%eax
c0101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5f:	c7 04 24 51 64 10 c0 	movl   $0xc0106451,(%esp)
c0101b66:	e8 eb e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b76:	c7 04 24 60 64 10 c0 	movl   $0xc0106460,(%esp)
c0101b7d:	e8 d4 e7 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b85:	8b 40 40             	mov    0x40(%eax),%eax
c0101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8c:	c7 04 24 73 64 10 c0 	movl   $0xc0106473,(%esp)
c0101b93:	e8 be e7 ff ff       	call   c0100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ba6:	eb 3d                	jmp    c0101be5 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bab:	8b 50 40             	mov    0x40(%eax),%edx
c0101bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bb1:	21 d0                	and    %edx,%eax
c0101bb3:	85 c0                	test   %eax,%eax
c0101bb5:	74 28                	je     c0101bdf <print_trapframe+0x148>
c0101bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bba:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101bc1:	85 c0                	test   %eax,%eax
c0101bc3:	74 1a                	je     c0101bdf <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c0101bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc8:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd3:	c7 04 24 82 64 10 c0 	movl   $0xc0106482,(%esp)
c0101bda:	e8 77 e7 ff ff       	call   c0100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bdf:	ff 45 f4             	incl   -0xc(%ebp)
c0101be2:	d1 65 f0             	shll   -0x10(%ebp)
c0101be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101be8:	83 f8 17             	cmp    $0x17,%eax
c0101beb:	76 bb                	jbe    c0101ba8 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf0:	8b 40 40             	mov    0x40(%eax),%eax
c0101bf3:	c1 e8 0c             	shr    $0xc,%eax
c0101bf6:	83 e0 03             	and    $0x3,%eax
c0101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bfd:	c7 04 24 86 64 10 c0 	movl   $0xc0106486,(%esp)
c0101c04:	e8 4d e7 ff ff       	call   c0100356 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0c:	89 04 24             	mov    %eax,(%esp)
c0101c0f:	e8 6e fe ff ff       	call   c0101a82 <trap_in_kernel>
c0101c14:	85 c0                	test   %eax,%eax
c0101c16:	75 2d                	jne    c0101c45 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1b:	8b 40 44             	mov    0x44(%eax),%eax
c0101c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c22:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
c0101c29:	e8 28 e7 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c31:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c39:	c7 04 24 9e 64 10 c0 	movl   $0xc010649e,(%esp)
c0101c40:	e8 11 e7 ff ff       	call   c0100356 <cprintf>
    }
}
c0101c45:	90                   	nop
c0101c46:	89 ec                	mov    %ebp,%esp
c0101c48:	5d                   	pop    %ebp
c0101c49:	c3                   	ret    

c0101c4a <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c4a:	55                   	push   %ebp
c0101c4b:	89 e5                	mov    %esp,%ebp
c0101c4d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c53:	8b 00                	mov    (%eax),%eax
c0101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c59:	c7 04 24 b1 64 10 c0 	movl   $0xc01064b1,(%esp)
c0101c60:	e8 f1 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c68:	8b 40 04             	mov    0x4(%eax),%eax
c0101c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c6f:	c7 04 24 c0 64 10 c0 	movl   $0xc01064c0,(%esp)
c0101c76:	e8 db e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7e:	8b 40 08             	mov    0x8(%eax),%eax
c0101c81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c85:	c7 04 24 cf 64 10 c0 	movl   $0xc01064cf,(%esp)
c0101c8c:	e8 c5 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c94:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9b:	c7 04 24 de 64 10 c0 	movl   $0xc01064de,(%esp)
c0101ca2:	e8 af e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101caa:	8b 40 10             	mov    0x10(%eax),%eax
c0101cad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb1:	c7 04 24 ed 64 10 c0 	movl   $0xc01064ed,(%esp)
c0101cb8:	e8 99 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc0:	8b 40 14             	mov    0x14(%eax),%eax
c0101cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc7:	c7 04 24 fc 64 10 c0 	movl   $0xc01064fc,(%esp)
c0101cce:	e8 83 e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd6:	8b 40 18             	mov    0x18(%eax),%eax
c0101cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdd:	c7 04 24 0b 65 10 c0 	movl   $0xc010650b,(%esp)
c0101ce4:	e8 6d e6 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cec:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf3:	c7 04 24 1a 65 10 c0 	movl   $0xc010651a,(%esp)
c0101cfa:	e8 57 e6 ff ff       	call   c0100356 <cprintf>
}
c0101cff:	90                   	nop
c0101d00:	89 ec                	mov    %ebp,%esp
c0101d02:	5d                   	pop    %ebp
c0101d03:	c3                   	ret    

c0101d04 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d04:	55                   	push   %ebp
c0101d05:	89 e5                	mov    %esp,%ebp
c0101d07:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0d:	8b 40 30             	mov    0x30(%eax),%eax
c0101d10:	83 f8 79             	cmp    $0x79,%eax
c0101d13:	0f 87 e6 00 00 00    	ja     c0101dff <trap_dispatch+0xfb>
c0101d19:	83 f8 78             	cmp    $0x78,%eax
c0101d1c:	0f 83 c1 00 00 00    	jae    c0101de3 <trap_dispatch+0xdf>
c0101d22:	83 f8 2f             	cmp    $0x2f,%eax
c0101d25:	0f 87 d4 00 00 00    	ja     c0101dff <trap_dispatch+0xfb>
c0101d2b:	83 f8 2e             	cmp    $0x2e,%eax
c0101d2e:	0f 83 00 01 00 00    	jae    c0101e34 <trap_dispatch+0x130>
c0101d34:	83 f8 24             	cmp    $0x24,%eax
c0101d37:	74 5e                	je     c0101d97 <trap_dispatch+0x93>
c0101d39:	83 f8 24             	cmp    $0x24,%eax
c0101d3c:	0f 87 bd 00 00 00    	ja     c0101dff <trap_dispatch+0xfb>
c0101d42:	83 f8 20             	cmp    $0x20,%eax
c0101d45:	74 0a                	je     c0101d51 <trap_dispatch+0x4d>
c0101d47:	83 f8 21             	cmp    $0x21,%eax
c0101d4a:	74 71                	je     c0101dbd <trap_dispatch+0xb9>
c0101d4c:	e9 ae 00 00 00       	jmp    c0101dff <trap_dispatch+0xfb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d51:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101d56:	40                   	inc    %eax
c0101d57:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
        if (ticks % TICK_NUM == 0) {
c0101d5c:	8b 0d 24 b4 11 c0    	mov    0xc011b424,%ecx
c0101d62:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d67:	89 c8                	mov    %ecx,%eax
c0101d69:	f7 e2                	mul    %edx
c0101d6b:	c1 ea 05             	shr    $0x5,%edx
c0101d6e:	89 d0                	mov    %edx,%eax
c0101d70:	c1 e0 02             	shl    $0x2,%eax
c0101d73:	01 d0                	add    %edx,%eax
c0101d75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101d7c:	01 d0                	add    %edx,%eax
c0101d7e:	c1 e0 02             	shl    $0x2,%eax
c0101d81:	29 c1                	sub    %eax,%ecx
c0101d83:	89 ca                	mov    %ecx,%edx
c0101d85:	85 d2                	test   %edx,%edx
c0101d87:	0f 85 aa 00 00 00    	jne    c0101e37 <trap_dispatch+0x133>
            print_ticks();
c0101d8d:	e8 86 fb ff ff       	call   c0101918 <print_ticks>
        }
        break;
c0101d92:	e9 a0 00 00 00       	jmp    c0101e37 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d97:	e8 1f f9 ff ff       	call   c01016bb <cons_getc>
c0101d9c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d9f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101da3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101da7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101daf:	c7 04 24 29 65 10 c0 	movl   $0xc0106529,(%esp)
c0101db6:	e8 9b e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101dbb:	eb 7b                	jmp    c0101e38 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dbd:	e8 f9 f8 ff ff       	call   c01016bb <cons_getc>
c0101dc2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dc5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dc9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd5:	c7 04 24 3b 65 10 c0 	movl   $0xc010653b,(%esp)
c0101ddc:	e8 75 e5 ff ff       	call   c0100356 <cprintf>
        break;
c0101de1:	eb 55                	jmp    c0101e38 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : 2011757 you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101de3:	c7 44 24 08 4a 65 10 	movl   $0xc010654a,0x8(%esp)
c0101dea:	c0 
c0101deb:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101df2:	00 
c0101df3:	c7 04 24 6e 63 10 c0 	movl   $0xc010636e,(%esp)
c0101dfa:	e8 dc ee ff ff       	call   c0100cdb <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e06:	83 e0 03             	and    $0x3,%eax
c0101e09:	85 c0                	test   %eax,%eax
c0101e0b:	75 2b                	jne    c0101e38 <trap_dispatch+0x134>
            print_trapframe(tf);
c0101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e10:	89 04 24             	mov    %eax,(%esp)
c0101e13:	e8 7f fc ff ff       	call   c0101a97 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e18:	c7 44 24 08 5a 65 10 	movl   $0xc010655a,0x8(%esp)
c0101e1f:	c0 
c0101e20:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101e27:	00 
c0101e28:	c7 04 24 6e 63 10 c0 	movl   $0xc010636e,(%esp)
c0101e2f:	e8 a7 ee ff ff       	call   c0100cdb <__panic>
        break;
c0101e34:	90                   	nop
c0101e35:	eb 01                	jmp    c0101e38 <trap_dispatch+0x134>
        break;
c0101e37:	90                   	nop
        }
    }
}
c0101e38:	90                   	nop
c0101e39:	89 ec                	mov    %ebp,%esp
c0101e3b:	5d                   	pop    %ebp
c0101e3c:	c3                   	ret    

c0101e3d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e3d:	55                   	push   %ebp
c0101e3e:	89 e5                	mov    %esp,%ebp
c0101e40:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e46:	89 04 24             	mov    %eax,(%esp)
c0101e49:	e8 b6 fe ff ff       	call   c0101d04 <trap_dispatch>
}
c0101e4e:	90                   	nop
c0101e4f:	89 ec                	mov    %ebp,%esp
c0101e51:	5d                   	pop    %ebp
c0101e52:	c3                   	ret    

c0101e53 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e53:	1e                   	push   %ds
    pushl %es
c0101e54:	06                   	push   %es
    pushl %fs
c0101e55:	0f a0                	push   %fs
    pushl %gs
c0101e57:	0f a8                	push   %gs
    pushal
c0101e59:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e5a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e5f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e61:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e63:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e64:	e8 d4 ff ff ff       	call   c0101e3d <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e69:	5c                   	pop    %esp

c0101e6a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e6a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e6b:	0f a9                	pop    %gs
    popl %fs
c0101e6d:	0f a1                	pop    %fs
    popl %es
c0101e6f:	07                   	pop    %es
    popl %ds
c0101e70:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e71:	83 c4 08             	add    $0x8,%esp
    iret
c0101e74:	cf                   	iret   

c0101e75 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e75:	6a 00                	push   $0x0
  pushl $0
c0101e77:	6a 00                	push   $0x0
  jmp __alltraps
c0101e79:	e9 d5 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101e7e <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e7e:	6a 00                	push   $0x0
  pushl $1
c0101e80:	6a 01                	push   $0x1
  jmp __alltraps
c0101e82:	e9 cc ff ff ff       	jmp    c0101e53 <__alltraps>

c0101e87 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e87:	6a 00                	push   $0x0
  pushl $2
c0101e89:	6a 02                	push   $0x2
  jmp __alltraps
c0101e8b:	e9 c3 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101e90 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e90:	6a 00                	push   $0x0
  pushl $3
c0101e92:	6a 03                	push   $0x3
  jmp __alltraps
c0101e94:	e9 ba ff ff ff       	jmp    c0101e53 <__alltraps>

c0101e99 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e99:	6a 00                	push   $0x0
  pushl $4
c0101e9b:	6a 04                	push   $0x4
  jmp __alltraps
c0101e9d:	e9 b1 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ea2 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101ea2:	6a 00                	push   $0x0
  pushl $5
c0101ea4:	6a 05                	push   $0x5
  jmp __alltraps
c0101ea6:	e9 a8 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101eab <vector6>:
.globl vector6
vector6:
  pushl $0
c0101eab:	6a 00                	push   $0x0
  pushl $6
c0101ead:	6a 06                	push   $0x6
  jmp __alltraps
c0101eaf:	e9 9f ff ff ff       	jmp    c0101e53 <__alltraps>

c0101eb4 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101eb4:	6a 00                	push   $0x0
  pushl $7
c0101eb6:	6a 07                	push   $0x7
  jmp __alltraps
c0101eb8:	e9 96 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ebd <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ebd:	6a 08                	push   $0x8
  jmp __alltraps
c0101ebf:	e9 8f ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ec4 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101ec4:	6a 09                	push   $0x9
  jmp __alltraps
c0101ec6:	e9 88 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ecb <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ecb:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ecd:	e9 81 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ed2 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ed2:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ed4:	e9 7a ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ed9 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ed9:	6a 0c                	push   $0xc
  jmp __alltraps
c0101edb:	e9 73 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ee0 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ee0:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ee2:	e9 6c ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ee7 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ee7:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ee9:	e9 65 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101eee <vector15>:
.globl vector15
vector15:
  pushl $0
c0101eee:	6a 00                	push   $0x0
  pushl $15
c0101ef0:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ef2:	e9 5c ff ff ff       	jmp    c0101e53 <__alltraps>

c0101ef7 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ef7:	6a 00                	push   $0x0
  pushl $16
c0101ef9:	6a 10                	push   $0x10
  jmp __alltraps
c0101efb:	e9 53 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f00 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f00:	6a 11                	push   $0x11
  jmp __alltraps
c0101f02:	e9 4c ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f07 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f07:	6a 00                	push   $0x0
  pushl $18
c0101f09:	6a 12                	push   $0x12
  jmp __alltraps
c0101f0b:	e9 43 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f10 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $19
c0101f12:	6a 13                	push   $0x13
  jmp __alltraps
c0101f14:	e9 3a ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f19 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f19:	6a 00                	push   $0x0
  pushl $20
c0101f1b:	6a 14                	push   $0x14
  jmp __alltraps
c0101f1d:	e9 31 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f22 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f22:	6a 00                	push   $0x0
  pushl $21
c0101f24:	6a 15                	push   $0x15
  jmp __alltraps
c0101f26:	e9 28 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f2b <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f2b:	6a 00                	push   $0x0
  pushl $22
c0101f2d:	6a 16                	push   $0x16
  jmp __alltraps
c0101f2f:	e9 1f ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f34 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f34:	6a 00                	push   $0x0
  pushl $23
c0101f36:	6a 17                	push   $0x17
  jmp __alltraps
c0101f38:	e9 16 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f3d <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $24
c0101f3f:	6a 18                	push   $0x18
  jmp __alltraps
c0101f41:	e9 0d ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f46 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $25
c0101f48:	6a 19                	push   $0x19
  jmp __alltraps
c0101f4a:	e9 04 ff ff ff       	jmp    c0101e53 <__alltraps>

c0101f4f <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $26
c0101f51:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f53:	e9 fb fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f58 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $27
c0101f5a:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f5c:	e9 f2 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f61 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $28
c0101f63:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f65:	e9 e9 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f6a <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $29
c0101f6c:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f6e:	e9 e0 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f73 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $30
c0101f75:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f77:	e9 d7 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f7c <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $31
c0101f7e:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f80:	e9 ce fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f85 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $32
c0101f87:	6a 20                	push   $0x20
  jmp __alltraps
c0101f89:	e9 c5 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f8e <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $33
c0101f90:	6a 21                	push   $0x21
  jmp __alltraps
c0101f92:	e9 bc fe ff ff       	jmp    c0101e53 <__alltraps>

c0101f97 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $34
c0101f99:	6a 22                	push   $0x22
  jmp __alltraps
c0101f9b:	e9 b3 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fa0 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $35
c0101fa2:	6a 23                	push   $0x23
  jmp __alltraps
c0101fa4:	e9 aa fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fa9 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $36
c0101fab:	6a 24                	push   $0x24
  jmp __alltraps
c0101fad:	e9 a1 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fb2 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $37
c0101fb4:	6a 25                	push   $0x25
  jmp __alltraps
c0101fb6:	e9 98 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fbb <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $38
c0101fbd:	6a 26                	push   $0x26
  jmp __alltraps
c0101fbf:	e9 8f fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fc4 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $39
c0101fc6:	6a 27                	push   $0x27
  jmp __alltraps
c0101fc8:	e9 86 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fcd <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $40
c0101fcf:	6a 28                	push   $0x28
  jmp __alltraps
c0101fd1:	e9 7d fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fd6 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $41
c0101fd8:	6a 29                	push   $0x29
  jmp __alltraps
c0101fda:	e9 74 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fdf <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $42
c0101fe1:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fe3:	e9 6b fe ff ff       	jmp    c0101e53 <__alltraps>

c0101fe8 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $43
c0101fea:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fec:	e9 62 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101ff1 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $44
c0101ff3:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101ff5:	e9 59 fe ff ff       	jmp    c0101e53 <__alltraps>

c0101ffa <vector45>:
.globl vector45
vector45:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $45
c0101ffc:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101ffe:	e9 50 fe ff ff       	jmp    c0101e53 <__alltraps>

c0102003 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $46
c0102005:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102007:	e9 47 fe ff ff       	jmp    c0101e53 <__alltraps>

c010200c <vector47>:
.globl vector47
vector47:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $47
c010200e:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102010:	e9 3e fe ff ff       	jmp    c0101e53 <__alltraps>

c0102015 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $48
c0102017:	6a 30                	push   $0x30
  jmp __alltraps
c0102019:	e9 35 fe ff ff       	jmp    c0101e53 <__alltraps>

c010201e <vector49>:
.globl vector49
vector49:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $49
c0102020:	6a 31                	push   $0x31
  jmp __alltraps
c0102022:	e9 2c fe ff ff       	jmp    c0101e53 <__alltraps>

c0102027 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $50
c0102029:	6a 32                	push   $0x32
  jmp __alltraps
c010202b:	e9 23 fe ff ff       	jmp    c0101e53 <__alltraps>

c0102030 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $51
c0102032:	6a 33                	push   $0x33
  jmp __alltraps
c0102034:	e9 1a fe ff ff       	jmp    c0101e53 <__alltraps>

c0102039 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $52
c010203b:	6a 34                	push   $0x34
  jmp __alltraps
c010203d:	e9 11 fe ff ff       	jmp    c0101e53 <__alltraps>

c0102042 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $53
c0102044:	6a 35                	push   $0x35
  jmp __alltraps
c0102046:	e9 08 fe ff ff       	jmp    c0101e53 <__alltraps>

c010204b <vector54>:
.globl vector54
vector54:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $54
c010204d:	6a 36                	push   $0x36
  jmp __alltraps
c010204f:	e9 ff fd ff ff       	jmp    c0101e53 <__alltraps>

c0102054 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $55
c0102056:	6a 37                	push   $0x37
  jmp __alltraps
c0102058:	e9 f6 fd ff ff       	jmp    c0101e53 <__alltraps>

c010205d <vector56>:
.globl vector56
vector56:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $56
c010205f:	6a 38                	push   $0x38
  jmp __alltraps
c0102061:	e9 ed fd ff ff       	jmp    c0101e53 <__alltraps>

c0102066 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $57
c0102068:	6a 39                	push   $0x39
  jmp __alltraps
c010206a:	e9 e4 fd ff ff       	jmp    c0101e53 <__alltraps>

c010206f <vector58>:
.globl vector58
vector58:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $58
c0102071:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102073:	e9 db fd ff ff       	jmp    c0101e53 <__alltraps>

c0102078 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $59
c010207a:	6a 3b                	push   $0x3b
  jmp __alltraps
c010207c:	e9 d2 fd ff ff       	jmp    c0101e53 <__alltraps>

c0102081 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $60
c0102083:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102085:	e9 c9 fd ff ff       	jmp    c0101e53 <__alltraps>

c010208a <vector61>:
.globl vector61
vector61:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $61
c010208c:	6a 3d                	push   $0x3d
  jmp __alltraps
c010208e:	e9 c0 fd ff ff       	jmp    c0101e53 <__alltraps>

c0102093 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $62
c0102095:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102097:	e9 b7 fd ff ff       	jmp    c0101e53 <__alltraps>

c010209c <vector63>:
.globl vector63
vector63:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $63
c010209e:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020a0:	e9 ae fd ff ff       	jmp    c0101e53 <__alltraps>

c01020a5 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $64
c01020a7:	6a 40                	push   $0x40
  jmp __alltraps
c01020a9:	e9 a5 fd ff ff       	jmp    c0101e53 <__alltraps>

c01020ae <vector65>:
.globl vector65
vector65:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $65
c01020b0:	6a 41                	push   $0x41
  jmp __alltraps
c01020b2:	e9 9c fd ff ff       	jmp    c0101e53 <__alltraps>

c01020b7 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $66
c01020b9:	6a 42                	push   $0x42
  jmp __alltraps
c01020bb:	e9 93 fd ff ff       	jmp    c0101e53 <__alltraps>

c01020c0 <vector67>:
.globl vector67
vector67:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $67
c01020c2:	6a 43                	push   $0x43
  jmp __alltraps
c01020c4:	e9 8a fd ff ff       	jmp    c0101e53 <__alltraps>

c01020c9 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $68
c01020cb:	6a 44                	push   $0x44
  jmp __alltraps
c01020cd:	e9 81 fd ff ff       	jmp    c0101e53 <__alltraps>

c01020d2 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $69
c01020d4:	6a 45                	push   $0x45
  jmp __alltraps
c01020d6:	e9 78 fd ff ff       	jmp    c0101e53 <__alltraps>

c01020db <vector70>:
.globl vector70
vector70:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $70
c01020dd:	6a 46                	push   $0x46
  jmp __alltraps
c01020df:	e9 6f fd ff ff       	jmp    c0101e53 <__alltraps>

c01020e4 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $71
c01020e6:	6a 47                	push   $0x47
  jmp __alltraps
c01020e8:	e9 66 fd ff ff       	jmp    c0101e53 <__alltraps>

c01020ed <vector72>:
.globl vector72
vector72:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $72
c01020ef:	6a 48                	push   $0x48
  jmp __alltraps
c01020f1:	e9 5d fd ff ff       	jmp    c0101e53 <__alltraps>

c01020f6 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $73
c01020f8:	6a 49                	push   $0x49
  jmp __alltraps
c01020fa:	e9 54 fd ff ff       	jmp    c0101e53 <__alltraps>

c01020ff <vector74>:
.globl vector74
vector74:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $74
c0102101:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102103:	e9 4b fd ff ff       	jmp    c0101e53 <__alltraps>

c0102108 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $75
c010210a:	6a 4b                	push   $0x4b
  jmp __alltraps
c010210c:	e9 42 fd ff ff       	jmp    c0101e53 <__alltraps>

c0102111 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $76
c0102113:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102115:	e9 39 fd ff ff       	jmp    c0101e53 <__alltraps>

c010211a <vector77>:
.globl vector77
vector77:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $77
c010211c:	6a 4d                	push   $0x4d
  jmp __alltraps
c010211e:	e9 30 fd ff ff       	jmp    c0101e53 <__alltraps>

c0102123 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $78
c0102125:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102127:	e9 27 fd ff ff       	jmp    c0101e53 <__alltraps>

c010212c <vector79>:
.globl vector79
vector79:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $79
c010212e:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102130:	e9 1e fd ff ff       	jmp    c0101e53 <__alltraps>

c0102135 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $80
c0102137:	6a 50                	push   $0x50
  jmp __alltraps
c0102139:	e9 15 fd ff ff       	jmp    c0101e53 <__alltraps>

c010213e <vector81>:
.globl vector81
vector81:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $81
c0102140:	6a 51                	push   $0x51
  jmp __alltraps
c0102142:	e9 0c fd ff ff       	jmp    c0101e53 <__alltraps>

c0102147 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $82
c0102149:	6a 52                	push   $0x52
  jmp __alltraps
c010214b:	e9 03 fd ff ff       	jmp    c0101e53 <__alltraps>

c0102150 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $83
c0102152:	6a 53                	push   $0x53
  jmp __alltraps
c0102154:	e9 fa fc ff ff       	jmp    c0101e53 <__alltraps>

c0102159 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $84
c010215b:	6a 54                	push   $0x54
  jmp __alltraps
c010215d:	e9 f1 fc ff ff       	jmp    c0101e53 <__alltraps>

c0102162 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $85
c0102164:	6a 55                	push   $0x55
  jmp __alltraps
c0102166:	e9 e8 fc ff ff       	jmp    c0101e53 <__alltraps>

c010216b <vector86>:
.globl vector86
vector86:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $86
c010216d:	6a 56                	push   $0x56
  jmp __alltraps
c010216f:	e9 df fc ff ff       	jmp    c0101e53 <__alltraps>

c0102174 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $87
c0102176:	6a 57                	push   $0x57
  jmp __alltraps
c0102178:	e9 d6 fc ff ff       	jmp    c0101e53 <__alltraps>

c010217d <vector88>:
.globl vector88
vector88:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $88
c010217f:	6a 58                	push   $0x58
  jmp __alltraps
c0102181:	e9 cd fc ff ff       	jmp    c0101e53 <__alltraps>

c0102186 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $89
c0102188:	6a 59                	push   $0x59
  jmp __alltraps
c010218a:	e9 c4 fc ff ff       	jmp    c0101e53 <__alltraps>

c010218f <vector90>:
.globl vector90
vector90:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $90
c0102191:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102193:	e9 bb fc ff ff       	jmp    c0101e53 <__alltraps>

c0102198 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $91
c010219a:	6a 5b                	push   $0x5b
  jmp __alltraps
c010219c:	e9 b2 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021a1 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $92
c01021a3:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021a5:	e9 a9 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021aa <vector93>:
.globl vector93
vector93:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $93
c01021ac:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021ae:	e9 a0 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021b3 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $94
c01021b5:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021b7:	e9 97 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021bc <vector95>:
.globl vector95
vector95:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $95
c01021be:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021c0:	e9 8e fc ff ff       	jmp    c0101e53 <__alltraps>

c01021c5 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $96
c01021c7:	6a 60                	push   $0x60
  jmp __alltraps
c01021c9:	e9 85 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021ce <vector97>:
.globl vector97
vector97:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $97
c01021d0:	6a 61                	push   $0x61
  jmp __alltraps
c01021d2:	e9 7c fc ff ff       	jmp    c0101e53 <__alltraps>

c01021d7 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $98
c01021d9:	6a 62                	push   $0x62
  jmp __alltraps
c01021db:	e9 73 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021e0 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $99
c01021e2:	6a 63                	push   $0x63
  jmp __alltraps
c01021e4:	e9 6a fc ff ff       	jmp    c0101e53 <__alltraps>

c01021e9 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $100
c01021eb:	6a 64                	push   $0x64
  jmp __alltraps
c01021ed:	e9 61 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021f2 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $101
c01021f4:	6a 65                	push   $0x65
  jmp __alltraps
c01021f6:	e9 58 fc ff ff       	jmp    c0101e53 <__alltraps>

c01021fb <vector102>:
.globl vector102
vector102:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $102
c01021fd:	6a 66                	push   $0x66
  jmp __alltraps
c01021ff:	e9 4f fc ff ff       	jmp    c0101e53 <__alltraps>

c0102204 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $103
c0102206:	6a 67                	push   $0x67
  jmp __alltraps
c0102208:	e9 46 fc ff ff       	jmp    c0101e53 <__alltraps>

c010220d <vector104>:
.globl vector104
vector104:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $104
c010220f:	6a 68                	push   $0x68
  jmp __alltraps
c0102211:	e9 3d fc ff ff       	jmp    c0101e53 <__alltraps>

c0102216 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $105
c0102218:	6a 69                	push   $0x69
  jmp __alltraps
c010221a:	e9 34 fc ff ff       	jmp    c0101e53 <__alltraps>

c010221f <vector106>:
.globl vector106
vector106:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $106
c0102221:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102223:	e9 2b fc ff ff       	jmp    c0101e53 <__alltraps>

c0102228 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $107
c010222a:	6a 6b                	push   $0x6b
  jmp __alltraps
c010222c:	e9 22 fc ff ff       	jmp    c0101e53 <__alltraps>

c0102231 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $108
c0102233:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102235:	e9 19 fc ff ff       	jmp    c0101e53 <__alltraps>

c010223a <vector109>:
.globl vector109
vector109:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $109
c010223c:	6a 6d                	push   $0x6d
  jmp __alltraps
c010223e:	e9 10 fc ff ff       	jmp    c0101e53 <__alltraps>

c0102243 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $110
c0102245:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102247:	e9 07 fc ff ff       	jmp    c0101e53 <__alltraps>

c010224c <vector111>:
.globl vector111
vector111:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $111
c010224e:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102250:	e9 fe fb ff ff       	jmp    c0101e53 <__alltraps>

c0102255 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $112
c0102257:	6a 70                	push   $0x70
  jmp __alltraps
c0102259:	e9 f5 fb ff ff       	jmp    c0101e53 <__alltraps>

c010225e <vector113>:
.globl vector113
vector113:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $113
c0102260:	6a 71                	push   $0x71
  jmp __alltraps
c0102262:	e9 ec fb ff ff       	jmp    c0101e53 <__alltraps>

c0102267 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $114
c0102269:	6a 72                	push   $0x72
  jmp __alltraps
c010226b:	e9 e3 fb ff ff       	jmp    c0101e53 <__alltraps>

c0102270 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $115
c0102272:	6a 73                	push   $0x73
  jmp __alltraps
c0102274:	e9 da fb ff ff       	jmp    c0101e53 <__alltraps>

c0102279 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $116
c010227b:	6a 74                	push   $0x74
  jmp __alltraps
c010227d:	e9 d1 fb ff ff       	jmp    c0101e53 <__alltraps>

c0102282 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $117
c0102284:	6a 75                	push   $0x75
  jmp __alltraps
c0102286:	e9 c8 fb ff ff       	jmp    c0101e53 <__alltraps>

c010228b <vector118>:
.globl vector118
vector118:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $118
c010228d:	6a 76                	push   $0x76
  jmp __alltraps
c010228f:	e9 bf fb ff ff       	jmp    c0101e53 <__alltraps>

c0102294 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $119
c0102296:	6a 77                	push   $0x77
  jmp __alltraps
c0102298:	e9 b6 fb ff ff       	jmp    c0101e53 <__alltraps>

c010229d <vector120>:
.globl vector120
vector120:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $120
c010229f:	6a 78                	push   $0x78
  jmp __alltraps
c01022a1:	e9 ad fb ff ff       	jmp    c0101e53 <__alltraps>

c01022a6 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $121
c01022a8:	6a 79                	push   $0x79
  jmp __alltraps
c01022aa:	e9 a4 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022af <vector122>:
.globl vector122
vector122:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $122
c01022b1:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022b3:	e9 9b fb ff ff       	jmp    c0101e53 <__alltraps>

c01022b8 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $123
c01022ba:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022bc:	e9 92 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022c1 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $124
c01022c3:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022c5:	e9 89 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022ca <vector125>:
.globl vector125
vector125:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $125
c01022cc:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022ce:	e9 80 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022d3 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $126
c01022d5:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022d7:	e9 77 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022dc <vector127>:
.globl vector127
vector127:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $127
c01022de:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022e0:	e9 6e fb ff ff       	jmp    c0101e53 <__alltraps>

c01022e5 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $128
c01022e7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022ec:	e9 62 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022f1 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $129
c01022f3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022f8:	e9 56 fb ff ff       	jmp    c0101e53 <__alltraps>

c01022fd <vector130>:
.globl vector130
vector130:
  pushl $0
c01022fd:	6a 00                	push   $0x0
  pushl $130
c01022ff:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102304:	e9 4a fb ff ff       	jmp    c0101e53 <__alltraps>

c0102309 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $131
c010230b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102310:	e9 3e fb ff ff       	jmp    c0101e53 <__alltraps>

c0102315 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $132
c0102317:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010231c:	e9 32 fb ff ff       	jmp    c0101e53 <__alltraps>

c0102321 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102321:	6a 00                	push   $0x0
  pushl $133
c0102323:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102328:	e9 26 fb ff ff       	jmp    c0101e53 <__alltraps>

c010232d <vector134>:
.globl vector134
vector134:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $134
c010232f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102334:	e9 1a fb ff ff       	jmp    c0101e53 <__alltraps>

c0102339 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $135
c010233b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102340:	e9 0e fb ff ff       	jmp    c0101e53 <__alltraps>

c0102345 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102345:	6a 00                	push   $0x0
  pushl $136
c0102347:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010234c:	e9 02 fb ff ff       	jmp    c0101e53 <__alltraps>

c0102351 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $137
c0102353:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102358:	e9 f6 fa ff ff       	jmp    c0101e53 <__alltraps>

c010235d <vector138>:
.globl vector138
vector138:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $138
c010235f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102364:	e9 ea fa ff ff       	jmp    c0101e53 <__alltraps>

c0102369 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $139
c010236b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102370:	e9 de fa ff ff       	jmp    c0101e53 <__alltraps>

c0102375 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $140
c0102377:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010237c:	e9 d2 fa ff ff       	jmp    c0101e53 <__alltraps>

c0102381 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $141
c0102383:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102388:	e9 c6 fa ff ff       	jmp    c0101e53 <__alltraps>

c010238d <vector142>:
.globl vector142
vector142:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $142
c010238f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102394:	e9 ba fa ff ff       	jmp    c0101e53 <__alltraps>

c0102399 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $143
c010239b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023a0:	e9 ae fa ff ff       	jmp    c0101e53 <__alltraps>

c01023a5 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $144
c01023a7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023ac:	e9 a2 fa ff ff       	jmp    c0101e53 <__alltraps>

c01023b1 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $145
c01023b3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023b8:	e9 96 fa ff ff       	jmp    c0101e53 <__alltraps>

c01023bd <vector146>:
.globl vector146
vector146:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $146
c01023bf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023c4:	e9 8a fa ff ff       	jmp    c0101e53 <__alltraps>

c01023c9 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $147
c01023cb:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023d0:	e9 7e fa ff ff       	jmp    c0101e53 <__alltraps>

c01023d5 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $148
c01023d7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023dc:	e9 72 fa ff ff       	jmp    c0101e53 <__alltraps>

c01023e1 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $149
c01023e3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023e8:	e9 66 fa ff ff       	jmp    c0101e53 <__alltraps>

c01023ed <vector150>:
.globl vector150
vector150:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $150
c01023ef:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023f4:	e9 5a fa ff ff       	jmp    c0101e53 <__alltraps>

c01023f9 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $151
c01023fb:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102400:	e9 4e fa ff ff       	jmp    c0101e53 <__alltraps>

c0102405 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $152
c0102407:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010240c:	e9 42 fa ff ff       	jmp    c0101e53 <__alltraps>

c0102411 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $153
c0102413:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102418:	e9 36 fa ff ff       	jmp    c0101e53 <__alltraps>

c010241d <vector154>:
.globl vector154
vector154:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $154
c010241f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102424:	e9 2a fa ff ff       	jmp    c0101e53 <__alltraps>

c0102429 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $155
c010242b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102430:	e9 1e fa ff ff       	jmp    c0101e53 <__alltraps>

c0102435 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $156
c0102437:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010243c:	e9 12 fa ff ff       	jmp    c0101e53 <__alltraps>

c0102441 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $157
c0102443:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102448:	e9 06 fa ff ff       	jmp    c0101e53 <__alltraps>

c010244d <vector158>:
.globl vector158
vector158:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $158
c010244f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102454:	e9 fa f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102459 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $159
c010245b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102460:	e9 ee f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102465 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $160
c0102467:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010246c:	e9 e2 f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102471 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $161
c0102473:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102478:	e9 d6 f9 ff ff       	jmp    c0101e53 <__alltraps>

c010247d <vector162>:
.globl vector162
vector162:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $162
c010247f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102484:	e9 ca f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102489 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $163
c010248b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102490:	e9 be f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102495 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $164
c0102497:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010249c:	e9 b2 f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024a1 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $165
c01024a3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024a8:	e9 a6 f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024ad <vector166>:
.globl vector166
vector166:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $166
c01024af:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024b4:	e9 9a f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024b9 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $167
c01024bb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024c0:	e9 8e f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024c5 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $168
c01024c7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024cc:	e9 82 f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024d1 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $169
c01024d3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024d8:	e9 76 f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024dd <vector170>:
.globl vector170
vector170:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $170
c01024df:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024e4:	e9 6a f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024e9 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $171
c01024eb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024f0:	e9 5e f9 ff ff       	jmp    c0101e53 <__alltraps>

c01024f5 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $172
c01024f7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024fc:	e9 52 f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102501 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $173
c0102503:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102508:	e9 46 f9 ff ff       	jmp    c0101e53 <__alltraps>

c010250d <vector174>:
.globl vector174
vector174:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $174
c010250f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102514:	e9 3a f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102519 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $175
c010251b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102520:	e9 2e f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102525 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $176
c0102527:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010252c:	e9 22 f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102531 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $177
c0102533:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102538:	e9 16 f9 ff ff       	jmp    c0101e53 <__alltraps>

c010253d <vector178>:
.globl vector178
vector178:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $178
c010253f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102544:	e9 0a f9 ff ff       	jmp    c0101e53 <__alltraps>

c0102549 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $179
c010254b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102550:	e9 fe f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102555 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $180
c0102557:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010255c:	e9 f2 f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102561 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $181
c0102563:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102568:	e9 e6 f8 ff ff       	jmp    c0101e53 <__alltraps>

c010256d <vector182>:
.globl vector182
vector182:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $182
c010256f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102574:	e9 da f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102579 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $183
c010257b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102580:	e9 ce f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102585 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $184
c0102587:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010258c:	e9 c2 f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102591 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $185
c0102593:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102598:	e9 b6 f8 ff ff       	jmp    c0101e53 <__alltraps>

c010259d <vector186>:
.globl vector186
vector186:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $186
c010259f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025a4:	e9 aa f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025a9 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $187
c01025ab:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025b0:	e9 9e f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025b5 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $188
c01025b7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025bc:	e9 92 f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025c1 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $189
c01025c3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025c8:	e9 86 f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025cd <vector190>:
.globl vector190
vector190:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $190
c01025cf:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025d4:	e9 7a f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025d9 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $191
c01025db:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025e0:	e9 6e f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025e5 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $192
c01025e7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025ec:	e9 62 f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025f1 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $193
c01025f3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025f8:	e9 56 f8 ff ff       	jmp    c0101e53 <__alltraps>

c01025fd <vector194>:
.globl vector194
vector194:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $194
c01025ff:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102604:	e9 4a f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102609 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $195
c010260b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102610:	e9 3e f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102615 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $196
c0102617:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010261c:	e9 32 f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102621 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $197
c0102623:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102628:	e9 26 f8 ff ff       	jmp    c0101e53 <__alltraps>

c010262d <vector198>:
.globl vector198
vector198:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $198
c010262f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102634:	e9 1a f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102639 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $199
c010263b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102640:	e9 0e f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102645 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $200
c0102647:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010264c:	e9 02 f8 ff ff       	jmp    c0101e53 <__alltraps>

c0102651 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $201
c0102653:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102658:	e9 f6 f7 ff ff       	jmp    c0101e53 <__alltraps>

c010265d <vector202>:
.globl vector202
vector202:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $202
c010265f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102664:	e9 ea f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102669 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $203
c010266b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102670:	e9 de f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102675 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $204
c0102677:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010267c:	e9 d2 f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102681 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $205
c0102683:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102688:	e9 c6 f7 ff ff       	jmp    c0101e53 <__alltraps>

c010268d <vector206>:
.globl vector206
vector206:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $206
c010268f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102694:	e9 ba f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102699 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $207
c010269b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026a0:	e9 ae f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026a5 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $208
c01026a7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026ac:	e9 a2 f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026b1 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $209
c01026b3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026b8:	e9 96 f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026bd <vector210>:
.globl vector210
vector210:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $210
c01026bf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026c4:	e9 8a f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026c9 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $211
c01026cb:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026d0:	e9 7e f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026d5 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $212
c01026d7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026dc:	e9 72 f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026e1 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $213
c01026e3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026e8:	e9 66 f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026ed <vector214>:
.globl vector214
vector214:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $214
c01026ef:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026f4:	e9 5a f7 ff ff       	jmp    c0101e53 <__alltraps>

c01026f9 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $215
c01026fb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102700:	e9 4e f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102705 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $216
c0102707:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010270c:	e9 42 f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102711 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $217
c0102713:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102718:	e9 36 f7 ff ff       	jmp    c0101e53 <__alltraps>

c010271d <vector218>:
.globl vector218
vector218:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $218
c010271f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102724:	e9 2a f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102729 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $219
c010272b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102730:	e9 1e f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102735 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $220
c0102737:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010273c:	e9 12 f7 ff ff       	jmp    c0101e53 <__alltraps>

c0102741 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $221
c0102743:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102748:	e9 06 f7 ff ff       	jmp    c0101e53 <__alltraps>

c010274d <vector222>:
.globl vector222
vector222:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $222
c010274f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102754:	e9 fa f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102759 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $223
c010275b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102760:	e9 ee f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102765 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $224
c0102767:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010276c:	e9 e2 f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102771 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $225
c0102773:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102778:	e9 d6 f6 ff ff       	jmp    c0101e53 <__alltraps>

c010277d <vector226>:
.globl vector226
vector226:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $226
c010277f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102784:	e9 ca f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102789 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $227
c010278b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102790:	e9 be f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102795 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $228
c0102797:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010279c:	e9 b2 f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027a1 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $229
c01027a3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027a8:	e9 a6 f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027ad <vector230>:
.globl vector230
vector230:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $230
c01027af:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027b4:	e9 9a f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027b9 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $231
c01027bb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027c0:	e9 8e f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027c5 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $232
c01027c7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027cc:	e9 82 f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027d1 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $233
c01027d3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027d8:	e9 76 f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027dd <vector234>:
.globl vector234
vector234:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $234
c01027df:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027e4:	e9 6a f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027e9 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $235
c01027eb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027f0:	e9 5e f6 ff ff       	jmp    c0101e53 <__alltraps>

c01027f5 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $236
c01027f7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027fc:	e9 52 f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102801 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102801:	6a 00                	push   $0x0
  pushl $237
c0102803:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102808:	e9 46 f6 ff ff       	jmp    c0101e53 <__alltraps>

c010280d <vector238>:
.globl vector238
vector238:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $238
c010280f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102814:	e9 3a f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102819 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $239
c010281b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102820:	e9 2e f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102825 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102825:	6a 00                	push   $0x0
  pushl $240
c0102827:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010282c:	e9 22 f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102831 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $241
c0102833:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102838:	e9 16 f6 ff ff       	jmp    c0101e53 <__alltraps>

c010283d <vector242>:
.globl vector242
vector242:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $242
c010283f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102844:	e9 0a f6 ff ff       	jmp    c0101e53 <__alltraps>

c0102849 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102849:	6a 00                	push   $0x0
  pushl $243
c010284b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102850:	e9 fe f5 ff ff       	jmp    c0101e53 <__alltraps>

c0102855 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $244
c0102857:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010285c:	e9 f2 f5 ff ff       	jmp    c0101e53 <__alltraps>

c0102861 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $245
c0102863:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102868:	e9 e6 f5 ff ff       	jmp    c0101e53 <__alltraps>

c010286d <vector246>:
.globl vector246
vector246:
  pushl $0
c010286d:	6a 00                	push   $0x0
  pushl $246
c010286f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102874:	e9 da f5 ff ff       	jmp    c0101e53 <__alltraps>

c0102879 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $247
c010287b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102880:	e9 ce f5 ff ff       	jmp    c0101e53 <__alltraps>

c0102885 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $248
c0102887:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010288c:	e9 c2 f5 ff ff       	jmp    c0101e53 <__alltraps>

c0102891 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102891:	6a 00                	push   $0x0
  pushl $249
c0102893:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102898:	e9 b6 f5 ff ff       	jmp    c0101e53 <__alltraps>

c010289d <vector250>:
.globl vector250
vector250:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $250
c010289f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028a4:	e9 aa f5 ff ff       	jmp    c0101e53 <__alltraps>

c01028a9 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $251
c01028ab:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028b0:	e9 9e f5 ff ff       	jmp    c0101e53 <__alltraps>

c01028b5 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028b5:	6a 00                	push   $0x0
  pushl $252
c01028b7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028bc:	e9 92 f5 ff ff       	jmp    c0101e53 <__alltraps>

c01028c1 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $253
c01028c3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028c8:	e9 86 f5 ff ff       	jmp    c0101e53 <__alltraps>

c01028cd <vector254>:
.globl vector254
vector254:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $254
c01028cf:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028d4:	e9 7a f5 ff ff       	jmp    c0101e53 <__alltraps>

c01028d9 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028d9:	6a 00                	push   $0x0
  pushl $255
c01028db:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028e0:	e9 6e f5 ff ff       	jmp    c0101e53 <__alltraps>

c01028e5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028e5:	55                   	push   %ebp
c01028e6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028e8:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c01028ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f1:	29 d0                	sub    %edx,%eax
c01028f3:	c1 f8 02             	sar    $0x2,%eax
c01028f6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028fc:	5d                   	pop    %ebp
c01028fd:	c3                   	ret    

c01028fe <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028fe:	55                   	push   %ebp
c01028ff:	89 e5                	mov    %esp,%ebp
c0102901:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102904:	8b 45 08             	mov    0x8(%ebp),%eax
c0102907:	89 04 24             	mov    %eax,(%esp)
c010290a:	e8 d6 ff ff ff       	call   c01028e5 <page2ppn>
c010290f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102912:	89 ec                	mov    %ebp,%esp
c0102914:	5d                   	pop    %ebp
c0102915:	c3                   	ret    

c0102916 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102916:	55                   	push   %ebp
c0102917:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102919:	8b 45 08             	mov    0x8(%ebp),%eax
c010291c:	8b 00                	mov    (%eax),%eax
}
c010291e:	5d                   	pop    %ebp
c010291f:	c3                   	ret    

c0102920 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102920:	55                   	push   %ebp
c0102921:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102923:	8b 45 08             	mov    0x8(%ebp),%eax
c0102926:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102929:	89 10                	mov    %edx,(%eax)
}
c010292b:	90                   	nop
c010292c:	5d                   	pop    %ebp
c010292d:	c3                   	ret    

c010292e <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲页块链表
static void
default_init(void) {
c010292e:	55                   	push   %ebp
c010292f:	89 e5                	mov    %esp,%ebp
c0102931:	83 ec 10             	sub    $0x10,%esp
c0102934:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010293b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010293e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102941:	89 50 04             	mov    %edx,0x4(%eax)
c0102944:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102947:	8b 50 04             	mov    0x4(%eax),%edx
c010294a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010294d:	89 10                	mov    %edx,(%eax)
}
c010294f:	90                   	nop
    list_init(&free_list);
    // 空闲页块一开始是0个
    nr_free = 0;
c0102950:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102957:	00 00 00 
}
c010295a:	90                   	nop
c010295b:	89 ec                	mov    %ebp,%esp
c010295d:	5d                   	pop    %ebp
c010295e:	c3                   	ret    

c010295f <default_init_memmap>:


static void
default_init_memmap(struct Page *base, size_t n) {
c010295f:	55                   	push   %ebp
c0102960:	89 e5                	mov    %esp,%ebp
c0102962:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102965:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102969:	75 24                	jne    c010298f <default_init_memmap+0x30>
c010296b:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0102972:	c0 
c0102973:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010297a:	c0 
c010297b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102982:	00 
c0102983:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010298a:	e8 4c e3 ff ff       	call   c0100cdb <__panic>
    struct Page *p = base;
c010298f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102992:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    //在查找可用内存并分配struct Page数组时，就已经将全部Page设置为 reserved
    for (; p != base + n; p ++) {
c0102995:	e9 97 00 00 00       	jmp    c0102a31 <default_init_memmap+0xd2>
        // 判断这个页是不是被内核保留的
        assert(PageReserved(p));
c010299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299d:	83 c0 04             	add    $0x4,%eax
c01029a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01029a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029b0:	0f a3 10             	bt     %edx,(%eax)
c01029b3:	19 c0                	sbb    %eax,%eax
c01029b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01029b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029bc:	0f 95 c0             	setne  %al
c01029bf:	0f b6 c0             	movzbl %al,%eax
c01029c2:	85 c0                	test   %eax,%eax
c01029c4:	75 24                	jne    c01029ea <default_init_memmap+0x8b>
c01029c6:	c7 44 24 0c 41 67 10 	movl   $0xc0106741,0xc(%esp)
c01029cd:	c0 
c01029ce:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01029d5:	c0 
c01029d6:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c01029dd:	00 
c01029de:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01029e5:	e8 f1 e2 ff ff       	call   c0100cdb <__panic>
        
        //将Page标记为可用的：ref设为0,清除reserved，设置PG_reserved，并把property设置为0（不是空闲块的第一个物理页）
        p->flags = p->property = 0;
c01029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f7:	8b 50 08             	mov    0x8(%eax),%edx
c01029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029fd:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102a00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a07:	00 
c0102a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a0b:	89 04 24             	mov    %eax,(%esp)
c0102a0e:	e8 0d ff ff ff       	call   c0102920 <set_page_ref>

        SetPageProperty(base);
c0102a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a16:	83 c0 04             	add    $0x4,%eax
c0102a19:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a29:	0f ab 10             	bts    %edx,(%eax)
}
c0102a2c:	90                   	nop
    for (; p != base + n; p ++) {
c0102a2d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a31:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a34:	89 d0                	mov    %edx,%eax
c0102a36:	c1 e0 02             	shl    $0x2,%eax
c0102a39:	01 d0                	add    %edx,%eax
c0102a3b:	c1 e0 02             	shl    $0x2,%eax
c0102a3e:	89 c2                	mov    %eax,%edx
c0102a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a43:	01 d0                	add    %edx,%eax
c0102a45:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102a48:	0f 85 4c ff ff ff    	jne    c010299a <default_init_memmap+0x3b>
    }
    //空闲页块第一个物理页要设置数量，在此处，property设置为n
    base->property = n;
c0102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a54:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    
    //更新空闲块的总和
    nr_free += n;
c0102a57:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a60:	01 d0                	add    %edx,%eax
c0102a62:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    
    // 初始化玩每个空闲页后，将其要插入到链表每次都插入到节点前面，因为是按地址排序
    //即p->page_link将这个页面链接到free_list
    list_add_before(&free_list, &(base->page_link));
c0102a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6a:	83 c0 0c             	add    $0xc,%eax
c0102a6d:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
c0102a74:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a7a:	8b 00                	mov    (%eax),%eax
c0102a7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a7f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a82:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a88:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a8e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a91:	89 10                	mov    %edx,(%eax)
c0102a93:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a96:	8b 10                	mov    (%eax),%edx
c0102a98:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102aa1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102aa4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102aaa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102aad:	89 10                	mov    %edx,(%eax)
}
c0102aaf:	90                   	nop
}
c0102ab0:	90                   	nop
}
c0102ab1:	90                   	nop
c0102ab2:	89 ec                	mov    %ebp,%esp
c0102ab4:	5d                   	pop    %ebp
c0102ab5:	c3                   	ret    

c0102ab6 <default_alloc_pages>:


// 分配n个页块
static struct Page *
default_alloc_pages(size_t n) {
c0102ab6:	55                   	push   %ebp
c0102ab7:	89 e5                	mov    %esp,%ebp
c0102ab9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102abc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102ac0:	75 24                	jne    c0102ae6 <default_alloc_pages+0x30>
c0102ac2:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0102ac9:	c0 
c0102aca:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102ad1:	c0 
c0102ad2:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
c0102ad9:	00 
c0102ada:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102ae1:	e8 f5 e1 ff ff       	call   c0100cdb <__panic>
    
    //如果请求的内存大小大于空闲块的大小，返回NULL
    if (n > nr_free) {
c0102ae6:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102aeb:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102aee:	76 0a                	jbe    c0102afa <default_alloc_pages+0x44>
        return NULL;
c0102af0:	b8 00 00 00 00       	mov    $0x0,%eax
c0102af5:	e9 70 01 00 00       	jmp    c0102c6a <default_alloc_pages+0x1b4>
    }
    
    struct Page *page = NULL;
c0102afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    
    //遍历空闲列表
    list_entry_t *le = &free_list;
c0102b01:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    // TODO: optimize (next-fit)
    
    // 查找 n 个或以上空闲页块 ，若找到则判断是否大过 n，则将其拆分 并将拆分后的剩下的空闲页块加回到链表中
    while ((le = list_next(le)) != &free_list) {
c0102b08:	eb 1c                	jmp    c0102b26 <default_alloc_pages+0x70>
        // 此处 le2page 就是将 le 的地址 - page_link 在 Page 的偏移 从而找到 Page 的地址
        // 获取page并检查p->property（记录这个块中空闲物理页的数量）是否 >= n
        struct Page *p = le2page(le, page_link);
c0102b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b0d:	83 e8 0c             	sub    $0xc,%eax
c0102b10:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        //如果找到满足大小的空闲块，则跳出循环
        if (p->property >= n) {
c0102b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b16:	8b 40 08             	mov    0x8(%eax),%eax
c0102b19:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b1c:	77 08                	ja     c0102b26 <default_alloc_pages+0x70>
            page = p;
c0102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b24:	eb 18                	jmp    c0102b3e <default_alloc_pages+0x88>
c0102b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b2f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b35:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102b3c:	75 cc                	jne    c0102b0a <default_alloc_pages+0x54>
        }
    }
    
    //找到满足大小（>=n)的空闲块后，被分配的物理页flags应该被设置为PG_reserved =1，PG_property =0,然后将这些页面从free_list中移除
    if (page != NULL) {
c0102b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b42:	0f 84 1f 01 00 00    	je     c0102c67 <default_alloc_pages+0x1b1>
  
        list_del(&(page->page_link));
c0102b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b4b:	83 c0 0c             	add    $0xc,%eax
c0102b4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b54:	8b 40 04             	mov    0x4(%eax),%eax
c0102b57:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b5a:	8b 12                	mov    (%edx),%edx
c0102b5c:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b65:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b68:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b71:	89 10                	mov    %edx,(%eax)
}
c0102b73:	90                   	nop
}
c0102b74:	90                   	nop
        
        //如果p->property >n，应该重新计算这个空闲块剩下的空闲物理页的数量
        if (page->property > n) {
c0102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b78:	8b 40 08             	mov    0x8(%eax),%eax
c0102b7b:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102b7e:	0f 83 8f 00 00 00    	jae    c0102c13 <default_alloc_pages+0x15d>
        
           //获得分裂出来的新的小空闲块的第一个页的描述信息
            struct Page *p = page + n;
c0102b84:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b87:	89 d0                	mov    %edx,%eax
c0102b89:	c1 e0 02             	shl    $0x2,%eax
c0102b8c:	01 d0                	add    %edx,%eax
c0102b8e:	c1 e0 02             	shl    $0x2,%eax
c0102b91:	89 c2                	mov    %eax,%edx
c0102b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b96:	01 d0                	add    %edx,%eax
c0102b98:	89 45 e8             	mov    %eax,-0x18(%ebp)
            
            //更新新的空闲块的大小信息
            p->property = page->property - n;
c0102b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba1:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ba4:	89 c2                	mov    %eax,%edx
c0102ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ba9:	89 50 08             	mov    %edx,0x8(%eax)
            //property被值为1,表明是空闲的
            SetPageProperty(p);
c0102bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102baf:	83 c0 04             	add    $0x4,%eax
c0102bb2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102bb9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bbc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bbf:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102bc2:	0f ab 10             	bts    %edx,(%eax)
}
c0102bc5:	90                   	nop
            
            //将新空闲块插入空闲块列表后
            list_add_after(&(page->page_link), &(p->page_link));
c0102bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bc9:	83 c0 0c             	add    $0xc,%eax
c0102bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102bcf:	83 c2 0c             	add    $0xc,%edx
c0102bd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102bd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bdb:	8b 40 04             	mov    0x4(%eax),%eax
c0102bde:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102be1:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102be4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102be7:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102bea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next->prev = elm;
c0102bed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bf0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102bf3:	89 10                	mov    %edx,(%eax)
c0102bf5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bf8:	8b 10                	mov    (%eax),%edx
c0102bfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102bfd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c00:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c03:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c06:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c09:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c0f:	89 10                	mov    %edx,(%eax)
}
c0102c11:	90                   	nop
}
c0102c12:	90                   	nop
        }
        
        // 在空闲页链表中删除掉原来的空闲页
        list_del(&(page->page_link));
c0102c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c16:	83 c0 0c             	add    $0xc,%eax
c0102c19:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102c1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c1f:	8b 40 04             	mov    0x4(%eax),%eax
c0102c22:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c25:	8b 12                	mov    (%edx),%edx
c0102c27:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102c2a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102c2d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102c30:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102c33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c36:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c39:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102c3c:	89 10                	mov    %edx,(%eax)
}
c0102c3e:	90                   	nop
}
c0102c3f:	90                   	nop
        
        //重新计算nr_free（更新所有空闲块的空闲部分的数量）
        nr_free -= n;
c0102c40:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102c45:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c48:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        //将分配出去的内存页标记为非空闲
        ClearPageProperty(page);
c0102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c50:	83 c0 04             	add    $0x4,%eax
c0102c53:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102c5a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c5d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c60:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c63:	0f b3 10             	btr    %edx,(%eax)
}
c0102c66:	90                   	nop
    }
    return page;
c0102c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c6a:	89 ec                	mov    %ebp,%esp
c0102c6c:	5d                   	pop    %ebp
c0102c6d:	c3                   	ret    

c0102c6e <default_free_pages>:


// 释放掉 n 个 页块
static void
default_free_pages(struct Page *base, size_t n) {
c0102c6e:	55                   	push   %ebp
c0102c6f:	89 e5                	mov    %esp,%ebp
c0102c71:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102c77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c7b:	75 24                	jne    c0102ca1 <default_free_pages+0x33>
c0102c7d:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0102c84:	c0 
c0102c85:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102c8c:	c0 
c0102c8d:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102c94:	00 
c0102c95:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102c9c:	e8 3a e0 ff ff       	call   c0100cdb <__panic>
    struct Page *p = base;
c0102ca1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    for (; p != base + n; p ++) {
c0102ca7:	e9 9d 00 00 00       	jmp    c0102d49 <default_free_pages+0xdb>
        //进行检查
        assert(!PageReserved(p) && !PageProperty(p));
c0102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102caf:	83 c0 04             	add    $0x4,%eax
c0102cb2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102cb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102cc2:	0f a3 10             	bt     %edx,(%eax)
c0102cc5:	19 c0                	sbb    %eax,%eax
c0102cc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102cca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102cce:	0f 95 c0             	setne  %al
c0102cd1:	0f b6 c0             	movzbl %al,%eax
c0102cd4:	85 c0                	test   %eax,%eax
c0102cd6:	75 2c                	jne    c0102d04 <default_free_pages+0x96>
c0102cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cdb:	83 c0 04             	add    $0x4,%eax
c0102cde:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102ce5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102ce8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ceb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cee:	0f a3 10             	bt     %edx,(%eax)
c0102cf1:	19 c0                	sbb    %eax,%eax
c0102cf3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102cf6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102cfa:	0f 95 c0             	setne  %al
c0102cfd:	0f b6 c0             	movzbl %al,%eax
c0102d00:	85 c0                	test   %eax,%eax
c0102d02:	74 24                	je     c0102d28 <default_free_pages+0xba>
c0102d04:	c7 44 24 0c 54 67 10 	movl   $0xc0106754,0xc(%esp)
c0102d0b:	c0 
c0102d0c:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102d13:	c0 
c0102d14:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0102d1b:	00 
c0102d1c:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102d23:	e8 b3 df ff ff       	call   c0100cdb <__panic>
        //重置物理页的属性
        p->flags = 0;
c0102d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        //清空引用计数
        set_page_ref(p, 0);
c0102d32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d39:	00 
c0102d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d3d:	89 04 24             	mov    %eax,(%esp)
c0102d40:	e8 db fb ff ff       	call   c0102920 <set_page_ref>
    for (; p != base + n; p ++) {
c0102d45:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102d49:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d4c:	89 d0                	mov    %edx,%eax
c0102d4e:	c1 e0 02             	shl    $0x2,%eax
c0102d51:	01 d0                	add    %edx,%eax
c0102d53:	c1 e0 02             	shl    $0x2,%eax
c0102d56:	89 c2                	mov    %eax,%edx
c0102d58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5b:	01 d0                	add    %edx,%eax
c0102d5d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102d60:	0f 85 46 ff ff ff    	jne    c0102cac <default_free_pages+0x3e>
    }
    
    //设置空闲块的的大小
    base->property = n;
c0102d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d69:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d6c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d72:	83 c0 04             	add    $0x4,%eax
c0102d75:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102d7c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d82:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d85:	0f ab 10             	bts    %edx,(%eax)
}
c0102d88:	90                   	nop
c0102d89:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102d90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d93:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 合并到合适的页块中，并将合并好的合适的页块添加回空闲页块链表
    //迭代空闲链表中的每一个节点
    while (le != &free_list) {
c0102d99:	e9 2d 01 00 00       	jmp    c0102ecb <default_free_pages+0x25d>
        //获取节点对应的Page结构
        p = le2page(le, page_link);
c0102d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102da1:	83 e8 0c             	sub    $0xc,%eax
c0102da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        
        // TODO: optimize
        //尾部正好能和下一个连上，则合并
        if (base + base->property == p) {
c0102da7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102daa:	8b 50 08             	mov    0x8(%eax),%edx
c0102dad:	89 d0                	mov    %edx,%eax
c0102daf:	c1 e0 02             	shl    $0x2,%eax
c0102db2:	01 d0                	add    %edx,%eax
c0102db4:	c1 e0 02             	shl    $0x2,%eax
c0102db7:	89 c2                	mov    %eax,%edx
c0102db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dbc:	01 d0                	add    %edx,%eax
c0102dbe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102dc1:	75 5f                	jne    c0102e22 <default_free_pages+0x1b4>
            base->property += p->property;
c0102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc6:	8b 50 08             	mov    0x8(%eax),%edx
c0102dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dcc:	8b 40 08             	mov    0x8(%eax),%eax
c0102dcf:	01 c2                	add    %eax,%edx
c0102dd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dd4:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dda:	83 c0 04             	add    $0x4,%eax
c0102ddd:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0102de4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102de7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dea:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ded:	0f b3 10             	btr    %edx,(%eax)
}
c0102df0:	90                   	nop
            list_del(&(p->page_link));
c0102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df4:	83 c0 0c             	add    $0xc,%eax
c0102df7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102dfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102dfd:	8b 40 04             	mov    0x4(%eax),%eax
c0102e00:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102e03:	8b 12                	mov    (%edx),%edx
c0102e05:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102e08:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next;
c0102e0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e0e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102e11:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e14:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102e17:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102e1a:	89 10                	mov    %edx,(%eax)
}
c0102e1c:	90                   	nop
}
c0102e1d:	e9 9a 00 00 00       	jmp    c0102ebc <default_free_pages+0x24e>
        }
        //头部正好和上一个连上，则合并
        else if (p + p->property == base) {
c0102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e25:	8b 50 08             	mov    0x8(%eax),%edx
c0102e28:	89 d0                	mov    %edx,%eax
c0102e2a:	c1 e0 02             	shl    $0x2,%eax
c0102e2d:	01 d0                	add    %edx,%eax
c0102e2f:	c1 e0 02             	shl    $0x2,%eax
c0102e32:	89 c2                	mov    %eax,%edx
c0102e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e37:	01 d0                	add    %edx,%eax
c0102e39:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102e3c:	75 62                	jne    c0102ea0 <default_free_pages+0x232>
            p->property += base->property;
c0102e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e41:	8b 50 08             	mov    0x8(%eax),%edx
c0102e44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e47:	8b 40 08             	mov    0x8(%eax),%eax
c0102e4a:	01 c2                	add    %eax,%edx
c0102e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e4f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e52:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e55:	83 c0 04             	add    $0x4,%eax
c0102e58:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0102e5f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e65:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e68:	0f b3 10             	btr    %edx,(%eax)
}
c0102e6b:	90                   	nop
            base = p;
c0102e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e75:	83 c0 0c             	add    $0xc,%eax
c0102e78:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102e7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e7e:	8b 40 04             	mov    0x4(%eax),%eax
c0102e81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e84:	8b 12                	mov    (%edx),%edx
c0102e86:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102e89:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next;
c0102e8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e8f:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e92:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e95:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e98:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e9b:	89 10                	mov    %edx,(%eax)
}
c0102e9d:	90                   	nop
}
c0102e9e:	eb 1c                	jmp    c0102ebc <default_free_pages+0x24e>
        }
        
        else if (base + base->property < p)
c0102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ea3:	8b 50 08             	mov    0x8(%eax),%edx
c0102ea6:	89 d0                	mov    %edx,%eax
c0102ea8:	c1 e0 02             	shl    $0x2,%eax
c0102eab:	01 d0                	add    %edx,%eax
c0102ead:	c1 e0 02             	shl    $0x2,%eax
c0102eb0:	89 c2                	mov    %eax,%edx
c0102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eb5:	01 d0                	add    %edx,%eax
c0102eb7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102eba:	77 1e                	ja     c0102eda <default_free_pages+0x26c>
c0102ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ebf:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0102ec2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ec5:	8b 40 04             	mov    0x4(%eax),%eax
        {
            break;
        }
        le = list_next(le);
c0102ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102ecb:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102ed2:	0f 85 c6 fe ff ff    	jne    c0102d9e <default_free_pages+0x130>
c0102ed8:	eb 01                	jmp    c0102edb <default_free_pages+0x26d>
            break;
c0102eda:	90                   	nop
    }
 
    //将空闲块插入到链表中
    list_add_before(le, &(base->page_link));
c0102edb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ede:	8d 50 0c             	lea    0xc(%eax),%edx
c0102ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ee4:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0102ee7:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102eea:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102eed:	8b 00                	mov    (%eax),%eax
c0102eef:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102ef2:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0102ef5:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102ef8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102efb:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
c0102efe:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f01:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102f04:	89 10                	mov    %edx,(%eax)
c0102f06:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f09:	8b 10                	mov    (%eax),%edx
c0102f0b:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f0e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102f11:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f14:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102f17:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f1a:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f1d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f20:	89 10                	mov    %edx,(%eax)
}
c0102f22:	90                   	nop
}
c0102f23:	90                   	nop
 
    //更新空间物理页总量
    nr_free += n;
c0102f24:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f2d:	01 d0                	add    %edx,%eax
c0102f2f:	a3 88 be 11 c0       	mov    %eax,0xc011be88
}
c0102f34:	90                   	nop
c0102f35:	89 ec                	mov    %ebp,%esp
c0102f37:	5d                   	pop    %ebp
c0102f38:	c3                   	ret    

c0102f39 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102f39:	55                   	push   %ebp
c0102f3a:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102f3c:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0102f41:	5d                   	pop    %ebp
c0102f42:	c3                   	ret    

c0102f43 <basic_check>:

static void
basic_check(void) {
c0102f43:	55                   	push   %ebp
c0102f44:	89 e5                	mov    %esp,%ebp
c0102f46:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102f49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f59:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102f5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f63:	e8 af 0e 00 00       	call   c0103e17 <alloc_pages>
c0102f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f6f:	75 24                	jne    c0102f95 <basic_check+0x52>
c0102f71:	c7 44 24 0c 79 67 10 	movl   $0xc0106779,0xc(%esp)
c0102f78:	c0 
c0102f79:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102f80:	c0 
c0102f81:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0102f88:	00 
c0102f89:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102f90:	e8 46 dd ff ff       	call   c0100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f9c:	e8 76 0e 00 00       	call   c0103e17 <alloc_pages>
c0102fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102fa8:	75 24                	jne    c0102fce <basic_check+0x8b>
c0102faa:	c7 44 24 0c 95 67 10 	movl   $0xc0106795,0xc(%esp)
c0102fb1:	c0 
c0102fb2:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102fb9:	c0 
c0102fba:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0102fc1:	00 
c0102fc2:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0102fc9:	e8 0d dd ff ff       	call   c0100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102fce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fd5:	e8 3d 0e 00 00       	call   c0103e17 <alloc_pages>
c0102fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102fe1:	75 24                	jne    c0103007 <basic_check+0xc4>
c0102fe3:	c7 44 24 0c b1 67 10 	movl   $0xc01067b1,0xc(%esp)
c0102fea:	c0 
c0102feb:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0102ff2:	c0 
c0102ff3:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0102ffa:	00 
c0102ffb:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103002:	e8 d4 dc ff ff       	call   c0100cdb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103007:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010300a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010300d:	74 10                	je     c010301f <basic_check+0xdc>
c010300f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103012:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103015:	74 08                	je     c010301f <basic_check+0xdc>
c0103017:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010301a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010301d:	75 24                	jne    c0103043 <basic_check+0x100>
c010301f:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c0103026:	c0 
c0103027:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010302e:	c0 
c010302f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103036:	00 
c0103037:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010303e:	e8 98 dc ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103043:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103046:	89 04 24             	mov    %eax,(%esp)
c0103049:	e8 c8 f8 ff ff       	call   c0102916 <page_ref>
c010304e:	85 c0                	test   %eax,%eax
c0103050:	75 1e                	jne    c0103070 <basic_check+0x12d>
c0103052:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103055:	89 04 24             	mov    %eax,(%esp)
c0103058:	e8 b9 f8 ff ff       	call   c0102916 <page_ref>
c010305d:	85 c0                	test   %eax,%eax
c010305f:	75 0f                	jne    c0103070 <basic_check+0x12d>
c0103061:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103064:	89 04 24             	mov    %eax,(%esp)
c0103067:	e8 aa f8 ff ff       	call   c0102916 <page_ref>
c010306c:	85 c0                	test   %eax,%eax
c010306e:	74 24                	je     c0103094 <basic_check+0x151>
c0103070:	c7 44 24 0c f4 67 10 	movl   $0xc01067f4,0xc(%esp)
c0103077:	c0 
c0103078:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010307f:	c0 
c0103080:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0103087:	00 
c0103088:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010308f:	e8 47 dc ff ff       	call   c0100cdb <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103094:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103097:	89 04 24             	mov    %eax,(%esp)
c010309a:	e8 5f f8 ff ff       	call   c01028fe <page2pa>
c010309f:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01030a5:	c1 e2 0c             	shl    $0xc,%edx
c01030a8:	39 d0                	cmp    %edx,%eax
c01030aa:	72 24                	jb     c01030d0 <basic_check+0x18d>
c01030ac:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c01030b3:	c0 
c01030b4:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01030bb:	c0 
c01030bc:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01030c3:	00 
c01030c4:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01030cb:	e8 0b dc ff ff       	call   c0100cdb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01030d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030d3:	89 04 24             	mov    %eax,(%esp)
c01030d6:	e8 23 f8 ff ff       	call   c01028fe <page2pa>
c01030db:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01030e1:	c1 e2 0c             	shl    $0xc,%edx
c01030e4:	39 d0                	cmp    %edx,%eax
c01030e6:	72 24                	jb     c010310c <basic_check+0x1c9>
c01030e8:	c7 44 24 0c 4d 68 10 	movl   $0xc010684d,0xc(%esp)
c01030ef:	c0 
c01030f0:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01030f7:	c0 
c01030f8:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c01030ff:	00 
c0103100:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103107:	e8 cf db ff ff       	call   c0100cdb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010310f:	89 04 24             	mov    %eax,(%esp)
c0103112:	e8 e7 f7 ff ff       	call   c01028fe <page2pa>
c0103117:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c010311d:	c1 e2 0c             	shl    $0xc,%edx
c0103120:	39 d0                	cmp    %edx,%eax
c0103122:	72 24                	jb     c0103148 <basic_check+0x205>
c0103124:	c7 44 24 0c 6a 68 10 	movl   $0xc010686a,0xc(%esp)
c010312b:	c0 
c010312c:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103133:	c0 
c0103134:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c010313b:	00 
c010313c:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103143:	e8 93 db ff ff       	call   c0100cdb <__panic>

    list_entry_t free_list_store = free_list;
c0103148:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010314d:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103153:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103156:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103159:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0103160:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103163:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103166:	89 50 04             	mov    %edx,0x4(%eax)
c0103169:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010316c:	8b 50 04             	mov    0x4(%eax),%edx
c010316f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103172:	89 10                	mov    %edx,(%eax)
}
c0103174:	90                   	nop
c0103175:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c010317c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010317f:	8b 40 04             	mov    0x4(%eax),%eax
c0103182:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103185:	0f 94 c0             	sete   %al
c0103188:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010318b:	85 c0                	test   %eax,%eax
c010318d:	75 24                	jne    c01031b3 <basic_check+0x270>
c010318f:	c7 44 24 0c 87 68 10 	movl   $0xc0106887,0xc(%esp)
c0103196:	c0 
c0103197:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010319e:	c0 
c010319f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01031a6:	00 
c01031a7:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01031ae:	e8 28 db ff ff       	call   c0100cdb <__panic>

    unsigned int nr_free_store = nr_free;
c01031b3:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01031b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01031bb:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01031c2:	00 00 00 

    assert(alloc_page() == NULL);
c01031c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031cc:	e8 46 0c 00 00       	call   c0103e17 <alloc_pages>
c01031d1:	85 c0                	test   %eax,%eax
c01031d3:	74 24                	je     c01031f9 <basic_check+0x2b6>
c01031d5:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c01031dc:	c0 
c01031dd:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01031e4:	c0 
c01031e5:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01031ec:	00 
c01031ed:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01031f4:	e8 e2 da ff ff       	call   c0100cdb <__panic>

    free_page(p0);
c01031f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103200:	00 
c0103201:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103204:	89 04 24             	mov    %eax,(%esp)
c0103207:	e8 45 0c 00 00       	call   c0103e51 <free_pages>
    free_page(p1);
c010320c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103213:	00 
c0103214:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103217:	89 04 24             	mov    %eax,(%esp)
c010321a:	e8 32 0c 00 00       	call   c0103e51 <free_pages>
    free_page(p2);
c010321f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103226:	00 
c0103227:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010322a:	89 04 24             	mov    %eax,(%esp)
c010322d:	e8 1f 0c 00 00       	call   c0103e51 <free_pages>
    assert(nr_free == 3);
c0103232:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103237:	83 f8 03             	cmp    $0x3,%eax
c010323a:	74 24                	je     c0103260 <basic_check+0x31d>
c010323c:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c0103243:	c0 
c0103244:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010324b:	c0 
c010324c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0103253:	00 
c0103254:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010325b:	e8 7b da ff ff       	call   c0100cdb <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103267:	e8 ab 0b 00 00       	call   c0103e17 <alloc_pages>
c010326c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010326f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103273:	75 24                	jne    c0103299 <basic_check+0x356>
c0103275:	c7 44 24 0c 79 67 10 	movl   $0xc0106779,0xc(%esp)
c010327c:	c0 
c010327d:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103284:	c0 
c0103285:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c010328c:	00 
c010328d:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103294:	e8 42 da ff ff       	call   c0100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103299:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032a0:	e8 72 0b 00 00       	call   c0103e17 <alloc_pages>
c01032a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032ac:	75 24                	jne    c01032d2 <basic_check+0x38f>
c01032ae:	c7 44 24 0c 95 67 10 	movl   $0xc0106795,0xc(%esp)
c01032b5:	c0 
c01032b6:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01032bd:	c0 
c01032be:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01032c5:	00 
c01032c6:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01032cd:	e8 09 da ff ff       	call   c0100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
c01032d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032d9:	e8 39 0b 00 00       	call   c0103e17 <alloc_pages>
c01032de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032e5:	75 24                	jne    c010330b <basic_check+0x3c8>
c01032e7:	c7 44 24 0c b1 67 10 	movl   $0xc01067b1,0xc(%esp)
c01032ee:	c0 
c01032ef:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01032f6:	c0 
c01032f7:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01032fe:	00 
c01032ff:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103306:	e8 d0 d9 ff ff       	call   c0100cdb <__panic>

    assert(alloc_page() == NULL);
c010330b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103312:	e8 00 0b 00 00       	call   c0103e17 <alloc_pages>
c0103317:	85 c0                	test   %eax,%eax
c0103319:	74 24                	je     c010333f <basic_check+0x3fc>
c010331b:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c0103322:	c0 
c0103323:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010332a:	c0 
c010332b:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c0103332:	00 
c0103333:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010333a:	e8 9c d9 ff ff       	call   c0100cdb <__panic>

    free_page(p0);
c010333f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103346:	00 
c0103347:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010334a:	89 04 24             	mov    %eax,(%esp)
c010334d:	e8 ff 0a 00 00       	call   c0103e51 <free_pages>
c0103352:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c0103359:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010335c:	8b 40 04             	mov    0x4(%eax),%eax
c010335f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103362:	0f 94 c0             	sete   %al
c0103365:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103368:	85 c0                	test   %eax,%eax
c010336a:	74 24                	je     c0103390 <basic_check+0x44d>
c010336c:	c7 44 24 0c c0 68 10 	movl   $0xc01068c0,0xc(%esp)
c0103373:	c0 
c0103374:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010337b:	c0 
c010337c:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103383:	00 
c0103384:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010338b:	e8 4b d9 ff ff       	call   c0100cdb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103390:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103397:	e8 7b 0a 00 00       	call   c0103e17 <alloc_pages>
c010339c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01033a5:	74 24                	je     c01033cb <basic_check+0x488>
c01033a7:	c7 44 24 0c d8 68 10 	movl   $0xc01068d8,0xc(%esp)
c01033ae:	c0 
c01033af:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01033b6:	c0 
c01033b7:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01033be:	00 
c01033bf:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01033c6:	e8 10 d9 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c01033cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033d2:	e8 40 0a 00 00       	call   c0103e17 <alloc_pages>
c01033d7:	85 c0                	test   %eax,%eax
c01033d9:	74 24                	je     c01033ff <basic_check+0x4bc>
c01033db:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c01033e2:	c0 
c01033e3:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01033ea:	c0 
c01033eb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01033f2:	00 
c01033f3:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01033fa:	e8 dc d8 ff ff       	call   c0100cdb <__panic>

    assert(nr_free == 0);
c01033ff:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103404:	85 c0                	test   %eax,%eax
c0103406:	74 24                	je     c010342c <basic_check+0x4e9>
c0103408:	c7 44 24 0c f1 68 10 	movl   $0xc01068f1,0xc(%esp)
c010340f:	c0 
c0103410:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103417:	c0 
c0103418:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c010341f:	00 
c0103420:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103427:	e8 af d8 ff ff       	call   c0100cdb <__panic>
    free_list = free_list_store;
c010342c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010342f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103432:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103437:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c010343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103440:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c0103445:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010344c:	00 
c010344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103450:	89 04 24             	mov    %eax,(%esp)
c0103453:	e8 f9 09 00 00       	call   c0103e51 <free_pages>
    free_page(p1);
c0103458:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010345f:	00 
c0103460:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103463:	89 04 24             	mov    %eax,(%esp)
c0103466:	e8 e6 09 00 00       	call   c0103e51 <free_pages>
    free_page(p2);
c010346b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103472:	00 
c0103473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103476:	89 04 24             	mov    %eax,(%esp)
c0103479:	e8 d3 09 00 00       	call   c0103e51 <free_pages>
}
c010347e:	90                   	nop
c010347f:	89 ec                	mov    %ebp,%esp
c0103481:	5d                   	pop    %ebp
c0103482:	c3                   	ret    

c0103483 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103483:	55                   	push   %ebp
c0103484:	89 e5                	mov    %esp,%ebp
c0103486:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c010348c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103493:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010349a:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01034a1:	eb 6a                	jmp    c010350d <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c01034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034a6:	83 e8 0c             	sub    $0xc,%eax
c01034a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c01034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01034af:	83 c0 04             	add    $0x4,%eax
c01034b2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01034b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034c2:	0f a3 10             	bt     %edx,(%eax)
c01034c5:	19 c0                	sbb    %eax,%eax
c01034c7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01034ca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01034ce:	0f 95 c0             	setne  %al
c01034d1:	0f b6 c0             	movzbl %al,%eax
c01034d4:	85 c0                	test   %eax,%eax
c01034d6:	75 24                	jne    c01034fc <default_check+0x79>
c01034d8:	c7 44 24 0c fe 68 10 	movl   $0xc01068fe,0xc(%esp)
c01034df:	c0 
c01034e0:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01034e7:	c0 
c01034e8:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c01034ef:	00 
c01034f0:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01034f7:	e8 df d7 ff ff       	call   c0100cdb <__panic>
        count ++, total += p->property;
c01034fc:	ff 45 f4             	incl   -0xc(%ebp)
c01034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103502:	8b 50 08             	mov    0x8(%eax),%edx
c0103505:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103508:	01 d0                	add    %edx,%eax
c010350a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103510:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0103513:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103516:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103519:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010351c:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103523:	0f 85 7a ff ff ff    	jne    c01034a3 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0103529:	e8 58 09 00 00       	call   c0103e86 <nr_free_pages>
c010352e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103531:	39 d0                	cmp    %edx,%eax
c0103533:	74 24                	je     c0103559 <default_check+0xd6>
c0103535:	c7 44 24 0c 0e 69 10 	movl   $0xc010690e,0xc(%esp)
c010353c:	c0 
c010353d:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103544:	c0 
c0103545:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c010354c:	00 
c010354d:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103554:	e8 82 d7 ff ff       	call   c0100cdb <__panic>

    basic_check();
c0103559:	e8 e5 f9 ff ff       	call   c0102f43 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010355e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103565:	e8 ad 08 00 00       	call   c0103e17 <alloc_pages>
c010356a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c010356d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103571:	75 24                	jne    c0103597 <default_check+0x114>
c0103573:	c7 44 24 0c 27 69 10 	movl   $0xc0106927,0xc(%esp)
c010357a:	c0 
c010357b:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103582:	c0 
c0103583:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c010358a:	00 
c010358b:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103592:	e8 44 d7 ff ff       	call   c0100cdb <__panic>
    assert(!PageProperty(p0));
c0103597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010359a:	83 c0 04             	add    $0x4,%eax
c010359d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01035a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01035aa:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01035ad:	0f a3 10             	bt     %edx,(%eax)
c01035b0:	19 c0                	sbb    %eax,%eax
c01035b2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01035b5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01035b9:	0f 95 c0             	setne  %al
c01035bc:	0f b6 c0             	movzbl %al,%eax
c01035bf:	85 c0                	test   %eax,%eax
c01035c1:	74 24                	je     c01035e7 <default_check+0x164>
c01035c3:	c7 44 24 0c 32 69 10 	movl   $0xc0106932,0xc(%esp)
c01035ca:	c0 
c01035cb:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01035d2:	c0 
c01035d3:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
c01035da:	00 
c01035db:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01035e2:	e8 f4 d6 ff ff       	call   c0100cdb <__panic>

    list_entry_t free_list_store = free_list;
c01035e7:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c01035ec:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c01035f2:	89 45 80             	mov    %eax,-0x80(%ebp)
c01035f5:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01035f8:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01035ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103602:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103605:	89 50 04             	mov    %edx,0x4(%eax)
c0103608:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010360b:	8b 50 04             	mov    0x4(%eax),%edx
c010360e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103611:	89 10                	mov    %edx,(%eax)
}
c0103613:	90                   	nop
c0103614:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c010361b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010361e:	8b 40 04             	mov    0x4(%eax),%eax
c0103621:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0103624:	0f 94 c0             	sete   %al
c0103627:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010362a:	85 c0                	test   %eax,%eax
c010362c:	75 24                	jne    c0103652 <default_check+0x1cf>
c010362e:	c7 44 24 0c 87 68 10 	movl   $0xc0106887,0xc(%esp)
c0103635:	c0 
c0103636:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010363d:	c0 
c010363e:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c0103645:	00 
c0103646:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010364d:	e8 89 d6 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c0103652:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103659:	e8 b9 07 00 00       	call   c0103e17 <alloc_pages>
c010365e:	85 c0                	test   %eax,%eax
c0103660:	74 24                	je     c0103686 <default_check+0x203>
c0103662:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c0103669:	c0 
c010366a:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103671:	c0 
c0103672:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
c0103679:	00 
c010367a:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103681:	e8 55 d6 ff ff       	call   c0100cdb <__panic>

    unsigned int nr_free_store = nr_free;
c0103686:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c010368b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c010368e:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0103695:	00 00 00 

    free_pages(p0 + 2, 3);
c0103698:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010369b:	83 c0 28             	add    $0x28,%eax
c010369e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036a5:	00 
c01036a6:	89 04 24             	mov    %eax,(%esp)
c01036a9:	e8 a3 07 00 00       	call   c0103e51 <free_pages>
    assert(alloc_pages(4) == NULL);
c01036ae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01036b5:	e8 5d 07 00 00       	call   c0103e17 <alloc_pages>
c01036ba:	85 c0                	test   %eax,%eax
c01036bc:	74 24                	je     c01036e2 <default_check+0x25f>
c01036be:	c7 44 24 0c 44 69 10 	movl   $0xc0106944,0xc(%esp)
c01036c5:	c0 
c01036c6:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01036cd:	c0 
c01036ce:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c01036d5:	00 
c01036d6:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01036dd:	e8 f9 d5 ff ff       	call   c0100cdb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01036e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036e5:	83 c0 28             	add    $0x28,%eax
c01036e8:	83 c0 04             	add    $0x4,%eax
c01036eb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01036f2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01036f8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01036fb:	0f a3 10             	bt     %edx,(%eax)
c01036fe:	19 c0                	sbb    %eax,%eax
c0103700:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103703:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103707:	0f 95 c0             	setne  %al
c010370a:	0f b6 c0             	movzbl %al,%eax
c010370d:	85 c0                	test   %eax,%eax
c010370f:	74 0e                	je     c010371f <default_check+0x29c>
c0103711:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103714:	83 c0 28             	add    $0x28,%eax
c0103717:	8b 40 08             	mov    0x8(%eax),%eax
c010371a:	83 f8 03             	cmp    $0x3,%eax
c010371d:	74 24                	je     c0103743 <default_check+0x2c0>
c010371f:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c0103726:	c0 
c0103727:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010372e:	c0 
c010372f:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
c0103736:	00 
c0103737:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010373e:	e8 98 d5 ff ff       	call   c0100cdb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103743:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010374a:	e8 c8 06 00 00       	call   c0103e17 <alloc_pages>
c010374f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103756:	75 24                	jne    c010377c <default_check+0x2f9>
c0103758:	c7 44 24 0c 88 69 10 	movl   $0xc0106988,0xc(%esp)
c010375f:	c0 
c0103760:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103767:	c0 
c0103768:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
c010376f:	00 
c0103770:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103777:	e8 5f d5 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c010377c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103783:	e8 8f 06 00 00       	call   c0103e17 <alloc_pages>
c0103788:	85 c0                	test   %eax,%eax
c010378a:	74 24                	je     c01037b0 <default_check+0x32d>
c010378c:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c0103793:	c0 
c0103794:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010379b:	c0 
c010379c:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
c01037a3:	00 
c01037a4:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01037ab:	e8 2b d5 ff ff       	call   c0100cdb <__panic>
    assert(p0 + 2 == p1);
c01037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037b3:	83 c0 28             	add    $0x28,%eax
c01037b6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01037b9:	74 24                	je     c01037df <default_check+0x35c>
c01037bb:	c7 44 24 0c a6 69 10 	movl   $0xc01069a6,0xc(%esp)
c01037c2:	c0 
c01037c3:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01037ca:	c0 
c01037cb:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c01037d2:	00 
c01037d3:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01037da:	e8 fc d4 ff ff       	call   c0100cdb <__panic>

    p2 = p0 + 1;
c01037df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037e2:	83 c0 14             	add    $0x14,%eax
c01037e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01037e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037ef:	00 
c01037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037f3:	89 04 24             	mov    %eax,(%esp)
c01037f6:	e8 56 06 00 00       	call   c0103e51 <free_pages>
    free_pages(p1, 3);
c01037fb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103802:	00 
c0103803:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103806:	89 04 24             	mov    %eax,(%esp)
c0103809:	e8 43 06 00 00       	call   c0103e51 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010380e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103811:	83 c0 04             	add    $0x4,%eax
c0103814:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010381b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010381e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103821:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103824:	0f a3 10             	bt     %edx,(%eax)
c0103827:	19 c0                	sbb    %eax,%eax
c0103829:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010382c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103830:	0f 95 c0             	setne  %al
c0103833:	0f b6 c0             	movzbl %al,%eax
c0103836:	85 c0                	test   %eax,%eax
c0103838:	74 0b                	je     c0103845 <default_check+0x3c2>
c010383a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010383d:	8b 40 08             	mov    0x8(%eax),%eax
c0103840:	83 f8 01             	cmp    $0x1,%eax
c0103843:	74 24                	je     c0103869 <default_check+0x3e6>
c0103845:	c7 44 24 0c b4 69 10 	movl   $0xc01069b4,0xc(%esp)
c010384c:	c0 
c010384d:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103854:	c0 
c0103855:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
c010385c:	00 
c010385d:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103864:	e8 72 d4 ff ff       	call   c0100cdb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103869:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010386c:	83 c0 04             	add    $0x4,%eax
c010386f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103876:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103879:	8b 45 90             	mov    -0x70(%ebp),%eax
c010387c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010387f:	0f a3 10             	bt     %edx,(%eax)
c0103882:	19 c0                	sbb    %eax,%eax
c0103884:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103887:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010388b:	0f 95 c0             	setne  %al
c010388e:	0f b6 c0             	movzbl %al,%eax
c0103891:	85 c0                	test   %eax,%eax
c0103893:	74 0b                	je     c01038a0 <default_check+0x41d>
c0103895:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103898:	8b 40 08             	mov    0x8(%eax),%eax
c010389b:	83 f8 03             	cmp    $0x3,%eax
c010389e:	74 24                	je     c01038c4 <default_check+0x441>
c01038a0:	c7 44 24 0c dc 69 10 	movl   $0xc01069dc,0xc(%esp)
c01038a7:	c0 
c01038a8:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01038af:	c0 
c01038b0:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
c01038b7:	00 
c01038b8:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01038bf:	e8 17 d4 ff ff       	call   c0100cdb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038cb:	e8 47 05 00 00       	call   c0103e17 <alloc_pages>
c01038d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01038d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038d6:	83 e8 14             	sub    $0x14,%eax
c01038d9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01038dc:	74 24                	je     c0103902 <default_check+0x47f>
c01038de:	c7 44 24 0c 02 6a 10 	movl   $0xc0106a02,0xc(%esp)
c01038e5:	c0 
c01038e6:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01038ed:	c0 
c01038ee:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
c01038f5:	00 
c01038f6:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01038fd:	e8 d9 d3 ff ff       	call   c0100cdb <__panic>
    free_page(p0);
c0103902:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103909:	00 
c010390a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010390d:	89 04 24             	mov    %eax,(%esp)
c0103910:	e8 3c 05 00 00       	call   c0103e51 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103915:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010391c:	e8 f6 04 00 00       	call   c0103e17 <alloc_pages>
c0103921:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103924:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103927:	83 c0 14             	add    $0x14,%eax
c010392a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010392d:	74 24                	je     c0103953 <default_check+0x4d0>
c010392f:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c0103936:	c0 
c0103937:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010393e:	c0 
c010393f:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c0103946:	00 
c0103947:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c010394e:	e8 88 d3 ff ff       	call   c0100cdb <__panic>

    free_pages(p0, 2);
c0103953:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010395a:	00 
c010395b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010395e:	89 04 24             	mov    %eax,(%esp)
c0103961:	e8 eb 04 00 00       	call   c0103e51 <free_pages>
    free_page(p2);
c0103966:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010396d:	00 
c010396e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103971:	89 04 24             	mov    %eax,(%esp)
c0103974:	e8 d8 04 00 00       	call   c0103e51 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103979:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103980:	e8 92 04 00 00       	call   c0103e17 <alloc_pages>
c0103985:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010398c:	75 24                	jne    c01039b2 <default_check+0x52f>
c010398e:	c7 44 24 0c 40 6a 10 	movl   $0xc0106a40,0xc(%esp)
c0103995:	c0 
c0103996:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c010399d:	c0 
c010399e:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
c01039a5:	00 
c01039a6:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01039ad:	e8 29 d3 ff ff       	call   c0100cdb <__panic>
    assert(alloc_page() == NULL);
c01039b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039b9:	e8 59 04 00 00       	call   c0103e17 <alloc_pages>
c01039be:	85 c0                	test   %eax,%eax
c01039c0:	74 24                	je     c01039e6 <default_check+0x563>
c01039c2:	c7 44 24 0c 9e 68 10 	movl   $0xc010689e,0xc(%esp)
c01039c9:	c0 
c01039ca:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01039d1:	c0 
c01039d2:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
c01039d9:	00 
c01039da:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c01039e1:	e8 f5 d2 ff ff       	call   c0100cdb <__panic>

    assert(nr_free == 0);
c01039e6:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01039eb:	85 c0                	test   %eax,%eax
c01039ed:	74 24                	je     c0103a13 <default_check+0x590>
c01039ef:	c7 44 24 0c f1 68 10 	movl   $0xc01068f1,0xc(%esp)
c01039f6:	c0 
c01039f7:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c01039fe:	c0 
c01039ff:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
c0103a06:	00 
c0103a07:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103a0e:	e8 c8 d2 ff ff       	call   c0100cdb <__panic>
    nr_free = nr_free_store;
c0103a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a16:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c0103a1b:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103a1e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103a21:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103a26:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c0103a2c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103a33:	00 
c0103a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103a37:	89 04 24             	mov    %eax,(%esp)
c0103a3a:	e8 12 04 00 00       	call   c0103e51 <free_pages>

    le = &free_list;
c0103a3f:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103a46:	eb 1c                	jmp    c0103a64 <default_check+0x5e1>
        struct Page *p = le2page(le, page_link);
c0103a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a4b:	83 e8 0c             	sub    $0xc,%eax
c0103a4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0103a51:	ff 4d f4             	decl   -0xc(%ebp)
c0103a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103a57:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a5a:	8b 48 08             	mov    0x8(%eax),%ecx
c0103a5d:	89 d0                	mov    %edx,%eax
c0103a5f:	29 c8                	sub    %ecx,%eax
c0103a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a67:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103a6a:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103a6d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103a70:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a73:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103a7a:	75 cc                	jne    c0103a48 <default_check+0x5c5>
    }
    assert(count == 0);
c0103a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a80:	74 24                	je     c0103aa6 <default_check+0x623>
c0103a82:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c0103a89:	c0 
c0103a8a:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103a91:	c0 
c0103a92:	c7 44 24 04 74 01 00 	movl   $0x174,0x4(%esp)
c0103a99:	00 
c0103a9a:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103aa1:	e8 35 d2 ff ff       	call   c0100cdb <__panic>
    assert(total == 0);
c0103aa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103aaa:	74 24                	je     c0103ad0 <default_check+0x64d>
c0103aac:	c7 44 24 0c 69 6a 10 	movl   $0xc0106a69,0xc(%esp)
c0103ab3:	c0 
c0103ab4:	c7 44 24 08 16 67 10 	movl   $0xc0106716,0x8(%esp)
c0103abb:	c0 
c0103abc:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
c0103ac3:	00 
c0103ac4:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0103acb:	e8 0b d2 ff ff       	call   c0100cdb <__panic>
}
c0103ad0:	90                   	nop
c0103ad1:	89 ec                	mov    %ebp,%esp
c0103ad3:	5d                   	pop    %ebp
c0103ad4:	c3                   	ret    

c0103ad5 <page2ppn>:
page2ppn(struct Page *page) {
c0103ad5:	55                   	push   %ebp
c0103ad6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103ad8:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0103ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae1:	29 d0                	sub    %edx,%eax
c0103ae3:	c1 f8 02             	sar    $0x2,%eax
c0103ae6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103aec:	5d                   	pop    %ebp
c0103aed:	c3                   	ret    

c0103aee <page2pa>:
page2pa(struct Page *page) {
c0103aee:	55                   	push   %ebp
c0103aef:	89 e5                	mov    %esp,%ebp
c0103af1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af7:	89 04 24             	mov    %eax,(%esp)
c0103afa:	e8 d6 ff ff ff       	call   c0103ad5 <page2ppn>
c0103aff:	c1 e0 0c             	shl    $0xc,%eax
}
c0103b02:	89 ec                	mov    %ebp,%esp
c0103b04:	5d                   	pop    %ebp
c0103b05:	c3                   	ret    

c0103b06 <pa2page>:
pa2page(uintptr_t pa) {
c0103b06:	55                   	push   %ebp
c0103b07:	89 e5                	mov    %esp,%ebp
c0103b09:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b0f:	c1 e8 0c             	shr    $0xc,%eax
c0103b12:	89 c2                	mov    %eax,%edx
c0103b14:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103b19:	39 c2                	cmp    %eax,%edx
c0103b1b:	72 1c                	jb     c0103b39 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103b1d:	c7 44 24 08 a4 6a 10 	movl   $0xc0106aa4,0x8(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103b2c:	00 
c0103b2d:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103b34:	e8 a2 d1 ff ff       	call   c0100cdb <__panic>
    return &pages[PPN(pa)];
c0103b39:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b42:	c1 e8 0c             	shr    $0xc,%eax
c0103b45:	89 c2                	mov    %eax,%edx
c0103b47:	89 d0                	mov    %edx,%eax
c0103b49:	c1 e0 02             	shl    $0x2,%eax
c0103b4c:	01 d0                	add    %edx,%eax
c0103b4e:	c1 e0 02             	shl    $0x2,%eax
c0103b51:	01 c8                	add    %ecx,%eax
}
c0103b53:	89 ec                	mov    %ebp,%esp
c0103b55:	5d                   	pop    %ebp
c0103b56:	c3                   	ret    

c0103b57 <page2kva>:
page2kva(struct Page *page) {
c0103b57:	55                   	push   %ebp
c0103b58:	89 e5                	mov    %esp,%ebp
c0103b5a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103b5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b60:	89 04 24             	mov    %eax,(%esp)
c0103b63:	e8 86 ff ff ff       	call   c0103aee <page2pa>
c0103b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b6e:	c1 e8 0c             	shr    $0xc,%eax
c0103b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b74:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103b79:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b7c:	72 23                	jb     c0103ba1 <page2kva+0x4a>
c0103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b81:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b85:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c0103b8c:	c0 
c0103b8d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b94:	00 
c0103b95:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103b9c:	e8 3a d1 ff ff       	call   c0100cdb <__panic>
c0103ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ba4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ba9:	89 ec                	mov    %ebp,%esp
c0103bab:	5d                   	pop    %ebp
c0103bac:	c3                   	ret    

c0103bad <pte2page>:
pte2page(pte_t pte) {
c0103bad:	55                   	push   %ebp
c0103bae:	89 e5                	mov    %esp,%ebp
c0103bb0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103bb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb6:	83 e0 01             	and    $0x1,%eax
c0103bb9:	85 c0                	test   %eax,%eax
c0103bbb:	75 1c                	jne    c0103bd9 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103bbd:	c7 44 24 08 f8 6a 10 	movl   $0xc0106af8,0x8(%esp)
c0103bc4:	c0 
c0103bc5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103bcc:	00 
c0103bcd:	c7 04 24 c3 6a 10 c0 	movl   $0xc0106ac3,(%esp)
c0103bd4:	e8 02 d1 ff ff       	call   c0100cdb <__panic>
    return pa2page(PTE_ADDR(pte));
c0103bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103be1:	89 04 24             	mov    %eax,(%esp)
c0103be4:	e8 1d ff ff ff       	call   c0103b06 <pa2page>
}
c0103be9:	89 ec                	mov    %ebp,%esp
c0103beb:	5d                   	pop    %ebp
c0103bec:	c3                   	ret    

c0103bed <pde2page>:
pde2page(pde_t pde) {
c0103bed:	55                   	push   %ebp
c0103bee:	89 e5                	mov    %esp,%ebp
c0103bf0:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bfb:	89 04 24             	mov    %eax,(%esp)
c0103bfe:	e8 03 ff ff ff       	call   c0103b06 <pa2page>
}
c0103c03:	89 ec                	mov    %ebp,%esp
c0103c05:	5d                   	pop    %ebp
c0103c06:	c3                   	ret    

c0103c07 <page_ref>:
page_ref(struct Page *page) {
c0103c07:	55                   	push   %ebp
c0103c08:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c0d:	8b 00                	mov    (%eax),%eax
}
c0103c0f:	5d                   	pop    %ebp
c0103c10:	c3                   	ret    

c0103c11 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103c11:	55                   	push   %ebp
c0103c12:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c1a:	89 10                	mov    %edx,(%eax)
}
c0103c1c:	90                   	nop
c0103c1d:	5d                   	pop    %ebp
c0103c1e:	c3                   	ret    

c0103c1f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103c1f:	55                   	push   %ebp
c0103c20:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c25:	8b 00                	mov    (%eax),%eax
c0103c27:	8d 50 01             	lea    0x1(%eax),%edx
c0103c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c2d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c32:	8b 00                	mov    (%eax),%eax
}
c0103c34:	5d                   	pop    %ebp
c0103c35:	c3                   	ret    

c0103c36 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103c36:	55                   	push   %ebp
c0103c37:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c3c:	8b 00                	mov    (%eax),%eax
c0103c3e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c44:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c49:	8b 00                	mov    (%eax),%eax
}
c0103c4b:	5d                   	pop    %ebp
c0103c4c:	c3                   	ret    

c0103c4d <__intr_save>:
__intr_save(void) {
c0103c4d:	55                   	push   %ebp
c0103c4e:	89 e5                	mov    %esp,%ebp
c0103c50:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103c53:	9c                   	pushf  
c0103c54:	58                   	pop    %eax
c0103c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103c5b:	25 00 02 00 00       	and    $0x200,%eax
c0103c60:	85 c0                	test   %eax,%eax
c0103c62:	74 0c                	je     c0103c70 <__intr_save+0x23>
        intr_disable();
c0103c64:	e8 cb da ff ff       	call   c0101734 <intr_disable>
        return 1;
c0103c69:	b8 01 00 00 00       	mov    $0x1,%eax
c0103c6e:	eb 05                	jmp    c0103c75 <__intr_save+0x28>
    return 0;
c0103c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103c75:	89 ec                	mov    %ebp,%esp
c0103c77:	5d                   	pop    %ebp
c0103c78:	c3                   	ret    

c0103c79 <__intr_restore>:
__intr_restore(bool flag) {
c0103c79:	55                   	push   %ebp
c0103c7a:	89 e5                	mov    %esp,%ebp
c0103c7c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103c83:	74 05                	je     c0103c8a <__intr_restore+0x11>
        intr_enable();
c0103c85:	e8 a2 da ff ff       	call   c010172c <intr_enable>
}
c0103c8a:	90                   	nop
c0103c8b:	89 ec                	mov    %ebp,%esp
c0103c8d:	5d                   	pop    %ebp
c0103c8e:	c3                   	ret    

c0103c8f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103c8f:	55                   	push   %ebp
c0103c90:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c95:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c98:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c9d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c9f:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ca4:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103ca6:	b8 10 00 00 00       	mov    $0x10,%eax
c0103cab:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103cad:	b8 10 00 00 00       	mov    $0x10,%eax
c0103cb2:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103cb4:	b8 10 00 00 00       	mov    $0x10,%eax
c0103cb9:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103cbb:	ea c2 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103cc2
}
c0103cc2:	90                   	nop
c0103cc3:	5d                   	pop    %ebp
c0103cc4:	c3                   	ret    

c0103cc5 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103cc5:	55                   	push   %ebp
c0103cc6:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ccb:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103cd0:	90                   	nop
c0103cd1:	5d                   	pop    %ebp
c0103cd2:	c3                   	ret    

c0103cd3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103cd3:	55                   	push   %ebp
c0103cd4:	89 e5                	mov    %esp,%ebp
c0103cd6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103cd9:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103cde:	89 04 24             	mov    %eax,(%esp)
c0103ce1:	e8 df ff ff ff       	call   c0103cc5 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103ce6:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103ced:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103cef:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103cf6:	68 00 
c0103cf8:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103cfd:	0f b7 c0             	movzwl %ax,%eax
c0103d00:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103d06:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103d0b:	c1 e8 10             	shr    $0x10,%eax
c0103d0e:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103d13:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d1a:	24 f0                	and    $0xf0,%al
c0103d1c:	0c 09                	or     $0x9,%al
c0103d1e:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d23:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d2a:	24 ef                	and    $0xef,%al
c0103d2c:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d31:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d38:	24 9f                	and    $0x9f,%al
c0103d3a:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d3f:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103d46:	0c 80                	or     $0x80,%al
c0103d48:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103d4d:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d54:	24 f0                	and    $0xf0,%al
c0103d56:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d5b:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d62:	24 ef                	and    $0xef,%al
c0103d64:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d69:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d70:	24 df                	and    $0xdf,%al
c0103d72:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d77:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d7e:	0c 40                	or     $0x40,%al
c0103d80:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d85:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103d8c:	24 7f                	and    $0x7f,%al
c0103d8e:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103d93:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103d98:	c1 e8 18             	shr    $0x18,%eax
c0103d9b:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103da0:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103da7:	e8 e3 fe ff ff       	call   c0103c8f <lgdt>
c0103dac:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103db2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103db6:	0f 00 d8             	ltr    %ax
}
c0103db9:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103dba:	90                   	nop
c0103dbb:	89 ec                	mov    %ebp,%esp
c0103dbd:	5d                   	pop    %ebp
c0103dbe:	c3                   	ret    

c0103dbf <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103dbf:	55                   	push   %ebp
c0103dc0:	89 e5                	mov    %esp,%ebp
c0103dc2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103dc5:	c7 05 ac be 11 c0 88 	movl   $0xc0106a88,0xc011beac
c0103dcc:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103dcf:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103dd4:	8b 00                	mov    (%eax),%eax
c0103dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103dda:	c7 04 24 24 6b 10 c0 	movl   $0xc0106b24,(%esp)
c0103de1:	e8 70 c5 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103de6:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103deb:	8b 40 04             	mov    0x4(%eax),%eax
c0103dee:	ff d0                	call   *%eax
}
c0103df0:	90                   	nop
c0103df1:	89 ec                	mov    %ebp,%esp
c0103df3:	5d                   	pop    %ebp
c0103df4:	c3                   	ret    

c0103df5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103df5:	55                   	push   %ebp
c0103df6:	89 e5                	mov    %esp,%ebp
c0103df8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103dfb:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e00:	8b 40 08             	mov    0x8(%eax),%eax
c0103e03:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e06:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e0a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e0d:	89 14 24             	mov    %edx,(%esp)
c0103e10:	ff d0                	call   *%eax
}
c0103e12:	90                   	nop
c0103e13:	89 ec                	mov    %ebp,%esp
c0103e15:	5d                   	pop    %ebp
c0103e16:	c3                   	ret    

c0103e17 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103e17:	55                   	push   %ebp
c0103e18:	89 e5                	mov    %esp,%ebp
c0103e1a:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e24:	e8 24 fe ff ff       	call   c0103c4d <__intr_save>
c0103e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103e2c:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e31:	8b 40 0c             	mov    0xc(%eax),%eax
c0103e34:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e37:	89 14 24             	mov    %edx,(%esp)
c0103e3a:	ff d0                	call   *%eax
c0103e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e42:	89 04 24             	mov    %eax,(%esp)
c0103e45:	e8 2f fe ff ff       	call   c0103c79 <__intr_restore>
    return page;
c0103e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103e4d:	89 ec                	mov    %ebp,%esp
c0103e4f:	5d                   	pop    %ebp
c0103e50:	c3                   	ret    

c0103e51 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103e51:	55                   	push   %ebp
c0103e52:	89 e5                	mov    %esp,%ebp
c0103e54:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e57:	e8 f1 fd ff ff       	call   c0103c4d <__intr_save>
c0103e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103e5f:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e64:	8b 40 10             	mov    0x10(%eax),%eax
c0103e67:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103e6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e6e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103e71:	89 14 24             	mov    %edx,(%esp)
c0103e74:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e79:	89 04 24             	mov    %eax,(%esp)
c0103e7c:	e8 f8 fd ff ff       	call   c0103c79 <__intr_restore>
}
c0103e81:	90                   	nop
c0103e82:	89 ec                	mov    %ebp,%esp
c0103e84:	5d                   	pop    %ebp
c0103e85:	c3                   	ret    

c0103e86 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103e86:	55                   	push   %ebp
c0103e87:	89 e5                	mov    %esp,%ebp
c0103e89:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103e8c:	e8 bc fd ff ff       	call   c0103c4d <__intr_save>
c0103e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103e94:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103e99:	8b 40 14             	mov    0x14(%eax),%eax
c0103e9c:	ff d0                	call   *%eax
c0103e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ea4:	89 04 24             	mov    %eax,(%esp)
c0103ea7:	e8 cd fd ff ff       	call   c0103c79 <__intr_restore>
    return ret;
c0103eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103eaf:	89 ec                	mov    %ebp,%esp
c0103eb1:	5d                   	pop    %ebp
c0103eb2:	c3                   	ret    

c0103eb3 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103eb3:	55                   	push   %ebp
c0103eb4:	89 e5                	mov    %esp,%ebp
c0103eb6:	57                   	push   %edi
c0103eb7:	56                   	push   %esi
c0103eb8:	53                   	push   %ebx
c0103eb9:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103ebf:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103ec6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103ecd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103ed4:	c7 04 24 3b 6b 10 c0 	movl   $0xc0106b3b,(%esp)
c0103edb:	e8 76 c4 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ee0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ee7:	e9 0c 01 00 00       	jmp    c0103ff8 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103eec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ef2:	89 d0                	mov    %edx,%eax
c0103ef4:	c1 e0 02             	shl    $0x2,%eax
c0103ef7:	01 d0                	add    %edx,%eax
c0103ef9:	c1 e0 02             	shl    $0x2,%eax
c0103efc:	01 c8                	add    %ecx,%eax
c0103efe:	8b 50 08             	mov    0x8(%eax),%edx
c0103f01:	8b 40 04             	mov    0x4(%eax),%eax
c0103f04:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103f07:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103f0a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f10:	89 d0                	mov    %edx,%eax
c0103f12:	c1 e0 02             	shl    $0x2,%eax
c0103f15:	01 d0                	add    %edx,%eax
c0103f17:	c1 e0 02             	shl    $0x2,%eax
c0103f1a:	01 c8                	add    %ecx,%eax
c0103f1c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f1f:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f22:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f25:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103f28:	01 c8                	add    %ecx,%eax
c0103f2a:	11 da                	adc    %ebx,%edx
c0103f2c:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103f2f:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103f32:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f35:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f38:	89 d0                	mov    %edx,%eax
c0103f3a:	c1 e0 02             	shl    $0x2,%eax
c0103f3d:	01 d0                	add    %edx,%eax
c0103f3f:	c1 e0 02             	shl    $0x2,%eax
c0103f42:	01 c8                	add    %ecx,%eax
c0103f44:	83 c0 14             	add    $0x14,%eax
c0103f47:	8b 00                	mov    (%eax),%eax
c0103f49:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103f4f:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103f52:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103f55:	83 c0 ff             	add    $0xffffffff,%eax
c0103f58:	83 d2 ff             	adc    $0xffffffff,%edx
c0103f5b:	89 c6                	mov    %eax,%esi
c0103f5d:	89 d7                	mov    %edx,%edi
c0103f5f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f62:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f65:	89 d0                	mov    %edx,%eax
c0103f67:	c1 e0 02             	shl    $0x2,%eax
c0103f6a:	01 d0                	add    %edx,%eax
c0103f6c:	c1 e0 02             	shl    $0x2,%eax
c0103f6f:	01 c8                	add    %ecx,%eax
c0103f71:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f74:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f77:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103f7d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103f81:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103f85:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103f89:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f8c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103f8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f93:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103f97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103f9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f9f:	c7 04 24 48 6b 10 c0 	movl   $0xc0106b48,(%esp)
c0103fa6:	e8 ab c3 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103fab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fb1:	89 d0                	mov    %edx,%eax
c0103fb3:	c1 e0 02             	shl    $0x2,%eax
c0103fb6:	01 d0                	add    %edx,%eax
c0103fb8:	c1 e0 02             	shl    $0x2,%eax
c0103fbb:	01 c8                	add    %ecx,%eax
c0103fbd:	83 c0 14             	add    $0x14,%eax
c0103fc0:	8b 00                	mov    (%eax),%eax
c0103fc2:	83 f8 01             	cmp    $0x1,%eax
c0103fc5:	75 2e                	jne    c0103ff5 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c0103fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103fca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103fcd:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103fd0:	89 d0                	mov    %edx,%eax
c0103fd2:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0103fd5:	73 1e                	jae    c0103ff5 <page_init+0x142>
c0103fd7:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103fdc:	b8 00 00 00 00       	mov    $0x0,%eax
c0103fe1:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0103fe4:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0103fe7:	72 0c                	jb     c0103ff5 <page_init+0x142>
                maxpa = end;
c0103fe9:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103fec:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103fef:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ff2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ff5:	ff 45 dc             	incl   -0x24(%ebp)
c0103ff8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ffb:	8b 00                	mov    (%eax),%eax
c0103ffd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104000:	0f 8c e6 fe ff ff    	jl     c0103eec <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104006:	ba 00 00 00 38       	mov    $0x38000000,%edx
c010400b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104010:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0104013:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0104016:	73 0e                	jae    c0104026 <page_init+0x173>
        maxpa = KMEMSIZE;
c0104018:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c010401f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104026:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104029:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010402c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104030:	c1 ea 0c             	shr    $0xc,%edx
c0104033:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104038:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c010403f:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0104044:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104047:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010404a:	01 d0                	add    %edx,%eax
c010404c:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010404f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104052:	ba 00 00 00 00       	mov    $0x0,%edx
c0104057:	f7 75 c0             	divl   -0x40(%ebp)
c010405a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010405d:	29 d0                	sub    %edx,%eax
c010405f:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c0104064:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010406b:	eb 2f                	jmp    c010409c <page_init+0x1e9>
        SetPageReserved(pages + i);
c010406d:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0104073:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104076:	89 d0                	mov    %edx,%eax
c0104078:	c1 e0 02             	shl    $0x2,%eax
c010407b:	01 d0                	add    %edx,%eax
c010407d:	c1 e0 02             	shl    $0x2,%eax
c0104080:	01 c8                	add    %ecx,%eax
c0104082:	83 c0 04             	add    $0x4,%eax
c0104085:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c010408c:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010408f:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104092:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104095:	0f ab 10             	bts    %edx,(%eax)
}
c0104098:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0104099:	ff 45 dc             	incl   -0x24(%ebp)
c010409c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010409f:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01040a4:	39 c2                	cmp    %eax,%edx
c01040a6:	72 c5                	jb     c010406d <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01040a8:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c01040ae:	89 d0                	mov    %edx,%eax
c01040b0:	c1 e0 02             	shl    $0x2,%eax
c01040b3:	01 d0                	add    %edx,%eax
c01040b5:	c1 e0 02             	shl    $0x2,%eax
c01040b8:	89 c2                	mov    %eax,%edx
c01040ba:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c01040bf:	01 d0                	add    %edx,%eax
c01040c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01040c4:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c01040cb:	77 23                	ja     c01040f0 <page_init+0x23d>
c01040cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01040d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040d4:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c01040db:	c0 
c01040dc:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01040e3:	00 
c01040e4:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01040eb:	e8 eb cb ff ff       	call   c0100cdb <__panic>
c01040f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01040f3:	05 00 00 00 40       	add    $0x40000000,%eax
c01040f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01040fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104102:	e9 53 01 00 00       	jmp    c010425a <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104107:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010410a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010410d:	89 d0                	mov    %edx,%eax
c010410f:	c1 e0 02             	shl    $0x2,%eax
c0104112:	01 d0                	add    %edx,%eax
c0104114:	c1 e0 02             	shl    $0x2,%eax
c0104117:	01 c8                	add    %ecx,%eax
c0104119:	8b 50 08             	mov    0x8(%eax),%edx
c010411c:	8b 40 04             	mov    0x4(%eax),%eax
c010411f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104122:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104125:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104128:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010412b:	89 d0                	mov    %edx,%eax
c010412d:	c1 e0 02             	shl    $0x2,%eax
c0104130:	01 d0                	add    %edx,%eax
c0104132:	c1 e0 02             	shl    $0x2,%eax
c0104135:	01 c8                	add    %ecx,%eax
c0104137:	8b 48 0c             	mov    0xc(%eax),%ecx
c010413a:	8b 58 10             	mov    0x10(%eax),%ebx
c010413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104143:	01 c8                	add    %ecx,%eax
c0104145:	11 da                	adc    %ebx,%edx
c0104147:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010414a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010414d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104150:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104153:	89 d0                	mov    %edx,%eax
c0104155:	c1 e0 02             	shl    $0x2,%eax
c0104158:	01 d0                	add    %edx,%eax
c010415a:	c1 e0 02             	shl    $0x2,%eax
c010415d:	01 c8                	add    %ecx,%eax
c010415f:	83 c0 14             	add    $0x14,%eax
c0104162:	8b 00                	mov    (%eax),%eax
c0104164:	83 f8 01             	cmp    $0x1,%eax
c0104167:	0f 85 ea 00 00 00    	jne    c0104257 <page_init+0x3a4>
            if (begin < freemem) {
c010416d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104170:	ba 00 00 00 00       	mov    $0x0,%edx
c0104175:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104178:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010417b:	19 d1                	sbb    %edx,%ecx
c010417d:	73 0d                	jae    c010418c <page_init+0x2d9>
                begin = freemem;
c010417f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104182:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104185:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010418c:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0104191:	b8 00 00 00 00       	mov    $0x0,%eax
c0104196:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0104199:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c010419c:	73 0e                	jae    c01041ac <page_init+0x2f9>
                end = KMEMSIZE;
c010419e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01041a5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01041ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01041b5:	89 d0                	mov    %edx,%eax
c01041b7:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c01041ba:	0f 83 97 00 00 00    	jae    c0104257 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c01041c0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c01041c7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01041cd:	01 d0                	add    %edx,%eax
c01041cf:	48                   	dec    %eax
c01041d0:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01041d3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01041d6:	ba 00 00 00 00       	mov    $0x0,%edx
c01041db:	f7 75 b0             	divl   -0x50(%ebp)
c01041de:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01041e1:	29 d0                	sub    %edx,%eax
c01041e3:	ba 00 00 00 00       	mov    $0x0,%edx
c01041e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01041eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01041ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041f1:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01041f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01041f7:	ba 00 00 00 00       	mov    $0x0,%edx
c01041fc:	89 c7                	mov    %eax,%edi
c01041fe:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104204:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104207:	89 d0                	mov    %edx,%eax
c0104209:	83 e0 00             	and    $0x0,%eax
c010420c:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010420f:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104212:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104215:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104218:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010421b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010421e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104221:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104224:	89 d0                	mov    %edx,%eax
c0104226:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0104229:	73 2c                	jae    c0104257 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010422b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010422e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104231:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104234:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0104237:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010423b:	c1 ea 0c             	shr    $0xc,%edx
c010423e:	89 c3                	mov    %eax,%ebx
c0104240:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104243:	89 04 24             	mov    %eax,(%esp)
c0104246:	e8 bb f8 ff ff       	call   c0103b06 <pa2page>
c010424b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010424f:	89 04 24             	mov    %eax,(%esp)
c0104252:	e8 9e fb ff ff       	call   c0103df5 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0104257:	ff 45 dc             	incl   -0x24(%ebp)
c010425a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010425d:	8b 00                	mov    (%eax),%eax
c010425f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104262:	0f 8c 9f fe ff ff    	jl     c0104107 <page_init+0x254>
                }
            }
        }
    }
}
c0104268:	90                   	nop
c0104269:	90                   	nop
c010426a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104270:	5b                   	pop    %ebx
c0104271:	5e                   	pop    %esi
c0104272:	5f                   	pop    %edi
c0104273:	5d                   	pop    %ebp
c0104274:	c3                   	ret    

c0104275 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104275:	55                   	push   %ebp
c0104276:	89 e5                	mov    %esp,%ebp
c0104278:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010427b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010427e:	33 45 14             	xor    0x14(%ebp),%eax
c0104281:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104286:	85 c0                	test   %eax,%eax
c0104288:	74 24                	je     c01042ae <boot_map_segment+0x39>
c010428a:	c7 44 24 0c aa 6b 10 	movl   $0xc0106baa,0xc(%esp)
c0104291:	c0 
c0104292:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104299:	c0 
c010429a:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01042a1:	00 
c01042a2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01042a9:	e8 2d ca ff ff       	call   c0100cdb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01042ae:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01042b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042b8:	25 ff 0f 00 00       	and    $0xfff,%eax
c01042bd:	89 c2                	mov    %eax,%edx
c01042bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01042c2:	01 c2                	add    %eax,%edx
c01042c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042c7:	01 d0                	add    %edx,%eax
c01042c9:	48                   	dec    %eax
c01042ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042d0:	ba 00 00 00 00       	mov    $0x0,%edx
c01042d5:	f7 75 f0             	divl   -0x10(%ebp)
c01042d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042db:	29 d0                	sub    %edx,%eax
c01042dd:	c1 e8 0c             	shr    $0xc,%eax
c01042e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01042e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01042e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042f1:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01042f4:	8b 45 14             	mov    0x14(%ebp),%eax
c01042f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104302:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104305:	eb 68                	jmp    c010436f <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104307:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010430e:	00 
c010430f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104312:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104316:	8b 45 08             	mov    0x8(%ebp),%eax
c0104319:	89 04 24             	mov    %eax,(%esp)
c010431c:	e8 88 01 00 00       	call   c01044a9 <get_pte>
c0104321:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104324:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104328:	75 24                	jne    c010434e <boot_map_segment+0xd9>
c010432a:	c7 44 24 0c d6 6b 10 	movl   $0xc0106bd6,0xc(%esp)
c0104331:	c0 
c0104332:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104339:	c0 
c010433a:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104341:	00 
c0104342:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104349:	e8 8d c9 ff ff       	call   c0100cdb <__panic>
        *ptep = pa | PTE_P | perm;
c010434e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104351:	0b 45 18             	or     0x18(%ebp),%eax
c0104354:	83 c8 01             	or     $0x1,%eax
c0104357:	89 c2                	mov    %eax,%edx
c0104359:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010435c:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010435e:	ff 4d f4             	decl   -0xc(%ebp)
c0104361:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104368:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010436f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104373:	75 92                	jne    c0104307 <boot_map_segment+0x92>
    }
}
c0104375:	90                   	nop
c0104376:	90                   	nop
c0104377:	89 ec                	mov    %ebp,%esp
c0104379:	5d                   	pop    %ebp
c010437a:	c3                   	ret    

c010437b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010437b:	55                   	push   %ebp
c010437c:	89 e5                	mov    %esp,%ebp
c010437e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104388:	e8 8a fa ff ff       	call   c0103e17 <alloc_pages>
c010438d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104394:	75 1c                	jne    c01043b2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104396:	c7 44 24 08 e3 6b 10 	movl   $0xc0106be3,0x8(%esp)
c010439d:	c0 
c010439e:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01043a5:	00 
c01043a6:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01043ad:	e8 29 c9 ff ff       	call   c0100cdb <__panic>
    }
    return page2kva(p);
c01043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b5:	89 04 24             	mov    %eax,(%esp)
c01043b8:	e8 9a f7 ff ff       	call   c0103b57 <page2kva>
}
c01043bd:	89 ec                	mov    %ebp,%esp
c01043bf:	5d                   	pop    %ebp
c01043c0:	c3                   	ret    

c01043c1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01043c1:	55                   	push   %ebp
c01043c2:	89 e5                	mov    %esp,%ebp
c01043c4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01043c7:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01043cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043cf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043d6:	77 23                	ja     c01043fb <pmm_init+0x3a>
c01043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043df:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c01043e6:	c0 
c01043e7:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01043ee:	00 
c01043ef:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01043f6:	e8 e0 c8 ff ff       	call   c0100cdb <__panic>
c01043fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043fe:	05 00 00 00 40       	add    $0x40000000,%eax
c0104403:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104408:	e8 b2 f9 ff ff       	call   c0103dbf <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010440d:	e8 a1 fa ff ff       	call   c0103eb3 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104412:	e8 ed 03 00 00       	call   c0104804 <check_alloc_page>

    check_pgdir();
c0104417:	e8 09 04 00 00       	call   c0104825 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010441c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104421:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104424:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010442b:	77 23                	ja     c0104450 <pmm_init+0x8f>
c010442d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104430:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104434:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c010443b:	c0 
c010443c:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104443:	00 
c0104444:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010444b:	e8 8b c8 ff ff       	call   c0100cdb <__panic>
c0104450:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104453:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0104459:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010445e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104463:	83 ca 03             	or     $0x3,%edx
c0104466:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104468:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010446d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104474:	00 
c0104475:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010447c:	00 
c010447d:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104484:	38 
c0104485:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010448c:	c0 
c010448d:	89 04 24             	mov    %eax,(%esp)
c0104490:	e8 e0 fd ff ff       	call   c0104275 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104495:	e8 39 f8 ff ff       	call   c0103cd3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010449a:	e8 24 0a 00 00       	call   c0104ec3 <check_boot_pgdir>

    print_pgdir();
c010449f:	e8 a1 0e 00 00       	call   c0105345 <print_pgdir>

}
c01044a4:	90                   	nop
c01044a5:	89 ec                	mov    %ebp,%esp
c01044a7:	5d                   	pop    %ebp
c01044a8:	c3                   	ret    

c01044a9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01044a9:	55                   	push   %ebp
c01044aa:	89 e5                	mov    %esp,%ebp
c01044ac:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    //由线性地址取page directory中对应的条目
    pde_t *pdep = &pgdir[PDX(la)];
c01044af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044b2:	c1 e8 16             	shr    $0x16,%eax
c01044b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01044bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bf:	01 d0                	add    %edx,%eax
c01044c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    //若存在位为0,则需要判断create选项
    if (!(*pdep & PTE_P)) {
c01044c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c7:	8b 00                	mov    (%eax),%eax
c01044c9:	83 e0 01             	and    $0x1,%eax
c01044cc:	85 c0                	test   %eax,%eax
c01044ce:	0f 85 af 00 00 00    	jne    c0104583 <get_pte+0xda>
        struct Page *page;
        //若create=0，则返回NULL
        //若create=1，则分配一块物理内存，作为新的页表
        if (!create || (page = alloc_page()) == NULL) {
c01044d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044d8:	74 15                	je     c01044ef <get_pte+0x46>
c01044da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044e1:	e8 31 f9 ff ff       	call   c0103e17 <alloc_pages>
c01044e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044ed:	75 0a                	jne    c01044f9 <get_pte+0x50>
            return NULL;
c01044ef:	b8 00 00 00 00       	mov    $0x0,%eax
c01044f4:	e9 e7 00 00 00       	jmp    c01045e0 <get_pte+0x137>
        }
        //设置page的引用计数
        set_page_ref(page, 1);
c01044f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104500:	00 
c0104501:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104504:	89 04 24             	mov    %eax,(%esp)
c0104507:	e8 05 f7 ff ff       	call   c0103c11 <set_page_ref>
        //修改page directory项的标志位，把新页表写入此项
        uintptr_t pa = page2pa(page);
c010450c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010450f:	89 04 24             	mov    %eax,(%esp)
c0104512:	e8 d7 f5 ff ff       	call   c0103aee <page2pa>
c0104517:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010451a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010451d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104520:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104523:	c1 e8 0c             	shr    $0xc,%eax
c0104526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104529:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010452e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104531:	72 23                	jb     c0104556 <get_pte+0xad>
c0104533:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104536:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010453a:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c0104541:	c0 
c0104542:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
c0104549:	00 
c010454a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104551:	e8 85 c7 ff ff       	call   c0100cdb <__panic>
c0104556:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104559:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010455e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104565:	00 
c0104566:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010456d:	00 
c010456e:	89 04 24             	mov    %eax,(%esp)
c0104571:	e8 d4 18 00 00       	call   c0105e4a <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104576:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104579:	83 c8 07             	or     $0x7,%eax
c010457c:	89 c2                	mov    %eax,%edx
c010457e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104581:	89 10                	mov    %edx,(%eax)
    }
    //若存在位不为0,则返回页表项地址
    //对*pdep取高20位得到页表（物理）基址
    //用KADDR将页表物理基址换算为内核虚拟地址
    //从页表虚拟基址取PTX（la）个偏移量得到页表项，返回它的地址
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104583:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104586:	8b 00                	mov    (%eax),%eax
c0104588:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010458d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104590:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104593:	c1 e8 0c             	shr    $0xc,%eax
c0104596:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104599:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010459e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01045a1:	72 23                	jb     c01045c6 <get_pte+0x11d>
c01045a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045aa:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c01045b1:	c0 
c01045b2:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
c01045b9:	00 
c01045ba:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01045c1:	e8 15 c7 ff ff       	call   c0100cdb <__panic>
c01045c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045c9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045ce:	89 c2                	mov    %eax,%edx
c01045d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045d3:	c1 e8 0c             	shr    $0xc,%eax
c01045d6:	25 ff 03 00 00       	and    $0x3ff,%eax
c01045db:	c1 e0 02             	shl    $0x2,%eax
c01045de:	01 d0                	add    %edx,%eax
}
c01045e0:	89 ec                	mov    %ebp,%esp
c01045e2:	5d                   	pop    %ebp
c01045e3:	c3                   	ret    

c01045e4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01045e4:	55                   	push   %ebp
c01045e5:	89 e5                	mov    %esp,%ebp
c01045e7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045f1:	00 
c01045f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01045fc:	89 04 24             	mov    %eax,(%esp)
c01045ff:	e8 a5 fe ff ff       	call   c01044a9 <get_pte>
c0104604:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104607:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010460b:	74 08                	je     c0104615 <get_page+0x31>
        *ptep_store = ptep;
c010460d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104610:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104613:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104619:	74 1b                	je     c0104636 <get_page+0x52>
c010461b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461e:	8b 00                	mov    (%eax),%eax
c0104620:	83 e0 01             	and    $0x1,%eax
c0104623:	85 c0                	test   %eax,%eax
c0104625:	74 0f                	je     c0104636 <get_page+0x52>
        return pte2page(*ptep);
c0104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462a:	8b 00                	mov    (%eax),%eax
c010462c:	89 04 24             	mov    %eax,(%esp)
c010462f:	e8 79 f5 ff ff       	call   c0103bad <pte2page>
c0104634:	eb 05                	jmp    c010463b <get_page+0x57>
    }
    return NULL;
c0104636:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010463b:	89 ec                	mov    %ebp,%esp
c010463d:	5d                   	pop    %ebp
c010463e:	c3                   	ret    

c010463f <page_remove_pte>:
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
//释放给定页表ptep关联的page
//去使能地址la对应的TLB
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010463f:	55                   	push   %ebp
c0104640:	89 e5                	mov    %esp,%ebp
c0104642:	83 ec 28             	sub    $0x28,%esp
                                  //(6) flush tlb
    }
#endif

    //排除页表不存在的情况，确保传入的二级页表是存在的
    if (*ptep & PTE_P) {
c0104645:	8b 45 10             	mov    0x10(%ebp),%eax
c0104648:	8b 00                	mov    (%eax),%eax
c010464a:	83 e0 01             	and    $0x1,%eax
c010464d:	85 c0                	test   %eax,%eax
c010464f:	74 4d                	je     c010469e <page_remove_pte+0x5f>
        //获取该页表项对应的物理页的Page结构
        struct Page *page = pte2page(*ptep);
c0104651:	8b 45 10             	mov    0x10(%ebp),%eax
c0104654:	8b 00                	mov    (%eax),%eax
c0104656:	89 04 24             	mov    %eax,(%esp)
c0104659:	e8 4f f5 ff ff       	call   c0103bad <pte2page>
c010465e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //如果该物理页的引用计数变成0,即不存在任何虚拟页指
        if (page_ref_dec(page) == 0) {
c0104661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104664:	89 04 24             	mov    %eax,(%esp)
c0104667:	e8 ca f5 ff ff       	call   c0103c36 <page_ref_dec>
c010466c:	85 c0                	test   %eax,%eax
c010466e:	75 13                	jne    c0104683 <page_remove_pte+0x44>
            free_page(page);
c0104670:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104677:	00 
c0104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010467b:	89 04 24             	mov    %eax,(%esp)
c010467e:	e8 ce f7 ff ff       	call   c0103e51 <free_pages>
        }
        //ptep的存在位设置为0,表明该映射关系无效
        *ptep = 0;
c0104683:	8b 45 10             	mov    0x10(%ebp),%eax
c0104686:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        //刷新TLB，保证TLB中的缓存不会有错误的映射关系
        tlb_invalidate(pgdir, la);
c010468c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010468f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104693:	8b 45 08             	mov    0x8(%ebp),%eax
c0104696:	89 04 24             	mov    %eax,(%esp)
c0104699:	e8 07 01 00 00       	call   c01047a5 <tlb_invalidate>
    }
}
c010469e:	90                   	nop
c010469f:	89 ec                	mov    %ebp,%esp
c01046a1:	5d                   	pop    %ebp
c01046a2:	c3                   	ret    

c01046a3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01046a3:	55                   	push   %ebp
c01046a4:	89 e5                	mov    %esp,%ebp
c01046a6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01046a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046b0:	00 
c01046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01046bb:	89 04 24             	mov    %eax,(%esp)
c01046be:	e8 e6 fd ff ff       	call   c01044a9 <get_pte>
c01046c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01046c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ca:	74 19                	je     c01046e5 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01046cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046da:	8b 45 08             	mov    0x8(%ebp),%eax
c01046dd:	89 04 24             	mov    %eax,(%esp)
c01046e0:	e8 5a ff ff ff       	call   c010463f <page_remove_pte>
    }
}
c01046e5:	90                   	nop
c01046e6:	89 ec                	mov    %ebp,%esp
c01046e8:	5d                   	pop    %ebp
c01046e9:	c3                   	ret    

c01046ea <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01046ea:	55                   	push   %ebp
c01046eb:	89 e5                	mov    %esp,%ebp
c01046ed:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01046f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01046f7:	00 
c01046f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01046fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104702:	89 04 24             	mov    %eax,(%esp)
c0104705:	e8 9f fd ff ff       	call   c01044a9 <get_pte>
c010470a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010470d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104711:	75 0a                	jne    c010471d <page_insert+0x33>
        return -E_NO_MEM;
c0104713:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104718:	e9 84 00 00 00       	jmp    c01047a1 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010471d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104720:	89 04 24             	mov    %eax,(%esp)
c0104723:	e8 f7 f4 ff ff       	call   c0103c1f <page_ref_inc>
    if (*ptep & PTE_P) {
c0104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472b:	8b 00                	mov    (%eax),%eax
c010472d:	83 e0 01             	and    $0x1,%eax
c0104730:	85 c0                	test   %eax,%eax
c0104732:	74 3e                	je     c0104772 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104737:	8b 00                	mov    (%eax),%eax
c0104739:	89 04 24             	mov    %eax,(%esp)
c010473c:	e8 6c f4 ff ff       	call   c0103bad <pte2page>
c0104741:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104744:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104747:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010474a:	75 0d                	jne    c0104759 <page_insert+0x6f>
            page_ref_dec(page);
c010474c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010474f:	89 04 24             	mov    %eax,(%esp)
c0104752:	e8 df f4 ff ff       	call   c0103c36 <page_ref_dec>
c0104757:	eb 19                	jmp    c0104772 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104759:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010475c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104760:	8b 45 10             	mov    0x10(%ebp),%eax
c0104763:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104767:	8b 45 08             	mov    0x8(%ebp),%eax
c010476a:	89 04 24             	mov    %eax,(%esp)
c010476d:	e8 cd fe ff ff       	call   c010463f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104772:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104775:	89 04 24             	mov    %eax,(%esp)
c0104778:	e8 71 f3 ff ff       	call   c0103aee <page2pa>
c010477d:	0b 45 14             	or     0x14(%ebp),%eax
c0104780:	83 c8 01             	or     $0x1,%eax
c0104783:	89 c2                	mov    %eax,%edx
c0104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104788:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010478a:	8b 45 10             	mov    0x10(%ebp),%eax
c010478d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104791:	8b 45 08             	mov    0x8(%ebp),%eax
c0104794:	89 04 24             	mov    %eax,(%esp)
c0104797:	e8 09 00 00 00       	call   c01047a5 <tlb_invalidate>
    return 0;
c010479c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047a1:	89 ec                	mov    %ebp,%esp
c01047a3:	5d                   	pop    %ebp
c01047a4:	c3                   	ret    

c01047a5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01047a5:	55                   	push   %ebp
c01047a6:	89 e5                	mov    %esp,%ebp
c01047a8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01047ab:	0f 20 d8             	mov    %cr3,%eax
c01047ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01047b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01047b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01047b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047ba:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01047c1:	77 23                	ja     c01047e6 <tlb_invalidate+0x41>
c01047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047ca:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c01047d1:	c0 
c01047d2:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c01047d9:	00 
c01047da:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01047e1:	e8 f5 c4 ff ff       	call   c0100cdb <__panic>
c01047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e9:	05 00 00 00 40       	add    $0x40000000,%eax
c01047ee:	39 d0                	cmp    %edx,%eax
c01047f0:	75 0d                	jne    c01047ff <tlb_invalidate+0x5a>
        invlpg((void *)la);
c01047f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01047f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047fb:	0f 01 38             	invlpg (%eax)
}
c01047fe:	90                   	nop
    }
}
c01047ff:	90                   	nop
c0104800:	89 ec                	mov    %ebp,%esp
c0104802:	5d                   	pop    %ebp
c0104803:	c3                   	ret    

c0104804 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104804:	55                   	push   %ebp
c0104805:	89 e5                	mov    %esp,%ebp
c0104807:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010480a:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c010480f:	8b 40 18             	mov    0x18(%eax),%eax
c0104812:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104814:	c7 04 24 fc 6b 10 c0 	movl   $0xc0106bfc,(%esp)
c010481b:	e8 36 bb ff ff       	call   c0100356 <cprintf>
}
c0104820:	90                   	nop
c0104821:	89 ec                	mov    %ebp,%esp
c0104823:	5d                   	pop    %ebp
c0104824:	c3                   	ret    

c0104825 <check_pgdir>:

static void
check_pgdir(void) {
c0104825:	55                   	push   %ebp
c0104826:	89 e5                	mov    %esp,%ebp
c0104828:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010482b:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104830:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104835:	76 24                	jbe    c010485b <check_pgdir+0x36>
c0104837:	c7 44 24 0c 1b 6c 10 	movl   $0xc0106c1b,0xc(%esp)
c010483e:	c0 
c010483f:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104846:	c0 
c0104847:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010484e:	00 
c010484f:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104856:	e8 80 c4 ff ff       	call   c0100cdb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010485b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104860:	85 c0                	test   %eax,%eax
c0104862:	74 0e                	je     c0104872 <check_pgdir+0x4d>
c0104864:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104869:	25 ff 0f 00 00       	and    $0xfff,%eax
c010486e:	85 c0                	test   %eax,%eax
c0104870:	74 24                	je     c0104896 <check_pgdir+0x71>
c0104872:	c7 44 24 0c 38 6c 10 	movl   $0xc0106c38,0xc(%esp)
c0104879:	c0 
c010487a:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104881:	c0 
c0104882:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104889:	00 
c010488a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104891:	e8 45 c4 ff ff       	call   c0100cdb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104896:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010489b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048a2:	00 
c01048a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048aa:	00 
c01048ab:	89 04 24             	mov    %eax,(%esp)
c01048ae:	e8 31 fd ff ff       	call   c01045e4 <get_page>
c01048b3:	85 c0                	test   %eax,%eax
c01048b5:	74 24                	je     c01048db <check_pgdir+0xb6>
c01048b7:	c7 44 24 0c 70 6c 10 	movl   $0xc0106c70,0xc(%esp)
c01048be:	c0 
c01048bf:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01048c6:	c0 
c01048c7:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c01048ce:	00 
c01048cf:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01048d6:	e8 00 c4 ff ff       	call   c0100cdb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01048db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048e2:	e8 30 f5 ff ff       	call   c0103e17 <alloc_pages>
c01048e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01048ea:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048f6:	00 
c01048f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048fe:	00 
c01048ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104902:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104906:	89 04 24             	mov    %eax,(%esp)
c0104909:	e8 dc fd ff ff       	call   c01046ea <page_insert>
c010490e:	85 c0                	test   %eax,%eax
c0104910:	74 24                	je     c0104936 <check_pgdir+0x111>
c0104912:	c7 44 24 0c 98 6c 10 	movl   $0xc0106c98,0xc(%esp)
c0104919:	c0 
c010491a:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104921:	c0 
c0104922:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104929:	00 
c010492a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104931:	e8 a5 c3 ff ff       	call   c0100cdb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104936:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010493b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104942:	00 
c0104943:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010494a:	00 
c010494b:	89 04 24             	mov    %eax,(%esp)
c010494e:	e8 56 fb ff ff       	call   c01044a9 <get_pte>
c0104953:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104956:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010495a:	75 24                	jne    c0104980 <check_pgdir+0x15b>
c010495c:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104963:	c0 
c0104964:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010496b:	c0 
c010496c:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104973:	00 
c0104974:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010497b:	e8 5b c3 ff ff       	call   c0100cdb <__panic>
    assert(pte2page(*ptep) == p1);
c0104980:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104983:	8b 00                	mov    (%eax),%eax
c0104985:	89 04 24             	mov    %eax,(%esp)
c0104988:	e8 20 f2 ff ff       	call   c0103bad <pte2page>
c010498d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104990:	74 24                	je     c01049b6 <check_pgdir+0x191>
c0104992:	c7 44 24 0c f1 6c 10 	movl   $0xc0106cf1,0xc(%esp)
c0104999:	c0 
c010499a:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01049a1:	c0 
c01049a2:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c01049a9:	00 
c01049aa:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01049b1:	e8 25 c3 ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p1) == 1);
c01049b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049b9:	89 04 24             	mov    %eax,(%esp)
c01049bc:	e8 46 f2 ff ff       	call   c0103c07 <page_ref>
c01049c1:	83 f8 01             	cmp    $0x1,%eax
c01049c4:	74 24                	je     c01049ea <check_pgdir+0x1c5>
c01049c6:	c7 44 24 0c 07 6d 10 	movl   $0xc0106d07,0xc(%esp)
c01049cd:	c0 
c01049ce:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01049d5:	c0 
c01049d6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01049dd:	00 
c01049de:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01049e5:	e8 f1 c2 ff ff       	call   c0100cdb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01049ea:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049ef:	8b 00                	mov    (%eax),%eax
c01049f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01049f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049fc:	c1 e8 0c             	shr    $0xc,%eax
c01049ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104a02:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104a07:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104a0a:	72 23                	jb     c0104a2f <check_pgdir+0x20a>
c0104a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a13:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c0104a1a:	c0 
c0104a1b:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104a22:	00 
c0104a23:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104a2a:	e8 ac c2 ff ff       	call   c0100cdb <__panic>
c0104a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a32:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104a37:	83 c0 04             	add    $0x4,%eax
c0104a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104a3d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a49:	00 
c0104a4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a51:	00 
c0104a52:	89 04 24             	mov    %eax,(%esp)
c0104a55:	e8 4f fa ff ff       	call   c01044a9 <get_pte>
c0104a5a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a5d:	74 24                	je     c0104a83 <check_pgdir+0x25e>
c0104a5f:	c7 44 24 0c 1c 6d 10 	movl   $0xc0106d1c,0xc(%esp)
c0104a66:	c0 
c0104a67:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104a6e:	c0 
c0104a6f:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104a76:	00 
c0104a77:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104a7e:	e8 58 c2 ff ff       	call   c0100cdb <__panic>

    p2 = alloc_page();
c0104a83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a8a:	e8 88 f3 ff ff       	call   c0103e17 <alloc_pages>
c0104a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a92:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a97:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a9e:	00 
c0104a9f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104aa6:	00 
c0104aa7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104aaa:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104aae:	89 04 24             	mov    %eax,(%esp)
c0104ab1:	e8 34 fc ff ff       	call   c01046ea <page_insert>
c0104ab6:	85 c0                	test   %eax,%eax
c0104ab8:	74 24                	je     c0104ade <check_pgdir+0x2b9>
c0104aba:	c7 44 24 0c 44 6d 10 	movl   $0xc0106d44,0xc(%esp)
c0104ac1:	c0 
c0104ac2:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104ac9:	c0 
c0104aca:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104ad1:	00 
c0104ad2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104ad9:	e8 fd c1 ff ff       	call   c0100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ade:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ae3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aea:	00 
c0104aeb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104af2:	00 
c0104af3:	89 04 24             	mov    %eax,(%esp)
c0104af6:	e8 ae f9 ff ff       	call   c01044a9 <get_pte>
c0104afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b02:	75 24                	jne    c0104b28 <check_pgdir+0x303>
c0104b04:	c7 44 24 0c 7c 6d 10 	movl   $0xc0106d7c,0xc(%esp)
c0104b0b:	c0 
c0104b0c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104b13:	c0 
c0104b14:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104b1b:	00 
c0104b1c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b23:	e8 b3 c1 ff ff       	call   c0100cdb <__panic>
    assert(*ptep & PTE_U);
c0104b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b2b:	8b 00                	mov    (%eax),%eax
c0104b2d:	83 e0 04             	and    $0x4,%eax
c0104b30:	85 c0                	test   %eax,%eax
c0104b32:	75 24                	jne    c0104b58 <check_pgdir+0x333>
c0104b34:	c7 44 24 0c ac 6d 10 	movl   $0xc0106dac,0xc(%esp)
c0104b3b:	c0 
c0104b3c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104b43:	c0 
c0104b44:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104b4b:	00 
c0104b4c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b53:	e8 83 c1 ff ff       	call   c0100cdb <__panic>
    assert(*ptep & PTE_W);
c0104b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5b:	8b 00                	mov    (%eax),%eax
c0104b5d:	83 e0 02             	and    $0x2,%eax
c0104b60:	85 c0                	test   %eax,%eax
c0104b62:	75 24                	jne    c0104b88 <check_pgdir+0x363>
c0104b64:	c7 44 24 0c ba 6d 10 	movl   $0xc0106dba,0xc(%esp)
c0104b6b:	c0 
c0104b6c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104b73:	c0 
c0104b74:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104b7b:	00 
c0104b7c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104b83:	e8 53 c1 ff ff       	call   c0100cdb <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b88:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b8d:	8b 00                	mov    (%eax),%eax
c0104b8f:	83 e0 04             	and    $0x4,%eax
c0104b92:	85 c0                	test   %eax,%eax
c0104b94:	75 24                	jne    c0104bba <check_pgdir+0x395>
c0104b96:	c7 44 24 0c c8 6d 10 	movl   $0xc0106dc8,0xc(%esp)
c0104b9d:	c0 
c0104b9e:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104ba5:	c0 
c0104ba6:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104bad:	00 
c0104bae:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104bb5:	e8 21 c1 ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 1);
c0104bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bbd:	89 04 24             	mov    %eax,(%esp)
c0104bc0:	e8 42 f0 ff ff       	call   c0103c07 <page_ref>
c0104bc5:	83 f8 01             	cmp    $0x1,%eax
c0104bc8:	74 24                	je     c0104bee <check_pgdir+0x3c9>
c0104bca:	c7 44 24 0c de 6d 10 	movl   $0xc0106dde,0xc(%esp)
c0104bd1:	c0 
c0104bd2:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104bd9:	c0 
c0104bda:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104be1:	00 
c0104be2:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104be9:	e8 ed c0 ff ff       	call   c0100cdb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104bee:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bf3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104bfa:	00 
c0104bfb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c02:	00 
c0104c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c06:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c0a:	89 04 24             	mov    %eax,(%esp)
c0104c0d:	e8 d8 fa ff ff       	call   c01046ea <page_insert>
c0104c12:	85 c0                	test   %eax,%eax
c0104c14:	74 24                	je     c0104c3a <check_pgdir+0x415>
c0104c16:	c7 44 24 0c f0 6d 10 	movl   $0xc0106df0,0xc(%esp)
c0104c1d:	c0 
c0104c1e:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104c25:	c0 
c0104c26:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104c2d:	00 
c0104c2e:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104c35:	e8 a1 c0 ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p1) == 2);
c0104c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c3d:	89 04 24             	mov    %eax,(%esp)
c0104c40:	e8 c2 ef ff ff       	call   c0103c07 <page_ref>
c0104c45:	83 f8 02             	cmp    $0x2,%eax
c0104c48:	74 24                	je     c0104c6e <check_pgdir+0x449>
c0104c4a:	c7 44 24 0c 1c 6e 10 	movl   $0xc0106e1c,0xc(%esp)
c0104c51:	c0 
c0104c52:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104c59:	c0 
c0104c5a:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104c61:	00 
c0104c62:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104c69:	e8 6d c0 ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 0);
c0104c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c71:	89 04 24             	mov    %eax,(%esp)
c0104c74:	e8 8e ef ff ff       	call   c0103c07 <page_ref>
c0104c79:	85 c0                	test   %eax,%eax
c0104c7b:	74 24                	je     c0104ca1 <check_pgdir+0x47c>
c0104c7d:	c7 44 24 0c 2e 6e 10 	movl   $0xc0106e2e,0xc(%esp)
c0104c84:	c0 
c0104c85:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104c8c:	c0 
c0104c8d:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104c94:	00 
c0104c95:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104c9c:	e8 3a c0 ff ff       	call   c0100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ca1:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ca6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cad:	00 
c0104cae:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cb5:	00 
c0104cb6:	89 04 24             	mov    %eax,(%esp)
c0104cb9:	e8 eb f7 ff ff       	call   c01044a9 <get_pte>
c0104cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cc5:	75 24                	jne    c0104ceb <check_pgdir+0x4c6>
c0104cc7:	c7 44 24 0c 7c 6d 10 	movl   $0xc0106d7c,0xc(%esp)
c0104cce:	c0 
c0104ccf:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104cd6:	c0 
c0104cd7:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104cde:	00 
c0104cdf:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104ce6:	e8 f0 bf ff ff       	call   c0100cdb <__panic>
    assert(pte2page(*ptep) == p1);
c0104ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cee:	8b 00                	mov    (%eax),%eax
c0104cf0:	89 04 24             	mov    %eax,(%esp)
c0104cf3:	e8 b5 ee ff ff       	call   c0103bad <pte2page>
c0104cf8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104cfb:	74 24                	je     c0104d21 <check_pgdir+0x4fc>
c0104cfd:	c7 44 24 0c f1 6c 10 	movl   $0xc0106cf1,0xc(%esp)
c0104d04:	c0 
c0104d05:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104d0c:	c0 
c0104d0d:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104d14:	00 
c0104d15:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104d1c:	e8 ba bf ff ff       	call   c0100cdb <__panic>
    assert((*ptep & PTE_U) == 0);
c0104d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d24:	8b 00                	mov    (%eax),%eax
c0104d26:	83 e0 04             	and    $0x4,%eax
c0104d29:	85 c0                	test   %eax,%eax
c0104d2b:	74 24                	je     c0104d51 <check_pgdir+0x52c>
c0104d2d:	c7 44 24 0c 40 6e 10 	movl   $0xc0106e40,0xc(%esp)
c0104d34:	c0 
c0104d35:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104d3c:	c0 
c0104d3d:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104d44:	00 
c0104d45:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104d4c:	e8 8a bf ff ff       	call   c0100cdb <__panic>

    page_remove(boot_pgdir, 0x0);
c0104d51:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d5d:	00 
c0104d5e:	89 04 24             	mov    %eax,(%esp)
c0104d61:	e8 3d f9 ff ff       	call   c01046a3 <page_remove>
    assert(page_ref(p1) == 1);
c0104d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d69:	89 04 24             	mov    %eax,(%esp)
c0104d6c:	e8 96 ee ff ff       	call   c0103c07 <page_ref>
c0104d71:	83 f8 01             	cmp    $0x1,%eax
c0104d74:	74 24                	je     c0104d9a <check_pgdir+0x575>
c0104d76:	c7 44 24 0c 07 6d 10 	movl   $0xc0106d07,0xc(%esp)
c0104d7d:	c0 
c0104d7e:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104d85:	c0 
c0104d86:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104d8d:	00 
c0104d8e:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104d95:	e8 41 bf ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 0);
c0104d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d9d:	89 04 24             	mov    %eax,(%esp)
c0104da0:	e8 62 ee ff ff       	call   c0103c07 <page_ref>
c0104da5:	85 c0                	test   %eax,%eax
c0104da7:	74 24                	je     c0104dcd <check_pgdir+0x5a8>
c0104da9:	c7 44 24 0c 2e 6e 10 	movl   $0xc0106e2e,0xc(%esp)
c0104db0:	c0 
c0104db1:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104db8:	c0 
c0104db9:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104dc0:	00 
c0104dc1:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104dc8:	e8 0e bf ff ff       	call   c0100cdb <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104dcd:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104dd2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dd9:	00 
c0104dda:	89 04 24             	mov    %eax,(%esp)
c0104ddd:	e8 c1 f8 ff ff       	call   c01046a3 <page_remove>
    assert(page_ref(p1) == 0);
c0104de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104de5:	89 04 24             	mov    %eax,(%esp)
c0104de8:	e8 1a ee ff ff       	call   c0103c07 <page_ref>
c0104ded:	85 c0                	test   %eax,%eax
c0104def:	74 24                	je     c0104e15 <check_pgdir+0x5f0>
c0104df1:	c7 44 24 0c 55 6e 10 	movl   $0xc0106e55,0xc(%esp)
c0104df8:	c0 
c0104df9:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104e00:	c0 
c0104e01:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104e08:	00 
c0104e09:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104e10:	e8 c6 be ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p2) == 0);
c0104e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e18:	89 04 24             	mov    %eax,(%esp)
c0104e1b:	e8 e7 ed ff ff       	call   c0103c07 <page_ref>
c0104e20:	85 c0                	test   %eax,%eax
c0104e22:	74 24                	je     c0104e48 <check_pgdir+0x623>
c0104e24:	c7 44 24 0c 2e 6e 10 	movl   $0xc0106e2e,0xc(%esp)
c0104e2b:	c0 
c0104e2c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104e33:	c0 
c0104e34:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104e3b:	00 
c0104e3c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104e43:	e8 93 be ff ff       	call   c0100cdb <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104e48:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e4d:	8b 00                	mov    (%eax),%eax
c0104e4f:	89 04 24             	mov    %eax,(%esp)
c0104e52:	e8 96 ed ff ff       	call   c0103bed <pde2page>
c0104e57:	89 04 24             	mov    %eax,(%esp)
c0104e5a:	e8 a8 ed ff ff       	call   c0103c07 <page_ref>
c0104e5f:	83 f8 01             	cmp    $0x1,%eax
c0104e62:	74 24                	je     c0104e88 <check_pgdir+0x663>
c0104e64:	c7 44 24 0c 68 6e 10 	movl   $0xc0106e68,0xc(%esp)
c0104e6b:	c0 
c0104e6c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104e73:	c0 
c0104e74:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104e7b:	00 
c0104e7c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104e83:	e8 53 be ff ff       	call   c0100cdb <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104e88:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e8d:	8b 00                	mov    (%eax),%eax
c0104e8f:	89 04 24             	mov    %eax,(%esp)
c0104e92:	e8 56 ed ff ff       	call   c0103bed <pde2page>
c0104e97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e9e:	00 
c0104e9f:	89 04 24             	mov    %eax,(%esp)
c0104ea2:	e8 aa ef ff ff       	call   c0103e51 <free_pages>
    boot_pgdir[0] = 0;
c0104ea7:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104eb2:	c7 04 24 8f 6e 10 c0 	movl   $0xc0106e8f,(%esp)
c0104eb9:	e8 98 b4 ff ff       	call   c0100356 <cprintf>
}
c0104ebe:	90                   	nop
c0104ebf:	89 ec                	mov    %ebp,%esp
c0104ec1:	5d                   	pop    %ebp
c0104ec2:	c3                   	ret    

c0104ec3 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104ec3:	55                   	push   %ebp
c0104ec4:	89 e5                	mov    %esp,%ebp
c0104ec6:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ec9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ed0:	e9 ca 00 00 00       	jmp    c0104f9f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ede:	c1 e8 0c             	shr    $0xc,%eax
c0104ee1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ee4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104ee9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104eec:	72 23                	jb     c0104f11 <check_boot_pgdir+0x4e>
c0104eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ef1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ef5:	c7 44 24 08 d4 6a 10 	movl   $0xc0106ad4,0x8(%esp)
c0104efc:	c0 
c0104efd:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104f04:	00 
c0104f05:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104f0c:	e8 ca bd ff ff       	call   c0100cdb <__panic>
c0104f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f14:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104f19:	89 c2                	mov    %eax,%edx
c0104f1b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104f20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f27:	00 
c0104f28:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f2c:	89 04 24             	mov    %eax,(%esp)
c0104f2f:	e8 75 f5 ff ff       	call   c01044a9 <get_pte>
c0104f34:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104f3b:	75 24                	jne    c0104f61 <check_boot_pgdir+0x9e>
c0104f3d:	c7 44 24 0c ac 6e 10 	movl   $0xc0106eac,0xc(%esp)
c0104f44:	c0 
c0104f45:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104f4c:	c0 
c0104f4d:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104f54:	00 
c0104f55:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104f5c:	e8 7a bd ff ff       	call   c0100cdb <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f64:	8b 00                	mov    (%eax),%eax
c0104f66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f6b:	89 c2                	mov    %eax,%edx
c0104f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f70:	39 c2                	cmp    %eax,%edx
c0104f72:	74 24                	je     c0104f98 <check_boot_pgdir+0xd5>
c0104f74:	c7 44 24 0c e9 6e 10 	movl   $0xc0106ee9,0xc(%esp)
c0104f7b:	c0 
c0104f7c:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0104f83:	c0 
c0104f84:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104f8b:	00 
c0104f8c:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104f93:	e8 43 bd ff ff       	call   c0100cdb <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104f98:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104fa2:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104fa7:	39 c2                	cmp    %eax,%edx
c0104fa9:	0f 82 26 ff ff ff    	jb     c0104ed5 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104faf:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104fb4:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104fb9:	8b 00                	mov    (%eax),%eax
c0104fbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104fc0:	89 c2                	mov    %eax,%edx
c0104fc2:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104fca:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104fd1:	77 23                	ja     c0104ff6 <check_boot_pgdir+0x133>
c0104fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fda:	c7 44 24 08 78 6b 10 	movl   $0xc0106b78,0x8(%esp)
c0104fe1:	c0 
c0104fe2:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0104fe9:	00 
c0104fea:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104ff1:	e8 e5 bc ff ff       	call   c0100cdb <__panic>
c0104ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ff9:	05 00 00 00 40       	add    $0x40000000,%eax
c0104ffe:	39 d0                	cmp    %edx,%eax
c0105000:	74 24                	je     c0105026 <check_boot_pgdir+0x163>
c0105002:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0105009:	c0 
c010500a:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0105011:	c0 
c0105012:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105019:	00 
c010501a:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0105021:	e8 b5 bc ff ff       	call   c0100cdb <__panic>

    assert(boot_pgdir[0] == 0);
c0105026:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010502b:	8b 00                	mov    (%eax),%eax
c010502d:	85 c0                	test   %eax,%eax
c010502f:	74 24                	je     c0105055 <check_boot_pgdir+0x192>
c0105031:	c7 44 24 0c 34 6f 10 	movl   $0xc0106f34,0xc(%esp)
c0105038:	c0 
c0105039:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c0105040:	c0 
c0105041:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105048:	00 
c0105049:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0105050:	e8 86 bc ff ff       	call   c0100cdb <__panic>

    struct Page *p;
    p = alloc_page();
c0105055:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010505c:	e8 b6 ed ff ff       	call   c0103e17 <alloc_pages>
c0105061:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105064:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105069:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105070:	00 
c0105071:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105078:	00 
c0105079:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010507c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105080:	89 04 24             	mov    %eax,(%esp)
c0105083:	e8 62 f6 ff ff       	call   c01046ea <page_insert>
c0105088:	85 c0                	test   %eax,%eax
c010508a:	74 24                	je     c01050b0 <check_boot_pgdir+0x1ed>
c010508c:	c7 44 24 0c 48 6f 10 	movl   $0xc0106f48,0xc(%esp)
c0105093:	c0 
c0105094:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010509b:	c0 
c010509c:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01050a3:	00 
c01050a4:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01050ab:	e8 2b bc ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p) == 1);
c01050b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050b3:	89 04 24             	mov    %eax,(%esp)
c01050b6:	e8 4c eb ff ff       	call   c0103c07 <page_ref>
c01050bb:	83 f8 01             	cmp    $0x1,%eax
c01050be:	74 24                	je     c01050e4 <check_boot_pgdir+0x221>
c01050c0:	c7 44 24 0c 76 6f 10 	movl   $0xc0106f76,0xc(%esp)
c01050c7:	c0 
c01050c8:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01050cf:	c0 
c01050d0:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01050d7:	00 
c01050d8:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01050df:	e8 f7 bb ff ff       	call   c0100cdb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01050e4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01050e9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01050f0:	00 
c01050f1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01050f8:	00 
c01050f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105100:	89 04 24             	mov    %eax,(%esp)
c0105103:	e8 e2 f5 ff ff       	call   c01046ea <page_insert>
c0105108:	85 c0                	test   %eax,%eax
c010510a:	74 24                	je     c0105130 <check_boot_pgdir+0x26d>
c010510c:	c7 44 24 0c 88 6f 10 	movl   $0xc0106f88,0xc(%esp)
c0105113:	c0 
c0105114:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010511b:	c0 
c010511c:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105123:	00 
c0105124:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010512b:	e8 ab bb ff ff       	call   c0100cdb <__panic>
    assert(page_ref(p) == 2);
c0105130:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105133:	89 04 24             	mov    %eax,(%esp)
c0105136:	e8 cc ea ff ff       	call   c0103c07 <page_ref>
c010513b:	83 f8 02             	cmp    $0x2,%eax
c010513e:	74 24                	je     c0105164 <check_boot_pgdir+0x2a1>
c0105140:	c7 44 24 0c bf 6f 10 	movl   $0xc0106fbf,0xc(%esp)
c0105147:	c0 
c0105148:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c010514f:	c0 
c0105150:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105157:	00 
c0105158:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c010515f:	e8 77 bb ff ff       	call   c0100cdb <__panic>

    const char *str = "ucore: Hello world!!";
c0105164:	c7 45 e8 d0 6f 10 c0 	movl   $0xc0106fd0,-0x18(%ebp)
    strcpy((void *)0x100, str);
c010516b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010516e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105172:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105179:	e8 fc 09 00 00       	call   c0105b7a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010517e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105185:	00 
c0105186:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010518d:	e8 60 0a 00 00       	call   c0105bf2 <strcmp>
c0105192:	85 c0                	test   %eax,%eax
c0105194:	74 24                	je     c01051ba <check_boot_pgdir+0x2f7>
c0105196:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c010519d:	c0 
c010519e:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01051a5:	c0 
c01051a6:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01051ad:	00 
c01051ae:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01051b5:	e8 21 bb ff ff       	call   c0100cdb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01051ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051bd:	89 04 24             	mov    %eax,(%esp)
c01051c0:	e8 92 e9 ff ff       	call   c0103b57 <page2kva>
c01051c5:	05 00 01 00 00       	add    $0x100,%eax
c01051ca:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01051cd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01051d4:	e8 47 09 00 00       	call   c0105b20 <strlen>
c01051d9:	85 c0                	test   %eax,%eax
c01051db:	74 24                	je     c0105201 <check_boot_pgdir+0x33e>
c01051dd:	c7 44 24 0c 20 70 10 	movl   $0xc0107020,0xc(%esp)
c01051e4:	c0 
c01051e5:	c7 44 24 08 c1 6b 10 	movl   $0xc0106bc1,0x8(%esp)
c01051ec:	c0 
c01051ed:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01051f4:	00 
c01051f5:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c01051fc:	e8 da ba ff ff       	call   c0100cdb <__panic>

    free_page(p);
c0105201:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105208:	00 
c0105209:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010520c:	89 04 24             	mov    %eax,(%esp)
c010520f:	e8 3d ec ff ff       	call   c0103e51 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105214:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105219:	8b 00                	mov    (%eax),%eax
c010521b:	89 04 24             	mov    %eax,(%esp)
c010521e:	e8 ca e9 ff ff       	call   c0103bed <pde2page>
c0105223:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010522a:	00 
c010522b:	89 04 24             	mov    %eax,(%esp)
c010522e:	e8 1e ec ff ff       	call   c0103e51 <free_pages>
    boot_pgdir[0] = 0;
c0105233:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0105238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010523e:	c7 04 24 44 70 10 c0 	movl   $0xc0107044,(%esp)
c0105245:	e8 0c b1 ff ff       	call   c0100356 <cprintf>
}
c010524a:	90                   	nop
c010524b:	89 ec                	mov    %ebp,%esp
c010524d:	5d                   	pop    %ebp
c010524e:	c3                   	ret    

c010524f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010524f:	55                   	push   %ebp
c0105250:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105252:	8b 45 08             	mov    0x8(%ebp),%eax
c0105255:	83 e0 04             	and    $0x4,%eax
c0105258:	85 c0                	test   %eax,%eax
c010525a:	74 04                	je     c0105260 <perm2str+0x11>
c010525c:	b0 75                	mov    $0x75,%al
c010525e:	eb 02                	jmp    c0105262 <perm2str+0x13>
c0105260:	b0 2d                	mov    $0x2d,%al
c0105262:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0105267:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010526e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105271:	83 e0 02             	and    $0x2,%eax
c0105274:	85 c0                	test   %eax,%eax
c0105276:	74 04                	je     c010527c <perm2str+0x2d>
c0105278:	b0 77                	mov    $0x77,%al
c010527a:	eb 02                	jmp    c010527e <perm2str+0x2f>
c010527c:	b0 2d                	mov    $0x2d,%al
c010527e:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0105283:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c010528a:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c010528f:	5d                   	pop    %ebp
c0105290:	c3                   	ret    

c0105291 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105291:	55                   	push   %ebp
c0105292:	89 e5                	mov    %esp,%ebp
c0105294:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105297:	8b 45 10             	mov    0x10(%ebp),%eax
c010529a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010529d:	72 0d                	jb     c01052ac <get_pgtable_items+0x1b>
        return 0;
c010529f:	b8 00 00 00 00       	mov    $0x0,%eax
c01052a4:	e9 98 00 00 00       	jmp    c0105341 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01052a9:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01052ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01052af:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052b2:	73 18                	jae    c01052cc <get_pgtable_items+0x3b>
c01052b4:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052be:	8b 45 14             	mov    0x14(%ebp),%eax
c01052c1:	01 d0                	add    %edx,%eax
c01052c3:	8b 00                	mov    (%eax),%eax
c01052c5:	83 e0 01             	and    $0x1,%eax
c01052c8:	85 c0                	test   %eax,%eax
c01052ca:	74 dd                	je     c01052a9 <get_pgtable_items+0x18>
    }
    if (start < right) {
c01052cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01052cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052d2:	73 68                	jae    c010533c <get_pgtable_items+0xab>
        if (left_store != NULL) {
c01052d4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01052d8:	74 08                	je     c01052e2 <get_pgtable_items+0x51>
            *left_store = start;
c01052da:	8b 45 18             	mov    0x18(%ebp),%eax
c01052dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01052e0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01052e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01052e5:	8d 50 01             	lea    0x1(%eax),%edx
c01052e8:	89 55 10             	mov    %edx,0x10(%ebp)
c01052eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052f2:	8b 45 14             	mov    0x14(%ebp),%eax
c01052f5:	01 d0                	add    %edx,%eax
c01052f7:	8b 00                	mov    (%eax),%eax
c01052f9:	83 e0 07             	and    $0x7,%eax
c01052fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052ff:	eb 03                	jmp    c0105304 <get_pgtable_items+0x73>
            start ++;
c0105301:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105304:	8b 45 10             	mov    0x10(%ebp),%eax
c0105307:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010530a:	73 1d                	jae    c0105329 <get_pgtable_items+0x98>
c010530c:	8b 45 10             	mov    0x10(%ebp),%eax
c010530f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105316:	8b 45 14             	mov    0x14(%ebp),%eax
c0105319:	01 d0                	add    %edx,%eax
c010531b:	8b 00                	mov    (%eax),%eax
c010531d:	83 e0 07             	and    $0x7,%eax
c0105320:	89 c2                	mov    %eax,%edx
c0105322:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105325:	39 c2                	cmp    %eax,%edx
c0105327:	74 d8                	je     c0105301 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0105329:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010532d:	74 08                	je     c0105337 <get_pgtable_items+0xa6>
            *right_store = start;
c010532f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105332:	8b 55 10             	mov    0x10(%ebp),%edx
c0105335:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105337:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010533a:	eb 05                	jmp    c0105341 <get_pgtable_items+0xb0>
    }
    return 0;
c010533c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105341:	89 ec                	mov    %ebp,%esp
c0105343:	5d                   	pop    %ebp
c0105344:	c3                   	ret    

c0105345 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105345:	55                   	push   %ebp
c0105346:	89 e5                	mov    %esp,%ebp
c0105348:	57                   	push   %edi
c0105349:	56                   	push   %esi
c010534a:	53                   	push   %ebx
c010534b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010534e:	c7 04 24 64 70 10 c0 	movl   $0xc0107064,(%esp)
c0105355:	e8 fc af ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c010535a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105361:	e9 f2 00 00 00       	jmp    c0105458 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105369:	89 04 24             	mov    %eax,(%esp)
c010536c:	e8 de fe ff ff       	call   c010524f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105371:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105374:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105377:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105379:	89 d6                	mov    %edx,%esi
c010537b:	c1 e6 16             	shl    $0x16,%esi
c010537e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105381:	89 d3                	mov    %edx,%ebx
c0105383:	c1 e3 16             	shl    $0x16,%ebx
c0105386:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105389:	89 d1                	mov    %edx,%ecx
c010538b:	c1 e1 16             	shl    $0x16,%ecx
c010538e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105391:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0105394:	29 fa                	sub    %edi,%edx
c0105396:	89 44 24 14          	mov    %eax,0x14(%esp)
c010539a:	89 74 24 10          	mov    %esi,0x10(%esp)
c010539e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053aa:	c7 04 24 95 70 10 c0 	movl   $0xc0107095,(%esp)
c01053b1:	e8 a0 af ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c01053b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053b9:	c1 e0 0a             	shl    $0xa,%eax
c01053bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053bf:	eb 50                	jmp    c0105411 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053c4:	89 04 24             	mov    %eax,(%esp)
c01053c7:	e8 83 fe ff ff       	call   c010524f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01053cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053cf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01053d2:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01053d4:	89 d6                	mov    %edx,%esi
c01053d6:	c1 e6 0c             	shl    $0xc,%esi
c01053d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053dc:	89 d3                	mov    %edx,%ebx
c01053de:	c1 e3 0c             	shl    $0xc,%ebx
c01053e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01053e4:	89 d1                	mov    %edx,%ecx
c01053e6:	c1 e1 0c             	shl    $0xc,%ecx
c01053e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053ec:	8b 7d d8             	mov    -0x28(%ebp),%edi
c01053ef:	29 fa                	sub    %edi,%edx
c01053f1:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053f5:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053f9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105401:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105405:	c7 04 24 b4 70 10 c0 	movl   $0xc01070b4,(%esp)
c010540c:	e8 45 af ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105411:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105419:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010541c:	89 d3                	mov    %edx,%ebx
c010541e:	c1 e3 0a             	shl    $0xa,%ebx
c0105421:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105424:	89 d1                	mov    %edx,%ecx
c0105426:	c1 e1 0a             	shl    $0xa,%ecx
c0105429:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010542c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105430:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105433:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105437:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010543b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010543f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105443:	89 0c 24             	mov    %ecx,(%esp)
c0105446:	e8 46 fe ff ff       	call   c0105291 <get_pgtable_items>
c010544b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010544e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105452:	0f 85 69 ff ff ff    	jne    c01053c1 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105458:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010545d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105460:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0105463:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105467:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010546a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010546e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0105472:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105476:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010547d:	00 
c010547e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105485:	e8 07 fe ff ff       	call   c0105291 <get_pgtable_items>
c010548a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010548d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105491:	0f 85 cf fe ff ff    	jne    c0105366 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105497:	c7 04 24 d8 70 10 c0 	movl   $0xc01070d8,(%esp)
c010549e:	e8 b3 ae ff ff       	call   c0100356 <cprintf>
}
c01054a3:	90                   	nop
c01054a4:	83 c4 4c             	add    $0x4c,%esp
c01054a7:	5b                   	pop    %ebx
c01054a8:	5e                   	pop    %esi
c01054a9:	5f                   	pop    %edi
c01054aa:	5d                   	pop    %ebp
c01054ab:	c3                   	ret    

c01054ac <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01054ac:	55                   	push   %ebp
c01054ad:	89 e5                	mov    %esp,%ebp
c01054af:	83 ec 58             	sub    $0x58,%esp
c01054b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01054bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01054be:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01054c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01054ca:	8b 45 18             	mov    0x18(%ebp),%eax
c01054cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054d9:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01054dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054e6:	74 1c                	je     c0105504 <printnum+0x58>
c01054e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054eb:	ba 00 00 00 00       	mov    $0x0,%edx
c01054f0:	f7 75 e4             	divl   -0x1c(%ebp)
c01054f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054f9:	ba 00 00 00 00       	mov    $0x0,%edx
c01054fe:	f7 75 e4             	divl   -0x1c(%ebp)
c0105501:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105504:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105507:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010550a:	f7 75 e4             	divl   -0x1c(%ebp)
c010550d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105510:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105513:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105516:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105519:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010551c:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010551f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105522:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105525:	8b 45 18             	mov    0x18(%ebp),%eax
c0105528:	ba 00 00 00 00       	mov    $0x0,%edx
c010552d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105530:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105533:	19 d1                	sbb    %edx,%ecx
c0105535:	72 4c                	jb     c0105583 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105537:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010553a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010553d:	8b 45 20             	mov    0x20(%ebp),%eax
c0105540:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105544:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105548:	8b 45 18             	mov    0x18(%ebp),%eax
c010554b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010554f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105552:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105555:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105559:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010555d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105560:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105564:	8b 45 08             	mov    0x8(%ebp),%eax
c0105567:	89 04 24             	mov    %eax,(%esp)
c010556a:	e8 3d ff ff ff       	call   c01054ac <printnum>
c010556f:	eb 1b                	jmp    c010558c <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105571:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105574:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105578:	8b 45 20             	mov    0x20(%ebp),%eax
c010557b:	89 04 24             	mov    %eax,(%esp)
c010557e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105581:	ff d0                	call   *%eax
        while (-- width > 0)
c0105583:	ff 4d 1c             	decl   0x1c(%ebp)
c0105586:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010558a:	7f e5                	jg     c0105571 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010558c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010558f:	05 8c 71 10 c0       	add    $0xc010718c,%eax
c0105594:	0f b6 00             	movzbl (%eax),%eax
c0105597:	0f be c0             	movsbl %al,%eax
c010559a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010559d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055a1:	89 04 24             	mov    %eax,(%esp)
c01055a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a7:	ff d0                	call   *%eax
}
c01055a9:	90                   	nop
c01055aa:	89 ec                	mov    %ebp,%esp
c01055ac:	5d                   	pop    %ebp
c01055ad:	c3                   	ret    

c01055ae <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01055ae:	55                   	push   %ebp
c01055af:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055b5:	7e 14                	jle    c01055cb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01055b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ba:	8b 00                	mov    (%eax),%eax
c01055bc:	8d 48 08             	lea    0x8(%eax),%ecx
c01055bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c2:	89 0a                	mov    %ecx,(%edx)
c01055c4:	8b 50 04             	mov    0x4(%eax),%edx
c01055c7:	8b 00                	mov    (%eax),%eax
c01055c9:	eb 30                	jmp    c01055fb <getuint+0x4d>
    }
    else if (lflag) {
c01055cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055cf:	74 16                	je     c01055e7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01055d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d4:	8b 00                	mov    (%eax),%eax
c01055d6:	8d 48 04             	lea    0x4(%eax),%ecx
c01055d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01055dc:	89 0a                	mov    %ecx,(%edx)
c01055de:	8b 00                	mov    (%eax),%eax
c01055e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01055e5:	eb 14                	jmp    c01055fb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01055e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ea:	8b 00                	mov    (%eax),%eax
c01055ec:	8d 48 04             	lea    0x4(%eax),%ecx
c01055ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01055f2:	89 0a                	mov    %ecx,(%edx)
c01055f4:	8b 00                	mov    (%eax),%eax
c01055f6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055fb:	5d                   	pop    %ebp
c01055fc:	c3                   	ret    

c01055fd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055fd:	55                   	push   %ebp
c01055fe:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105600:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105604:	7e 14                	jle    c010561a <getint+0x1d>
        return va_arg(*ap, long long);
c0105606:	8b 45 08             	mov    0x8(%ebp),%eax
c0105609:	8b 00                	mov    (%eax),%eax
c010560b:	8d 48 08             	lea    0x8(%eax),%ecx
c010560e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105611:	89 0a                	mov    %ecx,(%edx)
c0105613:	8b 50 04             	mov    0x4(%eax),%edx
c0105616:	8b 00                	mov    (%eax),%eax
c0105618:	eb 28                	jmp    c0105642 <getint+0x45>
    }
    else if (lflag) {
c010561a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010561e:	74 12                	je     c0105632 <getint+0x35>
        return va_arg(*ap, long);
c0105620:	8b 45 08             	mov    0x8(%ebp),%eax
c0105623:	8b 00                	mov    (%eax),%eax
c0105625:	8d 48 04             	lea    0x4(%eax),%ecx
c0105628:	8b 55 08             	mov    0x8(%ebp),%edx
c010562b:	89 0a                	mov    %ecx,(%edx)
c010562d:	8b 00                	mov    (%eax),%eax
c010562f:	99                   	cltd   
c0105630:	eb 10                	jmp    c0105642 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105632:	8b 45 08             	mov    0x8(%ebp),%eax
c0105635:	8b 00                	mov    (%eax),%eax
c0105637:	8d 48 04             	lea    0x4(%eax),%ecx
c010563a:	8b 55 08             	mov    0x8(%ebp),%edx
c010563d:	89 0a                	mov    %ecx,(%edx)
c010563f:	8b 00                	mov    (%eax),%eax
c0105641:	99                   	cltd   
    }
}
c0105642:	5d                   	pop    %ebp
c0105643:	c3                   	ret    

c0105644 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105644:	55                   	push   %ebp
c0105645:	89 e5                	mov    %esp,%ebp
c0105647:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010564a:	8d 45 14             	lea    0x14(%ebp),%eax
c010564d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105653:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105657:	8b 45 10             	mov    0x10(%ebp),%eax
c010565a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010565e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105661:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105665:	8b 45 08             	mov    0x8(%ebp),%eax
c0105668:	89 04 24             	mov    %eax,(%esp)
c010566b:	e8 05 00 00 00       	call   c0105675 <vprintfmt>
    va_end(ap);
}
c0105670:	90                   	nop
c0105671:	89 ec                	mov    %ebp,%esp
c0105673:	5d                   	pop    %ebp
c0105674:	c3                   	ret    

c0105675 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105675:	55                   	push   %ebp
c0105676:	89 e5                	mov    %esp,%ebp
c0105678:	56                   	push   %esi
c0105679:	53                   	push   %ebx
c010567a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010567d:	eb 17                	jmp    c0105696 <vprintfmt+0x21>
            if (ch == '\0') {
c010567f:	85 db                	test   %ebx,%ebx
c0105681:	0f 84 bf 03 00 00    	je     c0105a46 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105687:	8b 45 0c             	mov    0xc(%ebp),%eax
c010568a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010568e:	89 1c 24             	mov    %ebx,(%esp)
c0105691:	8b 45 08             	mov    0x8(%ebp),%eax
c0105694:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105696:	8b 45 10             	mov    0x10(%ebp),%eax
c0105699:	8d 50 01             	lea    0x1(%eax),%edx
c010569c:	89 55 10             	mov    %edx,0x10(%ebp)
c010569f:	0f b6 00             	movzbl (%eax),%eax
c01056a2:	0f b6 d8             	movzbl %al,%ebx
c01056a5:	83 fb 25             	cmp    $0x25,%ebx
c01056a8:	75 d5                	jne    c010567f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01056aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01056ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01056b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01056bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01056c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01056c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01056c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01056cb:	8d 50 01             	lea    0x1(%eax),%edx
c01056ce:	89 55 10             	mov    %edx,0x10(%ebp)
c01056d1:	0f b6 00             	movzbl (%eax),%eax
c01056d4:	0f b6 d8             	movzbl %al,%ebx
c01056d7:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01056da:	83 f8 55             	cmp    $0x55,%eax
c01056dd:	0f 87 37 03 00 00    	ja     c0105a1a <vprintfmt+0x3a5>
c01056e3:	8b 04 85 b0 71 10 c0 	mov    -0x3fef8e50(,%eax,4),%eax
c01056ea:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01056ec:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056f0:	eb d6                	jmp    c01056c8 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056f2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056f6:	eb d0                	jmp    c01056c8 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105702:	89 d0                	mov    %edx,%eax
c0105704:	c1 e0 02             	shl    $0x2,%eax
c0105707:	01 d0                	add    %edx,%eax
c0105709:	01 c0                	add    %eax,%eax
c010570b:	01 d8                	add    %ebx,%eax
c010570d:	83 e8 30             	sub    $0x30,%eax
c0105710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105713:	8b 45 10             	mov    0x10(%ebp),%eax
c0105716:	0f b6 00             	movzbl (%eax),%eax
c0105719:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010571c:	83 fb 2f             	cmp    $0x2f,%ebx
c010571f:	7e 38                	jle    c0105759 <vprintfmt+0xe4>
c0105721:	83 fb 39             	cmp    $0x39,%ebx
c0105724:	7f 33                	jg     c0105759 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105726:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105729:	eb d4                	jmp    c01056ff <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010572b:	8b 45 14             	mov    0x14(%ebp),%eax
c010572e:	8d 50 04             	lea    0x4(%eax),%edx
c0105731:	89 55 14             	mov    %edx,0x14(%ebp)
c0105734:	8b 00                	mov    (%eax),%eax
c0105736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105739:	eb 1f                	jmp    c010575a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010573b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010573f:	79 87                	jns    c01056c8 <vprintfmt+0x53>
                width = 0;
c0105741:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105748:	e9 7b ff ff ff       	jmp    c01056c8 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010574d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105754:	e9 6f ff ff ff       	jmp    c01056c8 <vprintfmt+0x53>
            goto process_precision;
c0105759:	90                   	nop

        process_precision:
            if (width < 0)
c010575a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010575e:	0f 89 64 ff ff ff    	jns    c01056c8 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105767:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010576a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105771:	e9 52 ff ff ff       	jmp    c01056c8 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105776:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105779:	e9 4a ff ff ff       	jmp    c01056c8 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010577e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105781:	8d 50 04             	lea    0x4(%eax),%edx
c0105784:	89 55 14             	mov    %edx,0x14(%ebp)
c0105787:	8b 00                	mov    (%eax),%eax
c0105789:	8b 55 0c             	mov    0xc(%ebp),%edx
c010578c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105790:	89 04 24             	mov    %eax,(%esp)
c0105793:	8b 45 08             	mov    0x8(%ebp),%eax
c0105796:	ff d0                	call   *%eax
            break;
c0105798:	e9 a4 02 00 00       	jmp    c0105a41 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010579d:	8b 45 14             	mov    0x14(%ebp),%eax
c01057a0:	8d 50 04             	lea    0x4(%eax),%edx
c01057a3:	89 55 14             	mov    %edx,0x14(%ebp)
c01057a6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01057a8:	85 db                	test   %ebx,%ebx
c01057aa:	79 02                	jns    c01057ae <vprintfmt+0x139>
                err = -err;
c01057ac:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01057ae:	83 fb 06             	cmp    $0x6,%ebx
c01057b1:	7f 0b                	jg     c01057be <vprintfmt+0x149>
c01057b3:	8b 34 9d 70 71 10 c0 	mov    -0x3fef8e90(,%ebx,4),%esi
c01057ba:	85 f6                	test   %esi,%esi
c01057bc:	75 23                	jne    c01057e1 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01057be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01057c2:	c7 44 24 08 9d 71 10 	movl   $0xc010719d,0x8(%esp)
c01057c9:	c0 
c01057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d4:	89 04 24             	mov    %eax,(%esp)
c01057d7:	e8 68 fe ff ff       	call   c0105644 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01057dc:	e9 60 02 00 00       	jmp    c0105a41 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c01057e1:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01057e5:	c7 44 24 08 a6 71 10 	movl   $0xc01071a6,0x8(%esp)
c01057ec:	c0 
c01057ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f7:	89 04 24             	mov    %eax,(%esp)
c01057fa:	e8 45 fe ff ff       	call   c0105644 <printfmt>
            break;
c01057ff:	e9 3d 02 00 00       	jmp    c0105a41 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105804:	8b 45 14             	mov    0x14(%ebp),%eax
c0105807:	8d 50 04             	lea    0x4(%eax),%edx
c010580a:	89 55 14             	mov    %edx,0x14(%ebp)
c010580d:	8b 30                	mov    (%eax),%esi
c010580f:	85 f6                	test   %esi,%esi
c0105811:	75 05                	jne    c0105818 <vprintfmt+0x1a3>
                p = "(null)";
c0105813:	be a9 71 10 c0       	mov    $0xc01071a9,%esi
            }
            if (width > 0 && padc != '-') {
c0105818:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010581c:	7e 76                	jle    c0105894 <vprintfmt+0x21f>
c010581e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105822:	74 70                	je     c0105894 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105827:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582b:	89 34 24             	mov    %esi,(%esp)
c010582e:	e8 16 03 00 00       	call   c0105b49 <strnlen>
c0105833:	89 c2                	mov    %eax,%edx
c0105835:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105838:	29 d0                	sub    %edx,%eax
c010583a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010583d:	eb 16                	jmp    c0105855 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010583f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105843:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105846:	89 54 24 04          	mov    %edx,0x4(%esp)
c010584a:	89 04 24             	mov    %eax,(%esp)
c010584d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105850:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105852:	ff 4d e8             	decl   -0x18(%ebp)
c0105855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105859:	7f e4                	jg     c010583f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010585b:	eb 37                	jmp    c0105894 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010585d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105861:	74 1f                	je     c0105882 <vprintfmt+0x20d>
c0105863:	83 fb 1f             	cmp    $0x1f,%ebx
c0105866:	7e 05                	jle    c010586d <vprintfmt+0x1f8>
c0105868:	83 fb 7e             	cmp    $0x7e,%ebx
c010586b:	7e 15                	jle    c0105882 <vprintfmt+0x20d>
                    putch('?', putdat);
c010586d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105870:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105874:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010587b:	8b 45 08             	mov    0x8(%ebp),%eax
c010587e:	ff d0                	call   *%eax
c0105880:	eb 0f                	jmp    c0105891 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105882:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105885:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105889:	89 1c 24             	mov    %ebx,(%esp)
c010588c:	8b 45 08             	mov    0x8(%ebp),%eax
c010588f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105891:	ff 4d e8             	decl   -0x18(%ebp)
c0105894:	89 f0                	mov    %esi,%eax
c0105896:	8d 70 01             	lea    0x1(%eax),%esi
c0105899:	0f b6 00             	movzbl (%eax),%eax
c010589c:	0f be d8             	movsbl %al,%ebx
c010589f:	85 db                	test   %ebx,%ebx
c01058a1:	74 27                	je     c01058ca <vprintfmt+0x255>
c01058a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058a7:	78 b4                	js     c010585d <vprintfmt+0x1e8>
c01058a9:	ff 4d e4             	decl   -0x1c(%ebp)
c01058ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01058b0:	79 ab                	jns    c010585d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01058b2:	eb 16                	jmp    c01058ca <vprintfmt+0x255>
                putch(' ', putdat);
c01058b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01058c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c5:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c01058c7:	ff 4d e8             	decl   -0x18(%ebp)
c01058ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058ce:	7f e4                	jg     c01058b4 <vprintfmt+0x23f>
            }
            break;
c01058d0:	e9 6c 01 00 00       	jmp    c0105a41 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01058d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058dc:	8d 45 14             	lea    0x14(%ebp),%eax
c01058df:	89 04 24             	mov    %eax,(%esp)
c01058e2:	e8 16 fd ff ff       	call   c01055fd <getint>
c01058e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01058ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058f3:	85 d2                	test   %edx,%edx
c01058f5:	79 26                	jns    c010591d <vprintfmt+0x2a8>
                putch('-', putdat);
c01058f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fe:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105905:	8b 45 08             	mov    0x8(%ebp),%eax
c0105908:	ff d0                	call   *%eax
                num = -(long long)num;
c010590a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010590d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105910:	f7 d8                	neg    %eax
c0105912:	83 d2 00             	adc    $0x0,%edx
c0105915:	f7 da                	neg    %edx
c0105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010591a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010591d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105924:	e9 a8 00 00 00       	jmp    c01059d1 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105929:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010592c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105930:	8d 45 14             	lea    0x14(%ebp),%eax
c0105933:	89 04 24             	mov    %eax,(%esp)
c0105936:	e8 73 fc ff ff       	call   c01055ae <getuint>
c010593b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010593e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105941:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105948:	e9 84 00 00 00       	jmp    c01059d1 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010594d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105950:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105954:	8d 45 14             	lea    0x14(%ebp),%eax
c0105957:	89 04 24             	mov    %eax,(%esp)
c010595a:	e8 4f fc ff ff       	call   c01055ae <getuint>
c010595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105962:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105965:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010596c:	eb 63                	jmp    c01059d1 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c010596e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105971:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105975:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010597c:	8b 45 08             	mov    0x8(%ebp),%eax
c010597f:	ff d0                	call   *%eax
            putch('x', putdat);
c0105981:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105984:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105988:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010598f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105992:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105994:	8b 45 14             	mov    0x14(%ebp),%eax
c0105997:	8d 50 04             	lea    0x4(%eax),%edx
c010599a:	89 55 14             	mov    %edx,0x14(%ebp)
c010599d:	8b 00                	mov    (%eax),%eax
c010599f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01059a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01059b0:	eb 1f                	jmp    c01059d1 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01059b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b9:	8d 45 14             	lea    0x14(%ebp),%eax
c01059bc:	89 04 24             	mov    %eax,(%esp)
c01059bf:	e8 ea fb ff ff       	call   c01055ae <getuint>
c01059c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01059ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01059d1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01059d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059d8:	89 54 24 18          	mov    %edx,0x18(%esp)
c01059dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01059df:	89 54 24 14          	mov    %edx,0x14(%esp)
c01059e3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01059e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ff:	89 04 24             	mov    %eax,(%esp)
c0105a02:	e8 a5 fa ff ff       	call   c01054ac <printnum>
            break;
c0105a07:	eb 38                	jmp    c0105a41 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a10:	89 1c 24             	mov    %ebx,(%esp)
c0105a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a16:	ff d0                	call   *%eax
            break;
c0105a18:	eb 27                	jmp    c0105a41 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a21:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105a28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105a2d:	ff 4d 10             	decl   0x10(%ebp)
c0105a30:	eb 03                	jmp    c0105a35 <vprintfmt+0x3c0>
c0105a32:	ff 4d 10             	decl   0x10(%ebp)
c0105a35:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a38:	48                   	dec    %eax
c0105a39:	0f b6 00             	movzbl (%eax),%eax
c0105a3c:	3c 25                	cmp    $0x25,%al
c0105a3e:	75 f2                	jne    c0105a32 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105a40:	90                   	nop
    while (1) {
c0105a41:	e9 37 fc ff ff       	jmp    c010567d <vprintfmt+0x8>
                return;
c0105a46:	90                   	nop
        }
    }
}
c0105a47:	83 c4 40             	add    $0x40,%esp
c0105a4a:	5b                   	pop    %ebx
c0105a4b:	5e                   	pop    %esi
c0105a4c:	5d                   	pop    %ebp
c0105a4d:	c3                   	ret    

c0105a4e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a4e:	55                   	push   %ebp
c0105a4f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a54:	8b 40 08             	mov    0x8(%eax),%eax
c0105a57:	8d 50 01             	lea    0x1(%eax),%edx
c0105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a5d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a63:	8b 10                	mov    (%eax),%edx
c0105a65:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a68:	8b 40 04             	mov    0x4(%eax),%eax
c0105a6b:	39 c2                	cmp    %eax,%edx
c0105a6d:	73 12                	jae    c0105a81 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a72:	8b 00                	mov    (%eax),%eax
c0105a74:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a77:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a7a:	89 0a                	mov    %ecx,(%edx)
c0105a7c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a7f:	88 10                	mov    %dl,(%eax)
    }
}
c0105a81:	90                   	nop
c0105a82:	5d                   	pop    %ebp
c0105a83:	c3                   	ret    

c0105a84 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a84:	55                   	push   %ebp
c0105a85:	89 e5                	mov    %esp,%ebp
c0105a87:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a8a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a97:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa8:	89 04 24             	mov    %eax,(%esp)
c0105aab:	e8 0a 00 00 00       	call   c0105aba <vsnprintf>
c0105ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ab6:	89 ec                	mov    %ebp,%esp
c0105ab8:	5d                   	pop    %ebp
c0105ab9:	c3                   	ret    

c0105aba <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105aba:	55                   	push   %ebp
c0105abb:	89 e5                	mov    %esp,%ebp
c0105abd:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acf:	01 d0                	add    %edx,%eax
c0105ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ad4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105adb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105adf:	74 0a                	je     c0105aeb <vsnprintf+0x31>
c0105ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ae7:	39 c2                	cmp    %eax,%edx
c0105ae9:	76 07                	jbe    c0105af2 <vsnprintf+0x38>
        return -E_INVAL;
c0105aeb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105af0:	eb 2a                	jmp    c0105b1c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105af2:	8b 45 14             	mov    0x14(%ebp),%eax
c0105af5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105af9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105afc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b00:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b07:	c7 04 24 4e 5a 10 c0 	movl   $0xc0105a4e,(%esp)
c0105b0e:	e8 62 fb ff ff       	call   c0105675 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b16:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b1c:	89 ec                	mov    %ebp,%esp
c0105b1e:	5d                   	pop    %ebp
c0105b1f:	c3                   	ret    

c0105b20 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105b20:	55                   	push   %ebp
c0105b21:	89 e5                	mov    %esp,%ebp
c0105b23:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105b2d:	eb 03                	jmp    c0105b32 <strlen+0x12>
        cnt ++;
c0105b2f:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b35:	8d 50 01             	lea    0x1(%eax),%edx
c0105b38:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b3b:	0f b6 00             	movzbl (%eax),%eax
c0105b3e:	84 c0                	test   %al,%al
c0105b40:	75 ed                	jne    c0105b2f <strlen+0xf>
    }
    return cnt;
c0105b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b45:	89 ec                	mov    %ebp,%esp
c0105b47:	5d                   	pop    %ebp
c0105b48:	c3                   	ret    

c0105b49 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b49:	55                   	push   %ebp
c0105b4a:	89 e5                	mov    %esp,%ebp
c0105b4c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b56:	eb 03                	jmp    c0105b5b <strnlen+0x12>
        cnt ++;
c0105b58:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b61:	73 10                	jae    c0105b73 <strnlen+0x2a>
c0105b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b66:	8d 50 01             	lea    0x1(%eax),%edx
c0105b69:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b6c:	0f b6 00             	movzbl (%eax),%eax
c0105b6f:	84 c0                	test   %al,%al
c0105b71:	75 e5                	jne    c0105b58 <strnlen+0xf>
    }
    return cnt;
c0105b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b76:	89 ec                	mov    %ebp,%esp
c0105b78:	5d                   	pop    %ebp
c0105b79:	c3                   	ret    

c0105b7a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b7a:	55                   	push   %ebp
c0105b7b:	89 e5                	mov    %esp,%ebp
c0105b7d:	57                   	push   %edi
c0105b7e:	56                   	push   %esi
c0105b7f:	83 ec 20             	sub    $0x20,%esp
c0105b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b94:	89 d1                	mov    %edx,%ecx
c0105b96:	89 c2                	mov    %eax,%edx
c0105b98:	89 ce                	mov    %ecx,%esi
c0105b9a:	89 d7                	mov    %edx,%edi
c0105b9c:	ac                   	lods   %ds:(%esi),%al
c0105b9d:	aa                   	stos   %al,%es:(%edi)
c0105b9e:	84 c0                	test   %al,%al
c0105ba0:	75 fa                	jne    c0105b9c <strcpy+0x22>
c0105ba2:	89 fa                	mov    %edi,%edx
c0105ba4:	89 f1                	mov    %esi,%ecx
c0105ba6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ba9:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105bb2:	83 c4 20             	add    $0x20,%esp
c0105bb5:	5e                   	pop    %esi
c0105bb6:	5f                   	pop    %edi
c0105bb7:	5d                   	pop    %ebp
c0105bb8:	c3                   	ret    

c0105bb9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105bb9:	55                   	push   %ebp
c0105bba:	89 e5                	mov    %esp,%ebp
c0105bbc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105bc5:	eb 1e                	jmp    c0105be5 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bca:	0f b6 10             	movzbl (%eax),%edx
c0105bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bd0:	88 10                	mov    %dl,(%eax)
c0105bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bd5:	0f b6 00             	movzbl (%eax),%eax
c0105bd8:	84 c0                	test   %al,%al
c0105bda:	74 03                	je     c0105bdf <strncpy+0x26>
            src ++;
c0105bdc:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105bdf:	ff 45 fc             	incl   -0x4(%ebp)
c0105be2:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105be5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105be9:	75 dc                	jne    c0105bc7 <strncpy+0xe>
    }
    return dst;
c0105beb:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bee:	89 ec                	mov    %ebp,%esp
c0105bf0:	5d                   	pop    %ebp
c0105bf1:	c3                   	ret    

c0105bf2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105bf2:	55                   	push   %ebp
c0105bf3:	89 e5                	mov    %esp,%ebp
c0105bf5:	57                   	push   %edi
c0105bf6:	56                   	push   %esi
c0105bf7:	83 ec 20             	sub    $0x20,%esp
c0105bfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c0c:	89 d1                	mov    %edx,%ecx
c0105c0e:	89 c2                	mov    %eax,%edx
c0105c10:	89 ce                	mov    %ecx,%esi
c0105c12:	89 d7                	mov    %edx,%edi
c0105c14:	ac                   	lods   %ds:(%esi),%al
c0105c15:	ae                   	scas   %es:(%edi),%al
c0105c16:	75 08                	jne    c0105c20 <strcmp+0x2e>
c0105c18:	84 c0                	test   %al,%al
c0105c1a:	75 f8                	jne    c0105c14 <strcmp+0x22>
c0105c1c:	31 c0                	xor    %eax,%eax
c0105c1e:	eb 04                	jmp    c0105c24 <strcmp+0x32>
c0105c20:	19 c0                	sbb    %eax,%eax
c0105c22:	0c 01                	or     $0x1,%al
c0105c24:	89 fa                	mov    %edi,%edx
c0105c26:	89 f1                	mov    %esi,%ecx
c0105c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c2b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105c2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105c34:	83 c4 20             	add    $0x20,%esp
c0105c37:	5e                   	pop    %esi
c0105c38:	5f                   	pop    %edi
c0105c39:	5d                   	pop    %ebp
c0105c3a:	c3                   	ret    

c0105c3b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105c3b:	55                   	push   %ebp
c0105c3c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c3e:	eb 09                	jmp    c0105c49 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105c40:	ff 4d 10             	decl   0x10(%ebp)
c0105c43:	ff 45 08             	incl   0x8(%ebp)
c0105c46:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c4d:	74 1a                	je     c0105c69 <strncmp+0x2e>
c0105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c52:	0f b6 00             	movzbl (%eax),%eax
c0105c55:	84 c0                	test   %al,%al
c0105c57:	74 10                	je     c0105c69 <strncmp+0x2e>
c0105c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5c:	0f b6 10             	movzbl (%eax),%edx
c0105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c62:	0f b6 00             	movzbl (%eax),%eax
c0105c65:	38 c2                	cmp    %al,%dl
c0105c67:	74 d7                	je     c0105c40 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c6d:	74 18                	je     c0105c87 <strncmp+0x4c>
c0105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c72:	0f b6 00             	movzbl (%eax),%eax
c0105c75:	0f b6 d0             	movzbl %al,%edx
c0105c78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c7b:	0f b6 00             	movzbl (%eax),%eax
c0105c7e:	0f b6 c8             	movzbl %al,%ecx
c0105c81:	89 d0                	mov    %edx,%eax
c0105c83:	29 c8                	sub    %ecx,%eax
c0105c85:	eb 05                	jmp    c0105c8c <strncmp+0x51>
c0105c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c8c:	5d                   	pop    %ebp
c0105c8d:	c3                   	ret    

c0105c8e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c8e:	55                   	push   %ebp
c0105c8f:	89 e5                	mov    %esp,%ebp
c0105c91:	83 ec 04             	sub    $0x4,%esp
c0105c94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c97:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c9a:	eb 13                	jmp    c0105caf <strchr+0x21>
        if (*s == c) {
c0105c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9f:	0f b6 00             	movzbl (%eax),%eax
c0105ca2:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105ca5:	75 05                	jne    c0105cac <strchr+0x1e>
            return (char *)s;
c0105ca7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105caa:	eb 12                	jmp    c0105cbe <strchr+0x30>
        }
        s ++;
c0105cac:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb2:	0f b6 00             	movzbl (%eax),%eax
c0105cb5:	84 c0                	test   %al,%al
c0105cb7:	75 e3                	jne    c0105c9c <strchr+0xe>
    }
    return NULL;
c0105cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cbe:	89 ec                	mov    %ebp,%esp
c0105cc0:	5d                   	pop    %ebp
c0105cc1:	c3                   	ret    

c0105cc2 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105cc2:	55                   	push   %ebp
c0105cc3:	89 e5                	mov    %esp,%ebp
c0105cc5:	83 ec 04             	sub    $0x4,%esp
c0105cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105cce:	eb 0e                	jmp    c0105cde <strfind+0x1c>
        if (*s == c) {
c0105cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd3:	0f b6 00             	movzbl (%eax),%eax
c0105cd6:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105cd9:	74 0f                	je     c0105cea <strfind+0x28>
            break;
        }
        s ++;
c0105cdb:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce1:	0f b6 00             	movzbl (%eax),%eax
c0105ce4:	84 c0                	test   %al,%al
c0105ce6:	75 e8                	jne    c0105cd0 <strfind+0xe>
c0105ce8:	eb 01                	jmp    c0105ceb <strfind+0x29>
            break;
c0105cea:	90                   	nop
    }
    return (char *)s;
c0105ceb:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105cee:	89 ec                	mov    %ebp,%esp
c0105cf0:	5d                   	pop    %ebp
c0105cf1:	c3                   	ret    

c0105cf2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105cf2:	55                   	push   %ebp
c0105cf3:	89 e5                	mov    %esp,%ebp
c0105cf5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105cf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105d06:	eb 03                	jmp    c0105d0b <strtol+0x19>
        s ++;
c0105d08:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105d0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0e:	0f b6 00             	movzbl (%eax),%eax
c0105d11:	3c 20                	cmp    $0x20,%al
c0105d13:	74 f3                	je     c0105d08 <strtol+0x16>
c0105d15:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d18:	0f b6 00             	movzbl (%eax),%eax
c0105d1b:	3c 09                	cmp    $0x9,%al
c0105d1d:	74 e9                	je     c0105d08 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d22:	0f b6 00             	movzbl (%eax),%eax
c0105d25:	3c 2b                	cmp    $0x2b,%al
c0105d27:	75 05                	jne    c0105d2e <strtol+0x3c>
        s ++;
c0105d29:	ff 45 08             	incl   0x8(%ebp)
c0105d2c:	eb 14                	jmp    c0105d42 <strtol+0x50>
    }
    else if (*s == '-') {
c0105d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d31:	0f b6 00             	movzbl (%eax),%eax
c0105d34:	3c 2d                	cmp    $0x2d,%al
c0105d36:	75 0a                	jne    c0105d42 <strtol+0x50>
        s ++, neg = 1;
c0105d38:	ff 45 08             	incl   0x8(%ebp)
c0105d3b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d46:	74 06                	je     c0105d4e <strtol+0x5c>
c0105d48:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d4c:	75 22                	jne    c0105d70 <strtol+0x7e>
c0105d4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d51:	0f b6 00             	movzbl (%eax),%eax
c0105d54:	3c 30                	cmp    $0x30,%al
c0105d56:	75 18                	jne    c0105d70 <strtol+0x7e>
c0105d58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5b:	40                   	inc    %eax
c0105d5c:	0f b6 00             	movzbl (%eax),%eax
c0105d5f:	3c 78                	cmp    $0x78,%al
c0105d61:	75 0d                	jne    c0105d70 <strtol+0x7e>
        s += 2, base = 16;
c0105d63:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d67:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d6e:	eb 29                	jmp    c0105d99 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d74:	75 16                	jne    c0105d8c <strtol+0x9a>
c0105d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d79:	0f b6 00             	movzbl (%eax),%eax
c0105d7c:	3c 30                	cmp    $0x30,%al
c0105d7e:	75 0c                	jne    c0105d8c <strtol+0x9a>
        s ++, base = 8;
c0105d80:	ff 45 08             	incl   0x8(%ebp)
c0105d83:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d8a:	eb 0d                	jmp    c0105d99 <strtol+0xa7>
    }
    else if (base == 0) {
c0105d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d90:	75 07                	jne    c0105d99 <strtol+0xa7>
        base = 10;
c0105d92:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d99:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9c:	0f b6 00             	movzbl (%eax),%eax
c0105d9f:	3c 2f                	cmp    $0x2f,%al
c0105da1:	7e 1b                	jle    c0105dbe <strtol+0xcc>
c0105da3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da6:	0f b6 00             	movzbl (%eax),%eax
c0105da9:	3c 39                	cmp    $0x39,%al
c0105dab:	7f 11                	jg     c0105dbe <strtol+0xcc>
            dig = *s - '0';
c0105dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db0:	0f b6 00             	movzbl (%eax),%eax
c0105db3:	0f be c0             	movsbl %al,%eax
c0105db6:	83 e8 30             	sub    $0x30,%eax
c0105db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105dbc:	eb 48                	jmp    c0105e06 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105dbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dc1:	0f b6 00             	movzbl (%eax),%eax
c0105dc4:	3c 60                	cmp    $0x60,%al
c0105dc6:	7e 1b                	jle    c0105de3 <strtol+0xf1>
c0105dc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dcb:	0f b6 00             	movzbl (%eax),%eax
c0105dce:	3c 7a                	cmp    $0x7a,%al
c0105dd0:	7f 11                	jg     c0105de3 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd5:	0f b6 00             	movzbl (%eax),%eax
c0105dd8:	0f be c0             	movsbl %al,%eax
c0105ddb:	83 e8 57             	sub    $0x57,%eax
c0105dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105de1:	eb 23                	jmp    c0105e06 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de6:	0f b6 00             	movzbl (%eax),%eax
c0105de9:	3c 40                	cmp    $0x40,%al
c0105deb:	7e 3b                	jle    c0105e28 <strtol+0x136>
c0105ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df0:	0f b6 00             	movzbl (%eax),%eax
c0105df3:	3c 5a                	cmp    $0x5a,%al
c0105df5:	7f 31                	jg     c0105e28 <strtol+0x136>
            dig = *s - 'A' + 10;
c0105df7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfa:	0f b6 00             	movzbl (%eax),%eax
c0105dfd:	0f be c0             	movsbl %al,%eax
c0105e00:	83 e8 37             	sub    $0x37,%eax
c0105e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e09:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105e0c:	7d 19                	jge    c0105e27 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105e0e:	ff 45 08             	incl   0x8(%ebp)
c0105e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e14:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105e18:	89 c2                	mov    %eax,%edx
c0105e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e1d:	01 d0                	add    %edx,%eax
c0105e1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105e22:	e9 72 ff ff ff       	jmp    c0105d99 <strtol+0xa7>
            break;
c0105e27:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105e28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105e2c:	74 08                	je     c0105e36 <strtol+0x144>
        *endptr = (char *) s;
c0105e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e31:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e34:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105e36:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105e3a:	74 07                	je     c0105e43 <strtol+0x151>
c0105e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e3f:	f7 d8                	neg    %eax
c0105e41:	eb 03                	jmp    c0105e46 <strtol+0x154>
c0105e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e46:	89 ec                	mov    %ebp,%esp
c0105e48:	5d                   	pop    %ebp
c0105e49:	c3                   	ret    

c0105e4a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e4a:	55                   	push   %ebp
c0105e4b:	89 e5                	mov    %esp,%ebp
c0105e4d:	83 ec 28             	sub    $0x28,%esp
c0105e50:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105e53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e56:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e59:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e60:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105e63:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105e66:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e6c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e6f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e73:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e76:	89 d7                	mov    %edx,%edi
c0105e78:	f3 aa                	rep stos %al,%es:(%edi)
c0105e7a:	89 fa                	mov    %edi,%edx
c0105e7c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e7f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e85:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105e88:	89 ec                	mov    %ebp,%esp
c0105e8a:	5d                   	pop    %ebp
c0105e8b:	c3                   	ret    

c0105e8c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e8c:	55                   	push   %ebp
c0105e8d:	89 e5                	mov    %esp,%ebp
c0105e8f:	57                   	push   %edi
c0105e90:	56                   	push   %esi
c0105e91:	53                   	push   %ebx
c0105e92:	83 ec 30             	sub    $0x30,%esp
c0105e95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ea1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eaa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105ead:	73 42                	jae    c0105ef1 <memmove+0x65>
c0105eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ebe:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ec1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ec4:	c1 e8 02             	shr    $0x2,%eax
c0105ec7:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ecf:	89 d7                	mov    %edx,%edi
c0105ed1:	89 c6                	mov    %eax,%esi
c0105ed3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ed5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105ed8:	83 e1 03             	and    $0x3,%ecx
c0105edb:	74 02                	je     c0105edf <memmove+0x53>
c0105edd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105edf:	89 f0                	mov    %esi,%eax
c0105ee1:	89 fa                	mov    %edi,%edx
c0105ee3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ee6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ee9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105eef:	eb 36                	jmp    c0105f27 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ef4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105efa:	01 c2                	add    %eax,%edx
c0105efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eff:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f05:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f0b:	89 c1                	mov    %eax,%ecx
c0105f0d:	89 d8                	mov    %ebx,%eax
c0105f0f:	89 d6                	mov    %edx,%esi
c0105f11:	89 c7                	mov    %eax,%edi
c0105f13:	fd                   	std    
c0105f14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f16:	fc                   	cld    
c0105f17:	89 f8                	mov    %edi,%eax
c0105f19:	89 f2                	mov    %esi,%edx
c0105f1b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105f1e:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105f21:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105f27:	83 c4 30             	add    $0x30,%esp
c0105f2a:	5b                   	pop    %ebx
c0105f2b:	5e                   	pop    %esi
c0105f2c:	5f                   	pop    %edi
c0105f2d:	5d                   	pop    %ebp
c0105f2e:	c3                   	ret    

c0105f2f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105f2f:	55                   	push   %ebp
c0105f30:	89 e5                	mov    %esp,%ebp
c0105f32:	57                   	push   %edi
c0105f33:	56                   	push   %esi
c0105f34:	83 ec 20             	sub    $0x20,%esp
c0105f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f43:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f46:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f4c:	c1 e8 02             	shr    $0x2,%eax
c0105f4f:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f57:	89 d7                	mov    %edx,%edi
c0105f59:	89 c6                	mov    %eax,%esi
c0105f5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f5d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f60:	83 e1 03             	and    $0x3,%ecx
c0105f63:	74 02                	je     c0105f67 <memcpy+0x38>
c0105f65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f67:	89 f0                	mov    %esi,%eax
c0105f69:	89 fa                	mov    %edi,%edx
c0105f6b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f71:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f77:	83 c4 20             	add    $0x20,%esp
c0105f7a:	5e                   	pop    %esi
c0105f7b:	5f                   	pop    %edi
c0105f7c:	5d                   	pop    %ebp
c0105f7d:	c3                   	ret    

c0105f7e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f7e:	55                   	push   %ebp
c0105f7f:	89 e5                	mov    %esp,%ebp
c0105f81:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f84:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f90:	eb 2e                	jmp    c0105fc0 <memcmp+0x42>
        if (*s1 != *s2) {
c0105f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f95:	0f b6 10             	movzbl (%eax),%edx
c0105f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f9b:	0f b6 00             	movzbl (%eax),%eax
c0105f9e:	38 c2                	cmp    %al,%dl
c0105fa0:	74 18                	je     c0105fba <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105fa5:	0f b6 00             	movzbl (%eax),%eax
c0105fa8:	0f b6 d0             	movzbl %al,%edx
c0105fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105fae:	0f b6 00             	movzbl (%eax),%eax
c0105fb1:	0f b6 c8             	movzbl %al,%ecx
c0105fb4:	89 d0                	mov    %edx,%eax
c0105fb6:	29 c8                	sub    %ecx,%eax
c0105fb8:	eb 18                	jmp    c0105fd2 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105fba:	ff 45 fc             	incl   -0x4(%ebp)
c0105fbd:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105fc6:	89 55 10             	mov    %edx,0x10(%ebp)
c0105fc9:	85 c0                	test   %eax,%eax
c0105fcb:	75 c5                	jne    c0105f92 <memcmp+0x14>
    }
    return 0;
c0105fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fd2:	89 ec                	mov    %ebp,%esp
c0105fd4:	5d                   	pop    %ebp
c0105fd5:	c3                   	ret    
