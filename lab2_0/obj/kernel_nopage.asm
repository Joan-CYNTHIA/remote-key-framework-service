
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 90 11 40       	mov    $0x40119000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 90 11 00       	mov    %eax,0x119000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  100041:	2d 36 8a 11 00       	sub    $0x118a36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 8a 11 00 	movl   $0x118a36,(%esp)
  100059:	e8 ec 5d 00 00       	call   105e4a <memset>

    cons_init();                // init the console
  10005e:	e8 ea 15 00 00       	call   10164d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 e0 5f 10 00 	movl   $0x105fe0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 fc 5f 10 00 	movl   $0x105ffc,(%esp)
  100078:	e8 d9 02 00 00       	call   100356 <cprintf>

    print_kerninfo();
  10007d:	e8 f7 07 00 00       	call   100879 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 35 43 00 00       	call   1043c1 <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 3d 17 00 00       	call   1017ce <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 c4 18 00 00       	call   10195a <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 11 0d 00 00       	call   100dac <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 8c 16 00 00       	call   10172c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 03 0c 00 00       	call   100cc7 <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
  1000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b0 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000f6:	89 ec                	mov    %ebp,%esp
  1000f8:	5d                   	pop    %ebp
  1000f9:	c3                   	ret    

001000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fa:	55                   	push   %ebp
  1000fb:	89 e5                	mov    %esp,%ebp
  1000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100100:	8b 45 10             	mov    0x10(%ebp),%eax
  100103:	89 44 24 04          	mov    %eax,0x4(%esp)
  100107:	8b 45 08             	mov    0x8(%ebp),%eax
  10010a:	89 04 24             	mov    %eax,(%esp)
  10010d:	e8 b7 ff ff ff       	call   1000c9 <grade_backtrace1>
}
  100112:	90                   	nop
  100113:	89 ec                	mov    %ebp,%esp
  100115:	5d                   	pop    %ebp
  100116:	c3                   	ret    

00100117 <grade_backtrace>:

void
grade_backtrace(void) {
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011d:	b8 36 00 10 00       	mov    $0x100036,%eax
  100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100129:	ff 
  10012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100135:	e8 c0 ff ff ff       	call   1000fa <grade_backtrace0>
}
  10013a:	90                   	nop
  10013b:	89 ec                	mov    %ebp,%esp
  10013d:	5d                   	pop    %ebp
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 01 60 10 00 	movl   $0x106001,(%esp)
  10016e:	e8 e3 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 0f 60 10 00 	movl   $0x10600f,(%esp)
  10018d:	e8 c4 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 1d 60 10 00 	movl   $0x10601d,(%esp)
  1001ac:	e8 a5 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 2b 60 10 00 	movl   $0x10602b,(%esp)
  1001cb:	e8 86 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 39 60 10 00 	movl   $0x106039,(%esp)
  1001ea:	e8 67 01 00 00       	call   100356 <cprintf>
    round ++;
  1001ef:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 b0 11 00       	mov    %eax,0x11b000
}
  1001fa:	90                   	nop
  1001fb:	89 ec                	mov    %ebp,%esp
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100202:	90                   	nop
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100208:	90                   	nop
  100209:	5d                   	pop    %ebp
  10020a:	c3                   	ret    

0010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10020b:	55                   	push   %ebp
  10020c:	89 e5                	mov    %esp,%ebp
  10020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100211:	e8 29 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100216:	c7 04 24 48 60 10 00 	movl   $0x106048,(%esp)
  10021d:	e8 34 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_user();
  100222:	e8 d8 ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100227:	e8 13 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022c:	c7 04 24 68 60 10 00 	movl   $0x106068,(%esp)
  100233:	e8 1e 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_kernel();
  100238:	e8 c8 ff ff ff       	call   100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023d:	e8 fd fe ff ff       	call   10013f <lab1_print_cur_status>
}
  100242:	90                   	nop
  100243:	89 ec                	mov    %ebp,%esp
  100245:	5d                   	pop    %ebp
  100246:	c3                   	ret    

00100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100247:	55                   	push   %ebp
  100248:	89 e5                	mov    %esp,%ebp
  10024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100251:	74 13                	je     100266 <readline+0x1f>
        cprintf("%s", prompt);
  100253:	8b 45 08             	mov    0x8(%ebp),%eax
  100256:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025a:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  100261:	e8 f0 00 00 00       	call   100356 <cprintf>
    }
    int i = 0, c;
  100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10026d:	e8 73 01 00 00       	call   1003e5 <getchar>
  100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100279:	79 07                	jns    100282 <readline+0x3b>
            return NULL;
  10027b:	b8 00 00 00 00       	mov    $0x0,%eax
  100280:	eb 78                	jmp    1002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100286:	7e 28                	jle    1002b0 <readline+0x69>
  100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10028f:	7f 1f                	jg     1002b0 <readline+0x69>
            cputchar(c);
  100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100294:	89 04 24             	mov    %eax,(%esp)
  100297:	e8 e2 00 00 00       	call   10037e <cputchar>
            buf[i ++] = c;
  10029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10029f:	8d 50 01             	lea    0x1(%eax),%edx
  1002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a8:	88 90 20 b0 11 00    	mov    %dl,0x11b020(%eax)
  1002ae:	eb 45                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002b4:	75 16                	jne    1002cc <readline+0x85>
  1002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ba:	7e 10                	jle    1002cc <readline+0x85>
            cputchar(c);
  1002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002bf:	89 04 24             	mov    %eax,(%esp)
  1002c2:	e8 b7 00 00 00       	call   10037e <cputchar>
            i --;
  1002c7:	ff 4d f4             	decl   -0xc(%ebp)
  1002ca:	eb 29                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002d0:	74 06                	je     1002d8 <readline+0x91>
  1002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002d6:	75 95                	jne    10026d <readline+0x26>
            cputchar(c);
  1002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002db:	89 04 24             	mov    %eax,(%esp)
  1002de:	e8 9b 00 00 00       	call   10037e <cputchar>
            buf[i] = '\0';
  1002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002e6:	05 20 b0 11 00       	add    $0x11b020,%eax
  1002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002ee:	b8 20 b0 11 00       	mov    $0x11b020,%eax
  1002f3:	eb 05                	jmp    1002fa <readline+0xb3>
        c = getchar();
  1002f5:	e9 73 ff ff ff       	jmp    10026d <readline+0x26>
        }
    }
}
  1002fa:	89 ec                	mov    %ebp,%esp
  1002fc:	5d                   	pop    %ebp
  1002fd:	c3                   	ret    

001002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002fe:	55                   	push   %ebp
  1002ff:	89 e5                	mov    %esp,%ebp
  100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100304:	8b 45 08             	mov    0x8(%ebp),%eax
  100307:	89 04 24             	mov    %eax,(%esp)
  10030a:	e8 6d 13 00 00       	call   10167c <cons_putc>
    (*cnt) ++;
  10030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100312:	8b 00                	mov    (%eax),%eax
  100314:	8d 50 01             	lea    0x1(%eax),%edx
  100317:	8b 45 0c             	mov    0xc(%ebp),%eax
  10031a:	89 10                	mov    %edx,(%eax)
}
  10031c:	90                   	nop
  10031d:	89 ec                	mov    %ebp,%esp
  10031f:	5d                   	pop    %ebp
  100320:	c3                   	ret    

00100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100321:	55                   	push   %ebp
  100322:	89 e5                	mov    %esp,%ebp
  100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 44 24 08          	mov    %eax,0x8(%esp)
  10033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	c7 04 24 fe 02 10 00 	movl   $0x1002fe,(%esp)
  10034a:	e8 26 53 00 00       	call   105675 <vprintfmt>
    return cnt;
  10034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100352:	89 ec                	mov    %ebp,%esp
  100354:	5d                   	pop    %ebp
  100355:	c3                   	ret    

00100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100356:	55                   	push   %ebp
  100357:	89 e5                	mov    %esp,%ebp
  100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10035c:	8d 45 0c             	lea    0xc(%ebp),%eax
  10035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100365:	89 44 24 04          	mov    %eax,0x4(%esp)
  100369:	8b 45 08             	mov    0x8(%ebp),%eax
  10036c:	89 04 24             	mov    %eax,(%esp)
  10036f:	e8 ad ff ff ff       	call   100321 <vcprintf>
  100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10037a:	89 ec                	mov    %ebp,%esp
  10037c:	5d                   	pop    %ebp
  10037d:	c3                   	ret    

0010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10037e:	55                   	push   %ebp
  10037f:	89 e5                	mov    %esp,%ebp
  100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100384:	8b 45 08             	mov    0x8(%ebp),%eax
  100387:	89 04 24             	mov    %eax,(%esp)
  10038a:	e8 ed 12 00 00       	call   10167c <cons_putc>
}
  10038f:	90                   	nop
  100390:	89 ec                	mov    %ebp,%esp
  100392:	5d                   	pop    %ebp
  100393:	c3                   	ret    

00100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100394:	55                   	push   %ebp
  100395:	89 e5                	mov    %esp,%ebp
  100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003a1:	eb 13                	jmp    1003b6 <cputs+0x22>
        cputch(c, &cnt);
  1003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003ae:	89 04 24             	mov    %eax,(%esp)
  1003b1:	e8 48 ff ff ff       	call   1002fe <cputch>
    while ((c = *str ++) != '\0') {
  1003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1003b9:	8d 50 01             	lea    0x1(%eax),%edx
  1003bc:	89 55 08             	mov    %edx,0x8(%ebp)
  1003bf:	0f b6 00             	movzbl (%eax),%eax
  1003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003c9:	75 d8                	jne    1003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003d9:	e8 20 ff ff ff       	call   1002fe <cputch>
    return cnt;
  1003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003e1:	89 ec                	mov    %ebp,%esp
  1003e3:	5d                   	pop    %ebp
  1003e4:	c3                   	ret    

001003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003e5:	55                   	push   %ebp
  1003e6:	89 e5                	mov    %esp,%ebp
  1003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003eb:	90                   	nop
  1003ec:	e8 ca 12 00 00       	call   1016bb <cons_getc>
  1003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f8:	74 f2                	je     1003ec <getchar+0x7>
        /* do nothing */;
    return c;
  1003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003fd:	89 ec                	mov    %ebp,%esp
  1003ff:	5d                   	pop    %ebp
  100400:	c3                   	ret    

00100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100401:	55                   	push   %ebp
  100402:	89 e5                	mov    %esp,%ebp
  100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100407:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040a:	8b 00                	mov    (%eax),%eax
  10040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10040f:	8b 45 10             	mov    0x10(%ebp),%eax
  100412:	8b 00                	mov    (%eax),%eax
  100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10041e:	e9 ca 00 00 00       	jmp    1004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100429:	01 d0                	add    %edx,%eax
  10042b:	89 c2                	mov    %eax,%edx
  10042d:	c1 ea 1f             	shr    $0x1f,%edx
  100430:	01 d0                	add    %edx,%eax
  100432:	d1 f8                	sar    %eax
  100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10043d:	eb 03                	jmp    100442 <stab_binsearch+0x41>
            m --;
  10043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100448:	7c 1f                	jl     100469 <stab_binsearch+0x68>
  10044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044d:	89 d0                	mov    %edx,%eax
  10044f:	01 c0                	add    %eax,%eax
  100451:	01 d0                	add    %edx,%eax
  100453:	c1 e0 02             	shl    $0x2,%eax
  100456:	89 c2                	mov    %eax,%edx
  100458:	8b 45 08             	mov    0x8(%ebp),%eax
  10045b:	01 d0                	add    %edx,%eax
  10045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100461:	0f b6 c0             	movzbl %al,%eax
  100464:	39 45 14             	cmp    %eax,0x14(%ebp)
  100467:	75 d6                	jne    10043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10046f:	7d 09                	jge    10047a <stab_binsearch+0x79>
            l = true_m + 1;
  100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100474:	40                   	inc    %eax
  100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100478:	eb 73                	jmp    1004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100484:	89 d0                	mov    %edx,%eax
  100486:	01 c0                	add    %eax,%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	c1 e0 02             	shl    $0x2,%eax
  10048d:	89 c2                	mov    %eax,%edx
  10048f:	8b 45 08             	mov    0x8(%ebp),%eax
  100492:	01 d0                	add    %edx,%eax
  100494:	8b 40 08             	mov    0x8(%eax),%eax
  100497:	39 45 18             	cmp    %eax,0x18(%ebp)
  10049a:	76 11                	jbe    1004ad <stab_binsearch+0xac>
            *region_left = m;
  10049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004a7:	40                   	inc    %eax
  1004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ab:	eb 40                	jmp    1004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  1004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b0:	89 d0                	mov    %edx,%eax
  1004b2:	01 c0                	add    %eax,%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	c1 e0 02             	shl    $0x2,%eax
  1004b9:	89 c2                	mov    %eax,%edx
  1004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004be:	01 d0                	add    %edx,%eax
  1004c0:	8b 40 08             	mov    0x8(%eax),%eax
  1004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004c6:	73 14                	jae    1004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	48                   	dec    %eax
  1004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004da:	eb 11                	jmp    1004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e2:	89 10                	mov    %edx,(%eax)
            l = m;
  1004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004f3:	0f 8e 2a ff ff ff    	jle    100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004fd:	75 0f                	jne    10050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 00                	mov    (%eax),%eax
  100504:	8d 50 ff             	lea    -0x1(%eax),%edx
  100507:	8b 45 10             	mov    0x10(%ebp),%eax
  10050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10050c:	eb 3e                	jmp    10054c <stab_binsearch+0x14b>
        l = *region_right;
  10050e:	8b 45 10             	mov    0x10(%ebp),%eax
  100511:	8b 00                	mov    (%eax),%eax
  100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100516:	eb 03                	jmp    10051b <stab_binsearch+0x11a>
  100518:	ff 4d fc             	decl   -0x4(%ebp)
  10051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051e:	8b 00                	mov    (%eax),%eax
  100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100523:	7e 1f                	jle    100544 <stab_binsearch+0x143>
  100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100528:	89 d0                	mov    %edx,%eax
  10052a:	01 c0                	add    %eax,%eax
  10052c:	01 d0                	add    %edx,%eax
  10052e:	c1 e0 02             	shl    $0x2,%eax
  100531:	89 c2                	mov    %eax,%edx
  100533:	8b 45 08             	mov    0x8(%ebp),%eax
  100536:	01 d0                	add    %edx,%eax
  100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053c:	0f b6 c0             	movzbl %al,%eax
  10053f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100542:	75 d4                	jne    100518 <stab_binsearch+0x117>
        *region_left = l;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
}
  10054c:	90                   	nop
  10054d:	89 ec                	mov    %ebp,%esp
  10054f:	5d                   	pop    %ebp
  100550:	c3                   	ret    

00100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100551:	55                   	push   %ebp
  100552:	89 e5                	mov    %esp,%ebp
  100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 00 8c 60 10 00    	movl   $0x10608c,(%eax)
    info->eip_line = 0;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	c7 40 08 8c 60 10 00 	movl   $0x10608c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100581:	8b 55 08             	mov    0x8(%ebp),%edx
  100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100591:	c7 45 f4 08 73 10 00 	movl   $0x107308,-0xc(%ebp)
    stab_end = __STAB_END__;
  100598:	c7 45 f0 5c 2a 11 00 	movl   $0x112a5c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10059f:	c7 45 ec 5d 2a 11 00 	movl   $0x112a5d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005a6:	c7 45 e8 f5 5f 11 00 	movl   $0x115ff5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005b3:	76 0b                	jbe    1005c0 <debuginfo_eip+0x6f>
  1005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b8:	48                   	dec    %eax
  1005b9:	0f b6 00             	movzbl (%eax),%eax
  1005bc:	84 c0                	test   %al,%al
  1005be:	74 0a                	je     1005ca <debuginfo_eip+0x79>
        return -1;
  1005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c5:	e9 ab 02 00 00       	jmp    100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005d7:	c1 f8 02             	sar    $0x2,%eax
  1005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005e0:	48                   	dec    %eax
  1005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005f2:	00 
  1005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100604:	89 04 24             	mov    %eax,(%esp)
  100607:	e8 f5 fd ff ff       	call   100401 <stab_binsearch>
    if (lfile == 0)
  10060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060f:	85 c0                	test   %eax,%eax
  100611:	75 0a                	jne    10061d <debuginfo_eip+0xcc>
        return -1;
  100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100618:	e9 58 02 00 00       	jmp    100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100629:	8b 45 08             	mov    0x8(%ebp),%eax
  10062c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100637:	00 
  100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10063b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100642:	89 44 24 04          	mov    %eax,0x4(%esp)
  100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100649:	89 04 24             	mov    %eax,(%esp)
  10064c:	e8 b0 fd ff ff       	call   100401 <stab_binsearch>

    if (lfun <= rfun) {
  100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100657:	39 c2                	cmp    %eax,%edx
  100659:	7f 78                	jg     1006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	89 d0                	mov    %edx,%eax
  100662:	01 c0                	add    %eax,%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	c1 e0 02             	shl    $0x2,%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066e:	01 d0                	add    %edx,%eax
  100670:	8b 10                	mov    (%eax),%edx
  100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100678:	39 c2                	cmp    %eax,%edx
  10067a:	73 22                	jae    10069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067f:	89 c2                	mov    %eax,%edx
  100681:	89 d0                	mov    %edx,%eax
  100683:	01 c0                	add    %eax,%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	c1 e0 02             	shl    $0x2,%eax
  10068a:	89 c2                	mov    %eax,%edx
  10068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068f:	01 d0                	add    %edx,%eax
  100691:	8b 10                	mov    (%eax),%edx
  100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100696:	01 c2                	add    %eax,%edx
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a1:	89 c2                	mov    %eax,%edx
  1006a3:	89 d0                	mov    %edx,%eax
  1006a5:	01 c0                	add    %eax,%eax
  1006a7:	01 d0                	add    %edx,%eax
  1006a9:	c1 e0 02             	shl    $0x2,%eax
  1006ac:	89 c2                	mov    %eax,%edx
  1006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b1:	01 d0                	add    %edx,%eax
  1006b3:	8b 50 08             	mov    0x8(%eax),%edx
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 10             	mov    0x10(%eax),%eax
  1006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006d1:	eb 15                	jmp    1006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006eb:	8b 40 08             	mov    0x8(%eax),%eax
  1006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006f5:	00 
  1006f6:	89 04 24             	mov    %eax,(%esp)
  1006f9:	e8 c4 55 00 00       	call   105cc2 <strfind>
  1006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  100701:	8b 4a 08             	mov    0x8(%edx),%ecx
  100704:	29 c8                	sub    %ecx,%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10070e:	8b 45 08             	mov    0x8(%ebp),%eax
  100711:	89 44 24 10          	mov    %eax,0x10(%esp)
  100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10071c:	00 
  10071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100720:	89 44 24 08          	mov    %eax,0x8(%esp)
  100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072e:	89 04 24             	mov    %eax,(%esp)
  100731:	e8 cb fc ff ff       	call   100401 <stab_binsearch>
    if (lline <= rline) {
  100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	39 c2                	cmp    %eax,%edx
  10073e:	7f 23                	jg     100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	89 d0                	mov    %edx,%eax
  100747:	01 c0                	add    %eax,%eax
  100749:	01 d0                	add    %edx,%eax
  10074b:	c1 e0 02             	shl    $0x2,%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100761:	eb 11                	jmp    100774 <debuginfo_eip+0x223>
        return -1;
  100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100768:	e9 08 01 00 00       	jmp    100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100770:	48                   	dec    %eax
  100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10077a:	39 c2                	cmp    %eax,%edx
  10077c:	7c 56                	jl     1007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  10077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100797:	3c 84                	cmp    $0x84,%al
  100799:	74 39                	je     1007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079e:	89 c2                	mov    %eax,%edx
  1007a0:	89 d0                	mov    %edx,%eax
  1007a2:	01 c0                	add    %eax,%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	c1 e0 02             	shl    $0x2,%eax
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b4:	3c 64                	cmp    $0x64,%al
  1007b6:	75 b5                	jne    10076d <debuginfo_eip+0x21c>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 40 08             	mov    0x8(%eax),%eax
  1007d0:	85 c0                	test   %eax,%eax
  1007d2:	74 99                	je     10076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	7c 42                	jl     100820 <debuginfo_eip+0x2cf>
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f1:	01 d0                	add    %edx,%eax
  1007f3:	8b 10                	mov    (%eax),%edx
  1007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 46                	jge    100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	40                   	inc    %eax
  10082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100831:	eb 16                	jmp    100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	8b 40 14             	mov    0x14(%eax),%eax
  100839:	8d 50 01             	lea    0x1(%eax),%edx
  10083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100845:	40                   	inc    %eax
  100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7d 1d                	jge    100870 <debuginfo_eip+0x31f>
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c a0                	cmp    $0xa0,%al
  10086e:	74 c3                	je     100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100875:	89 ec                	mov    %ebp,%esp
  100877:	5d                   	pop    %ebp
  100878:	c3                   	ret    

00100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100879:	55                   	push   %ebp
  10087a:	89 e5                	mov    %esp,%ebp
  10087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10087f:	c7 04 24 96 60 10 00 	movl   $0x106096,(%esp)
  100886:	e8 cb fa ff ff       	call   100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088b:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100892:	00 
  100893:	c7 04 24 af 60 10 00 	movl   $0x1060af,(%esp)
  10089a:	e8 b7 fa ff ff       	call   100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10089f:	c7 44 24 04 d6 5f 10 	movl   $0x105fd6,0x4(%esp)
  1008a6:	00 
  1008a7:	c7 04 24 c7 60 10 00 	movl   $0x1060c7,(%esp)
  1008ae:	e8 a3 fa ff ff       	call   100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b3:	c7 44 24 04 36 8a 11 	movl   $0x118a36,0x4(%esp)
  1008ba:	00 
  1008bb:	c7 04 24 df 60 10 00 	movl   $0x1060df,(%esp)
  1008c2:	e8 8f fa ff ff       	call   100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c7:	c7 44 24 04 2c bf 11 	movl   $0x11bf2c,0x4(%esp)
  1008ce:	00 
  1008cf:	c7 04 24 f7 60 10 00 	movl   $0x1060f7,(%esp)
  1008d6:	e8 7b fa ff ff       	call   100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008db:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  1008e0:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f0:	85 c0                	test   %eax,%eax
  1008f2:	0f 48 c2             	cmovs  %edx,%eax
  1008f5:	c1 f8 0a             	sar    $0xa,%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	c7 04 24 10 61 10 00 	movl   $0x106110,(%esp)
  100903:	e8 4e fa ff ff       	call   100356 <cprintf>
}
  100908:	90                   	nop
  100909:	89 ec                	mov    %ebp,%esp
  10090b:	5d                   	pop    %ebp
  10090c:	c3                   	ret    

0010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10090d:	55                   	push   %ebp
  10090e:	89 e5                	mov    %esp,%ebp
  100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10091d:	8b 45 08             	mov    0x8(%ebp),%eax
  100920:	89 04 24             	mov    %eax,(%esp)
  100923:	e8 29 fc ff ff       	call   100551 <debuginfo_eip>
  100928:	85 c0                	test   %eax,%eax
  10092a:	74 15                	je     100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100933:	c7 04 24 3a 61 10 00 	movl   $0x10613a,(%esp)
  10093a:	e8 17 fa ff ff       	call   100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10093f:	eb 6c                	jmp    1009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100948:	eb 1b                	jmp    100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  10094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	0f b6 10             	movzbl (%eax),%edx
  100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095e:	01 c8                	add    %ecx,%eax
  100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100962:	ff 45 f4             	incl   -0xc(%ebp)
  100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10096b:	7c dd                	jl     10094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
  10096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100976:	01 d0                	add    %edx,%eax
  100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  10097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10097e:	8b 45 08             	mov    0x8(%ebp),%eax
  100981:	29 d0                	sub    %edx,%eax
  100983:	89 c1                	mov    %eax,%ecx
  100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100999:	89 54 24 08          	mov    %edx,0x8(%esp)
  10099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a1:	c7 04 24 56 61 10 00 	movl   $0x106156,(%esp)
  1009a8:	e8 a9 f9 ff ff       	call   100356 <cprintf>
}
  1009ad:	90                   	nop
  1009ae:	89 ec                	mov    %ebp,%esp
  1009b0:	5d                   	pop    %ebp
  1009b1:	c3                   	ret    

001009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b2:	55                   	push   %ebp
  1009b3:	89 e5                	mov    %esp,%ebp
  1009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009b8:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c1:	89 ec                	mov    %ebp,%esp
  1009c3:	5d                   	pop    %ebp
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
  1009c8:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cb:	89 e8                	mov    %ebp,%eax
  1009cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009d6:	e8 d7 ff ff ff       	call   1009b2 <read_eip>
  1009db:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e5:	e9 84 00 00 00       	jmp    100a6e <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  1009ff:	e8 52 f9 ff ff       	call   100356 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a07:	83 c0 08             	add    $0x8,%eax
  100a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a14:	eb 24                	jmp    100a3a <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  100a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	8b 00                	mov    (%eax),%eax
  100a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2b:	c7 04 24 84 61 10 00 	movl   $0x106184,(%esp)
  100a32:	e8 1f f9 ff ff       	call   100356 <cprintf>
        for (j = 0; j < 4; j ++) {
  100a37:	ff 45 e8             	incl   -0x18(%ebp)
  100a3a:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3e:	7e d6                	jle    100a16 <print_stackframe+0x51>
        }
        cprintf("\n");
  100a40:	c7 04 24 8c 61 10 00 	movl   $0x10618c,(%esp)
  100a47:	e8 0a f9 ff ff       	call   100356 <cprintf>
        print_debuginfo(eip - 1);
  100a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4f:	48                   	dec    %eax
  100a50:	89 04 24             	mov    %eax,(%esp)
  100a53:	e8 b5 fe ff ff       	call   10090d <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5b:	83 c0 04             	add    $0x4,%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a66:	8b 00                	mov    (%eax),%eax
  100a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a6b:	ff 45 ec             	incl   -0x14(%ebp)
  100a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a72:	74 0a                	je     100a7e <print_stackframe+0xb9>
  100a74:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a78:	0f 8e 6c ff ff ff    	jle    1009ea <print_stackframe+0x25>
    }
}
  100a7e:	90                   	nop
  100a7f:	89 ec                	mov    %ebp,%esp
  100a81:	5d                   	pop    %ebp
  100a82:	c3                   	ret    

00100a83 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a83:	55                   	push   %ebp
  100a84:	89 e5                	mov    %esp,%ebp
  100a86:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a90:	eb 0c                	jmp    100a9e <parse+0x1b>
            *buf ++ = '\0';
  100a92:	8b 45 08             	mov    0x8(%ebp),%eax
  100a95:	8d 50 01             	lea    0x1(%eax),%edx
  100a98:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	84 c0                	test   %al,%al
  100aa6:	74 1d                	je     100ac5 <parse+0x42>
  100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aab:	0f b6 00             	movzbl (%eax),%eax
  100aae:	0f be c0             	movsbl %al,%eax
  100ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab5:	c7 04 24 10 62 10 00 	movl   $0x106210,(%esp)
  100abc:	e8 cd 51 00 00       	call   105c8e <strchr>
  100ac1:	85 c0                	test   %eax,%eax
  100ac3:	75 cd                	jne    100a92 <parse+0xf>
        }
        if (*buf == '\0') {
  100ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac8:	0f b6 00             	movzbl (%eax),%eax
  100acb:	84 c0                	test   %al,%al
  100acd:	74 65                	je     100b34 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100acf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad3:	75 14                	jne    100ae9 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adc:	00 
  100add:	c7 04 24 15 62 10 00 	movl   $0x106215,(%esp)
  100ae4:	e8 6d f8 ff ff       	call   100356 <cprintf>
        }
        argv[argc ++] = buf;
  100ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aec:	8d 50 01             	lea    0x1(%eax),%edx
  100aef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afc:	01 c2                	add    %eax,%edx
  100afe:	8b 45 08             	mov    0x8(%ebp),%eax
  100b01:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b03:	eb 03                	jmp    100b08 <parse+0x85>
            buf ++;
  100b05:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 8c                	je     100a9e <parse+0x1b>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 10 62 10 00 	movl   $0x106210,(%esp)
  100b26:	e8 63 51 00 00       	call   105c8e <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d6                	je     100b05 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2f:	e9 6a ff ff ff       	jmp    100a9e <parse+0x1b>
            break;
  100b34:	90                   	nop
        }
    }
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	89 ec                	mov    %ebp,%esp
  100b3a:	5d                   	pop    %ebp
  100b3b:	c3                   	ret    

00100b3c <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3c:	55                   	push   %ebp
  100b3d:	89 e5                	mov    %esp,%ebp
  100b3f:	83 ec 68             	sub    $0x68,%esp
  100b42:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b45:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4f:	89 04 24             	mov    %eax,(%esp)
  100b52:	e8 2c ff ff ff       	call   100a83 <parse>
  100b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5e:	75 0a                	jne    100b6a <runcmd+0x2e>
        return 0;
  100b60:	b8 00 00 00 00       	mov    $0x0,%eax
  100b65:	e9 83 00 00 00       	jmp    100bed <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b71:	eb 5a                	jmp    100bcd <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b73:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b76:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b79:	89 c8                	mov    %ecx,%eax
  100b7b:	01 c0                	add    %eax,%eax
  100b7d:	01 c8                	add    %ecx,%eax
  100b7f:	c1 e0 02             	shl    $0x2,%eax
  100b82:	05 00 80 11 00       	add    $0x118000,%eax
  100b87:	8b 00                	mov    (%eax),%eax
  100b89:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8d:	89 04 24             	mov    %eax,(%esp)
  100b90:	e8 5d 50 00 00       	call   105bf2 <strcmp>
  100b95:	85 c0                	test   %eax,%eax
  100b97:	75 31                	jne    100bca <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9c:	89 d0                	mov    %edx,%eax
  100b9e:	01 c0                	add    %eax,%eax
  100ba0:	01 d0                	add    %edx,%eax
  100ba2:	c1 e0 02             	shl    $0x2,%eax
  100ba5:	05 08 80 11 00       	add    $0x118008,%eax
  100baa:	8b 10                	mov    (%eax),%edx
  100bac:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100baf:	83 c0 04             	add    $0x4,%eax
  100bb2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bb5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc3:	89 1c 24             	mov    %ebx,(%esp)
  100bc6:	ff d2                	call   *%edx
  100bc8:	eb 23                	jmp    100bed <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bca:	ff 45 f4             	incl   -0xc(%ebp)
  100bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd0:	83 f8 02             	cmp    $0x2,%eax
  100bd3:	76 9e                	jbe    100b73 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdc:	c7 04 24 33 62 10 00 	movl   $0x106233,(%esp)
  100be3:	e8 6e f7 ff ff       	call   100356 <cprintf>
    return 0;
  100be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bf0:	89 ec                	mov    %ebp,%esp
  100bf2:	5d                   	pop    %ebp
  100bf3:	c3                   	ret    

00100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf4:	55                   	push   %ebp
  100bf5:	89 e5                	mov    %esp,%ebp
  100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bfa:	c7 04 24 4c 62 10 00 	movl   $0x10624c,(%esp)
  100c01:	e8 50 f7 ff ff       	call   100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c06:	c7 04 24 74 62 10 00 	movl   $0x106274,(%esp)
  100c0d:	e8 44 f7 ff ff       	call   100356 <cprintf>

    if (tf != NULL) {
  100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c16:	74 0b                	je     100c23 <kmonitor+0x2f>
        print_trapframe(tf);
  100c18:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1b:	89 04 24             	mov    %eax,(%esp)
  100c1e:	e8 74 0e 00 00       	call   101a97 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c23:	c7 04 24 99 62 10 00 	movl   $0x106299,(%esp)
  100c2a:	e8 18 f6 ff ff       	call   100247 <readline>
  100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c36:	74 eb                	je     100c23 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c38:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c42:	89 04 24             	mov    %eax,(%esp)
  100c45:	e8 f2 fe ff ff       	call   100b3c <runcmd>
  100c4a:	85 c0                	test   %eax,%eax
  100c4c:	78 02                	js     100c50 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c4e:	eb d3                	jmp    100c23 <kmonitor+0x2f>
                break;
  100c50:	90                   	nop
            }
        }
    }
}
  100c51:	90                   	nop
  100c52:	89 ec                	mov    %ebp,%esp
  100c54:	5d                   	pop    %ebp
  100c55:	c3                   	ret    

00100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c56:	55                   	push   %ebp
  100c57:	89 e5                	mov    %esp,%ebp
  100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c63:	eb 3d                	jmp    100ca2 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c68:	89 d0                	mov    %edx,%eax
  100c6a:	01 c0                	add    %eax,%eax
  100c6c:	01 d0                	add    %edx,%eax
  100c6e:	c1 e0 02             	shl    $0x2,%eax
  100c71:	05 04 80 11 00       	add    $0x118004,%eax
  100c76:	8b 10                	mov    (%eax),%edx
  100c78:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c7b:	89 c8                	mov    %ecx,%eax
  100c7d:	01 c0                	add    %eax,%eax
  100c7f:	01 c8                	add    %ecx,%eax
  100c81:	c1 e0 02             	shl    $0x2,%eax
  100c84:	05 00 80 11 00       	add    $0x118000,%eax
  100c89:	8b 00                	mov    (%eax),%eax
  100c8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c93:	c7 04 24 9d 62 10 00 	movl   $0x10629d,(%esp)
  100c9a:	e8 b7 f6 ff ff       	call   100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9f:	ff 45 f4             	incl   -0xc(%ebp)
  100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca5:	83 f8 02             	cmp    $0x2,%eax
  100ca8:	76 bb                	jbe    100c65 <mon_help+0xf>
    }
    return 0;
  100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100caf:	89 ec                	mov    %ebp,%esp
  100cb1:	5d                   	pop    %ebp
  100cb2:	c3                   	ret    

00100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb9:	e8 bb fb ff ff       	call   100879 <print_kerninfo>
    return 0;
  100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc3:	89 ec                	mov    %ebp,%esp
  100cc5:	5d                   	pop    %ebp
  100cc6:	c3                   	ret    

00100cc7 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ccd:	e8 f3 fc ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd7:	89 ec                	mov    %ebp,%esp
  100cd9:	5d                   	pop    %ebp
  100cda:	c3                   	ret    

00100cdb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cdb:	55                   	push   %ebp
  100cdc:	89 e5                	mov    %esp,%ebp
  100cde:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ce1:	a1 20 b4 11 00       	mov    0x11b420,%eax
  100ce6:	85 c0                	test   %eax,%eax
  100ce8:	75 5b                	jne    100d45 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cea:	c7 05 20 b4 11 00 01 	movl   $0x1,0x11b420
  100cf1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cf4:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cfd:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d01:	8b 45 08             	mov    0x8(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	c7 04 24 a6 62 10 00 	movl   $0x1062a6,(%esp)
  100d0f:	e8 42 f6 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d17:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1b:	8b 45 10             	mov    0x10(%ebp),%eax
  100d1e:	89 04 24             	mov    %eax,(%esp)
  100d21:	e8 fb f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d26:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100d2d:	e8 24 f6 ff ff       	call   100356 <cprintf>
    
    cprintf("stack trackback:\n");
  100d32:	c7 04 24 c4 62 10 00 	movl   $0x1062c4,(%esp)
  100d39:	e8 18 f6 ff ff       	call   100356 <cprintf>
    print_stackframe();
  100d3e:	e8 82 fc ff ff       	call   1009c5 <print_stackframe>
  100d43:	eb 01                	jmp    100d46 <__panic+0x6b>
        goto panic_dead;
  100d45:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d46:	e8 e9 09 00 00       	call   101734 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d52:	e8 9d fe ff ff       	call   100bf4 <kmonitor>
  100d57:	eb f2                	jmp    100d4b <__panic+0x70>

00100d59 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d59:	55                   	push   %ebp
  100d5a:	89 e5                	mov    %esp,%ebp
  100d5c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d5f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d68:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d73:	c7 04 24 d6 62 10 00 	movl   $0x1062d6,(%esp)
  100d7a:	e8 d7 f5 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d86:	8b 45 10             	mov    0x10(%ebp),%eax
  100d89:	89 04 24             	mov    %eax,(%esp)
  100d8c:	e8 90 f5 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100d91:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100d98:	e8 b9 f5 ff ff       	call   100356 <cprintf>
    va_end(ap);
}
  100d9d:	90                   	nop
  100d9e:	89 ec                	mov    %ebp,%esp
  100da0:	5d                   	pop    %ebp
  100da1:	c3                   	ret    

00100da2 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100da2:	55                   	push   %ebp
  100da3:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100da5:	a1 20 b4 11 00       	mov    0x11b420,%eax
}
  100daa:	5d                   	pop    %ebp
  100dab:	c3                   	ret    

00100dac <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dac:	55                   	push   %ebp
  100dad:	89 e5                	mov    %esp,%ebp
  100daf:	83 ec 28             	sub    $0x28,%esp
  100db2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100db8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dbc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc4:	ee                   	out    %al,(%dx)
}
  100dc5:	90                   	nop
  100dc6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dcc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dd0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dd4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dd8:	ee                   	out    %al,(%dx)
}
  100dd9:	90                   	nop
  100dda:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100de0:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100de4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100de8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dec:	ee                   	out    %al,(%dx)
}
  100ded:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dee:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  100df5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100df8:	c7 04 24 f4 62 10 00 	movl   $0x1062f4,(%esp)
  100dff:	e8 52 f5 ff ff       	call   100356 <cprintf>
    pic_enable(IRQ_TIMER);
  100e04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e0b:	e8 89 09 00 00       	call   101799 <pic_enable>
}
  100e10:	90                   	nop
  100e11:	89 ec                	mov    %ebp,%esp
  100e13:	5d                   	pop    %ebp
  100e14:	c3                   	ret    

00100e15 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e15:	55                   	push   %ebp
  100e16:	89 e5                	mov    %esp,%ebp
  100e18:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e1b:	9c                   	pushf  
  100e1c:	58                   	pop    %eax
  100e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e23:	25 00 02 00 00       	and    $0x200,%eax
  100e28:	85 c0                	test   %eax,%eax
  100e2a:	74 0c                	je     100e38 <__intr_save+0x23>
        intr_disable();
  100e2c:	e8 03 09 00 00       	call   101734 <intr_disable>
        return 1;
  100e31:	b8 01 00 00 00       	mov    $0x1,%eax
  100e36:	eb 05                	jmp    100e3d <__intr_save+0x28>
    }
    return 0;
  100e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e3d:	89 ec                	mov    %ebp,%esp
  100e3f:	5d                   	pop    %ebp
  100e40:	c3                   	ret    

00100e41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e41:	55                   	push   %ebp
  100e42:	89 e5                	mov    %esp,%ebp
  100e44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e4b:	74 05                	je     100e52 <__intr_restore+0x11>
        intr_enable();
  100e4d:	e8 da 08 00 00       	call   10172c <intr_enable>
    }
}
  100e52:	90                   	nop
  100e53:	89 ec                	mov    %ebp,%esp
  100e55:	5d                   	pop    %ebp
  100e56:	c3                   	ret    

00100e57 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e57:	55                   	push   %ebp
  100e58:	89 e5                	mov    %esp,%ebp
  100e5a:	83 ec 10             	sub    $0x10,%esp
  100e5d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e63:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e6d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e73:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e77:	89 c2                	mov    %eax,%edx
  100e79:	ec                   	in     (%dx),%al
  100e7a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e7d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e83:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e87:	89 c2                	mov    %eax,%edx
  100e89:	ec                   	in     (%dx),%al
  100e8a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e8d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e93:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e97:	89 c2                	mov    %eax,%edx
  100e99:	ec                   	in     (%dx),%al
  100e9a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e9d:	90                   	nop
  100e9e:	89 ec                	mov    %ebp,%esp
  100ea0:	5d                   	pop    %ebp
  100ea1:	c3                   	ret    

00100ea2 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ea2:	55                   	push   %ebp
  100ea3:	89 e5                	mov    %esp,%ebp
  100ea5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ea8:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb2:	0f b7 00             	movzwl (%eax),%eax
  100eb5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec4:	0f b7 00             	movzwl (%eax),%eax
  100ec7:	0f b7 c0             	movzwl %ax,%eax
  100eca:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ecf:	74 12                	je     100ee3 <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ed1:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ed8:	66 c7 05 46 b4 11 00 	movw   $0x3b4,0x11b446
  100edf:	b4 03 
  100ee1:	eb 13                	jmp    100ef6 <cga_init+0x54>
    } else {
        *cp = was;
  100ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eea:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eed:	66 c7 05 46 b4 11 00 	movw   $0x3d4,0x11b446
  100ef4:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ef6:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100efd:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f01:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f05:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f09:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f0d:	ee                   	out    %al,(%dx)
}
  100f0e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f0f:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f16:	40                   	inc    %eax
  100f17:	0f b7 c0             	movzwl %ax,%eax
  100f1a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f1e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f22:	89 c2                	mov    %eax,%edx
  100f24:	ec                   	in     (%dx),%al
  100f25:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f28:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f2c:	0f b6 c0             	movzbl %al,%eax
  100f2f:	c1 e0 08             	shl    $0x8,%eax
  100f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f35:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f3c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f40:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f44:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f48:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f4c:	ee                   	out    %al,(%dx)
}
  100f4d:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f4e:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100f55:	40                   	inc    %eax
  100f56:	0f b7 c0             	movzwl %ax,%eax
  100f59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f5d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f61:	89 c2                	mov    %eax,%edx
  100f63:	ec                   	in     (%dx),%al
  100f64:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f67:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f6b:	0f b6 c0             	movzbl %al,%eax
  100f6e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f74:	a3 40 b4 11 00       	mov    %eax,0x11b440
    crt_pos = pos;
  100f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f7c:	0f b7 c0             	movzwl %ax,%eax
  100f7f:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
}
  100f85:	90                   	nop
  100f86:	89 ec                	mov    %ebp,%esp
  100f88:	5d                   	pop    %ebp
  100f89:	c3                   	ret    

00100f8a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f8a:	55                   	push   %ebp
  100f8b:	89 e5                	mov    %esp,%ebp
  100f8d:	83 ec 48             	sub    $0x48,%esp
  100f90:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f96:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f9a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f9e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
}
  100fa3:	90                   	nop
  100fa4:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100faa:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fae:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fb2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100fb6:	ee                   	out    %al,(%dx)
}
  100fb7:	90                   	nop
  100fb8:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fbe:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fc6:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fca:	ee                   	out    %al,(%dx)
}
  100fcb:	90                   	nop
  100fcc:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd2:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fd6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fda:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fde:	ee                   	out    %al,(%dx)
}
  100fdf:	90                   	nop
  100fe0:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fe6:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ff2:	ee                   	out    %al,(%dx)
}
  100ff3:	90                   	nop
  100ff4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100ffa:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ffe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101002:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101006:	ee                   	out    %al,(%dx)
}
  101007:	90                   	nop
  101008:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10100e:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101012:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101016:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10101a:	ee                   	out    %al,(%dx)
}
  10101b:	90                   	nop
  10101c:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101022:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101026:	89 c2                	mov    %eax,%edx
  101028:	ec                   	in     (%dx),%al
  101029:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10102c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101030:	3c ff                	cmp    $0xff,%al
  101032:	0f 95 c0             	setne  %al
  101035:	0f b6 c0             	movzbl %al,%eax
  101038:	a3 48 b4 11 00       	mov    %eax,0x11b448
  10103d:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101043:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101047:	89 c2                	mov    %eax,%edx
  101049:	ec                   	in     (%dx),%al
  10104a:	88 45 f1             	mov    %al,-0xf(%ebp)
  10104d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101053:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101057:	89 c2                	mov    %eax,%edx
  101059:	ec                   	in     (%dx),%al
  10105a:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10105d:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101062:	85 c0                	test   %eax,%eax
  101064:	74 0c                	je     101072 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  101066:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10106d:	e8 27 07 00 00       	call   101799 <pic_enable>
    }
}
  101072:	90                   	nop
  101073:	89 ec                	mov    %ebp,%esp
  101075:	5d                   	pop    %ebp
  101076:	c3                   	ret    

00101077 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101077:	55                   	push   %ebp
  101078:	89 e5                	mov    %esp,%ebp
  10107a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101084:	eb 08                	jmp    10108e <lpt_putc_sub+0x17>
        delay();
  101086:	e8 cc fd ff ff       	call   100e57 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10108b:	ff 45 fc             	incl   -0x4(%ebp)
  10108e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101094:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101098:	89 c2                	mov    %eax,%edx
  10109a:	ec                   	in     (%dx),%al
  10109b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10109e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010a2:	84 c0                	test   %al,%al
  1010a4:	78 09                	js     1010af <lpt_putc_sub+0x38>
  1010a6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010ad:	7e d7                	jle    101086 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  1010af:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b2:	0f b6 c0             	movzbl %al,%eax
  1010b5:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010bb:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010be:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010c2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010c6:	ee                   	out    %al,(%dx)
}
  1010c7:	90                   	nop
  1010c8:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010ce:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010d2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010d6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010da:	ee                   	out    %al,(%dx)
}
  1010db:	90                   	nop
  1010dc:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010e2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010ea:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010ee:	ee                   	out    %al,(%dx)
}
  1010ef:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010f0:	90                   	nop
  1010f1:	89 ec                	mov    %ebp,%esp
  1010f3:	5d                   	pop    %ebp
  1010f4:	c3                   	ret    

001010f5 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010f5:	55                   	push   %ebp
  1010f6:	89 e5                	mov    %esp,%ebp
  1010f8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010fb:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010ff:	74 0d                	je     10110e <lpt_putc+0x19>
        lpt_putc_sub(c);
  101101:	8b 45 08             	mov    0x8(%ebp),%eax
  101104:	89 04 24             	mov    %eax,(%esp)
  101107:	e8 6b ff ff ff       	call   101077 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10110c:	eb 24                	jmp    101132 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10110e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101115:	e8 5d ff ff ff       	call   101077 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10111a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101121:	e8 51 ff ff ff       	call   101077 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101126:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10112d:	e8 45 ff ff ff       	call   101077 <lpt_putc_sub>
}
  101132:	90                   	nop
  101133:	89 ec                	mov    %ebp,%esp
  101135:	5d                   	pop    %ebp
  101136:	c3                   	ret    

00101137 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101137:	55                   	push   %ebp
  101138:	89 e5                	mov    %esp,%ebp
  10113a:	83 ec 38             	sub    $0x38,%esp
  10113d:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  101140:	8b 45 08             	mov    0x8(%ebp),%eax
  101143:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101148:	85 c0                	test   %eax,%eax
  10114a:	75 07                	jne    101153 <cga_putc+0x1c>
        c |= 0x0700;
  10114c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101153:	8b 45 08             	mov    0x8(%ebp),%eax
  101156:	0f b6 c0             	movzbl %al,%eax
  101159:	83 f8 0d             	cmp    $0xd,%eax
  10115c:	74 72                	je     1011d0 <cga_putc+0x99>
  10115e:	83 f8 0d             	cmp    $0xd,%eax
  101161:	0f 8f a3 00 00 00    	jg     10120a <cga_putc+0xd3>
  101167:	83 f8 08             	cmp    $0x8,%eax
  10116a:	74 0a                	je     101176 <cga_putc+0x3f>
  10116c:	83 f8 0a             	cmp    $0xa,%eax
  10116f:	74 4c                	je     1011bd <cga_putc+0x86>
  101171:	e9 94 00 00 00       	jmp    10120a <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  101176:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10117d:	85 c0                	test   %eax,%eax
  10117f:	0f 84 af 00 00 00    	je     101234 <cga_putc+0xfd>
            crt_pos --;
  101185:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10118c:	48                   	dec    %eax
  10118d:	0f b7 c0             	movzwl %ax,%eax
  101190:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101196:	8b 45 08             	mov    0x8(%ebp),%eax
  101199:	98                   	cwtl   
  10119a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10119f:	98                   	cwtl   
  1011a0:	83 c8 20             	or     $0x20,%eax
  1011a3:	98                   	cwtl   
  1011a4:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  1011aa:	0f b7 15 44 b4 11 00 	movzwl 0x11b444,%edx
  1011b1:	01 d2                	add    %edx,%edx
  1011b3:	01 ca                	add    %ecx,%edx
  1011b5:	0f b7 c0             	movzwl %ax,%eax
  1011b8:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011bb:	eb 77                	jmp    101234 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  1011bd:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1011c4:	83 c0 50             	add    $0x50,%eax
  1011c7:	0f b7 c0             	movzwl %ax,%eax
  1011ca:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011d0:	0f b7 1d 44 b4 11 00 	movzwl 0x11b444,%ebx
  1011d7:	0f b7 0d 44 b4 11 00 	movzwl 0x11b444,%ecx
  1011de:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011e3:	89 c8                	mov    %ecx,%eax
  1011e5:	f7 e2                	mul    %edx
  1011e7:	c1 ea 06             	shr    $0x6,%edx
  1011ea:	89 d0                	mov    %edx,%eax
  1011ec:	c1 e0 02             	shl    $0x2,%eax
  1011ef:	01 d0                	add    %edx,%eax
  1011f1:	c1 e0 04             	shl    $0x4,%eax
  1011f4:	29 c1                	sub    %eax,%ecx
  1011f6:	89 ca                	mov    %ecx,%edx
  1011f8:	0f b7 d2             	movzwl %dx,%edx
  1011fb:	89 d8                	mov    %ebx,%eax
  1011fd:	29 d0                	sub    %edx,%eax
  1011ff:	0f b7 c0             	movzwl %ax,%eax
  101202:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
        break;
  101208:	eb 2b                	jmp    101235 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10120a:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  101210:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101217:	8d 50 01             	lea    0x1(%eax),%edx
  10121a:	0f b7 d2             	movzwl %dx,%edx
  10121d:	66 89 15 44 b4 11 00 	mov    %dx,0x11b444
  101224:	01 c0                	add    %eax,%eax
  101226:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101229:	8b 45 08             	mov    0x8(%ebp),%eax
  10122c:	0f b7 c0             	movzwl %ax,%eax
  10122f:	66 89 02             	mov    %ax,(%edx)
        break;
  101232:	eb 01                	jmp    101235 <cga_putc+0xfe>
        break;
  101234:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101235:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10123c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101241:	76 5e                	jbe    1012a1 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101243:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101248:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10124e:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101253:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10125a:	00 
  10125b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10125f:	89 04 24             	mov    %eax,(%esp)
  101262:	e8 25 4c 00 00       	call   105e8c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101267:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10126e:	eb 15                	jmp    101285 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101270:	8b 15 40 b4 11 00    	mov    0x11b440,%edx
  101276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101279:	01 c0                	add    %eax,%eax
  10127b:	01 d0                	add    %edx,%eax
  10127d:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101282:	ff 45 f4             	incl   -0xc(%ebp)
  101285:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10128c:	7e e2                	jle    101270 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  10128e:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101295:	83 e8 50             	sub    $0x50,%eax
  101298:	0f b7 c0             	movzwl %ax,%eax
  10129b:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012a1:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012a8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012ac:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012ba:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1012c1:	c1 e8 08             	shr    $0x8,%eax
  1012c4:	0f b7 c0             	movzwl %ax,%eax
  1012c7:	0f b6 c0             	movzbl %al,%eax
  1012ca:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  1012d1:	42                   	inc    %edx
  1012d2:	0f b7 d2             	movzwl %dx,%edx
  1012d5:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012d9:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012dc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012e0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012e4:	ee                   	out    %al,(%dx)
}
  1012e5:	90                   	nop
    outb(addr_6845, 15);
  1012e6:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1012ed:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012f1:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012f9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012fd:	ee                   	out    %al,(%dx)
}
  1012fe:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012ff:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101306:	0f b6 c0             	movzbl %al,%eax
  101309:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  101310:	42                   	inc    %edx
  101311:	0f b7 d2             	movzwl %dx,%edx
  101314:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101318:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10131b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10131f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101323:	ee                   	out    %al,(%dx)
}
  101324:	90                   	nop
}
  101325:	90                   	nop
  101326:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101329:	89 ec                	mov    %ebp,%esp
  10132b:	5d                   	pop    %ebp
  10132c:	c3                   	ret    

0010132d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10132d:	55                   	push   %ebp
  10132e:	89 e5                	mov    %esp,%ebp
  101330:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101333:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10133a:	eb 08                	jmp    101344 <serial_putc_sub+0x17>
        delay();
  10133c:	e8 16 fb ff ff       	call   100e57 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101341:	ff 45 fc             	incl   -0x4(%ebp)
  101344:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10134a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10134e:	89 c2                	mov    %eax,%edx
  101350:	ec                   	in     (%dx),%al
  101351:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101354:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101358:	0f b6 c0             	movzbl %al,%eax
  10135b:	83 e0 20             	and    $0x20,%eax
  10135e:	85 c0                	test   %eax,%eax
  101360:	75 09                	jne    10136b <serial_putc_sub+0x3e>
  101362:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101369:	7e d1                	jle    10133c <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10136b:	8b 45 08             	mov    0x8(%ebp),%eax
  10136e:	0f b6 c0             	movzbl %al,%eax
  101371:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101377:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10137a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10137e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101382:	ee                   	out    %al,(%dx)
}
  101383:	90                   	nop
}
  101384:	90                   	nop
  101385:	89 ec                	mov    %ebp,%esp
  101387:	5d                   	pop    %ebp
  101388:	c3                   	ret    

00101389 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101389:	55                   	push   %ebp
  10138a:	89 e5                	mov    %esp,%ebp
  10138c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10138f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101393:	74 0d                	je     1013a2 <serial_putc+0x19>
        serial_putc_sub(c);
  101395:	8b 45 08             	mov    0x8(%ebp),%eax
  101398:	89 04 24             	mov    %eax,(%esp)
  10139b:	e8 8d ff ff ff       	call   10132d <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013a0:	eb 24                	jmp    1013c6 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1013a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013a9:	e8 7f ff ff ff       	call   10132d <serial_putc_sub>
        serial_putc_sub(' ');
  1013ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013b5:	e8 73 ff ff ff       	call   10132d <serial_putc_sub>
        serial_putc_sub('\b');
  1013ba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013c1:	e8 67 ff ff ff       	call   10132d <serial_putc_sub>
}
  1013c6:	90                   	nop
  1013c7:	89 ec                	mov    %ebp,%esp
  1013c9:	5d                   	pop    %ebp
  1013ca:	c3                   	ret    

001013cb <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013cb:	55                   	push   %ebp
  1013cc:	89 e5                	mov    %esp,%ebp
  1013ce:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013d1:	eb 33                	jmp    101406 <cons_intr+0x3b>
        if (c != 0) {
  1013d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013d7:	74 2d                	je     101406 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013d9:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013de:	8d 50 01             	lea    0x1(%eax),%edx
  1013e1:	89 15 64 b6 11 00    	mov    %edx,0x11b664
  1013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ea:	88 90 60 b4 11 00    	mov    %dl,0x11b460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013f0:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1013f5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013fa:	75 0a                	jne    101406 <cons_intr+0x3b>
                cons.wpos = 0;
  1013fc:	c7 05 64 b6 11 00 00 	movl   $0x0,0x11b664
  101403:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101406:	8b 45 08             	mov    0x8(%ebp),%eax
  101409:	ff d0                	call   *%eax
  10140b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10140e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101412:	75 bf                	jne    1013d3 <cons_intr+0x8>
            }
        }
    }
}
  101414:	90                   	nop
  101415:	90                   	nop
  101416:	89 ec                	mov    %ebp,%esp
  101418:	5d                   	pop    %ebp
  101419:	c3                   	ret    

0010141a <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10141a:	55                   	push   %ebp
  10141b:	89 e5                	mov    %esp,%ebp
  10141d:	83 ec 10             	sub    $0x10,%esp
  101420:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101426:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10142a:	89 c2                	mov    %eax,%edx
  10142c:	ec                   	in     (%dx),%al
  10142d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101430:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101434:	0f b6 c0             	movzbl %al,%eax
  101437:	83 e0 01             	and    $0x1,%eax
  10143a:	85 c0                	test   %eax,%eax
  10143c:	75 07                	jne    101445 <serial_proc_data+0x2b>
        return -1;
  10143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101443:	eb 2a                	jmp    10146f <serial_proc_data+0x55>
  101445:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10144f:	89 c2                	mov    %eax,%edx
  101451:	ec                   	in     (%dx),%al
  101452:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101455:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101459:	0f b6 c0             	movzbl %al,%eax
  10145c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10145f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101463:	75 07                	jne    10146c <serial_proc_data+0x52>
        c = '\b';
  101465:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10146f:	89 ec                	mov    %ebp,%esp
  101471:	5d                   	pop    %ebp
  101472:	c3                   	ret    

00101473 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101473:	55                   	push   %ebp
  101474:	89 e5                	mov    %esp,%ebp
  101476:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101479:	a1 48 b4 11 00       	mov    0x11b448,%eax
  10147e:	85 c0                	test   %eax,%eax
  101480:	74 0c                	je     10148e <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101482:	c7 04 24 1a 14 10 00 	movl   $0x10141a,(%esp)
  101489:	e8 3d ff ff ff       	call   1013cb <cons_intr>
    }
}
  10148e:	90                   	nop
  10148f:	89 ec                	mov    %ebp,%esp
  101491:	5d                   	pop    %ebp
  101492:	c3                   	ret    

00101493 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101493:	55                   	push   %ebp
  101494:	89 e5                	mov    %esp,%ebp
  101496:	83 ec 38             	sub    $0x38,%esp
  101499:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014a2:	89 c2                	mov    %eax,%edx
  1014a4:	ec                   	in     (%dx),%al
  1014a5:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014ac:	0f b6 c0             	movzbl %al,%eax
  1014af:	83 e0 01             	and    $0x1,%eax
  1014b2:	85 c0                	test   %eax,%eax
  1014b4:	75 0a                	jne    1014c0 <kbd_proc_data+0x2d>
        return -1;
  1014b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014bb:	e9 56 01 00 00       	jmp    101616 <kbd_proc_data+0x183>
  1014c0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014c9:	89 c2                	mov    %eax,%edx
  1014cb:	ec                   	in     (%dx),%al
  1014cc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014cf:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014d3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014d6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014da:	75 17                	jne    1014f3 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1014dc:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014e1:	83 c8 40             	or     $0x40,%eax
  1014e4:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  1014e9:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ee:	e9 23 01 00 00       	jmp    101616 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  1014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f7:	84 c0                	test   %al,%al
  1014f9:	79 45                	jns    101540 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014fb:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101500:	83 e0 40             	and    $0x40,%eax
  101503:	85 c0                	test   %eax,%eax
  101505:	75 08                	jne    10150f <kbd_proc_data+0x7c>
  101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150b:	24 7f                	and    $0x7f,%al
  10150d:	eb 04                	jmp    101513 <kbd_proc_data+0x80>
  10150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101513:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101516:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151a:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101521:	0c 40                	or     $0x40,%al
  101523:	0f b6 c0             	movzbl %al,%eax
  101526:	f7 d0                	not    %eax
  101528:	89 c2                	mov    %eax,%edx
  10152a:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10152f:	21 d0                	and    %edx,%eax
  101531:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  101536:	b8 00 00 00 00       	mov    $0x0,%eax
  10153b:	e9 d6 00 00 00       	jmp    101616 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101540:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101545:	83 e0 40             	and    $0x40,%eax
  101548:	85 c0                	test   %eax,%eax
  10154a:	74 11                	je     10155d <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10154c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101550:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101555:	83 e0 bf             	and    $0xffffffbf,%eax
  101558:	a3 68 b6 11 00       	mov    %eax,0x11b668
    }

    shift |= shiftcode[data];
  10155d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101561:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101568:	0f b6 d0             	movzbl %al,%edx
  10156b:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101570:	09 d0                	or     %edx,%eax
  101572:	a3 68 b6 11 00       	mov    %eax,0x11b668
    shift ^= togglecode[data];
  101577:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157b:	0f b6 80 40 81 11 00 	movzbl 0x118140(%eax),%eax
  101582:	0f b6 d0             	movzbl %al,%edx
  101585:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10158a:	31 d0                	xor    %edx,%eax
  10158c:	a3 68 b6 11 00       	mov    %eax,0x11b668

    c = charcode[shift & (CTL | SHIFT)][data];
  101591:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101596:	83 e0 03             	and    $0x3,%eax
  101599:	8b 14 85 40 85 11 00 	mov    0x118540(,%eax,4),%edx
  1015a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a4:	01 d0                	add    %edx,%eax
  1015a6:	0f b6 00             	movzbl (%eax),%eax
  1015a9:	0f b6 c0             	movzbl %al,%eax
  1015ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015af:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015b4:	83 e0 08             	and    $0x8,%eax
  1015b7:	85 c0                	test   %eax,%eax
  1015b9:	74 22                	je     1015dd <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1015bb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015bf:	7e 0c                	jle    1015cd <kbd_proc_data+0x13a>
  1015c1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015c5:	7f 06                	jg     1015cd <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1015c7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015cb:	eb 10                	jmp    1015dd <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1015cd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015d1:	7e 0a                	jle    1015dd <kbd_proc_data+0x14a>
  1015d3:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015d7:	7f 04                	jg     1015dd <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1015d9:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015dd:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1015e2:	f7 d0                	not    %eax
  1015e4:	83 e0 06             	and    $0x6,%eax
  1015e7:	85 c0                	test   %eax,%eax
  1015e9:	75 28                	jne    101613 <kbd_proc_data+0x180>
  1015eb:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015f2:	75 1f                	jne    101613 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  1015f4:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  1015fb:	e8 56 ed ff ff       	call   100356 <cprintf>
  101600:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101606:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10160a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10160e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101611:	ee                   	out    %al,(%dx)
}
  101612:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101613:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101616:	89 ec                	mov    %ebp,%esp
  101618:	5d                   	pop    %ebp
  101619:	c3                   	ret    

0010161a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10161a:	55                   	push   %ebp
  10161b:	89 e5                	mov    %esp,%ebp
  10161d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101620:	c7 04 24 93 14 10 00 	movl   $0x101493,(%esp)
  101627:	e8 9f fd ff ff       	call   1013cb <cons_intr>
}
  10162c:	90                   	nop
  10162d:	89 ec                	mov    %ebp,%esp
  10162f:	5d                   	pop    %ebp
  101630:	c3                   	ret    

00101631 <kbd_init>:

static void
kbd_init(void) {
  101631:	55                   	push   %ebp
  101632:	89 e5                	mov    %esp,%ebp
  101634:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101637:	e8 de ff ff ff       	call   10161a <kbd_intr>
    pic_enable(IRQ_KBD);
  10163c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101643:	e8 51 01 00 00       	call   101799 <pic_enable>
}
  101648:	90                   	nop
  101649:	89 ec                	mov    %ebp,%esp
  10164b:	5d                   	pop    %ebp
  10164c:	c3                   	ret    

0010164d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10164d:	55                   	push   %ebp
  10164e:	89 e5                	mov    %esp,%ebp
  101650:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101653:	e8 4a f8 ff ff       	call   100ea2 <cga_init>
    serial_init();
  101658:	e8 2d f9 ff ff       	call   100f8a <serial_init>
    kbd_init();
  10165d:	e8 cf ff ff ff       	call   101631 <kbd_init>
    if (!serial_exists) {
  101662:	a1 48 b4 11 00       	mov    0x11b448,%eax
  101667:	85 c0                	test   %eax,%eax
  101669:	75 0c                	jne    101677 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10166b:	c7 04 24 1b 63 10 00 	movl   $0x10631b,(%esp)
  101672:	e8 df ec ff ff       	call   100356 <cprintf>
    }
}
  101677:	90                   	nop
  101678:	89 ec                	mov    %ebp,%esp
  10167a:	5d                   	pop    %ebp
  10167b:	c3                   	ret    

0010167c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
  10167f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101682:	e8 8e f7 ff ff       	call   100e15 <__intr_save>
  101687:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	89 04 24             	mov    %eax,(%esp)
  101690:	e8 60 fa ff ff       	call   1010f5 <lpt_putc>
        cga_putc(c);
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 97 fa ff ff       	call   101137 <cga_putc>
        serial_putc(c);
  1016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a3:	89 04 24             	mov    %eax,(%esp)
  1016a6:	e8 de fc ff ff       	call   101389 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ae:	89 04 24             	mov    %eax,(%esp)
  1016b1:	e8 8b f7 ff ff       	call   100e41 <__intr_restore>
}
  1016b6:	90                   	nop
  1016b7:	89 ec                	mov    %ebp,%esp
  1016b9:	5d                   	pop    %ebp
  1016ba:	c3                   	ret    

001016bb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016bb:	55                   	push   %ebp
  1016bc:	89 e5                	mov    %esp,%ebp
  1016be:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016c8:	e8 48 f7 ff ff       	call   100e15 <__intr_save>
  1016cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016d0:	e8 9e fd ff ff       	call   101473 <serial_intr>
        kbd_intr();
  1016d5:	e8 40 ff ff ff       	call   10161a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016da:	8b 15 60 b6 11 00    	mov    0x11b660,%edx
  1016e0:	a1 64 b6 11 00       	mov    0x11b664,%eax
  1016e5:	39 c2                	cmp    %eax,%edx
  1016e7:	74 31                	je     10171a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1016e9:	a1 60 b6 11 00       	mov    0x11b660,%eax
  1016ee:	8d 50 01             	lea    0x1(%eax),%edx
  1016f1:	89 15 60 b6 11 00    	mov    %edx,0x11b660
  1016f7:	0f b6 80 60 b4 11 00 	movzbl 0x11b460(%eax),%eax
  1016fe:	0f b6 c0             	movzbl %al,%eax
  101701:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101704:	a1 60 b6 11 00       	mov    0x11b660,%eax
  101709:	3d 00 02 00 00       	cmp    $0x200,%eax
  10170e:	75 0a                	jne    10171a <cons_getc+0x5f>
                cons.rpos = 0;
  101710:	c7 05 60 b6 11 00 00 	movl   $0x0,0x11b660
  101717:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10171d:	89 04 24             	mov    %eax,(%esp)
  101720:	e8 1c f7 ff ff       	call   100e41 <__intr_restore>
    return c;
  101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101728:	89 ec                	mov    %ebp,%esp
  10172a:	5d                   	pop    %ebp
  10172b:	c3                   	ret    

0010172c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10172c:	55                   	push   %ebp
  10172d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10172f:	fb                   	sti    
}
  101730:	90                   	nop
    sti();
}
  101731:	90                   	nop
  101732:	5d                   	pop    %ebp
  101733:	c3                   	ret    

00101734 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101734:	55                   	push   %ebp
  101735:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101737:	fa                   	cli    
}
  101738:	90                   	nop
    cli();
}
  101739:	90                   	nop
  10173a:	5d                   	pop    %ebp
  10173b:	c3                   	ret    

0010173c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10173c:	55                   	push   %ebp
  10173d:	89 e5                	mov    %esp,%ebp
  10173f:	83 ec 14             	sub    $0x14,%esp
  101742:	8b 45 08             	mov    0x8(%ebp),%eax
  101745:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10174c:	66 a3 50 85 11 00    	mov    %ax,0x118550
    if (did_init) {
  101752:	a1 6c b6 11 00       	mov    0x11b66c,%eax
  101757:	85 c0                	test   %eax,%eax
  101759:	74 39                	je     101794 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  10175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10175e:	0f b6 c0             	movzbl %al,%eax
  101761:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101767:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10176a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101772:	ee                   	out    %al,(%dx)
}
  101773:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101774:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101778:	c1 e8 08             	shr    $0x8,%eax
  10177b:	0f b7 c0             	movzwl %ax,%eax
  10177e:	0f b6 c0             	movzbl %al,%eax
  101781:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101787:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10178a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10178e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
}
  101793:	90                   	nop
    }
}
  101794:	90                   	nop
  101795:	89 ec                	mov    %ebp,%esp
  101797:	5d                   	pop    %ebp
  101798:	c3                   	ret    

00101799 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101799:	55                   	push   %ebp
  10179a:	89 e5                	mov    %esp,%ebp
  10179c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10179f:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a2:	ba 01 00 00 00       	mov    $0x1,%edx
  1017a7:	88 c1                	mov    %al,%cl
  1017a9:	d3 e2                	shl    %cl,%edx
  1017ab:	89 d0                	mov    %edx,%eax
  1017ad:	98                   	cwtl   
  1017ae:	f7 d0                	not    %eax
  1017b0:	0f bf d0             	movswl %ax,%edx
  1017b3:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  1017ba:	98                   	cwtl   
  1017bb:	21 d0                	and    %edx,%eax
  1017bd:	98                   	cwtl   
  1017be:	0f b7 c0             	movzwl %ax,%eax
  1017c1:	89 04 24             	mov    %eax,(%esp)
  1017c4:	e8 73 ff ff ff       	call   10173c <pic_setmask>
}
  1017c9:	90                   	nop
  1017ca:	89 ec                	mov    %ebp,%esp
  1017cc:	5d                   	pop    %ebp
  1017cd:	c3                   	ret    

001017ce <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017ce:	55                   	push   %ebp
  1017cf:	89 e5                	mov    %esp,%ebp
  1017d1:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017d4:	c7 05 6c b6 11 00 01 	movl   $0x1,0x11b66c
  1017db:	00 00 00 
  1017de:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017e4:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e8:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ec:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
}
  1017f1:	90                   	nop
  1017f2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017f8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017fc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101800:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101804:	ee                   	out    %al,(%dx)
}
  101805:	90                   	nop
  101806:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10180c:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101810:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101814:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101818:	ee                   	out    %al,(%dx)
}
  101819:	90                   	nop
  10181a:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101820:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101824:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101828:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10182c:	ee                   	out    %al,(%dx)
}
  10182d:	90                   	nop
  10182e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101834:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101838:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10183c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
}
  101841:	90                   	nop
  101842:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101848:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101850:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
}
  101855:	90                   	nop
  101856:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10185c:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101868:	ee                   	out    %al,(%dx)
}
  101869:	90                   	nop
  10186a:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101870:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101874:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101878:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10187c:	ee                   	out    %al,(%dx)
}
  10187d:	90                   	nop
  10187e:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101884:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101888:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10188c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101890:	ee                   	out    %al,(%dx)
}
  101891:	90                   	nop
  101892:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101898:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018a0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018a4:	ee                   	out    %al,(%dx)
}
  1018a5:	90                   	nop
  1018a6:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018ac:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1018b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1018b8:	ee                   	out    %al,(%dx)
}
  1018b9:	90                   	nop
  1018ba:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1018c0:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018c8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018cc:	ee                   	out    %al,(%dx)
}
  1018cd:	90                   	nop
  1018ce:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018d4:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018dc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018e0:	ee                   	out    %al,(%dx)
}
  1018e1:	90                   	nop
  1018e2:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018e8:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ec:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018f0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018f4:	ee                   	out    %al,(%dx)
}
  1018f5:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018f6:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  1018fd:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101902:	74 0f                	je     101913 <pic_init+0x145>
        pic_setmask(irq_mask);
  101904:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  10190b:	89 04 24             	mov    %eax,(%esp)
  10190e:	e8 29 fe ff ff       	call   10173c <pic_setmask>
    }
}
  101913:	90                   	nop
  101914:	89 ec                	mov    %ebp,%esp
  101916:	5d                   	pop    %ebp
  101917:	c3                   	ret    

00101918 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101918:	55                   	push   %ebp
  101919:	89 e5                	mov    %esp,%ebp
  10191b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10191e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101925:	00 
  101926:	c7 04 24 40 63 10 00 	movl   $0x106340,(%esp)
  10192d:	e8 24 ea ff ff       	call   100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101932:	c7 04 24 4a 63 10 00 	movl   $0x10634a,(%esp)
  101939:	e8 18 ea ff ff       	call   100356 <cprintf>
    panic("EOT: kernel seems ok.");
  10193e:	c7 44 24 08 58 63 10 	movl   $0x106358,0x8(%esp)
  101945:	00 
  101946:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10194d:	00 
  10194e:	c7 04 24 6e 63 10 00 	movl   $0x10636e,(%esp)
  101955:	e8 81 f3 ff ff       	call   100cdb <__panic>

0010195a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10195a:	55                   	push   %ebp
  10195b:	89 e5                	mov    %esp,%ebp
  10195d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101960:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101967:	e9 c4 00 00 00       	jmp    101a30 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101976:	0f b7 d0             	movzwl %ax,%edx
  101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197c:	66 89 14 c5 80 b6 11 	mov    %dx,0x11b680(,%eax,8)
  101983:	00 
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	66 c7 04 c5 82 b6 11 	movw   $0x8,0x11b682(,%eax,8)
  10198e:	00 08 00 
  101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101994:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  10199b:	00 
  10199c:	80 e2 e0             	and    $0xe0,%dl
  10199f:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a9:	0f b6 14 c5 84 b6 11 	movzbl 0x11b684(,%eax,8),%edx
  1019b0:	00 
  1019b1:	80 e2 1f             	and    $0x1f,%dl
  1019b4:	88 14 c5 84 b6 11 00 	mov    %dl,0x11b684(,%eax,8)
  1019bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019be:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019c5:	00 
  1019c6:	80 e2 f0             	and    $0xf0,%dl
  1019c9:	80 ca 0e             	or     $0xe,%dl
  1019cc:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d6:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019dd:	00 
  1019de:	80 e2 ef             	and    $0xef,%dl
  1019e1:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019eb:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  1019f2:	00 
  1019f3:	80 e2 9f             	and    $0x9f,%dl
  1019f6:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  1019fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a00:	0f b6 14 c5 85 b6 11 	movzbl 0x11b685(,%eax,8),%edx
  101a07:	00 
  101a08:	80 ca 80             	or     $0x80,%dl
  101a0b:	88 14 c5 85 b6 11 00 	mov    %dl,0x11b685(,%eax,8)
  101a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a15:	8b 04 85 e0 85 11 00 	mov    0x1185e0(,%eax,4),%eax
  101a1c:	c1 e8 10             	shr    $0x10,%eax
  101a1f:	0f b7 d0             	movzwl %ax,%edx
  101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a25:	66 89 14 c5 86 b6 11 	mov    %dx,0x11b686(,%eax,8)
  101a2c:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a2d:	ff 45 fc             	incl   -0x4(%ebp)
  101a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a33:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a38:	0f 86 2e ff ff ff    	jbe    10196c <idt_init+0x12>
  101a3e:	c7 45 f8 60 85 11 00 	movl   $0x118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a48:	0f 01 18             	lidtl  (%eax)
}
  101a4b:	90                   	nop
    }
    lidt(&idt_pd);
}
  101a4c:	90                   	nop
  101a4d:	89 ec                	mov    %ebp,%esp
  101a4f:	5d                   	pop    %ebp
  101a50:	c3                   	ret    

00101a51 <trapname>:

static const char *
trapname(int trapno) {
  101a51:	55                   	push   %ebp
  101a52:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a54:	8b 45 08             	mov    0x8(%ebp),%eax
  101a57:	83 f8 13             	cmp    $0x13,%eax
  101a5a:	77 0c                	ja     101a68 <trapname+0x17>
        return excnames[trapno];
  101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5f:	8b 04 85 c0 66 10 00 	mov    0x1066c0(,%eax,4),%eax
  101a66:	eb 18                	jmp    101a80 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a68:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a6c:	7e 0d                	jle    101a7b <trapname+0x2a>
  101a6e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a72:	7f 07                	jg     101a7b <trapname+0x2a>
        return "Hardware Interrupt";
  101a74:	b8 7f 63 10 00       	mov    $0x10637f,%eax
  101a79:	eb 05                	jmp    101a80 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a7b:	b8 92 63 10 00       	mov    $0x106392,%eax
}
  101a80:	5d                   	pop    %ebp
  101a81:	c3                   	ret    

00101a82 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a82:	55                   	push   %ebp
  101a83:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a85:	8b 45 08             	mov    0x8(%ebp),%eax
  101a88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a8c:	83 f8 08             	cmp    $0x8,%eax
  101a8f:	0f 94 c0             	sete   %al
  101a92:	0f b6 c0             	movzbl %al,%eax
}
  101a95:	5d                   	pop    %ebp
  101a96:	c3                   	ret    

00101a97 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a97:	55                   	push   %ebp
  101a98:	89 e5                	mov    %esp,%ebp
  101a9a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa4:	c7 04 24 d3 63 10 00 	movl   $0x1063d3,(%esp)
  101aab:	e8 a6 e8 ff ff       	call   100356 <cprintf>
    print_regs(&tf->tf_regs);
  101ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab3:	89 04 24             	mov    %eax,(%esp)
  101ab6:	e8 8f 01 00 00       	call   101c4a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101abb:	8b 45 08             	mov    0x8(%ebp),%eax
  101abe:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac6:	c7 04 24 e4 63 10 00 	movl   $0x1063e4,(%esp)
  101acd:	e8 84 e8 ff ff       	call   100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101add:	c7 04 24 f7 63 10 00 	movl   $0x1063f7,(%esp)
  101ae4:	e8 6d e8 ff ff       	call   100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af4:	c7 04 24 0a 64 10 00 	movl   $0x10640a,(%esp)
  101afb:	e8 56 e8 ff ff       	call   100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b00:	8b 45 08             	mov    0x8(%ebp),%eax
  101b03:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0b:	c7 04 24 1d 64 10 00 	movl   $0x10641d,(%esp)
  101b12:	e8 3f e8 ff ff       	call   100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b17:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1a:	8b 40 30             	mov    0x30(%eax),%eax
  101b1d:	89 04 24             	mov    %eax,(%esp)
  101b20:	e8 2c ff ff ff       	call   101a51 <trapname>
  101b25:	8b 55 08             	mov    0x8(%ebp),%edx
  101b28:	8b 52 30             	mov    0x30(%edx),%edx
  101b2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b2f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b33:	c7 04 24 30 64 10 00 	movl   $0x106430,(%esp)
  101b3a:	e8 17 e8 ff ff       	call   100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b42:	8b 40 34             	mov    0x34(%eax),%eax
  101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b49:	c7 04 24 42 64 10 00 	movl   $0x106442,(%esp)
  101b50:	e8 01 e8 ff ff       	call   100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	8b 40 38             	mov    0x38(%eax),%eax
  101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5f:	c7 04 24 51 64 10 00 	movl   $0x106451,(%esp)
  101b66:	e8 eb e7 ff ff       	call   100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b76:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  101b7d:	e8 d4 e7 ff ff       	call   100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	8b 40 40             	mov    0x40(%eax),%eax
  101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8c:	c7 04 24 73 64 10 00 	movl   $0x106473,(%esp)
  101b93:	e8 be e7 ff ff       	call   100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ba6:	eb 3d                	jmp    101be5 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bab:	8b 50 40             	mov    0x40(%eax),%edx
  101bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bb1:	21 d0                	and    %edx,%eax
  101bb3:	85 c0                	test   %eax,%eax
  101bb5:	74 28                	je     101bdf <print_trapframe+0x148>
  101bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bba:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101bc1:	85 c0                	test   %eax,%eax
  101bc3:	74 1a                	je     101bdf <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc8:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd3:	c7 04 24 82 64 10 00 	movl   $0x106482,(%esp)
  101bda:	e8 77 e7 ff ff       	call   100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bdf:	ff 45 f4             	incl   -0xc(%ebp)
  101be2:	d1 65 f0             	shll   -0x10(%ebp)
  101be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101be8:	83 f8 17             	cmp    $0x17,%eax
  101beb:	76 bb                	jbe    101ba8 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	8b 40 40             	mov    0x40(%eax),%eax
  101bf3:	c1 e8 0c             	shr    $0xc,%eax
  101bf6:	83 e0 03             	and    $0x3,%eax
  101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfd:	c7 04 24 86 64 10 00 	movl   $0x106486,(%esp)
  101c04:	e8 4d e7 ff ff       	call   100356 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	89 04 24             	mov    %eax,(%esp)
  101c0f:	e8 6e fe ff ff       	call   101a82 <trap_in_kernel>
  101c14:	85 c0                	test   %eax,%eax
  101c16:	75 2d                	jne    101c45 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c18:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1b:	8b 40 44             	mov    0x44(%eax),%eax
  101c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c22:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
  101c29:	e8 28 e7 ff ff       	call   100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c31:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c39:	c7 04 24 9e 64 10 00 	movl   $0x10649e,(%esp)
  101c40:	e8 11 e7 ff ff       	call   100356 <cprintf>
    }
}
  101c45:	90                   	nop
  101c46:	89 ec                	mov    %ebp,%esp
  101c48:	5d                   	pop    %ebp
  101c49:	c3                   	ret    

00101c4a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c4a:	55                   	push   %ebp
  101c4b:	89 e5                	mov    %esp,%ebp
  101c4d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 00                	mov    (%eax),%eax
  101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c59:	c7 04 24 b1 64 10 00 	movl   $0x1064b1,(%esp)
  101c60:	e8 f1 e6 ff ff       	call   100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c65:	8b 45 08             	mov    0x8(%ebp),%eax
  101c68:	8b 40 04             	mov    0x4(%eax),%eax
  101c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6f:	c7 04 24 c0 64 10 00 	movl   $0x1064c0,(%esp)
  101c76:	e8 db e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7e:	8b 40 08             	mov    0x8(%eax),%eax
  101c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c85:	c7 04 24 cf 64 10 00 	movl   $0x1064cf,(%esp)
  101c8c:	e8 c5 e6 ff ff       	call   100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c91:	8b 45 08             	mov    0x8(%ebp),%eax
  101c94:	8b 40 0c             	mov    0xc(%eax),%eax
  101c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9b:	c7 04 24 de 64 10 00 	movl   $0x1064de,(%esp)
  101ca2:	e8 af e6 ff ff       	call   100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  101caa:	8b 40 10             	mov    0x10(%eax),%eax
  101cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb1:	c7 04 24 ed 64 10 00 	movl   $0x1064ed,(%esp)
  101cb8:	e8 99 e6 ff ff       	call   100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc0:	8b 40 14             	mov    0x14(%eax),%eax
  101cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc7:	c7 04 24 fc 64 10 00 	movl   $0x1064fc,(%esp)
  101cce:	e8 83 e6 ff ff       	call   100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd6:	8b 40 18             	mov    0x18(%eax),%eax
  101cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdd:	c7 04 24 0b 65 10 00 	movl   $0x10650b,(%esp)
  101ce4:	e8 6d e6 ff ff       	call   100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cec:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf3:	c7 04 24 1a 65 10 00 	movl   $0x10651a,(%esp)
  101cfa:	e8 57 e6 ff ff       	call   100356 <cprintf>
}
  101cff:	90                   	nop
  101d00:	89 ec                	mov    %ebp,%esp
  101d02:	5d                   	pop    %ebp
  101d03:	c3                   	ret    

00101d04 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d04:	55                   	push   %ebp
  101d05:	89 e5                	mov    %esp,%ebp
  101d07:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0d:	8b 40 30             	mov    0x30(%eax),%eax
  101d10:	83 f8 79             	cmp    $0x79,%eax
  101d13:	0f 87 e6 00 00 00    	ja     101dff <trap_dispatch+0xfb>
  101d19:	83 f8 78             	cmp    $0x78,%eax
  101d1c:	0f 83 c1 00 00 00    	jae    101de3 <trap_dispatch+0xdf>
  101d22:	83 f8 2f             	cmp    $0x2f,%eax
  101d25:	0f 87 d4 00 00 00    	ja     101dff <trap_dispatch+0xfb>
  101d2b:	83 f8 2e             	cmp    $0x2e,%eax
  101d2e:	0f 83 00 01 00 00    	jae    101e34 <trap_dispatch+0x130>
  101d34:	83 f8 24             	cmp    $0x24,%eax
  101d37:	74 5e                	je     101d97 <trap_dispatch+0x93>
  101d39:	83 f8 24             	cmp    $0x24,%eax
  101d3c:	0f 87 bd 00 00 00    	ja     101dff <trap_dispatch+0xfb>
  101d42:	83 f8 20             	cmp    $0x20,%eax
  101d45:	74 0a                	je     101d51 <trap_dispatch+0x4d>
  101d47:	83 f8 21             	cmp    $0x21,%eax
  101d4a:	74 71                	je     101dbd <trap_dispatch+0xb9>
  101d4c:	e9 ae 00 00 00       	jmp    101dff <trap_dispatch+0xfb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d51:	a1 24 b4 11 00       	mov    0x11b424,%eax
  101d56:	40                   	inc    %eax
  101d57:	a3 24 b4 11 00       	mov    %eax,0x11b424
        if (ticks % TICK_NUM == 0) {
  101d5c:	8b 0d 24 b4 11 00    	mov    0x11b424,%ecx
  101d62:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d67:	89 c8                	mov    %ecx,%eax
  101d69:	f7 e2                	mul    %edx
  101d6b:	c1 ea 05             	shr    $0x5,%edx
  101d6e:	89 d0                	mov    %edx,%eax
  101d70:	c1 e0 02             	shl    $0x2,%eax
  101d73:	01 d0                	add    %edx,%eax
  101d75:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d7c:	01 d0                	add    %edx,%eax
  101d7e:	c1 e0 02             	shl    $0x2,%eax
  101d81:	29 c1                	sub    %eax,%ecx
  101d83:	89 ca                	mov    %ecx,%edx
  101d85:	85 d2                	test   %edx,%edx
  101d87:	0f 85 aa 00 00 00    	jne    101e37 <trap_dispatch+0x133>
            print_ticks();
  101d8d:	e8 86 fb ff ff       	call   101918 <print_ticks>
        }
        break;
  101d92:	e9 a0 00 00 00       	jmp    101e37 <trap_dispatch+0x133>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d97:	e8 1f f9 ff ff       	call   1016bb <cons_getc>
  101d9c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d9f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101daf:	c7 04 24 29 65 10 00 	movl   $0x106529,(%esp)
  101db6:	e8 9b e5 ff ff       	call   100356 <cprintf>
        break;
  101dbb:	eb 7b                	jmp    101e38 <trap_dispatch+0x134>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dbd:	e8 f9 f8 ff ff       	call   1016bb <cons_getc>
  101dc2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dc5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dc9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd5:	c7 04 24 3b 65 10 00 	movl   $0x10653b,(%esp)
  101ddc:	e8 75 e5 ff ff       	call   100356 <cprintf>
        break;
  101de1:	eb 55                	jmp    101e38 <trap_dispatch+0x134>
    //LAB1 CHALLENGE 1 : 2011757 you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101de3:	c7 44 24 08 4a 65 10 	movl   $0x10654a,0x8(%esp)
  101dea:	00 
  101deb:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101df2:	00 
  101df3:	c7 04 24 6e 63 10 00 	movl   $0x10636e,(%esp)
  101dfa:	e8 dc ee ff ff       	call   100cdb <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dff:	8b 45 08             	mov    0x8(%ebp),%eax
  101e02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e06:	83 e0 03             	and    $0x3,%eax
  101e09:	85 c0                	test   %eax,%eax
  101e0b:	75 2b                	jne    101e38 <trap_dispatch+0x134>
            print_trapframe(tf);
  101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e10:	89 04 24             	mov    %eax,(%esp)
  101e13:	e8 7f fc ff ff       	call   101a97 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e18:	c7 44 24 08 5a 65 10 	movl   $0x10655a,0x8(%esp)
  101e1f:	00 
  101e20:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101e27:	00 
  101e28:	c7 04 24 6e 63 10 00 	movl   $0x10636e,(%esp)
  101e2f:	e8 a7 ee ff ff       	call   100cdb <__panic>
        break;
  101e34:	90                   	nop
  101e35:	eb 01                	jmp    101e38 <trap_dispatch+0x134>
        break;
  101e37:	90                   	nop
        }
    }
}
  101e38:	90                   	nop
  101e39:	89 ec                	mov    %ebp,%esp
  101e3b:	5d                   	pop    %ebp
  101e3c:	c3                   	ret    

00101e3d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e3d:	55                   	push   %ebp
  101e3e:	89 e5                	mov    %esp,%ebp
  101e40:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e43:	8b 45 08             	mov    0x8(%ebp),%eax
  101e46:	89 04 24             	mov    %eax,(%esp)
  101e49:	e8 b6 fe ff ff       	call   101d04 <trap_dispatch>
}
  101e4e:	90                   	nop
  101e4f:	89 ec                	mov    %ebp,%esp
  101e51:	5d                   	pop    %ebp
  101e52:	c3                   	ret    

00101e53 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e53:	1e                   	push   %ds
    pushl %es
  101e54:	06                   	push   %es
    pushl %fs
  101e55:	0f a0                	push   %fs
    pushl %gs
  101e57:	0f a8                	push   %gs
    pushal
  101e59:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e5a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e5f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e61:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e63:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e64:	e8 d4 ff ff ff       	call   101e3d <trap>

    # pop the pushed stack pointer
    popl %esp
  101e69:	5c                   	pop    %esp

00101e6a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e6a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e6b:	0f a9                	pop    %gs
    popl %fs
  101e6d:	0f a1                	pop    %fs
    popl %es
  101e6f:	07                   	pop    %es
    popl %ds
  101e70:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e71:	83 c4 08             	add    $0x8,%esp
    iret
  101e74:	cf                   	iret   

00101e75 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $0
  101e77:	6a 00                	push   $0x0
  jmp __alltraps
  101e79:	e9 d5 ff ff ff       	jmp    101e53 <__alltraps>

00101e7e <vector1>:
.globl vector1
vector1:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $1
  101e80:	6a 01                	push   $0x1
  jmp __alltraps
  101e82:	e9 cc ff ff ff       	jmp    101e53 <__alltraps>

00101e87 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $2
  101e89:	6a 02                	push   $0x2
  jmp __alltraps
  101e8b:	e9 c3 ff ff ff       	jmp    101e53 <__alltraps>

00101e90 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $3
  101e92:	6a 03                	push   $0x3
  jmp __alltraps
  101e94:	e9 ba ff ff ff       	jmp    101e53 <__alltraps>

00101e99 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $4
  101e9b:	6a 04                	push   $0x4
  jmp __alltraps
  101e9d:	e9 b1 ff ff ff       	jmp    101e53 <__alltraps>

00101ea2 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $5
  101ea4:	6a 05                	push   $0x5
  jmp __alltraps
  101ea6:	e9 a8 ff ff ff       	jmp    101e53 <__alltraps>

00101eab <vector6>:
.globl vector6
vector6:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $6
  101ead:	6a 06                	push   $0x6
  jmp __alltraps
  101eaf:	e9 9f ff ff ff       	jmp    101e53 <__alltraps>

00101eb4 <vector7>:
.globl vector7
vector7:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $7
  101eb6:	6a 07                	push   $0x7
  jmp __alltraps
  101eb8:	e9 96 ff ff ff       	jmp    101e53 <__alltraps>

00101ebd <vector8>:
.globl vector8
vector8:
  pushl $8
  101ebd:	6a 08                	push   $0x8
  jmp __alltraps
  101ebf:	e9 8f ff ff ff       	jmp    101e53 <__alltraps>

00101ec4 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ec4:	6a 09                	push   $0x9
  jmp __alltraps
  101ec6:	e9 88 ff ff ff       	jmp    101e53 <__alltraps>

00101ecb <vector10>:
.globl vector10
vector10:
  pushl $10
  101ecb:	6a 0a                	push   $0xa
  jmp __alltraps
  101ecd:	e9 81 ff ff ff       	jmp    101e53 <__alltraps>

00101ed2 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ed2:	6a 0b                	push   $0xb
  jmp __alltraps
  101ed4:	e9 7a ff ff ff       	jmp    101e53 <__alltraps>

00101ed9 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ed9:	6a 0c                	push   $0xc
  jmp __alltraps
  101edb:	e9 73 ff ff ff       	jmp    101e53 <__alltraps>

00101ee0 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ee0:	6a 0d                	push   $0xd
  jmp __alltraps
  101ee2:	e9 6c ff ff ff       	jmp    101e53 <__alltraps>

00101ee7 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ee7:	6a 0e                	push   $0xe
  jmp __alltraps
  101ee9:	e9 65 ff ff ff       	jmp    101e53 <__alltraps>

00101eee <vector15>:
.globl vector15
vector15:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $15
  101ef0:	6a 0f                	push   $0xf
  jmp __alltraps
  101ef2:	e9 5c ff ff ff       	jmp    101e53 <__alltraps>

00101ef7 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $16
  101ef9:	6a 10                	push   $0x10
  jmp __alltraps
  101efb:	e9 53 ff ff ff       	jmp    101e53 <__alltraps>

00101f00 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f00:	6a 11                	push   $0x11
  jmp __alltraps
  101f02:	e9 4c ff ff ff       	jmp    101e53 <__alltraps>

00101f07 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $18
  101f09:	6a 12                	push   $0x12
  jmp __alltraps
  101f0b:	e9 43 ff ff ff       	jmp    101e53 <__alltraps>

00101f10 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $19
  101f12:	6a 13                	push   $0x13
  jmp __alltraps
  101f14:	e9 3a ff ff ff       	jmp    101e53 <__alltraps>

00101f19 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $20
  101f1b:	6a 14                	push   $0x14
  jmp __alltraps
  101f1d:	e9 31 ff ff ff       	jmp    101e53 <__alltraps>

00101f22 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $21
  101f24:	6a 15                	push   $0x15
  jmp __alltraps
  101f26:	e9 28 ff ff ff       	jmp    101e53 <__alltraps>

00101f2b <vector22>:
.globl vector22
vector22:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $22
  101f2d:	6a 16                	push   $0x16
  jmp __alltraps
  101f2f:	e9 1f ff ff ff       	jmp    101e53 <__alltraps>

00101f34 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $23
  101f36:	6a 17                	push   $0x17
  jmp __alltraps
  101f38:	e9 16 ff ff ff       	jmp    101e53 <__alltraps>

00101f3d <vector24>:
.globl vector24
vector24:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $24
  101f3f:	6a 18                	push   $0x18
  jmp __alltraps
  101f41:	e9 0d ff ff ff       	jmp    101e53 <__alltraps>

00101f46 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $25
  101f48:	6a 19                	push   $0x19
  jmp __alltraps
  101f4a:	e9 04 ff ff ff       	jmp    101e53 <__alltraps>

00101f4f <vector26>:
.globl vector26
vector26:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $26
  101f51:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f53:	e9 fb fe ff ff       	jmp    101e53 <__alltraps>

00101f58 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $27
  101f5a:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f5c:	e9 f2 fe ff ff       	jmp    101e53 <__alltraps>

00101f61 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $28
  101f63:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f65:	e9 e9 fe ff ff       	jmp    101e53 <__alltraps>

00101f6a <vector29>:
.globl vector29
vector29:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $29
  101f6c:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f6e:	e9 e0 fe ff ff       	jmp    101e53 <__alltraps>

00101f73 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $30
  101f75:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f77:	e9 d7 fe ff ff       	jmp    101e53 <__alltraps>

00101f7c <vector31>:
.globl vector31
vector31:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $31
  101f7e:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f80:	e9 ce fe ff ff       	jmp    101e53 <__alltraps>

00101f85 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $32
  101f87:	6a 20                	push   $0x20
  jmp __alltraps
  101f89:	e9 c5 fe ff ff       	jmp    101e53 <__alltraps>

00101f8e <vector33>:
.globl vector33
vector33:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $33
  101f90:	6a 21                	push   $0x21
  jmp __alltraps
  101f92:	e9 bc fe ff ff       	jmp    101e53 <__alltraps>

00101f97 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $34
  101f99:	6a 22                	push   $0x22
  jmp __alltraps
  101f9b:	e9 b3 fe ff ff       	jmp    101e53 <__alltraps>

00101fa0 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $35
  101fa2:	6a 23                	push   $0x23
  jmp __alltraps
  101fa4:	e9 aa fe ff ff       	jmp    101e53 <__alltraps>

00101fa9 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $36
  101fab:	6a 24                	push   $0x24
  jmp __alltraps
  101fad:	e9 a1 fe ff ff       	jmp    101e53 <__alltraps>

00101fb2 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $37
  101fb4:	6a 25                	push   $0x25
  jmp __alltraps
  101fb6:	e9 98 fe ff ff       	jmp    101e53 <__alltraps>

00101fbb <vector38>:
.globl vector38
vector38:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $38
  101fbd:	6a 26                	push   $0x26
  jmp __alltraps
  101fbf:	e9 8f fe ff ff       	jmp    101e53 <__alltraps>

00101fc4 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $39
  101fc6:	6a 27                	push   $0x27
  jmp __alltraps
  101fc8:	e9 86 fe ff ff       	jmp    101e53 <__alltraps>

00101fcd <vector40>:
.globl vector40
vector40:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $40
  101fcf:	6a 28                	push   $0x28
  jmp __alltraps
  101fd1:	e9 7d fe ff ff       	jmp    101e53 <__alltraps>

00101fd6 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $41
  101fd8:	6a 29                	push   $0x29
  jmp __alltraps
  101fda:	e9 74 fe ff ff       	jmp    101e53 <__alltraps>

00101fdf <vector42>:
.globl vector42
vector42:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $42
  101fe1:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fe3:	e9 6b fe ff ff       	jmp    101e53 <__alltraps>

00101fe8 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $43
  101fea:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fec:	e9 62 fe ff ff       	jmp    101e53 <__alltraps>

00101ff1 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $44
  101ff3:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ff5:	e9 59 fe ff ff       	jmp    101e53 <__alltraps>

00101ffa <vector45>:
.globl vector45
vector45:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $45
  101ffc:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ffe:	e9 50 fe ff ff       	jmp    101e53 <__alltraps>

00102003 <vector46>:
.globl vector46
vector46:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $46
  102005:	6a 2e                	push   $0x2e
  jmp __alltraps
  102007:	e9 47 fe ff ff       	jmp    101e53 <__alltraps>

0010200c <vector47>:
.globl vector47
vector47:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $47
  10200e:	6a 2f                	push   $0x2f
  jmp __alltraps
  102010:	e9 3e fe ff ff       	jmp    101e53 <__alltraps>

00102015 <vector48>:
.globl vector48
vector48:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $48
  102017:	6a 30                	push   $0x30
  jmp __alltraps
  102019:	e9 35 fe ff ff       	jmp    101e53 <__alltraps>

0010201e <vector49>:
.globl vector49
vector49:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $49
  102020:	6a 31                	push   $0x31
  jmp __alltraps
  102022:	e9 2c fe ff ff       	jmp    101e53 <__alltraps>

00102027 <vector50>:
.globl vector50
vector50:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $50
  102029:	6a 32                	push   $0x32
  jmp __alltraps
  10202b:	e9 23 fe ff ff       	jmp    101e53 <__alltraps>

00102030 <vector51>:
.globl vector51
vector51:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $51
  102032:	6a 33                	push   $0x33
  jmp __alltraps
  102034:	e9 1a fe ff ff       	jmp    101e53 <__alltraps>

00102039 <vector52>:
.globl vector52
vector52:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $52
  10203b:	6a 34                	push   $0x34
  jmp __alltraps
  10203d:	e9 11 fe ff ff       	jmp    101e53 <__alltraps>

00102042 <vector53>:
.globl vector53
vector53:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $53
  102044:	6a 35                	push   $0x35
  jmp __alltraps
  102046:	e9 08 fe ff ff       	jmp    101e53 <__alltraps>

0010204b <vector54>:
.globl vector54
vector54:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $54
  10204d:	6a 36                	push   $0x36
  jmp __alltraps
  10204f:	e9 ff fd ff ff       	jmp    101e53 <__alltraps>

00102054 <vector55>:
.globl vector55
vector55:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $55
  102056:	6a 37                	push   $0x37
  jmp __alltraps
  102058:	e9 f6 fd ff ff       	jmp    101e53 <__alltraps>

0010205d <vector56>:
.globl vector56
vector56:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $56
  10205f:	6a 38                	push   $0x38
  jmp __alltraps
  102061:	e9 ed fd ff ff       	jmp    101e53 <__alltraps>

00102066 <vector57>:
.globl vector57
vector57:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $57
  102068:	6a 39                	push   $0x39
  jmp __alltraps
  10206a:	e9 e4 fd ff ff       	jmp    101e53 <__alltraps>

0010206f <vector58>:
.globl vector58
vector58:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $58
  102071:	6a 3a                	push   $0x3a
  jmp __alltraps
  102073:	e9 db fd ff ff       	jmp    101e53 <__alltraps>

00102078 <vector59>:
.globl vector59
vector59:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $59
  10207a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10207c:	e9 d2 fd ff ff       	jmp    101e53 <__alltraps>

00102081 <vector60>:
.globl vector60
vector60:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $60
  102083:	6a 3c                	push   $0x3c
  jmp __alltraps
  102085:	e9 c9 fd ff ff       	jmp    101e53 <__alltraps>

0010208a <vector61>:
.globl vector61
vector61:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $61
  10208c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10208e:	e9 c0 fd ff ff       	jmp    101e53 <__alltraps>

00102093 <vector62>:
.globl vector62
vector62:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $62
  102095:	6a 3e                	push   $0x3e
  jmp __alltraps
  102097:	e9 b7 fd ff ff       	jmp    101e53 <__alltraps>

0010209c <vector63>:
.globl vector63
vector63:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $63
  10209e:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020a0:	e9 ae fd ff ff       	jmp    101e53 <__alltraps>

001020a5 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $64
  1020a7:	6a 40                	push   $0x40
  jmp __alltraps
  1020a9:	e9 a5 fd ff ff       	jmp    101e53 <__alltraps>

001020ae <vector65>:
.globl vector65
vector65:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $65
  1020b0:	6a 41                	push   $0x41
  jmp __alltraps
  1020b2:	e9 9c fd ff ff       	jmp    101e53 <__alltraps>

001020b7 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $66
  1020b9:	6a 42                	push   $0x42
  jmp __alltraps
  1020bb:	e9 93 fd ff ff       	jmp    101e53 <__alltraps>

001020c0 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $67
  1020c2:	6a 43                	push   $0x43
  jmp __alltraps
  1020c4:	e9 8a fd ff ff       	jmp    101e53 <__alltraps>

001020c9 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $68
  1020cb:	6a 44                	push   $0x44
  jmp __alltraps
  1020cd:	e9 81 fd ff ff       	jmp    101e53 <__alltraps>

001020d2 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $69
  1020d4:	6a 45                	push   $0x45
  jmp __alltraps
  1020d6:	e9 78 fd ff ff       	jmp    101e53 <__alltraps>

001020db <vector70>:
.globl vector70
vector70:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $70
  1020dd:	6a 46                	push   $0x46
  jmp __alltraps
  1020df:	e9 6f fd ff ff       	jmp    101e53 <__alltraps>

001020e4 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $71
  1020e6:	6a 47                	push   $0x47
  jmp __alltraps
  1020e8:	e9 66 fd ff ff       	jmp    101e53 <__alltraps>

001020ed <vector72>:
.globl vector72
vector72:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $72
  1020ef:	6a 48                	push   $0x48
  jmp __alltraps
  1020f1:	e9 5d fd ff ff       	jmp    101e53 <__alltraps>

001020f6 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $73
  1020f8:	6a 49                	push   $0x49
  jmp __alltraps
  1020fa:	e9 54 fd ff ff       	jmp    101e53 <__alltraps>

001020ff <vector74>:
.globl vector74
vector74:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $74
  102101:	6a 4a                	push   $0x4a
  jmp __alltraps
  102103:	e9 4b fd ff ff       	jmp    101e53 <__alltraps>

00102108 <vector75>:
.globl vector75
vector75:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $75
  10210a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10210c:	e9 42 fd ff ff       	jmp    101e53 <__alltraps>

00102111 <vector76>:
.globl vector76
vector76:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $76
  102113:	6a 4c                	push   $0x4c
  jmp __alltraps
  102115:	e9 39 fd ff ff       	jmp    101e53 <__alltraps>

0010211a <vector77>:
.globl vector77
vector77:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $77
  10211c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10211e:	e9 30 fd ff ff       	jmp    101e53 <__alltraps>

00102123 <vector78>:
.globl vector78
vector78:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $78
  102125:	6a 4e                	push   $0x4e
  jmp __alltraps
  102127:	e9 27 fd ff ff       	jmp    101e53 <__alltraps>

0010212c <vector79>:
.globl vector79
vector79:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $79
  10212e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102130:	e9 1e fd ff ff       	jmp    101e53 <__alltraps>

00102135 <vector80>:
.globl vector80
vector80:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $80
  102137:	6a 50                	push   $0x50
  jmp __alltraps
  102139:	e9 15 fd ff ff       	jmp    101e53 <__alltraps>

0010213e <vector81>:
.globl vector81
vector81:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $81
  102140:	6a 51                	push   $0x51
  jmp __alltraps
  102142:	e9 0c fd ff ff       	jmp    101e53 <__alltraps>

00102147 <vector82>:
.globl vector82
vector82:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $82
  102149:	6a 52                	push   $0x52
  jmp __alltraps
  10214b:	e9 03 fd ff ff       	jmp    101e53 <__alltraps>

00102150 <vector83>:
.globl vector83
vector83:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $83
  102152:	6a 53                	push   $0x53
  jmp __alltraps
  102154:	e9 fa fc ff ff       	jmp    101e53 <__alltraps>

00102159 <vector84>:
.globl vector84
vector84:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $84
  10215b:	6a 54                	push   $0x54
  jmp __alltraps
  10215d:	e9 f1 fc ff ff       	jmp    101e53 <__alltraps>

00102162 <vector85>:
.globl vector85
vector85:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $85
  102164:	6a 55                	push   $0x55
  jmp __alltraps
  102166:	e9 e8 fc ff ff       	jmp    101e53 <__alltraps>

0010216b <vector86>:
.globl vector86
vector86:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $86
  10216d:	6a 56                	push   $0x56
  jmp __alltraps
  10216f:	e9 df fc ff ff       	jmp    101e53 <__alltraps>

00102174 <vector87>:
.globl vector87
vector87:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $87
  102176:	6a 57                	push   $0x57
  jmp __alltraps
  102178:	e9 d6 fc ff ff       	jmp    101e53 <__alltraps>

0010217d <vector88>:
.globl vector88
vector88:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $88
  10217f:	6a 58                	push   $0x58
  jmp __alltraps
  102181:	e9 cd fc ff ff       	jmp    101e53 <__alltraps>

00102186 <vector89>:
.globl vector89
vector89:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $89
  102188:	6a 59                	push   $0x59
  jmp __alltraps
  10218a:	e9 c4 fc ff ff       	jmp    101e53 <__alltraps>

0010218f <vector90>:
.globl vector90
vector90:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $90
  102191:	6a 5a                	push   $0x5a
  jmp __alltraps
  102193:	e9 bb fc ff ff       	jmp    101e53 <__alltraps>

00102198 <vector91>:
.globl vector91
vector91:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $91
  10219a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10219c:	e9 b2 fc ff ff       	jmp    101e53 <__alltraps>

001021a1 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $92
  1021a3:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021a5:	e9 a9 fc ff ff       	jmp    101e53 <__alltraps>

001021aa <vector93>:
.globl vector93
vector93:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $93
  1021ac:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021ae:	e9 a0 fc ff ff       	jmp    101e53 <__alltraps>

001021b3 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $94
  1021b5:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021b7:	e9 97 fc ff ff       	jmp    101e53 <__alltraps>

001021bc <vector95>:
.globl vector95
vector95:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $95
  1021be:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021c0:	e9 8e fc ff ff       	jmp    101e53 <__alltraps>

001021c5 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $96
  1021c7:	6a 60                	push   $0x60
  jmp __alltraps
  1021c9:	e9 85 fc ff ff       	jmp    101e53 <__alltraps>

001021ce <vector97>:
.globl vector97
vector97:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $97
  1021d0:	6a 61                	push   $0x61
  jmp __alltraps
  1021d2:	e9 7c fc ff ff       	jmp    101e53 <__alltraps>

001021d7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $98
  1021d9:	6a 62                	push   $0x62
  jmp __alltraps
  1021db:	e9 73 fc ff ff       	jmp    101e53 <__alltraps>

001021e0 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $99
  1021e2:	6a 63                	push   $0x63
  jmp __alltraps
  1021e4:	e9 6a fc ff ff       	jmp    101e53 <__alltraps>

001021e9 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $100
  1021eb:	6a 64                	push   $0x64
  jmp __alltraps
  1021ed:	e9 61 fc ff ff       	jmp    101e53 <__alltraps>

001021f2 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $101
  1021f4:	6a 65                	push   $0x65
  jmp __alltraps
  1021f6:	e9 58 fc ff ff       	jmp    101e53 <__alltraps>

001021fb <vector102>:
.globl vector102
vector102:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $102
  1021fd:	6a 66                	push   $0x66
  jmp __alltraps
  1021ff:	e9 4f fc ff ff       	jmp    101e53 <__alltraps>

00102204 <vector103>:
.globl vector103
vector103:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $103
  102206:	6a 67                	push   $0x67
  jmp __alltraps
  102208:	e9 46 fc ff ff       	jmp    101e53 <__alltraps>

0010220d <vector104>:
.globl vector104
vector104:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $104
  10220f:	6a 68                	push   $0x68
  jmp __alltraps
  102211:	e9 3d fc ff ff       	jmp    101e53 <__alltraps>

00102216 <vector105>:
.globl vector105
vector105:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $105
  102218:	6a 69                	push   $0x69
  jmp __alltraps
  10221a:	e9 34 fc ff ff       	jmp    101e53 <__alltraps>

0010221f <vector106>:
.globl vector106
vector106:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $106
  102221:	6a 6a                	push   $0x6a
  jmp __alltraps
  102223:	e9 2b fc ff ff       	jmp    101e53 <__alltraps>

00102228 <vector107>:
.globl vector107
vector107:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $107
  10222a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10222c:	e9 22 fc ff ff       	jmp    101e53 <__alltraps>

00102231 <vector108>:
.globl vector108
vector108:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $108
  102233:	6a 6c                	push   $0x6c
  jmp __alltraps
  102235:	e9 19 fc ff ff       	jmp    101e53 <__alltraps>

0010223a <vector109>:
.globl vector109
vector109:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $109
  10223c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10223e:	e9 10 fc ff ff       	jmp    101e53 <__alltraps>

00102243 <vector110>:
.globl vector110
vector110:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $110
  102245:	6a 6e                	push   $0x6e
  jmp __alltraps
  102247:	e9 07 fc ff ff       	jmp    101e53 <__alltraps>

0010224c <vector111>:
.globl vector111
vector111:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $111
  10224e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102250:	e9 fe fb ff ff       	jmp    101e53 <__alltraps>

00102255 <vector112>:
.globl vector112
vector112:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $112
  102257:	6a 70                	push   $0x70
  jmp __alltraps
  102259:	e9 f5 fb ff ff       	jmp    101e53 <__alltraps>

0010225e <vector113>:
.globl vector113
vector113:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $113
  102260:	6a 71                	push   $0x71
  jmp __alltraps
  102262:	e9 ec fb ff ff       	jmp    101e53 <__alltraps>

00102267 <vector114>:
.globl vector114
vector114:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $114
  102269:	6a 72                	push   $0x72
  jmp __alltraps
  10226b:	e9 e3 fb ff ff       	jmp    101e53 <__alltraps>

00102270 <vector115>:
.globl vector115
vector115:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $115
  102272:	6a 73                	push   $0x73
  jmp __alltraps
  102274:	e9 da fb ff ff       	jmp    101e53 <__alltraps>

00102279 <vector116>:
.globl vector116
vector116:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $116
  10227b:	6a 74                	push   $0x74
  jmp __alltraps
  10227d:	e9 d1 fb ff ff       	jmp    101e53 <__alltraps>

00102282 <vector117>:
.globl vector117
vector117:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $117
  102284:	6a 75                	push   $0x75
  jmp __alltraps
  102286:	e9 c8 fb ff ff       	jmp    101e53 <__alltraps>

0010228b <vector118>:
.globl vector118
vector118:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $118
  10228d:	6a 76                	push   $0x76
  jmp __alltraps
  10228f:	e9 bf fb ff ff       	jmp    101e53 <__alltraps>

00102294 <vector119>:
.globl vector119
vector119:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $119
  102296:	6a 77                	push   $0x77
  jmp __alltraps
  102298:	e9 b6 fb ff ff       	jmp    101e53 <__alltraps>

0010229d <vector120>:
.globl vector120
vector120:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $120
  10229f:	6a 78                	push   $0x78
  jmp __alltraps
  1022a1:	e9 ad fb ff ff       	jmp    101e53 <__alltraps>

001022a6 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $121
  1022a8:	6a 79                	push   $0x79
  jmp __alltraps
  1022aa:	e9 a4 fb ff ff       	jmp    101e53 <__alltraps>

001022af <vector122>:
.globl vector122
vector122:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $122
  1022b1:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022b3:	e9 9b fb ff ff       	jmp    101e53 <__alltraps>

001022b8 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $123
  1022ba:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022bc:	e9 92 fb ff ff       	jmp    101e53 <__alltraps>

001022c1 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $124
  1022c3:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022c5:	e9 89 fb ff ff       	jmp    101e53 <__alltraps>

001022ca <vector125>:
.globl vector125
vector125:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $125
  1022cc:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022ce:	e9 80 fb ff ff       	jmp    101e53 <__alltraps>

001022d3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $126
  1022d5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022d7:	e9 77 fb ff ff       	jmp    101e53 <__alltraps>

001022dc <vector127>:
.globl vector127
vector127:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $127
  1022de:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022e0:	e9 6e fb ff ff       	jmp    101e53 <__alltraps>

001022e5 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $128
  1022e7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022ec:	e9 62 fb ff ff       	jmp    101e53 <__alltraps>

001022f1 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $129
  1022f3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022f8:	e9 56 fb ff ff       	jmp    101e53 <__alltraps>

001022fd <vector130>:
.globl vector130
vector130:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $130
  1022ff:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102304:	e9 4a fb ff ff       	jmp    101e53 <__alltraps>

00102309 <vector131>:
.globl vector131
vector131:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $131
  10230b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102310:	e9 3e fb ff ff       	jmp    101e53 <__alltraps>

00102315 <vector132>:
.globl vector132
vector132:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $132
  102317:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10231c:	e9 32 fb ff ff       	jmp    101e53 <__alltraps>

00102321 <vector133>:
.globl vector133
vector133:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $133
  102323:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102328:	e9 26 fb ff ff       	jmp    101e53 <__alltraps>

0010232d <vector134>:
.globl vector134
vector134:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $134
  10232f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102334:	e9 1a fb ff ff       	jmp    101e53 <__alltraps>

00102339 <vector135>:
.globl vector135
vector135:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $135
  10233b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102340:	e9 0e fb ff ff       	jmp    101e53 <__alltraps>

00102345 <vector136>:
.globl vector136
vector136:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $136
  102347:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10234c:	e9 02 fb ff ff       	jmp    101e53 <__alltraps>

00102351 <vector137>:
.globl vector137
vector137:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $137
  102353:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102358:	e9 f6 fa ff ff       	jmp    101e53 <__alltraps>

0010235d <vector138>:
.globl vector138
vector138:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $138
  10235f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102364:	e9 ea fa ff ff       	jmp    101e53 <__alltraps>

00102369 <vector139>:
.globl vector139
vector139:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $139
  10236b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102370:	e9 de fa ff ff       	jmp    101e53 <__alltraps>

00102375 <vector140>:
.globl vector140
vector140:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $140
  102377:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10237c:	e9 d2 fa ff ff       	jmp    101e53 <__alltraps>

00102381 <vector141>:
.globl vector141
vector141:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $141
  102383:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102388:	e9 c6 fa ff ff       	jmp    101e53 <__alltraps>

0010238d <vector142>:
.globl vector142
vector142:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $142
  10238f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102394:	e9 ba fa ff ff       	jmp    101e53 <__alltraps>

00102399 <vector143>:
.globl vector143
vector143:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $143
  10239b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023a0:	e9 ae fa ff ff       	jmp    101e53 <__alltraps>

001023a5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $144
  1023a7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023ac:	e9 a2 fa ff ff       	jmp    101e53 <__alltraps>

001023b1 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $145
  1023b3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023b8:	e9 96 fa ff ff       	jmp    101e53 <__alltraps>

001023bd <vector146>:
.globl vector146
vector146:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $146
  1023bf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023c4:	e9 8a fa ff ff       	jmp    101e53 <__alltraps>

001023c9 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $147
  1023cb:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023d0:	e9 7e fa ff ff       	jmp    101e53 <__alltraps>

001023d5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $148
  1023d7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023dc:	e9 72 fa ff ff       	jmp    101e53 <__alltraps>

001023e1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $149
  1023e3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023e8:	e9 66 fa ff ff       	jmp    101e53 <__alltraps>

001023ed <vector150>:
.globl vector150
vector150:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $150
  1023ef:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023f4:	e9 5a fa ff ff       	jmp    101e53 <__alltraps>

001023f9 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $151
  1023fb:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102400:	e9 4e fa ff ff       	jmp    101e53 <__alltraps>

00102405 <vector152>:
.globl vector152
vector152:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $152
  102407:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10240c:	e9 42 fa ff ff       	jmp    101e53 <__alltraps>

00102411 <vector153>:
.globl vector153
vector153:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $153
  102413:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102418:	e9 36 fa ff ff       	jmp    101e53 <__alltraps>

0010241d <vector154>:
.globl vector154
vector154:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $154
  10241f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102424:	e9 2a fa ff ff       	jmp    101e53 <__alltraps>

00102429 <vector155>:
.globl vector155
vector155:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $155
  10242b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102430:	e9 1e fa ff ff       	jmp    101e53 <__alltraps>

00102435 <vector156>:
.globl vector156
vector156:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $156
  102437:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10243c:	e9 12 fa ff ff       	jmp    101e53 <__alltraps>

00102441 <vector157>:
.globl vector157
vector157:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $157
  102443:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102448:	e9 06 fa ff ff       	jmp    101e53 <__alltraps>

0010244d <vector158>:
.globl vector158
vector158:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $158
  10244f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102454:	e9 fa f9 ff ff       	jmp    101e53 <__alltraps>

00102459 <vector159>:
.globl vector159
vector159:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $159
  10245b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102460:	e9 ee f9 ff ff       	jmp    101e53 <__alltraps>

00102465 <vector160>:
.globl vector160
vector160:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $160
  102467:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10246c:	e9 e2 f9 ff ff       	jmp    101e53 <__alltraps>

00102471 <vector161>:
.globl vector161
vector161:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $161
  102473:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102478:	e9 d6 f9 ff ff       	jmp    101e53 <__alltraps>

0010247d <vector162>:
.globl vector162
vector162:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $162
  10247f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102484:	e9 ca f9 ff ff       	jmp    101e53 <__alltraps>

00102489 <vector163>:
.globl vector163
vector163:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $163
  10248b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102490:	e9 be f9 ff ff       	jmp    101e53 <__alltraps>

00102495 <vector164>:
.globl vector164
vector164:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $164
  102497:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10249c:	e9 b2 f9 ff ff       	jmp    101e53 <__alltraps>

001024a1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $165
  1024a3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024a8:	e9 a6 f9 ff ff       	jmp    101e53 <__alltraps>

001024ad <vector166>:
.globl vector166
vector166:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $166
  1024af:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024b4:	e9 9a f9 ff ff       	jmp    101e53 <__alltraps>

001024b9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $167
  1024bb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024c0:	e9 8e f9 ff ff       	jmp    101e53 <__alltraps>

001024c5 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $168
  1024c7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024cc:	e9 82 f9 ff ff       	jmp    101e53 <__alltraps>

001024d1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $169
  1024d3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024d8:	e9 76 f9 ff ff       	jmp    101e53 <__alltraps>

001024dd <vector170>:
.globl vector170
vector170:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $170
  1024df:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024e4:	e9 6a f9 ff ff       	jmp    101e53 <__alltraps>

001024e9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $171
  1024eb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024f0:	e9 5e f9 ff ff       	jmp    101e53 <__alltraps>

001024f5 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $172
  1024f7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024fc:	e9 52 f9 ff ff       	jmp    101e53 <__alltraps>

00102501 <vector173>:
.globl vector173
vector173:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $173
  102503:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102508:	e9 46 f9 ff ff       	jmp    101e53 <__alltraps>

0010250d <vector174>:
.globl vector174
vector174:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $174
  10250f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102514:	e9 3a f9 ff ff       	jmp    101e53 <__alltraps>

00102519 <vector175>:
.globl vector175
vector175:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $175
  10251b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102520:	e9 2e f9 ff ff       	jmp    101e53 <__alltraps>

00102525 <vector176>:
.globl vector176
vector176:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $176
  102527:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10252c:	e9 22 f9 ff ff       	jmp    101e53 <__alltraps>

00102531 <vector177>:
.globl vector177
vector177:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $177
  102533:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102538:	e9 16 f9 ff ff       	jmp    101e53 <__alltraps>

0010253d <vector178>:
.globl vector178
vector178:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $178
  10253f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102544:	e9 0a f9 ff ff       	jmp    101e53 <__alltraps>

00102549 <vector179>:
.globl vector179
vector179:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $179
  10254b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102550:	e9 fe f8 ff ff       	jmp    101e53 <__alltraps>

00102555 <vector180>:
.globl vector180
vector180:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $180
  102557:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10255c:	e9 f2 f8 ff ff       	jmp    101e53 <__alltraps>

00102561 <vector181>:
.globl vector181
vector181:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $181
  102563:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102568:	e9 e6 f8 ff ff       	jmp    101e53 <__alltraps>

0010256d <vector182>:
.globl vector182
vector182:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $182
  10256f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102574:	e9 da f8 ff ff       	jmp    101e53 <__alltraps>

00102579 <vector183>:
.globl vector183
vector183:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $183
  10257b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102580:	e9 ce f8 ff ff       	jmp    101e53 <__alltraps>

00102585 <vector184>:
.globl vector184
vector184:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $184
  102587:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10258c:	e9 c2 f8 ff ff       	jmp    101e53 <__alltraps>

00102591 <vector185>:
.globl vector185
vector185:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $185
  102593:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102598:	e9 b6 f8 ff ff       	jmp    101e53 <__alltraps>

0010259d <vector186>:
.globl vector186
vector186:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $186
  10259f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025a4:	e9 aa f8 ff ff       	jmp    101e53 <__alltraps>

001025a9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $187
  1025ab:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025b0:	e9 9e f8 ff ff       	jmp    101e53 <__alltraps>

001025b5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $188
  1025b7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025bc:	e9 92 f8 ff ff       	jmp    101e53 <__alltraps>

001025c1 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $189
  1025c3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025c8:	e9 86 f8 ff ff       	jmp    101e53 <__alltraps>

001025cd <vector190>:
.globl vector190
vector190:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $190
  1025cf:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025d4:	e9 7a f8 ff ff       	jmp    101e53 <__alltraps>

001025d9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $191
  1025db:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025e0:	e9 6e f8 ff ff       	jmp    101e53 <__alltraps>

001025e5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $192
  1025e7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025ec:	e9 62 f8 ff ff       	jmp    101e53 <__alltraps>

001025f1 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $193
  1025f3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025f8:	e9 56 f8 ff ff       	jmp    101e53 <__alltraps>

001025fd <vector194>:
.globl vector194
vector194:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $194
  1025ff:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102604:	e9 4a f8 ff ff       	jmp    101e53 <__alltraps>

00102609 <vector195>:
.globl vector195
vector195:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $195
  10260b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102610:	e9 3e f8 ff ff       	jmp    101e53 <__alltraps>

00102615 <vector196>:
.globl vector196
vector196:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $196
  102617:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10261c:	e9 32 f8 ff ff       	jmp    101e53 <__alltraps>

00102621 <vector197>:
.globl vector197
vector197:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $197
  102623:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102628:	e9 26 f8 ff ff       	jmp    101e53 <__alltraps>

0010262d <vector198>:
.globl vector198
vector198:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $198
  10262f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102634:	e9 1a f8 ff ff       	jmp    101e53 <__alltraps>

00102639 <vector199>:
.globl vector199
vector199:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $199
  10263b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102640:	e9 0e f8 ff ff       	jmp    101e53 <__alltraps>

00102645 <vector200>:
.globl vector200
vector200:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $200
  102647:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10264c:	e9 02 f8 ff ff       	jmp    101e53 <__alltraps>

00102651 <vector201>:
.globl vector201
vector201:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $201
  102653:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102658:	e9 f6 f7 ff ff       	jmp    101e53 <__alltraps>

0010265d <vector202>:
.globl vector202
vector202:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $202
  10265f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102664:	e9 ea f7 ff ff       	jmp    101e53 <__alltraps>

00102669 <vector203>:
.globl vector203
vector203:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $203
  10266b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102670:	e9 de f7 ff ff       	jmp    101e53 <__alltraps>

00102675 <vector204>:
.globl vector204
vector204:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $204
  102677:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10267c:	e9 d2 f7 ff ff       	jmp    101e53 <__alltraps>

00102681 <vector205>:
.globl vector205
vector205:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $205
  102683:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102688:	e9 c6 f7 ff ff       	jmp    101e53 <__alltraps>

0010268d <vector206>:
.globl vector206
vector206:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $206
  10268f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102694:	e9 ba f7 ff ff       	jmp    101e53 <__alltraps>

00102699 <vector207>:
.globl vector207
vector207:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $207
  10269b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026a0:	e9 ae f7 ff ff       	jmp    101e53 <__alltraps>

001026a5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $208
  1026a7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026ac:	e9 a2 f7 ff ff       	jmp    101e53 <__alltraps>

001026b1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $209
  1026b3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026b8:	e9 96 f7 ff ff       	jmp    101e53 <__alltraps>

001026bd <vector210>:
.globl vector210
vector210:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $210
  1026bf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026c4:	e9 8a f7 ff ff       	jmp    101e53 <__alltraps>

001026c9 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $211
  1026cb:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026d0:	e9 7e f7 ff ff       	jmp    101e53 <__alltraps>

001026d5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $212
  1026d7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026dc:	e9 72 f7 ff ff       	jmp    101e53 <__alltraps>

001026e1 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $213
  1026e3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026e8:	e9 66 f7 ff ff       	jmp    101e53 <__alltraps>

001026ed <vector214>:
.globl vector214
vector214:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $214
  1026ef:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026f4:	e9 5a f7 ff ff       	jmp    101e53 <__alltraps>

001026f9 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $215
  1026fb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102700:	e9 4e f7 ff ff       	jmp    101e53 <__alltraps>

00102705 <vector216>:
.globl vector216
vector216:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $216
  102707:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10270c:	e9 42 f7 ff ff       	jmp    101e53 <__alltraps>

00102711 <vector217>:
.globl vector217
vector217:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $217
  102713:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102718:	e9 36 f7 ff ff       	jmp    101e53 <__alltraps>

0010271d <vector218>:
.globl vector218
vector218:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $218
  10271f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102724:	e9 2a f7 ff ff       	jmp    101e53 <__alltraps>

00102729 <vector219>:
.globl vector219
vector219:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $219
  10272b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102730:	e9 1e f7 ff ff       	jmp    101e53 <__alltraps>

00102735 <vector220>:
.globl vector220
vector220:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $220
  102737:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10273c:	e9 12 f7 ff ff       	jmp    101e53 <__alltraps>

00102741 <vector221>:
.globl vector221
vector221:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $221
  102743:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102748:	e9 06 f7 ff ff       	jmp    101e53 <__alltraps>

0010274d <vector222>:
.globl vector222
vector222:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $222
  10274f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102754:	e9 fa f6 ff ff       	jmp    101e53 <__alltraps>

00102759 <vector223>:
.globl vector223
vector223:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $223
  10275b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102760:	e9 ee f6 ff ff       	jmp    101e53 <__alltraps>

00102765 <vector224>:
.globl vector224
vector224:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $224
  102767:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10276c:	e9 e2 f6 ff ff       	jmp    101e53 <__alltraps>

00102771 <vector225>:
.globl vector225
vector225:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $225
  102773:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102778:	e9 d6 f6 ff ff       	jmp    101e53 <__alltraps>

0010277d <vector226>:
.globl vector226
vector226:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $226
  10277f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102784:	e9 ca f6 ff ff       	jmp    101e53 <__alltraps>

00102789 <vector227>:
.globl vector227
vector227:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $227
  10278b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102790:	e9 be f6 ff ff       	jmp    101e53 <__alltraps>

00102795 <vector228>:
.globl vector228
vector228:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $228
  102797:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10279c:	e9 b2 f6 ff ff       	jmp    101e53 <__alltraps>

001027a1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $229
  1027a3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027a8:	e9 a6 f6 ff ff       	jmp    101e53 <__alltraps>

001027ad <vector230>:
.globl vector230
vector230:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $230
  1027af:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027b4:	e9 9a f6 ff ff       	jmp    101e53 <__alltraps>

001027b9 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $231
  1027bb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027c0:	e9 8e f6 ff ff       	jmp    101e53 <__alltraps>

001027c5 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $232
  1027c7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027cc:	e9 82 f6 ff ff       	jmp    101e53 <__alltraps>

001027d1 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $233
  1027d3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027d8:	e9 76 f6 ff ff       	jmp    101e53 <__alltraps>

001027dd <vector234>:
.globl vector234
vector234:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $234
  1027df:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027e4:	e9 6a f6 ff ff       	jmp    101e53 <__alltraps>

001027e9 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $235
  1027eb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027f0:	e9 5e f6 ff ff       	jmp    101e53 <__alltraps>

001027f5 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $236
  1027f7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027fc:	e9 52 f6 ff ff       	jmp    101e53 <__alltraps>

00102801 <vector237>:
.globl vector237
vector237:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $237
  102803:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102808:	e9 46 f6 ff ff       	jmp    101e53 <__alltraps>

0010280d <vector238>:
.globl vector238
vector238:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $238
  10280f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102814:	e9 3a f6 ff ff       	jmp    101e53 <__alltraps>

00102819 <vector239>:
.globl vector239
vector239:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $239
  10281b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102820:	e9 2e f6 ff ff       	jmp    101e53 <__alltraps>

00102825 <vector240>:
.globl vector240
vector240:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $240
  102827:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10282c:	e9 22 f6 ff ff       	jmp    101e53 <__alltraps>

00102831 <vector241>:
.globl vector241
vector241:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $241
  102833:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102838:	e9 16 f6 ff ff       	jmp    101e53 <__alltraps>

0010283d <vector242>:
.globl vector242
vector242:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $242
  10283f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102844:	e9 0a f6 ff ff       	jmp    101e53 <__alltraps>

00102849 <vector243>:
.globl vector243
vector243:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $243
  10284b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102850:	e9 fe f5 ff ff       	jmp    101e53 <__alltraps>

00102855 <vector244>:
.globl vector244
vector244:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $244
  102857:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10285c:	e9 f2 f5 ff ff       	jmp    101e53 <__alltraps>

00102861 <vector245>:
.globl vector245
vector245:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $245
  102863:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102868:	e9 e6 f5 ff ff       	jmp    101e53 <__alltraps>

0010286d <vector246>:
.globl vector246
vector246:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $246
  10286f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102874:	e9 da f5 ff ff       	jmp    101e53 <__alltraps>

00102879 <vector247>:
.globl vector247
vector247:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $247
  10287b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102880:	e9 ce f5 ff ff       	jmp    101e53 <__alltraps>

00102885 <vector248>:
.globl vector248
vector248:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $248
  102887:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10288c:	e9 c2 f5 ff ff       	jmp    101e53 <__alltraps>

00102891 <vector249>:
.globl vector249
vector249:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $249
  102893:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102898:	e9 b6 f5 ff ff       	jmp    101e53 <__alltraps>

0010289d <vector250>:
.globl vector250
vector250:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $250
  10289f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028a4:	e9 aa f5 ff ff       	jmp    101e53 <__alltraps>

001028a9 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $251
  1028ab:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028b0:	e9 9e f5 ff ff       	jmp    101e53 <__alltraps>

001028b5 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $252
  1028b7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028bc:	e9 92 f5 ff ff       	jmp    101e53 <__alltraps>

001028c1 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $253
  1028c3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028c8:	e9 86 f5 ff ff       	jmp    101e53 <__alltraps>

001028cd <vector254>:
.globl vector254
vector254:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $254
  1028cf:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028d4:	e9 7a f5 ff ff       	jmp    101e53 <__alltraps>

001028d9 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $255
  1028db:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028e0:	e9 6e f5 ff ff       	jmp    101e53 <__alltraps>

001028e5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028e5:	55                   	push   %ebp
  1028e6:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028e8:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  1028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f1:	29 d0                	sub    %edx,%eax
  1028f3:	c1 f8 02             	sar    $0x2,%eax
  1028f6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028fc:	5d                   	pop    %ebp
  1028fd:	c3                   	ret    

001028fe <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028fe:	55                   	push   %ebp
  1028ff:	89 e5                	mov    %esp,%ebp
  102901:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102904:	8b 45 08             	mov    0x8(%ebp),%eax
  102907:	89 04 24             	mov    %eax,(%esp)
  10290a:	e8 d6 ff ff ff       	call   1028e5 <page2ppn>
  10290f:	c1 e0 0c             	shl    $0xc,%eax
}
  102912:	89 ec                	mov    %ebp,%esp
  102914:	5d                   	pop    %ebp
  102915:	c3                   	ret    

00102916 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102916:	55                   	push   %ebp
  102917:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102919:	8b 45 08             	mov    0x8(%ebp),%eax
  10291c:	8b 00                	mov    (%eax),%eax
}
  10291e:	5d                   	pop    %ebp
  10291f:	c3                   	ret    

00102920 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102920:	55                   	push   %ebp
  102921:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102923:	8b 45 08             	mov    0x8(%ebp),%eax
  102926:	8b 55 0c             	mov    0xc(%ebp),%edx
  102929:	89 10                	mov    %edx,(%eax)
}
  10292b:	90                   	nop
  10292c:	5d                   	pop    %ebp
  10292d:	c3                   	ret    

0010292e <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化空闲页块链表
static void
default_init(void) {
  10292e:	55                   	push   %ebp
  10292f:	89 e5                	mov    %esp,%ebp
  102931:	83 ec 10             	sub    $0x10,%esp
  102934:	c7 45 fc 80 be 11 00 	movl   $0x11be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10293b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10293e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102941:	89 50 04             	mov    %edx,0x4(%eax)
  102944:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102947:	8b 50 04             	mov    0x4(%eax),%edx
  10294a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10294d:	89 10                	mov    %edx,(%eax)
}
  10294f:	90                   	nop
    list_init(&free_list);
    // 空闲页块一开始是0个
    nr_free = 0;
  102950:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  102957:	00 00 00 
}
  10295a:	90                   	nop
  10295b:	89 ec                	mov    %ebp,%esp
  10295d:	5d                   	pop    %ebp
  10295e:	c3                   	ret    

0010295f <default_init_memmap>:


static void
default_init_memmap(struct Page *base, size_t n) {
  10295f:	55                   	push   %ebp
  102960:	89 e5                	mov    %esp,%ebp
  102962:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102965:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102969:	75 24                	jne    10298f <default_init_memmap+0x30>
  10296b:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  102972:	00 
  102973:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10297a:	00 
  10297b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102982:	00 
  102983:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10298a:	e8 4c e3 ff ff       	call   100cdb <__panic>
    struct Page *p = base;
  10298f:	8b 45 08             	mov    0x8(%ebp),%eax
  102992:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    //在查找可用内存并分配struct Page数组时，就已经将全部Page设置为 reserved
    for (; p != base + n; p ++) {
  102995:	e9 97 00 00 00       	jmp    102a31 <default_init_memmap+0xd2>
        // 判断这个页是不是被内核保留的
        assert(PageReserved(p));
  10299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299d:	83 c0 04             	add    $0x4,%eax
  1029a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1029a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029b0:	0f a3 10             	bt     %edx,(%eax)
  1029b3:	19 c0                	sbb    %eax,%eax
  1029b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1029b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029bc:	0f 95 c0             	setne  %al
  1029bf:	0f b6 c0             	movzbl %al,%eax
  1029c2:	85 c0                	test   %eax,%eax
  1029c4:	75 24                	jne    1029ea <default_init_memmap+0x8b>
  1029c6:	c7 44 24 0c 41 67 10 	movl   $0x106741,0xc(%esp)
  1029cd:	00 
  1029ce:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1029d5:	00 
  1029d6:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  1029dd:	00 
  1029de:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1029e5:	e8 f1 e2 ff ff       	call   100cdb <__panic>
        
        //将Page标记为可用的：ref设为0,清除reserved，设置PG_reserved，并把property设置为0（不是空闲块的第一个物理页）
        p->flags = p->property = 0;
  1029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f7:	8b 50 08             	mov    0x8(%eax),%edx
  1029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029fd:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102a00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a07:	00 
  102a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a0b:	89 04 24             	mov    %eax,(%esp)
  102a0e:	e8 0d ff ff ff       	call   102920 <set_page_ref>

        SetPageProperty(base);
  102a13:	8b 45 08             	mov    0x8(%ebp),%eax
  102a16:	83 c0 04             	add    $0x4,%eax
  102a19:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a29:	0f ab 10             	bts    %edx,(%eax)
}
  102a2c:	90                   	nop
    for (; p != base + n; p ++) {
  102a2d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a34:	89 d0                	mov    %edx,%eax
  102a36:	c1 e0 02             	shl    $0x2,%eax
  102a39:	01 d0                	add    %edx,%eax
  102a3b:	c1 e0 02             	shl    $0x2,%eax
  102a3e:	89 c2                	mov    %eax,%edx
  102a40:	8b 45 08             	mov    0x8(%ebp),%eax
  102a43:	01 d0                	add    %edx,%eax
  102a45:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102a48:	0f 85 4c ff ff ff    	jne    10299a <default_init_memmap+0x3b>
    }
    //空闲页块第一个物理页要设置数量，在此处，property设置为n
    base->property = n;
  102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a54:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    
    //更新空闲块的总和
    nr_free += n;
  102a57:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a60:	01 d0                	add    %edx,%eax
  102a62:	a3 88 be 11 00       	mov    %eax,0x11be88
    
    // 初始化玩每个空闲页后，将其要插入到链表每次都插入到节点前面，因为是按地址排序
    //即p->page_link将这个页面链接到free_list
    list_add_before(&free_list, &(base->page_link));
  102a67:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6a:	83 c0 0c             	add    $0xc,%eax
  102a6d:	c7 45 dc 80 be 11 00 	movl   $0x11be80,-0x24(%ebp)
  102a74:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a7a:	8b 00                	mov    (%eax),%eax
  102a7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a7f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a82:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a88:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a8b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a8e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a91:	89 10                	mov    %edx,(%eax)
  102a93:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a96:	8b 10                	mov    (%eax),%edx
  102a98:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a9b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a9e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102aa1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102aa4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102aa7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102aaa:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102aad:	89 10                	mov    %edx,(%eax)
}
  102aaf:	90                   	nop
}
  102ab0:	90                   	nop
}
  102ab1:	90                   	nop
  102ab2:	89 ec                	mov    %ebp,%esp
  102ab4:	5d                   	pop    %ebp
  102ab5:	c3                   	ret    

00102ab6 <default_alloc_pages>:


// 分配n个页块
static struct Page *
default_alloc_pages(size_t n) {
  102ab6:	55                   	push   %ebp
  102ab7:	89 e5                	mov    %esp,%ebp
  102ab9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102abc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ac0:	75 24                	jne    102ae6 <default_alloc_pages+0x30>
  102ac2:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  102ac9:	00 
  102aca:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102ad1:	00 
  102ad2:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  102ad9:	00 
  102ada:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102ae1:	e8 f5 e1 ff ff       	call   100cdb <__panic>
    
    //如果请求的内存大小大于空闲块的大小，返回NULL
    if (n > nr_free) {
  102ae6:	a1 88 be 11 00       	mov    0x11be88,%eax
  102aeb:	39 45 08             	cmp    %eax,0x8(%ebp)
  102aee:	76 0a                	jbe    102afa <default_alloc_pages+0x44>
        return NULL;
  102af0:	b8 00 00 00 00       	mov    $0x0,%eax
  102af5:	e9 70 01 00 00       	jmp    102c6a <default_alloc_pages+0x1b4>
    }
    
    struct Page *page = NULL;
  102afa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    
    //遍历空闲列表
    list_entry_t *le = &free_list;
  102b01:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    // TODO: optimize (next-fit)
    
    // 查找 n 个或以上空闲页块 ，若找到则判断是否大过 n，则将其拆分 并将拆分后的剩下的空闲页块加回到链表中
    while ((le = list_next(le)) != &free_list) {
  102b08:	eb 1c                	jmp    102b26 <default_alloc_pages+0x70>
        // 此处 le2page 就是将 le 的地址 - page_link 在 Page 的偏移 从而找到 Page 的地址
        // 获取page并检查p->property（记录这个块中空闲物理页的数量）是否 >= n
        struct Page *p = le2page(le, page_link);
  102b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b0d:	83 e8 0c             	sub    $0xc,%eax
  102b10:	89 45 ec             	mov    %eax,-0x14(%ebp)
        
        //如果找到满足大小的空闲块，则跳出循环
        if (p->property >= n) {
  102b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b16:	8b 40 08             	mov    0x8(%eax),%eax
  102b19:	39 45 08             	cmp    %eax,0x8(%ebp)
  102b1c:	77 08                	ja     102b26 <default_alloc_pages+0x70>
            page = p;
  102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b24:	eb 18                	jmp    102b3e <default_alloc_pages+0x88>
  102b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  102b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b2f:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  102b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b35:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102b3c:	75 cc                	jne    102b0a <default_alloc_pages+0x54>
        }
    }
    
    //找到满足大小（>=n)的空闲块后，被分配的物理页flags应该被设置为PG_reserved =1，PG_property =0,然后将这些页面从free_list中移除
    if (page != NULL) {
  102b3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b42:	0f 84 1f 01 00 00    	je     102c67 <default_alloc_pages+0x1b1>
  
        list_del(&(page->page_link));
  102b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b4b:	83 c0 0c             	add    $0xc,%eax
  102b4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  102b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b54:	8b 40 04             	mov    0x4(%eax),%eax
  102b57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b5a:	8b 12                	mov    (%edx),%edx
  102b5c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b65:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b68:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b6b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b71:	89 10                	mov    %edx,(%eax)
}
  102b73:	90                   	nop
}
  102b74:	90                   	nop
        
        //如果p->property >n，应该重新计算这个空闲块剩下的空闲物理页的数量
        if (page->property > n) {
  102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b78:	8b 40 08             	mov    0x8(%eax),%eax
  102b7b:	39 45 08             	cmp    %eax,0x8(%ebp)
  102b7e:	0f 83 8f 00 00 00    	jae    102c13 <default_alloc_pages+0x15d>
        
           //获得分裂出来的新的小空闲块的第一个页的描述信息
            struct Page *p = page + n;
  102b84:	8b 55 08             	mov    0x8(%ebp),%edx
  102b87:	89 d0                	mov    %edx,%eax
  102b89:	c1 e0 02             	shl    $0x2,%eax
  102b8c:	01 d0                	add    %edx,%eax
  102b8e:	c1 e0 02             	shl    $0x2,%eax
  102b91:	89 c2                	mov    %eax,%edx
  102b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b96:	01 d0                	add    %edx,%eax
  102b98:	89 45 e8             	mov    %eax,-0x18(%ebp)
            
            //更新新的空闲块的大小信息
            p->property = page->property - n;
  102b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b9e:	8b 40 08             	mov    0x8(%eax),%eax
  102ba1:	2b 45 08             	sub    0x8(%ebp),%eax
  102ba4:	89 c2                	mov    %eax,%edx
  102ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ba9:	89 50 08             	mov    %edx,0x8(%eax)
            //property被值为1,表明是空闲的
            SetPageProperty(p);
  102bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102baf:	83 c0 04             	add    $0x4,%eax
  102bb2:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102bb9:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bbc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bbf:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102bc2:	0f ab 10             	bts    %edx,(%eax)
}
  102bc5:	90                   	nop
            
            //将新空闲块插入空闲块列表后
            list_add_after(&(page->page_link), &(p->page_link));
  102bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bc9:	83 c0 0c             	add    $0xc,%eax
  102bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bcf:	83 c2 0c             	add    $0xc,%edx
  102bd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102bd5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    __list_add(elm, listelm, listelm->next);
  102bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bdb:	8b 40 04             	mov    0x4(%eax),%eax
  102bde:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102be1:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102be4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102be7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102bea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    prev->next = next->prev = elm;
  102bed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bf0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102bf3:	89 10                	mov    %edx,(%eax)
  102bf5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bf8:	8b 10                	mov    (%eax),%edx
  102bfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102bfd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c03:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c06:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c0f:	89 10                	mov    %edx,(%eax)
}
  102c11:	90                   	nop
}
  102c12:	90                   	nop
        }
        
        // 在空闲页链表中删除掉原来的空闲页
        list_del(&(page->page_link));
  102c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c16:	83 c0 0c             	add    $0xc,%eax
  102c19:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  102c1c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c1f:	8b 40 04             	mov    0x4(%eax),%eax
  102c22:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c25:	8b 12                	mov    (%edx),%edx
  102c27:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102c2a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  102c2d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102c30:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102c33:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c36:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c39:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102c3c:	89 10                	mov    %edx,(%eax)
}
  102c3e:	90                   	nop
}
  102c3f:	90                   	nop
        
        //重新计算nr_free（更新所有空闲块的空闲部分的数量）
        nr_free -= n;
  102c40:	a1 88 be 11 00       	mov    0x11be88,%eax
  102c45:	2b 45 08             	sub    0x8(%ebp),%eax
  102c48:	a3 88 be 11 00       	mov    %eax,0x11be88
        //将分配出去的内存页标记为非空闲
        ClearPageProperty(page);
  102c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c50:	83 c0 04             	add    $0x4,%eax
  102c53:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102c5a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c5d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c60:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c63:	0f b3 10             	btr    %edx,(%eax)
}
  102c66:	90                   	nop
    }
    return page;
  102c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c6a:	89 ec                	mov    %ebp,%esp
  102c6c:	5d                   	pop    %ebp
  102c6d:	c3                   	ret    

00102c6e <default_free_pages>:


// 释放掉 n 个 页块
static void
default_free_pages(struct Page *base, size_t n) {
  102c6e:	55                   	push   %ebp
  102c6f:	89 e5                	mov    %esp,%ebp
  102c71:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  102c77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c7b:	75 24                	jne    102ca1 <default_free_pages+0x33>
  102c7d:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  102c84:	00 
  102c85:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102c8c:	00 
  102c8d:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  102c94:	00 
  102c95:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102c9c:	e8 3a e0 ff ff       	call   100cdb <__panic>
    struct Page *p = base;
  102ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    for (; p != base + n; p ++) {
  102ca7:	e9 9d 00 00 00       	jmp    102d49 <default_free_pages+0xdb>
        //进行检查
        assert(!PageReserved(p) && !PageProperty(p));
  102cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102caf:	83 c0 04             	add    $0x4,%eax
  102cb2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102cb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102cc2:	0f a3 10             	bt     %edx,(%eax)
  102cc5:	19 c0                	sbb    %eax,%eax
  102cc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102cca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102cce:	0f 95 c0             	setne  %al
  102cd1:	0f b6 c0             	movzbl %al,%eax
  102cd4:	85 c0                	test   %eax,%eax
  102cd6:	75 2c                	jne    102d04 <default_free_pages+0x96>
  102cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cdb:	83 c0 04             	add    $0x4,%eax
  102cde:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102ce5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102ce8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ceb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cee:	0f a3 10             	bt     %edx,(%eax)
  102cf1:	19 c0                	sbb    %eax,%eax
  102cf3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102cf6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102cfa:	0f 95 c0             	setne  %al
  102cfd:	0f b6 c0             	movzbl %al,%eax
  102d00:	85 c0                	test   %eax,%eax
  102d02:	74 24                	je     102d28 <default_free_pages+0xba>
  102d04:	c7 44 24 0c 54 67 10 	movl   $0x106754,0xc(%esp)
  102d0b:	00 
  102d0c:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102d13:	00 
  102d14:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  102d1b:	00 
  102d1c:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102d23:	e8 b3 df ff ff       	call   100cdb <__panic>
        //重置物理页的属性
        p->flags = 0;
  102d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        //清空引用计数
        set_page_ref(p, 0);
  102d32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d39:	00 
  102d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d3d:	89 04 24             	mov    %eax,(%esp)
  102d40:	e8 db fb ff ff       	call   102920 <set_page_ref>
    for (; p != base + n; p ++) {
  102d45:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d4c:	89 d0                	mov    %edx,%eax
  102d4e:	c1 e0 02             	shl    $0x2,%eax
  102d51:	01 d0                	add    %edx,%eax
  102d53:	c1 e0 02             	shl    $0x2,%eax
  102d56:	89 c2                	mov    %eax,%edx
  102d58:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5b:	01 d0                	add    %edx,%eax
  102d5d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102d60:	0f 85 46 ff ff ff    	jne    102cac <default_free_pages+0x3e>
    }
    
    //设置空闲块的的大小
    base->property = n;
  102d66:	8b 45 08             	mov    0x8(%ebp),%eax
  102d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d6c:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d72:	83 c0 04             	add    $0x4,%eax
  102d75:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102d7c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d82:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d85:	0f ab 10             	bts    %edx,(%eax)
}
  102d88:	90                   	nop
  102d89:	c7 45 d4 80 be 11 00 	movl   $0x11be80,-0x2c(%ebp)
    return listelm->next;
  102d90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d93:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
    // 合并到合适的页块中，并将合并好的合适的页块添加回空闲页块链表
    //迭代空闲链表中的每一个节点
    while (le != &free_list) {
  102d99:	e9 2d 01 00 00       	jmp    102ecb <default_free_pages+0x25d>
        //获取节点对应的Page结构
        p = le2page(le, page_link);
  102d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da1:	83 e8 0c             	sub    $0xc,%eax
  102da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        
        // TODO: optimize
        //尾部正好能和下一个连上，则合并
        if (base + base->property == p) {
  102da7:	8b 45 08             	mov    0x8(%ebp),%eax
  102daa:	8b 50 08             	mov    0x8(%eax),%edx
  102dad:	89 d0                	mov    %edx,%eax
  102daf:	c1 e0 02             	shl    $0x2,%eax
  102db2:	01 d0                	add    %edx,%eax
  102db4:	c1 e0 02             	shl    $0x2,%eax
  102db7:	89 c2                	mov    %eax,%edx
  102db9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbc:	01 d0                	add    %edx,%eax
  102dbe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102dc1:	75 5f                	jne    102e22 <default_free_pages+0x1b4>
            base->property += p->property;
  102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc6:	8b 50 08             	mov    0x8(%eax),%edx
  102dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dcc:	8b 40 08             	mov    0x8(%eax),%eax
  102dcf:	01 c2                	add    %eax,%edx
  102dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd4:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dda:	83 c0 04             	add    $0x4,%eax
  102ddd:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  102de4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102de7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dea:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ded:	0f b3 10             	btr    %edx,(%eax)
}
  102df0:	90                   	nop
            list_del(&(p->page_link));
  102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df4:	83 c0 0c             	add    $0xc,%eax
  102df7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_del(listelm->prev, listelm->next);
  102dfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102dfd:	8b 40 04             	mov    0x4(%eax),%eax
  102e00:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102e03:	8b 12                	mov    (%edx),%edx
  102e05:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102e08:	89 45 c0             	mov    %eax,-0x40(%ebp)
    prev->next = next;
  102e0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e0e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102e11:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e14:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102e17:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102e1a:	89 10                	mov    %edx,(%eax)
}
  102e1c:	90                   	nop
}
  102e1d:	e9 9a 00 00 00       	jmp    102ebc <default_free_pages+0x24e>
        }
        //头部正好和上一个连上，则合并
        else if (p + p->property == base) {
  102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e25:	8b 50 08             	mov    0x8(%eax),%edx
  102e28:	89 d0                	mov    %edx,%eax
  102e2a:	c1 e0 02             	shl    $0x2,%eax
  102e2d:	01 d0                	add    %edx,%eax
  102e2f:	c1 e0 02             	shl    $0x2,%eax
  102e32:	89 c2                	mov    %eax,%edx
  102e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e37:	01 d0                	add    %edx,%eax
  102e39:	39 45 08             	cmp    %eax,0x8(%ebp)
  102e3c:	75 62                	jne    102ea0 <default_free_pages+0x232>
            p->property += base->property;
  102e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e41:	8b 50 08             	mov    0x8(%eax),%edx
  102e44:	8b 45 08             	mov    0x8(%ebp),%eax
  102e47:	8b 40 08             	mov    0x8(%eax),%eax
  102e4a:	01 c2                	add    %eax,%edx
  102e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e4f:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e52:	8b 45 08             	mov    0x8(%ebp),%eax
  102e55:	83 c0 04             	add    $0x4,%eax
  102e58:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  102e5f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e65:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102e68:	0f b3 10             	btr    %edx,(%eax)
}
  102e6b:	90                   	nop
            base = p;
  102e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6f:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e75:	83 c0 0c             	add    $0xc,%eax
  102e78:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102e7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e7e:	8b 40 04             	mov    0x4(%eax),%eax
  102e81:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e84:	8b 12                	mov    (%edx),%edx
  102e86:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102e89:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next;
  102e8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e8f:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102e92:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e95:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e98:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e9b:	89 10                	mov    %edx,(%eax)
}
  102e9d:	90                   	nop
}
  102e9e:	eb 1c                	jmp    102ebc <default_free_pages+0x24e>
        }
        
        else if (base + base->property < p)
  102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea3:	8b 50 08             	mov    0x8(%eax),%edx
  102ea6:	89 d0                	mov    %edx,%eax
  102ea8:	c1 e0 02             	shl    $0x2,%eax
  102eab:	01 d0                	add    %edx,%eax
  102ead:	c1 e0 02             	shl    $0x2,%eax
  102eb0:	89 c2                	mov    %eax,%edx
  102eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb5:	01 d0                	add    %edx,%eax
  102eb7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102eba:	77 1e                	ja     102eda <default_free_pages+0x26c>
  102ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebf:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
  102ec2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ec5:	8b 40 04             	mov    0x4(%eax),%eax
        {
            break;
        }
        le = list_next(le);
  102ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102ecb:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102ed2:	0f 85 c6 fe ff ff    	jne    102d9e <default_free_pages+0x130>
  102ed8:	eb 01                	jmp    102edb <default_free_pages+0x26d>
            break;
  102eda:	90                   	nop
    }
 
    //将空闲块插入到链表中
    list_add_before(le, &(base->page_link));
  102edb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ede:	8d 50 0c             	lea    0xc(%eax),%edx
  102ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee4:	89 45 9c             	mov    %eax,-0x64(%ebp)
  102ee7:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
  102eea:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102eed:	8b 00                	mov    (%eax),%eax
  102eef:	8b 55 98             	mov    -0x68(%ebp),%edx
  102ef2:	89 55 94             	mov    %edx,-0x6c(%ebp)
  102ef5:	89 45 90             	mov    %eax,-0x70(%ebp)
  102ef8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102efb:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
  102efe:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f01:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102f04:	89 10                	mov    %edx,(%eax)
  102f06:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f09:	8b 10                	mov    (%eax),%edx
  102f0b:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f0e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102f11:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f14:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102f17:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102f1a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f1d:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f20:	89 10                	mov    %edx,(%eax)
}
  102f22:	90                   	nop
}
  102f23:	90                   	nop
 
    //更新空间物理页总量
    nr_free += n;
  102f24:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2d:	01 d0                	add    %edx,%eax
  102f2f:	a3 88 be 11 00       	mov    %eax,0x11be88
}
  102f34:	90                   	nop
  102f35:	89 ec                	mov    %ebp,%esp
  102f37:	5d                   	pop    %ebp
  102f38:	c3                   	ret    

00102f39 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102f39:	55                   	push   %ebp
  102f3a:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102f3c:	a1 88 be 11 00       	mov    0x11be88,%eax
}
  102f41:	5d                   	pop    %ebp
  102f42:	c3                   	ret    

00102f43 <basic_check>:

static void
basic_check(void) {
  102f43:	55                   	push   %ebp
  102f44:	89 e5                	mov    %esp,%ebp
  102f46:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102f49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f59:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102f5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f63:	e8 af 0e 00 00       	call   103e17 <alloc_pages>
  102f68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f6b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f6f:	75 24                	jne    102f95 <basic_check+0x52>
  102f71:	c7 44 24 0c 79 67 10 	movl   $0x106779,0xc(%esp)
  102f78:	00 
  102f79:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102f80:	00 
  102f81:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  102f88:	00 
  102f89:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102f90:	e8 46 dd ff ff       	call   100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f9c:	e8 76 0e 00 00       	call   103e17 <alloc_pages>
  102fa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102fa8:	75 24                	jne    102fce <basic_check+0x8b>
  102faa:	c7 44 24 0c 95 67 10 	movl   $0x106795,0xc(%esp)
  102fb1:	00 
  102fb2:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102fb9:	00 
  102fba:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  102fc1:	00 
  102fc2:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  102fc9:	e8 0d dd ff ff       	call   100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
  102fce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fd5:	e8 3d 0e 00 00       	call   103e17 <alloc_pages>
  102fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102fe1:	75 24                	jne    103007 <basic_check+0xc4>
  102fe3:	c7 44 24 0c b1 67 10 	movl   $0x1067b1,0xc(%esp)
  102fea:	00 
  102feb:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  102ff2:	00 
  102ff3:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  102ffa:	00 
  102ffb:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103002:	e8 d4 dc ff ff       	call   100cdb <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10300a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10300d:	74 10                	je     10301f <basic_check+0xdc>
  10300f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103012:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103015:	74 08                	je     10301f <basic_check+0xdc>
  103017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10301a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10301d:	75 24                	jne    103043 <basic_check+0x100>
  10301f:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  103026:	00 
  103027:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10302e:	00 
  10302f:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103036:	00 
  103037:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10303e:	e8 98 dc ff ff       	call   100cdb <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  103043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103046:	89 04 24             	mov    %eax,(%esp)
  103049:	e8 c8 f8 ff ff       	call   102916 <page_ref>
  10304e:	85 c0                	test   %eax,%eax
  103050:	75 1e                	jne    103070 <basic_check+0x12d>
  103052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103055:	89 04 24             	mov    %eax,(%esp)
  103058:	e8 b9 f8 ff ff       	call   102916 <page_ref>
  10305d:	85 c0                	test   %eax,%eax
  10305f:	75 0f                	jne    103070 <basic_check+0x12d>
  103061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103064:	89 04 24             	mov    %eax,(%esp)
  103067:	e8 aa f8 ff ff       	call   102916 <page_ref>
  10306c:	85 c0                	test   %eax,%eax
  10306e:	74 24                	je     103094 <basic_check+0x151>
  103070:	c7 44 24 0c f4 67 10 	movl   $0x1067f4,0xc(%esp)
  103077:	00 
  103078:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10307f:	00 
  103080:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  103087:	00 
  103088:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10308f:	e8 47 dc ff ff       	call   100cdb <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  103094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103097:	89 04 24             	mov    %eax,(%esp)
  10309a:	e8 5f f8 ff ff       	call   1028fe <page2pa>
  10309f:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1030a5:	c1 e2 0c             	shl    $0xc,%edx
  1030a8:	39 d0                	cmp    %edx,%eax
  1030aa:	72 24                	jb     1030d0 <basic_check+0x18d>
  1030ac:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  1030b3:	00 
  1030b4:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1030bb:	00 
  1030bc:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  1030c3:	00 
  1030c4:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1030cb:	e8 0b dc ff ff       	call   100cdb <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1030d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d3:	89 04 24             	mov    %eax,(%esp)
  1030d6:	e8 23 f8 ff ff       	call   1028fe <page2pa>
  1030db:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1030e1:	c1 e2 0c             	shl    $0xc,%edx
  1030e4:	39 d0                	cmp    %edx,%eax
  1030e6:	72 24                	jb     10310c <basic_check+0x1c9>
  1030e8:	c7 44 24 0c 4d 68 10 	movl   $0x10684d,0xc(%esp)
  1030ef:	00 
  1030f0:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1030f7:	00 
  1030f8:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  1030ff:	00 
  103100:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103107:	e8 cf db ff ff       	call   100cdb <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10310f:	89 04 24             	mov    %eax,(%esp)
  103112:	e8 e7 f7 ff ff       	call   1028fe <page2pa>
  103117:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  10311d:	c1 e2 0c             	shl    $0xc,%edx
  103120:	39 d0                	cmp    %edx,%eax
  103122:	72 24                	jb     103148 <basic_check+0x205>
  103124:	c7 44 24 0c 6a 68 10 	movl   $0x10686a,0xc(%esp)
  10312b:	00 
  10312c:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103133:	00 
  103134:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  10313b:	00 
  10313c:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103143:	e8 93 db ff ff       	call   100cdb <__panic>

    list_entry_t free_list_store = free_list;
  103148:	a1 80 be 11 00       	mov    0x11be80,%eax
  10314d:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103153:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103156:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103159:	c7 45 dc 80 be 11 00 	movl   $0x11be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  103160:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103163:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103166:	89 50 04             	mov    %edx,0x4(%eax)
  103169:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10316c:	8b 50 04             	mov    0x4(%eax),%edx
  10316f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103172:	89 10                	mov    %edx,(%eax)
}
  103174:	90                   	nop
  103175:	c7 45 e0 80 be 11 00 	movl   $0x11be80,-0x20(%ebp)
    return list->next == list;
  10317c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10317f:	8b 40 04             	mov    0x4(%eax),%eax
  103182:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103185:	0f 94 c0             	sete   %al
  103188:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10318b:	85 c0                	test   %eax,%eax
  10318d:	75 24                	jne    1031b3 <basic_check+0x270>
  10318f:	c7 44 24 0c 87 68 10 	movl   $0x106887,0xc(%esp)
  103196:	00 
  103197:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10319e:	00 
  10319f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1031a6:	00 
  1031a7:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1031ae:	e8 28 db ff ff       	call   100cdb <__panic>

    unsigned int nr_free_store = nr_free;
  1031b3:	a1 88 be 11 00       	mov    0x11be88,%eax
  1031b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1031bb:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  1031c2:	00 00 00 

    assert(alloc_page() == NULL);
  1031c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031cc:	e8 46 0c 00 00       	call   103e17 <alloc_pages>
  1031d1:	85 c0                	test   %eax,%eax
  1031d3:	74 24                	je     1031f9 <basic_check+0x2b6>
  1031d5:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  1031dc:	00 
  1031dd:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1031e4:	00 
  1031e5:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  1031ec:	00 
  1031ed:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1031f4:	e8 e2 da ff ff       	call   100cdb <__panic>

    free_page(p0);
  1031f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103200:	00 
  103201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103204:	89 04 24             	mov    %eax,(%esp)
  103207:	e8 45 0c 00 00       	call   103e51 <free_pages>
    free_page(p1);
  10320c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103213:	00 
  103214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103217:	89 04 24             	mov    %eax,(%esp)
  10321a:	e8 32 0c 00 00       	call   103e51 <free_pages>
    free_page(p2);
  10321f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103226:	00 
  103227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10322a:	89 04 24             	mov    %eax,(%esp)
  10322d:	e8 1f 0c 00 00       	call   103e51 <free_pages>
    assert(nr_free == 3);
  103232:	a1 88 be 11 00       	mov    0x11be88,%eax
  103237:	83 f8 03             	cmp    $0x3,%eax
  10323a:	74 24                	je     103260 <basic_check+0x31d>
  10323c:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  103243:	00 
  103244:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10324b:	00 
  10324c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  103253:	00 
  103254:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10325b:	e8 7b da ff ff       	call   100cdb <__panic>

    assert((p0 = alloc_page()) != NULL);
  103260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103267:	e8 ab 0b 00 00       	call   103e17 <alloc_pages>
  10326c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10326f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103273:	75 24                	jne    103299 <basic_check+0x356>
  103275:	c7 44 24 0c 79 67 10 	movl   $0x106779,0xc(%esp)
  10327c:	00 
  10327d:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103284:	00 
  103285:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  10328c:	00 
  10328d:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103294:	e8 42 da ff ff       	call   100cdb <__panic>
    assert((p1 = alloc_page()) != NULL);
  103299:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032a0:	e8 72 0b 00 00       	call   103e17 <alloc_pages>
  1032a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032ac:	75 24                	jne    1032d2 <basic_check+0x38f>
  1032ae:	c7 44 24 0c 95 67 10 	movl   $0x106795,0xc(%esp)
  1032b5:	00 
  1032b6:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1032bd:	00 
  1032be:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  1032c5:	00 
  1032c6:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1032cd:	e8 09 da ff ff       	call   100cdb <__panic>
    assert((p2 = alloc_page()) != NULL);
  1032d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032d9:	e8 39 0b 00 00       	call   103e17 <alloc_pages>
  1032de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032e5:	75 24                	jne    10330b <basic_check+0x3c8>
  1032e7:	c7 44 24 0c b1 67 10 	movl   $0x1067b1,0xc(%esp)
  1032ee:	00 
  1032ef:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1032f6:	00 
  1032f7:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  1032fe:	00 
  1032ff:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103306:	e8 d0 d9 ff ff       	call   100cdb <__panic>

    assert(alloc_page() == NULL);
  10330b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103312:	e8 00 0b 00 00       	call   103e17 <alloc_pages>
  103317:	85 c0                	test   %eax,%eax
  103319:	74 24                	je     10333f <basic_check+0x3fc>
  10331b:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  103322:	00 
  103323:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10332a:	00 
  10332b:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  103332:	00 
  103333:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10333a:	e8 9c d9 ff ff       	call   100cdb <__panic>

    free_page(p0);
  10333f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103346:	00 
  103347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10334a:	89 04 24             	mov    %eax,(%esp)
  10334d:	e8 ff 0a 00 00       	call   103e51 <free_pages>
  103352:	c7 45 d8 80 be 11 00 	movl   $0x11be80,-0x28(%ebp)
  103359:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10335c:	8b 40 04             	mov    0x4(%eax),%eax
  10335f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103362:	0f 94 c0             	sete   %al
  103365:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103368:	85 c0                	test   %eax,%eax
  10336a:	74 24                	je     103390 <basic_check+0x44d>
  10336c:	c7 44 24 0c c0 68 10 	movl   $0x1068c0,0xc(%esp)
  103373:	00 
  103374:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10337b:	00 
  10337c:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  103383:	00 
  103384:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10338b:	e8 4b d9 ff ff       	call   100cdb <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103390:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103397:	e8 7b 0a 00 00       	call   103e17 <alloc_pages>
  10339c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1033a5:	74 24                	je     1033cb <basic_check+0x488>
  1033a7:	c7 44 24 0c d8 68 10 	movl   $0x1068d8,0xc(%esp)
  1033ae:	00 
  1033af:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1033b6:	00 
  1033b7:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1033be:	00 
  1033bf:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1033c6:	e8 10 d9 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  1033cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033d2:	e8 40 0a 00 00       	call   103e17 <alloc_pages>
  1033d7:	85 c0                	test   %eax,%eax
  1033d9:	74 24                	je     1033ff <basic_check+0x4bc>
  1033db:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  1033e2:	00 
  1033e3:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1033ea:	00 
  1033eb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1033f2:	00 
  1033f3:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1033fa:	e8 dc d8 ff ff       	call   100cdb <__panic>

    assert(nr_free == 0);
  1033ff:	a1 88 be 11 00       	mov    0x11be88,%eax
  103404:	85 c0                	test   %eax,%eax
  103406:	74 24                	je     10342c <basic_check+0x4e9>
  103408:	c7 44 24 0c f1 68 10 	movl   $0x1068f1,0xc(%esp)
  10340f:	00 
  103410:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103417:	00 
  103418:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  10341f:	00 
  103420:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103427:	e8 af d8 ff ff       	call   100cdb <__panic>
    free_list = free_list_store;
  10342c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10342f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103432:	a3 80 be 11 00       	mov    %eax,0x11be80
  103437:	89 15 84 be 11 00    	mov    %edx,0x11be84
    nr_free = nr_free_store;
  10343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103440:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_page(p);
  103445:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10344c:	00 
  10344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103450:	89 04 24             	mov    %eax,(%esp)
  103453:	e8 f9 09 00 00       	call   103e51 <free_pages>
    free_page(p1);
  103458:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10345f:	00 
  103460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103463:	89 04 24             	mov    %eax,(%esp)
  103466:	e8 e6 09 00 00       	call   103e51 <free_pages>
    free_page(p2);
  10346b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103472:	00 
  103473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103476:	89 04 24             	mov    %eax,(%esp)
  103479:	e8 d3 09 00 00       	call   103e51 <free_pages>
}
  10347e:	90                   	nop
  10347f:	89 ec                	mov    %ebp,%esp
  103481:	5d                   	pop    %ebp
  103482:	c3                   	ret    

00103483 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103483:	55                   	push   %ebp
  103484:	89 e5                	mov    %esp,%ebp
  103486:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  10348c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103493:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10349a:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1034a1:	eb 6a                	jmp    10350d <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  1034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034a6:	83 e8 0c             	sub    $0xc,%eax
  1034a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1034ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1034af:	83 c0 04             	add    $0x4,%eax
  1034b2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1034b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1034bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1034c2:	0f a3 10             	bt     %edx,(%eax)
  1034c5:	19 c0                	sbb    %eax,%eax
  1034c7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1034ca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1034ce:	0f 95 c0             	setne  %al
  1034d1:	0f b6 c0             	movzbl %al,%eax
  1034d4:	85 c0                	test   %eax,%eax
  1034d6:	75 24                	jne    1034fc <default_check+0x79>
  1034d8:	c7 44 24 0c fe 68 10 	movl   $0x1068fe,0xc(%esp)
  1034df:	00 
  1034e0:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1034e7:	00 
  1034e8:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  1034ef:	00 
  1034f0:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1034f7:	e8 df d7 ff ff       	call   100cdb <__panic>
        count ++, total += p->property;
  1034fc:	ff 45 f4             	incl   -0xc(%ebp)
  1034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103502:	8b 50 08             	mov    0x8(%eax),%edx
  103505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103508:	01 d0                	add    %edx,%eax
  10350a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10350d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103510:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  103513:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103516:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103519:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10351c:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103523:	0f 85 7a ff ff ff    	jne    1034a3 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  103529:	e8 58 09 00 00       	call   103e86 <nr_free_pages>
  10352e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103531:	39 d0                	cmp    %edx,%eax
  103533:	74 24                	je     103559 <default_check+0xd6>
  103535:	c7 44 24 0c 0e 69 10 	movl   $0x10690e,0xc(%esp)
  10353c:	00 
  10353d:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103544:	00 
  103545:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  10354c:	00 
  10354d:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103554:	e8 82 d7 ff ff       	call   100cdb <__panic>

    basic_check();
  103559:	e8 e5 f9 ff ff       	call   102f43 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10355e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103565:	e8 ad 08 00 00       	call   103e17 <alloc_pages>
  10356a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  10356d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103571:	75 24                	jne    103597 <default_check+0x114>
  103573:	c7 44 24 0c 27 69 10 	movl   $0x106927,0xc(%esp)
  10357a:	00 
  10357b:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103582:	00 
  103583:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  10358a:	00 
  10358b:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103592:	e8 44 d7 ff ff       	call   100cdb <__panic>
    assert(!PageProperty(p0));
  103597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10359a:	83 c0 04             	add    $0x4,%eax
  10359d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1035a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035a7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1035aa:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1035ad:	0f a3 10             	bt     %edx,(%eax)
  1035b0:	19 c0                	sbb    %eax,%eax
  1035b2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1035b5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1035b9:	0f 95 c0             	setne  %al
  1035bc:	0f b6 c0             	movzbl %al,%eax
  1035bf:	85 c0                	test   %eax,%eax
  1035c1:	74 24                	je     1035e7 <default_check+0x164>
  1035c3:	c7 44 24 0c 32 69 10 	movl   $0x106932,0xc(%esp)
  1035ca:	00 
  1035cb:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1035d2:	00 
  1035d3:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  1035da:	00 
  1035db:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1035e2:	e8 f4 d6 ff ff       	call   100cdb <__panic>

    list_entry_t free_list_store = free_list;
  1035e7:	a1 80 be 11 00       	mov    0x11be80,%eax
  1035ec:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  1035f2:	89 45 80             	mov    %eax,-0x80(%ebp)
  1035f5:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1035f8:	c7 45 b0 80 be 11 00 	movl   $0x11be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1035ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103602:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103605:	89 50 04             	mov    %edx,0x4(%eax)
  103608:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10360b:	8b 50 04             	mov    0x4(%eax),%edx
  10360e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103611:	89 10                	mov    %edx,(%eax)
}
  103613:	90                   	nop
  103614:	c7 45 b4 80 be 11 00 	movl   $0x11be80,-0x4c(%ebp)
    return list->next == list;
  10361b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10361e:	8b 40 04             	mov    0x4(%eax),%eax
  103621:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  103624:	0f 94 c0             	sete   %al
  103627:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10362a:	85 c0                	test   %eax,%eax
  10362c:	75 24                	jne    103652 <default_check+0x1cf>
  10362e:	c7 44 24 0c 87 68 10 	movl   $0x106887,0xc(%esp)
  103635:	00 
  103636:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10363d:	00 
  10363e:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
  103645:	00 
  103646:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10364d:	e8 89 d6 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  103652:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103659:	e8 b9 07 00 00       	call   103e17 <alloc_pages>
  10365e:	85 c0                	test   %eax,%eax
  103660:	74 24                	je     103686 <default_check+0x203>
  103662:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  103669:	00 
  10366a:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103671:	00 
  103672:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
  103679:	00 
  10367a:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103681:	e8 55 d6 ff ff       	call   100cdb <__panic>

    unsigned int nr_free_store = nr_free;
  103686:	a1 88 be 11 00       	mov    0x11be88,%eax
  10368b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10368e:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  103695:	00 00 00 

    free_pages(p0 + 2, 3);
  103698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10369b:	83 c0 28             	add    $0x28,%eax
  10369e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036a5:	00 
  1036a6:	89 04 24             	mov    %eax,(%esp)
  1036a9:	e8 a3 07 00 00       	call   103e51 <free_pages>
    assert(alloc_pages(4) == NULL);
  1036ae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1036b5:	e8 5d 07 00 00       	call   103e17 <alloc_pages>
  1036ba:	85 c0                	test   %eax,%eax
  1036bc:	74 24                	je     1036e2 <default_check+0x25f>
  1036be:	c7 44 24 0c 44 69 10 	movl   $0x106944,0xc(%esp)
  1036c5:	00 
  1036c6:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1036cd:	00 
  1036ce:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
  1036d5:	00 
  1036d6:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1036dd:	e8 f9 d5 ff ff       	call   100cdb <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1036e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036e5:	83 c0 28             	add    $0x28,%eax
  1036e8:	83 c0 04             	add    $0x4,%eax
  1036eb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1036f2:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036f5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1036f8:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1036fb:	0f a3 10             	bt     %edx,(%eax)
  1036fe:	19 c0                	sbb    %eax,%eax
  103700:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103703:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103707:	0f 95 c0             	setne  %al
  10370a:	0f b6 c0             	movzbl %al,%eax
  10370d:	85 c0                	test   %eax,%eax
  10370f:	74 0e                	je     10371f <default_check+0x29c>
  103711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103714:	83 c0 28             	add    $0x28,%eax
  103717:	8b 40 08             	mov    0x8(%eax),%eax
  10371a:	83 f8 03             	cmp    $0x3,%eax
  10371d:	74 24                	je     103743 <default_check+0x2c0>
  10371f:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  103726:	00 
  103727:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10372e:	00 
  10372f:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  103736:	00 
  103737:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10373e:	e8 98 d5 ff ff       	call   100cdb <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103743:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10374a:	e8 c8 06 00 00       	call   103e17 <alloc_pages>
  10374f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103756:	75 24                	jne    10377c <default_check+0x2f9>
  103758:	c7 44 24 0c 88 69 10 	movl   $0x106988,0xc(%esp)
  10375f:	00 
  103760:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103767:	00 
  103768:	c7 44 24 04 55 01 00 	movl   $0x155,0x4(%esp)
  10376f:	00 
  103770:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103777:	e8 5f d5 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  10377c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103783:	e8 8f 06 00 00       	call   103e17 <alloc_pages>
  103788:	85 c0                	test   %eax,%eax
  10378a:	74 24                	je     1037b0 <default_check+0x32d>
  10378c:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  103793:	00 
  103794:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10379b:	00 
  10379c:	c7 44 24 04 56 01 00 	movl   $0x156,0x4(%esp)
  1037a3:	00 
  1037a4:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1037ab:	e8 2b d5 ff ff       	call   100cdb <__panic>
    assert(p0 + 2 == p1);
  1037b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037b3:	83 c0 28             	add    $0x28,%eax
  1037b6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1037b9:	74 24                	je     1037df <default_check+0x35c>
  1037bb:	c7 44 24 0c a6 69 10 	movl   $0x1069a6,0xc(%esp)
  1037c2:	00 
  1037c3:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1037ca:	00 
  1037cb:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
  1037d2:	00 
  1037d3:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1037da:	e8 fc d4 ff ff       	call   100cdb <__panic>

    p2 = p0 + 1;
  1037df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037e2:	83 c0 14             	add    $0x14,%eax
  1037e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1037e8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037ef:	00 
  1037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037f3:	89 04 24             	mov    %eax,(%esp)
  1037f6:	e8 56 06 00 00       	call   103e51 <free_pages>
    free_pages(p1, 3);
  1037fb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103802:	00 
  103803:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103806:	89 04 24             	mov    %eax,(%esp)
  103809:	e8 43 06 00 00       	call   103e51 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10380e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103811:	83 c0 04             	add    $0x4,%eax
  103814:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10381b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10381e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103821:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103824:	0f a3 10             	bt     %edx,(%eax)
  103827:	19 c0                	sbb    %eax,%eax
  103829:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10382c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103830:	0f 95 c0             	setne  %al
  103833:	0f b6 c0             	movzbl %al,%eax
  103836:	85 c0                	test   %eax,%eax
  103838:	74 0b                	je     103845 <default_check+0x3c2>
  10383a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10383d:	8b 40 08             	mov    0x8(%eax),%eax
  103840:	83 f8 01             	cmp    $0x1,%eax
  103843:	74 24                	je     103869 <default_check+0x3e6>
  103845:	c7 44 24 0c b4 69 10 	movl   $0x1069b4,0xc(%esp)
  10384c:	00 
  10384d:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103854:	00 
  103855:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
  10385c:	00 
  10385d:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103864:	e8 72 d4 ff ff       	call   100cdb <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103869:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10386c:	83 c0 04             	add    $0x4,%eax
  10386f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103876:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103879:	8b 45 90             	mov    -0x70(%ebp),%eax
  10387c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10387f:	0f a3 10             	bt     %edx,(%eax)
  103882:	19 c0                	sbb    %eax,%eax
  103884:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103887:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10388b:	0f 95 c0             	setne  %al
  10388e:	0f b6 c0             	movzbl %al,%eax
  103891:	85 c0                	test   %eax,%eax
  103893:	74 0b                	je     1038a0 <default_check+0x41d>
  103895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103898:	8b 40 08             	mov    0x8(%eax),%eax
  10389b:	83 f8 03             	cmp    $0x3,%eax
  10389e:	74 24                	je     1038c4 <default_check+0x441>
  1038a0:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  1038a7:	00 
  1038a8:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1038af:	00 
  1038b0:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
  1038b7:	00 
  1038b8:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1038bf:	e8 17 d4 ff ff       	call   100cdb <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038cb:	e8 47 05 00 00       	call   103e17 <alloc_pages>
  1038d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1038d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1038d6:	83 e8 14             	sub    $0x14,%eax
  1038d9:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1038dc:	74 24                	je     103902 <default_check+0x47f>
  1038de:	c7 44 24 0c 02 6a 10 	movl   $0x106a02,0xc(%esp)
  1038e5:	00 
  1038e6:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1038ed:	00 
  1038ee:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
  1038f5:	00 
  1038f6:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1038fd:	e8 d9 d3 ff ff       	call   100cdb <__panic>
    free_page(p0);
  103902:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103909:	00 
  10390a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10390d:	89 04 24             	mov    %eax,(%esp)
  103910:	e8 3c 05 00 00       	call   103e51 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103915:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10391c:	e8 f6 04 00 00       	call   103e17 <alloc_pages>
  103921:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103924:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103927:	83 c0 14             	add    $0x14,%eax
  10392a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10392d:	74 24                	je     103953 <default_check+0x4d0>
  10392f:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  103936:	00 
  103937:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10393e:	00 
  10393f:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
  103946:	00 
  103947:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  10394e:	e8 88 d3 ff ff       	call   100cdb <__panic>

    free_pages(p0, 2);
  103953:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10395a:	00 
  10395b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10395e:	89 04 24             	mov    %eax,(%esp)
  103961:	e8 eb 04 00 00       	call   103e51 <free_pages>
    free_page(p2);
  103966:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10396d:	00 
  10396e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103971:	89 04 24             	mov    %eax,(%esp)
  103974:	e8 d8 04 00 00       	call   103e51 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103979:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103980:	e8 92 04 00 00       	call   103e17 <alloc_pages>
  103985:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10398c:	75 24                	jne    1039b2 <default_check+0x52f>
  10398e:	c7 44 24 0c 40 6a 10 	movl   $0x106a40,0xc(%esp)
  103995:	00 
  103996:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  10399d:	00 
  10399e:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
  1039a5:	00 
  1039a6:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1039ad:	e8 29 d3 ff ff       	call   100cdb <__panic>
    assert(alloc_page() == NULL);
  1039b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039b9:	e8 59 04 00 00       	call   103e17 <alloc_pages>
  1039be:	85 c0                	test   %eax,%eax
  1039c0:	74 24                	je     1039e6 <default_check+0x563>
  1039c2:	c7 44 24 0c 9e 68 10 	movl   $0x10689e,0xc(%esp)
  1039c9:	00 
  1039ca:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1039d1:	00 
  1039d2:	c7 44 24 04 67 01 00 	movl   $0x167,0x4(%esp)
  1039d9:	00 
  1039da:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  1039e1:	e8 f5 d2 ff ff       	call   100cdb <__panic>

    assert(nr_free == 0);
  1039e6:	a1 88 be 11 00       	mov    0x11be88,%eax
  1039eb:	85 c0                	test   %eax,%eax
  1039ed:	74 24                	je     103a13 <default_check+0x590>
  1039ef:	c7 44 24 0c f1 68 10 	movl   $0x1068f1,0xc(%esp)
  1039f6:	00 
  1039f7:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  1039fe:	00 
  1039ff:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
  103a06:	00 
  103a07:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103a0e:	e8 c8 d2 ff ff       	call   100cdb <__panic>
    nr_free = nr_free_store;
  103a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a16:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_list = free_list_store;
  103a1b:	8b 45 80             	mov    -0x80(%ebp),%eax
  103a1e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103a21:	a3 80 be 11 00       	mov    %eax,0x11be80
  103a26:	89 15 84 be 11 00    	mov    %edx,0x11be84
    free_pages(p0, 5);
  103a2c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103a33:	00 
  103a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103a37:	89 04 24             	mov    %eax,(%esp)
  103a3a:	e8 12 04 00 00       	call   103e51 <free_pages>

    le = &free_list;
  103a3f:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103a46:	eb 1c                	jmp    103a64 <default_check+0x5e1>
        struct Page *p = le2page(le, page_link);
  103a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a4b:	83 e8 0c             	sub    $0xc,%eax
  103a4e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  103a51:	ff 4d f4             	decl   -0xc(%ebp)
  103a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103a57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a5a:	8b 48 08             	mov    0x8(%eax),%ecx
  103a5d:	89 d0                	mov    %edx,%eax
  103a5f:	29 c8                	sub    %ecx,%eax
  103a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103a67:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  103a6a:	8b 45 88             	mov    -0x78(%ebp),%eax
  103a6d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103a70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103a73:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  103a7a:	75 cc                	jne    103a48 <default_check+0x5c5>
    }
    assert(count == 0);
  103a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a80:	74 24                	je     103aa6 <default_check+0x623>
  103a82:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  103a89:	00 
  103a8a:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103a91:	00 
  103a92:	c7 44 24 04 74 01 00 	movl   $0x174,0x4(%esp)
  103a99:	00 
  103a9a:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103aa1:	e8 35 d2 ff ff       	call   100cdb <__panic>
    assert(total == 0);
  103aa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103aaa:	74 24                	je     103ad0 <default_check+0x64d>
  103aac:	c7 44 24 0c 69 6a 10 	movl   $0x106a69,0xc(%esp)
  103ab3:	00 
  103ab4:	c7 44 24 08 16 67 10 	movl   $0x106716,0x8(%esp)
  103abb:	00 
  103abc:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  103ac3:	00 
  103ac4:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  103acb:	e8 0b d2 ff ff       	call   100cdb <__panic>
}
  103ad0:	90                   	nop
  103ad1:	89 ec                	mov    %ebp,%esp
  103ad3:	5d                   	pop    %ebp
  103ad4:	c3                   	ret    

00103ad5 <page2ppn>:
page2ppn(struct Page *page) {
  103ad5:	55                   	push   %ebp
  103ad6:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103ad8:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  103ade:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae1:	29 d0                	sub    %edx,%eax
  103ae3:	c1 f8 02             	sar    $0x2,%eax
  103ae6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103aec:	5d                   	pop    %ebp
  103aed:	c3                   	ret    

00103aee <page2pa>:
page2pa(struct Page *page) {
  103aee:	55                   	push   %ebp
  103aef:	89 e5                	mov    %esp,%ebp
  103af1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103af4:	8b 45 08             	mov    0x8(%ebp),%eax
  103af7:	89 04 24             	mov    %eax,(%esp)
  103afa:	e8 d6 ff ff ff       	call   103ad5 <page2ppn>
  103aff:	c1 e0 0c             	shl    $0xc,%eax
}
  103b02:	89 ec                	mov    %ebp,%esp
  103b04:	5d                   	pop    %ebp
  103b05:	c3                   	ret    

00103b06 <pa2page>:
pa2page(uintptr_t pa) {
  103b06:	55                   	push   %ebp
  103b07:	89 e5                	mov    %esp,%ebp
  103b09:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b0f:	c1 e8 0c             	shr    $0xc,%eax
  103b12:	89 c2                	mov    %eax,%edx
  103b14:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103b19:	39 c2                	cmp    %eax,%edx
  103b1b:	72 1c                	jb     103b39 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103b1d:	c7 44 24 08 a4 6a 10 	movl   $0x106aa4,0x8(%esp)
  103b24:	00 
  103b25:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103b2c:	00 
  103b2d:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103b34:	e8 a2 d1 ff ff       	call   100cdb <__panic>
    return &pages[PPN(pa)];
  103b39:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b42:	c1 e8 0c             	shr    $0xc,%eax
  103b45:	89 c2                	mov    %eax,%edx
  103b47:	89 d0                	mov    %edx,%eax
  103b49:	c1 e0 02             	shl    $0x2,%eax
  103b4c:	01 d0                	add    %edx,%eax
  103b4e:	c1 e0 02             	shl    $0x2,%eax
  103b51:	01 c8                	add    %ecx,%eax
}
  103b53:	89 ec                	mov    %ebp,%esp
  103b55:	5d                   	pop    %ebp
  103b56:	c3                   	ret    

00103b57 <page2kva>:
page2kva(struct Page *page) {
  103b57:	55                   	push   %ebp
  103b58:	89 e5                	mov    %esp,%ebp
  103b5a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  103b60:	89 04 24             	mov    %eax,(%esp)
  103b63:	e8 86 ff ff ff       	call   103aee <page2pa>
  103b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b6e:	c1 e8 0c             	shr    $0xc,%eax
  103b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b74:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103b79:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b7c:	72 23                	jb     103ba1 <page2kva+0x4a>
  103b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b85:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  103b8c:	00 
  103b8d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103b94:	00 
  103b95:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103b9c:	e8 3a d1 ff ff       	call   100cdb <__panic>
  103ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ba4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ba9:	89 ec                	mov    %ebp,%esp
  103bab:	5d                   	pop    %ebp
  103bac:	c3                   	ret    

00103bad <pte2page>:
pte2page(pte_t pte) {
  103bad:	55                   	push   %ebp
  103bae:	89 e5                	mov    %esp,%ebp
  103bb0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb6:	83 e0 01             	and    $0x1,%eax
  103bb9:	85 c0                	test   %eax,%eax
  103bbb:	75 1c                	jne    103bd9 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103bbd:	c7 44 24 08 f8 6a 10 	movl   $0x106af8,0x8(%esp)
  103bc4:	00 
  103bc5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103bcc:	00 
  103bcd:	c7 04 24 c3 6a 10 00 	movl   $0x106ac3,(%esp)
  103bd4:	e8 02 d1 ff ff       	call   100cdb <__panic>
    return pa2page(PTE_ADDR(pte));
  103bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  103bdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103be1:	89 04 24             	mov    %eax,(%esp)
  103be4:	e8 1d ff ff ff       	call   103b06 <pa2page>
}
  103be9:	89 ec                	mov    %ebp,%esp
  103beb:	5d                   	pop    %ebp
  103bec:	c3                   	ret    

00103bed <pde2page>:
pde2page(pde_t pde) {
  103bed:	55                   	push   %ebp
  103bee:	89 e5                	mov    %esp,%ebp
  103bf0:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103bfb:	89 04 24             	mov    %eax,(%esp)
  103bfe:	e8 03 ff ff ff       	call   103b06 <pa2page>
}
  103c03:	89 ec                	mov    %ebp,%esp
  103c05:	5d                   	pop    %ebp
  103c06:	c3                   	ret    

00103c07 <page_ref>:
page_ref(struct Page *page) {
  103c07:	55                   	push   %ebp
  103c08:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c0d:	8b 00                	mov    (%eax),%eax
}
  103c0f:	5d                   	pop    %ebp
  103c10:	c3                   	ret    

00103c11 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103c11:	55                   	push   %ebp
  103c12:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103c14:	8b 45 08             	mov    0x8(%ebp),%eax
  103c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c1a:	89 10                	mov    %edx,(%eax)
}
  103c1c:	90                   	nop
  103c1d:	5d                   	pop    %ebp
  103c1e:	c3                   	ret    

00103c1f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103c1f:	55                   	push   %ebp
  103c20:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103c22:	8b 45 08             	mov    0x8(%ebp),%eax
  103c25:	8b 00                	mov    (%eax),%eax
  103c27:	8d 50 01             	lea    0x1(%eax),%edx
  103c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c2d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  103c32:	8b 00                	mov    (%eax),%eax
}
  103c34:	5d                   	pop    %ebp
  103c35:	c3                   	ret    

00103c36 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103c36:	55                   	push   %ebp
  103c37:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103c39:	8b 45 08             	mov    0x8(%ebp),%eax
  103c3c:	8b 00                	mov    (%eax),%eax
  103c3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103c41:	8b 45 08             	mov    0x8(%ebp),%eax
  103c44:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103c46:	8b 45 08             	mov    0x8(%ebp),%eax
  103c49:	8b 00                	mov    (%eax),%eax
}
  103c4b:	5d                   	pop    %ebp
  103c4c:	c3                   	ret    

00103c4d <__intr_save>:
__intr_save(void) {
  103c4d:	55                   	push   %ebp
  103c4e:	89 e5                	mov    %esp,%ebp
  103c50:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103c53:	9c                   	pushf  
  103c54:	58                   	pop    %eax
  103c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103c5b:	25 00 02 00 00       	and    $0x200,%eax
  103c60:	85 c0                	test   %eax,%eax
  103c62:	74 0c                	je     103c70 <__intr_save+0x23>
        intr_disable();
  103c64:	e8 cb da ff ff       	call   101734 <intr_disable>
        return 1;
  103c69:	b8 01 00 00 00       	mov    $0x1,%eax
  103c6e:	eb 05                	jmp    103c75 <__intr_save+0x28>
    return 0;
  103c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103c75:	89 ec                	mov    %ebp,%esp
  103c77:	5d                   	pop    %ebp
  103c78:	c3                   	ret    

00103c79 <__intr_restore>:
__intr_restore(bool flag) {
  103c79:	55                   	push   %ebp
  103c7a:	89 e5                	mov    %esp,%ebp
  103c7c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103c83:	74 05                	je     103c8a <__intr_restore+0x11>
        intr_enable();
  103c85:	e8 a2 da ff ff       	call   10172c <intr_enable>
}
  103c8a:	90                   	nop
  103c8b:	89 ec                	mov    %ebp,%esp
  103c8d:	5d                   	pop    %ebp
  103c8e:	c3                   	ret    

00103c8f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103c8f:	55                   	push   %ebp
  103c90:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103c92:	8b 45 08             	mov    0x8(%ebp),%eax
  103c95:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103c98:	b8 23 00 00 00       	mov    $0x23,%eax
  103c9d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103c9f:	b8 23 00 00 00       	mov    $0x23,%eax
  103ca4:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103ca6:	b8 10 00 00 00       	mov    $0x10,%eax
  103cab:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103cad:	b8 10 00 00 00       	mov    $0x10,%eax
  103cb2:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103cb4:	b8 10 00 00 00       	mov    $0x10,%eax
  103cb9:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103cbb:	ea c2 3c 10 00 08 00 	ljmp   $0x8,$0x103cc2
}
  103cc2:	90                   	nop
  103cc3:	5d                   	pop    %ebp
  103cc4:	c3                   	ret    

00103cc5 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103cc5:	55                   	push   %ebp
  103cc6:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  103ccb:	a3 c4 be 11 00       	mov    %eax,0x11bec4
}
  103cd0:	90                   	nop
  103cd1:	5d                   	pop    %ebp
  103cd2:	c3                   	ret    

00103cd3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103cd3:	55                   	push   %ebp
  103cd4:	89 e5                	mov    %esp,%ebp
  103cd6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103cd9:	b8 00 80 11 00       	mov    $0x118000,%eax
  103cde:	89 04 24             	mov    %eax,(%esp)
  103ce1:	e8 df ff ff ff       	call   103cc5 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103ce6:	66 c7 05 c8 be 11 00 	movw   $0x10,0x11bec8
  103ced:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103cef:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103cf6:	68 00 
  103cf8:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103cfd:	0f b7 c0             	movzwl %ax,%eax
  103d00:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103d06:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103d0b:	c1 e8 10             	shr    $0x10,%eax
  103d0e:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103d13:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103d1a:	24 f0                	and    $0xf0,%al
  103d1c:	0c 09                	or     $0x9,%al
  103d1e:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103d23:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103d2a:	24 ef                	and    $0xef,%al
  103d2c:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103d31:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103d38:	24 9f                	and    $0x9f,%al
  103d3a:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103d3f:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103d46:	0c 80                	or     $0x80,%al
  103d48:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103d4d:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103d54:	24 f0                	and    $0xf0,%al
  103d56:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103d5b:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103d62:	24 ef                	and    $0xef,%al
  103d64:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103d69:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103d70:	24 df                	and    $0xdf,%al
  103d72:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103d77:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103d7e:	0c 40                	or     $0x40,%al
  103d80:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103d85:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103d8c:	24 7f                	and    $0x7f,%al
  103d8e:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103d93:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103d98:	c1 e8 18             	shr    $0x18,%eax
  103d9b:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103da0:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103da7:	e8 e3 fe ff ff       	call   103c8f <lgdt>
  103dac:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103db2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103db6:	0f 00 d8             	ltr    %ax
}
  103db9:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103dba:	90                   	nop
  103dbb:	89 ec                	mov    %ebp,%esp
  103dbd:	5d                   	pop    %ebp
  103dbe:	c3                   	ret    

00103dbf <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103dbf:	55                   	push   %ebp
  103dc0:	89 e5                	mov    %esp,%ebp
  103dc2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103dc5:	c7 05 ac be 11 00 88 	movl   $0x106a88,0x11beac
  103dcc:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103dcf:	a1 ac be 11 00       	mov    0x11beac,%eax
  103dd4:	8b 00                	mov    (%eax),%eax
  103dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103dda:	c7 04 24 24 6b 10 00 	movl   $0x106b24,(%esp)
  103de1:	e8 70 c5 ff ff       	call   100356 <cprintf>
    pmm_manager->init();
  103de6:	a1 ac be 11 00       	mov    0x11beac,%eax
  103deb:	8b 40 04             	mov    0x4(%eax),%eax
  103dee:	ff d0                	call   *%eax
}
  103df0:	90                   	nop
  103df1:	89 ec                	mov    %ebp,%esp
  103df3:	5d                   	pop    %ebp
  103df4:	c3                   	ret    

00103df5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103df5:	55                   	push   %ebp
  103df6:	89 e5                	mov    %esp,%ebp
  103df8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103dfb:	a1 ac be 11 00       	mov    0x11beac,%eax
  103e00:	8b 40 08             	mov    0x8(%eax),%eax
  103e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e06:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  103e0d:	89 14 24             	mov    %edx,(%esp)
  103e10:	ff d0                	call   *%eax
}
  103e12:	90                   	nop
  103e13:	89 ec                	mov    %ebp,%esp
  103e15:	5d                   	pop    %ebp
  103e16:	c3                   	ret    

00103e17 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103e17:	55                   	push   %ebp
  103e18:	89 e5                	mov    %esp,%ebp
  103e1a:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103e24:	e8 24 fe ff ff       	call   103c4d <__intr_save>
  103e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103e2c:	a1 ac be 11 00       	mov    0x11beac,%eax
  103e31:	8b 40 0c             	mov    0xc(%eax),%eax
  103e34:	8b 55 08             	mov    0x8(%ebp),%edx
  103e37:	89 14 24             	mov    %edx,(%esp)
  103e3a:	ff d0                	call   *%eax
  103e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e42:	89 04 24             	mov    %eax,(%esp)
  103e45:	e8 2f fe ff ff       	call   103c79 <__intr_restore>
    return page;
  103e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103e4d:	89 ec                	mov    %ebp,%esp
  103e4f:	5d                   	pop    %ebp
  103e50:	c3                   	ret    

00103e51 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103e51:	55                   	push   %ebp
  103e52:	89 e5                	mov    %esp,%ebp
  103e54:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103e57:	e8 f1 fd ff ff       	call   103c4d <__intr_save>
  103e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103e5f:	a1 ac be 11 00       	mov    0x11beac,%eax
  103e64:	8b 40 10             	mov    0x10(%eax),%eax
  103e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  103e6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  103e71:	89 14 24             	mov    %edx,(%esp)
  103e74:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e79:	89 04 24             	mov    %eax,(%esp)
  103e7c:	e8 f8 fd ff ff       	call   103c79 <__intr_restore>
}
  103e81:	90                   	nop
  103e82:	89 ec                	mov    %ebp,%esp
  103e84:	5d                   	pop    %ebp
  103e85:	c3                   	ret    

00103e86 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103e86:	55                   	push   %ebp
  103e87:	89 e5                	mov    %esp,%ebp
  103e89:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103e8c:	e8 bc fd ff ff       	call   103c4d <__intr_save>
  103e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103e94:	a1 ac be 11 00       	mov    0x11beac,%eax
  103e99:	8b 40 14             	mov    0x14(%eax),%eax
  103e9c:	ff d0                	call   *%eax
  103e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ea4:	89 04 24             	mov    %eax,(%esp)
  103ea7:	e8 cd fd ff ff       	call   103c79 <__intr_restore>
    return ret;
  103eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103eaf:	89 ec                	mov    %ebp,%esp
  103eb1:	5d                   	pop    %ebp
  103eb2:	c3                   	ret    

00103eb3 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103eb3:	55                   	push   %ebp
  103eb4:	89 e5                	mov    %esp,%ebp
  103eb6:	57                   	push   %edi
  103eb7:	56                   	push   %esi
  103eb8:	53                   	push   %ebx
  103eb9:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103ebf:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103ec6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103ecd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103ed4:	c7 04 24 3b 6b 10 00 	movl   $0x106b3b,(%esp)
  103edb:	e8 76 c4 ff ff       	call   100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ee0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ee7:	e9 0c 01 00 00       	jmp    103ff8 <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103eec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103eef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ef2:	89 d0                	mov    %edx,%eax
  103ef4:	c1 e0 02             	shl    $0x2,%eax
  103ef7:	01 d0                	add    %edx,%eax
  103ef9:	c1 e0 02             	shl    $0x2,%eax
  103efc:	01 c8                	add    %ecx,%eax
  103efe:	8b 50 08             	mov    0x8(%eax),%edx
  103f01:	8b 40 04             	mov    0x4(%eax),%eax
  103f04:	89 45 a0             	mov    %eax,-0x60(%ebp)
  103f07:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  103f0a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f10:	89 d0                	mov    %edx,%eax
  103f12:	c1 e0 02             	shl    $0x2,%eax
  103f15:	01 d0                	add    %edx,%eax
  103f17:	c1 e0 02             	shl    $0x2,%eax
  103f1a:	01 c8                	add    %ecx,%eax
  103f1c:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f1f:	8b 58 10             	mov    0x10(%eax),%ebx
  103f22:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f25:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103f28:	01 c8                	add    %ecx,%eax
  103f2a:	11 da                	adc    %ebx,%edx
  103f2c:	89 45 98             	mov    %eax,-0x68(%ebp)
  103f2f:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103f32:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f35:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f38:	89 d0                	mov    %edx,%eax
  103f3a:	c1 e0 02             	shl    $0x2,%eax
  103f3d:	01 d0                	add    %edx,%eax
  103f3f:	c1 e0 02             	shl    $0x2,%eax
  103f42:	01 c8                	add    %ecx,%eax
  103f44:	83 c0 14             	add    $0x14,%eax
  103f47:	8b 00                	mov    (%eax),%eax
  103f49:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103f4f:	8b 45 98             	mov    -0x68(%ebp),%eax
  103f52:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103f55:	83 c0 ff             	add    $0xffffffff,%eax
  103f58:	83 d2 ff             	adc    $0xffffffff,%edx
  103f5b:	89 c6                	mov    %eax,%esi
  103f5d:	89 d7                	mov    %edx,%edi
  103f5f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f65:	89 d0                	mov    %edx,%eax
  103f67:	c1 e0 02             	shl    $0x2,%eax
  103f6a:	01 d0                	add    %edx,%eax
  103f6c:	c1 e0 02             	shl    $0x2,%eax
  103f6f:	01 c8                	add    %ecx,%eax
  103f71:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f74:	8b 58 10             	mov    0x10(%eax),%ebx
  103f77:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103f7d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103f81:	89 74 24 14          	mov    %esi,0x14(%esp)
  103f85:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103f89:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f8c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103f8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f93:	89 54 24 10          	mov    %edx,0x10(%esp)
  103f97:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f9f:	c7 04 24 48 6b 10 00 	movl   $0x106b48,(%esp)
  103fa6:	e8 ab c3 ff ff       	call   100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103fab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fb1:	89 d0                	mov    %edx,%eax
  103fb3:	c1 e0 02             	shl    $0x2,%eax
  103fb6:	01 d0                	add    %edx,%eax
  103fb8:	c1 e0 02             	shl    $0x2,%eax
  103fbb:	01 c8                	add    %ecx,%eax
  103fbd:	83 c0 14             	add    $0x14,%eax
  103fc0:	8b 00                	mov    (%eax),%eax
  103fc2:	83 f8 01             	cmp    $0x1,%eax
  103fc5:	75 2e                	jne    103ff5 <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  103fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103fca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103fcd:	3b 45 98             	cmp    -0x68(%ebp),%eax
  103fd0:	89 d0                	mov    %edx,%eax
  103fd2:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  103fd5:	73 1e                	jae    103ff5 <page_init+0x142>
  103fd7:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  103fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  103fe1:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  103fe4:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  103fe7:	72 0c                	jb     103ff5 <page_init+0x142>
                maxpa = end;
  103fe9:	8b 45 98             	mov    -0x68(%ebp),%eax
  103fec:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103fef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ff2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  103ff5:	ff 45 dc             	incl   -0x24(%ebp)
  103ff8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ffb:	8b 00                	mov    (%eax),%eax
  103ffd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104000:	0f 8c e6 fe ff ff    	jl     103eec <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104006:	ba 00 00 00 38       	mov    $0x38000000,%edx
  10400b:	b8 00 00 00 00       	mov    $0x0,%eax
  104010:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  104013:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  104016:	73 0e                	jae    104026 <page_init+0x173>
        maxpa = KMEMSIZE;
  104018:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  10401f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104026:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104029:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10402c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104030:	c1 ea 0c             	shr    $0xc,%edx
  104033:	a3 a4 be 11 00       	mov    %eax,0x11bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104038:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  10403f:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  104044:	8d 50 ff             	lea    -0x1(%eax),%edx
  104047:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10404a:	01 d0                	add    %edx,%eax
  10404c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  10404f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104052:	ba 00 00 00 00       	mov    $0x0,%edx
  104057:	f7 75 c0             	divl   -0x40(%ebp)
  10405a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10405d:	29 d0                	sub    %edx,%eax
  10405f:	a3 a0 be 11 00       	mov    %eax,0x11bea0

    for (i = 0; i < npage; i ++) {
  104064:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10406b:	eb 2f                	jmp    10409c <page_init+0x1e9>
        SetPageReserved(pages + i);
  10406d:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  104073:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104076:	89 d0                	mov    %edx,%eax
  104078:	c1 e0 02             	shl    $0x2,%eax
  10407b:	01 d0                	add    %edx,%eax
  10407d:	c1 e0 02             	shl    $0x2,%eax
  104080:	01 c8                	add    %ecx,%eax
  104082:	83 c0 04             	add    $0x4,%eax
  104085:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  10408c:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10408f:	8b 45 90             	mov    -0x70(%ebp),%eax
  104092:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104095:	0f ab 10             	bts    %edx,(%eax)
}
  104098:	90                   	nop
    for (i = 0; i < npage; i ++) {
  104099:	ff 45 dc             	incl   -0x24(%ebp)
  10409c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10409f:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1040a4:	39 c2                	cmp    %eax,%edx
  1040a6:	72 c5                	jb     10406d <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1040a8:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  1040ae:	89 d0                	mov    %edx,%eax
  1040b0:	c1 e0 02             	shl    $0x2,%eax
  1040b3:	01 d0                	add    %edx,%eax
  1040b5:	c1 e0 02             	shl    $0x2,%eax
  1040b8:	89 c2                	mov    %eax,%edx
  1040ba:	a1 a0 be 11 00       	mov    0x11bea0,%eax
  1040bf:	01 d0                	add    %edx,%eax
  1040c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1040c4:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1040cb:	77 23                	ja     1040f0 <page_init+0x23d>
  1040cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1040d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040d4:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  1040db:	00 
  1040dc:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  1040e3:	00 
  1040e4:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1040eb:	e8 eb cb ff ff       	call   100cdb <__panic>
  1040f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1040f3:	05 00 00 00 40       	add    $0x40000000,%eax
  1040f8:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1040fb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104102:	e9 53 01 00 00       	jmp    10425a <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104107:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10410a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10410d:	89 d0                	mov    %edx,%eax
  10410f:	c1 e0 02             	shl    $0x2,%eax
  104112:	01 d0                	add    %edx,%eax
  104114:	c1 e0 02             	shl    $0x2,%eax
  104117:	01 c8                	add    %ecx,%eax
  104119:	8b 50 08             	mov    0x8(%eax),%edx
  10411c:	8b 40 04             	mov    0x4(%eax),%eax
  10411f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104122:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104125:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104128:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10412b:	89 d0                	mov    %edx,%eax
  10412d:	c1 e0 02             	shl    $0x2,%eax
  104130:	01 d0                	add    %edx,%eax
  104132:	c1 e0 02             	shl    $0x2,%eax
  104135:	01 c8                	add    %ecx,%eax
  104137:	8b 48 0c             	mov    0xc(%eax),%ecx
  10413a:	8b 58 10             	mov    0x10(%eax),%ebx
  10413d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104143:	01 c8                	add    %ecx,%eax
  104145:	11 da                	adc    %ebx,%edx
  104147:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10414a:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10414d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104150:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104153:	89 d0                	mov    %edx,%eax
  104155:	c1 e0 02             	shl    $0x2,%eax
  104158:	01 d0                	add    %edx,%eax
  10415a:	c1 e0 02             	shl    $0x2,%eax
  10415d:	01 c8                	add    %ecx,%eax
  10415f:	83 c0 14             	add    $0x14,%eax
  104162:	8b 00                	mov    (%eax),%eax
  104164:	83 f8 01             	cmp    $0x1,%eax
  104167:	0f 85 ea 00 00 00    	jne    104257 <page_init+0x3a4>
            if (begin < freemem) {
  10416d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104170:	ba 00 00 00 00       	mov    $0x0,%edx
  104175:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104178:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10417b:	19 d1                	sbb    %edx,%ecx
  10417d:	73 0d                	jae    10418c <page_init+0x2d9>
                begin = freemem;
  10417f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104182:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104185:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10418c:	ba 00 00 00 38       	mov    $0x38000000,%edx
  104191:	b8 00 00 00 00       	mov    $0x0,%eax
  104196:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  104199:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  10419c:	73 0e                	jae    1041ac <page_init+0x2f9>
                end = KMEMSIZE;
  10419e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1041a5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1041ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1041b5:	89 d0                	mov    %edx,%eax
  1041b7:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1041ba:	0f 83 97 00 00 00    	jae    104257 <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  1041c0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1041c7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1041ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1041cd:	01 d0                	add    %edx,%eax
  1041cf:	48                   	dec    %eax
  1041d0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1041d3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1041d6:	ba 00 00 00 00       	mov    $0x0,%edx
  1041db:	f7 75 b0             	divl   -0x50(%ebp)
  1041de:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1041e1:	29 d0                	sub    %edx,%eax
  1041e3:	ba 00 00 00 00       	mov    $0x0,%edx
  1041e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041eb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1041ee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041f1:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1041f4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1041f7:	ba 00 00 00 00       	mov    $0x0,%edx
  1041fc:	89 c7                	mov    %eax,%edi
  1041fe:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104204:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104207:	89 d0                	mov    %edx,%eax
  104209:	83 e0 00             	and    $0x0,%eax
  10420c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10420f:	8b 45 80             	mov    -0x80(%ebp),%eax
  104212:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104215:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104218:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10421b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10421e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104221:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104224:	89 d0                	mov    %edx,%eax
  104226:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  104229:	73 2c                	jae    104257 <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10422b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10422e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104231:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104234:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  104237:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10423b:	c1 ea 0c             	shr    $0xc,%edx
  10423e:	89 c3                	mov    %eax,%ebx
  104240:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104243:	89 04 24             	mov    %eax,(%esp)
  104246:	e8 bb f8 ff ff       	call   103b06 <pa2page>
  10424b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10424f:	89 04 24             	mov    %eax,(%esp)
  104252:	e8 9e fb ff ff       	call   103df5 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  104257:	ff 45 dc             	incl   -0x24(%ebp)
  10425a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10425d:	8b 00                	mov    (%eax),%eax
  10425f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104262:	0f 8c 9f fe ff ff    	jl     104107 <page_init+0x254>
                }
            }
        }
    }
}
  104268:	90                   	nop
  104269:	90                   	nop
  10426a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104270:	5b                   	pop    %ebx
  104271:	5e                   	pop    %esi
  104272:	5f                   	pop    %edi
  104273:	5d                   	pop    %ebp
  104274:	c3                   	ret    

00104275 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104275:	55                   	push   %ebp
  104276:	89 e5                	mov    %esp,%ebp
  104278:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10427b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10427e:	33 45 14             	xor    0x14(%ebp),%eax
  104281:	25 ff 0f 00 00       	and    $0xfff,%eax
  104286:	85 c0                	test   %eax,%eax
  104288:	74 24                	je     1042ae <boot_map_segment+0x39>
  10428a:	c7 44 24 0c aa 6b 10 	movl   $0x106baa,0xc(%esp)
  104291:	00 
  104292:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104299:	00 
  10429a:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1042a1:	00 
  1042a2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1042a9:	e8 2d ca ff ff       	call   100cdb <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1042ae:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1042b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042b8:	25 ff 0f 00 00       	and    $0xfff,%eax
  1042bd:	89 c2                	mov    %eax,%edx
  1042bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1042c2:	01 c2                	add    %eax,%edx
  1042c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042c7:	01 d0                	add    %edx,%eax
  1042c9:	48                   	dec    %eax
  1042ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1042cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042d0:	ba 00 00 00 00       	mov    $0x0,%edx
  1042d5:	f7 75 f0             	divl   -0x10(%ebp)
  1042d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042db:	29 d0                	sub    %edx,%eax
  1042dd:	c1 e8 0c             	shr    $0xc,%eax
  1042e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1042e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1042e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042f1:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1042f4:	8b 45 14             	mov    0x14(%ebp),%eax
  1042f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104302:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104305:	eb 68                	jmp    10436f <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104307:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10430e:	00 
  10430f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104312:	89 44 24 04          	mov    %eax,0x4(%esp)
  104316:	8b 45 08             	mov    0x8(%ebp),%eax
  104319:	89 04 24             	mov    %eax,(%esp)
  10431c:	e8 88 01 00 00       	call   1044a9 <get_pte>
  104321:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104324:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104328:	75 24                	jne    10434e <boot_map_segment+0xd9>
  10432a:	c7 44 24 0c d6 6b 10 	movl   $0x106bd6,0xc(%esp)
  104331:	00 
  104332:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104339:	00 
  10433a:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104341:	00 
  104342:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104349:	e8 8d c9 ff ff       	call   100cdb <__panic>
        *ptep = pa | PTE_P | perm;
  10434e:	8b 45 14             	mov    0x14(%ebp),%eax
  104351:	0b 45 18             	or     0x18(%ebp),%eax
  104354:	83 c8 01             	or     $0x1,%eax
  104357:	89 c2                	mov    %eax,%edx
  104359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10435c:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10435e:	ff 4d f4             	decl   -0xc(%ebp)
  104361:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104368:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10436f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104373:	75 92                	jne    104307 <boot_map_segment+0x92>
    }
}
  104375:	90                   	nop
  104376:	90                   	nop
  104377:	89 ec                	mov    %ebp,%esp
  104379:	5d                   	pop    %ebp
  10437a:	c3                   	ret    

0010437b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10437b:	55                   	push   %ebp
  10437c:	89 e5                	mov    %esp,%ebp
  10437e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104388:	e8 8a fa ff ff       	call   103e17 <alloc_pages>
  10438d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104394:	75 1c                	jne    1043b2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104396:	c7 44 24 08 e3 6b 10 	movl   $0x106be3,0x8(%esp)
  10439d:	00 
  10439e:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1043a5:	00 
  1043a6:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1043ad:	e8 29 c9 ff ff       	call   100cdb <__panic>
    }
    return page2kva(p);
  1043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043b5:	89 04 24             	mov    %eax,(%esp)
  1043b8:	e8 9a f7 ff ff       	call   103b57 <page2kva>
}
  1043bd:	89 ec                	mov    %ebp,%esp
  1043bf:	5d                   	pop    %ebp
  1043c0:	c3                   	ret    

001043c1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1043c1:	55                   	push   %ebp
  1043c2:	89 e5                	mov    %esp,%ebp
  1043c4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1043c7:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1043cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043cf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1043d6:	77 23                	ja     1043fb <pmm_init+0x3a>
  1043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043df:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  1043e6:	00 
  1043e7:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1043ee:	00 
  1043ef:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1043f6:	e8 e0 c8 ff ff       	call   100cdb <__panic>
  1043fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043fe:	05 00 00 00 40       	add    $0x40000000,%eax
  104403:	a3 a8 be 11 00       	mov    %eax,0x11bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104408:	e8 b2 f9 ff ff       	call   103dbf <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10440d:	e8 a1 fa ff ff       	call   103eb3 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104412:	e8 ed 03 00 00       	call   104804 <check_alloc_page>

    check_pgdir();
  104417:	e8 09 04 00 00       	call   104825 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10441c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104421:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104424:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10442b:	77 23                	ja     104450 <pmm_init+0x8f>
  10442d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104434:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  10443b:	00 
  10443c:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104443:	00 
  104444:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10444b:	e8 8b c8 ff ff       	call   100cdb <__panic>
  104450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104453:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  104459:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10445e:	05 ac 0f 00 00       	add    $0xfac,%eax
  104463:	83 ca 03             	or     $0x3,%edx
  104466:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104468:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10446d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104474:	00 
  104475:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10447c:	00 
  10447d:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104484:	38 
  104485:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10448c:	c0 
  10448d:	89 04 24             	mov    %eax,(%esp)
  104490:	e8 e0 fd ff ff       	call   104275 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104495:	e8 39 f8 ff ff       	call   103cd3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10449a:	e8 24 0a 00 00       	call   104ec3 <check_boot_pgdir>

    print_pgdir();
  10449f:	e8 a1 0e 00 00       	call   105345 <print_pgdir>

}
  1044a4:	90                   	nop
  1044a5:	89 ec                	mov    %ebp,%esp
  1044a7:	5d                   	pop    %ebp
  1044a8:	c3                   	ret    

001044a9 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1044a9:	55                   	push   %ebp
  1044aa:	89 e5                	mov    %esp,%ebp
  1044ac:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    //由线性地址取page directory中对应的条目
    pde_t *pdep = &pgdir[PDX(la)];
  1044af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044b2:	c1 e8 16             	shr    $0x16,%eax
  1044b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1044bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1044bf:	01 d0                	add    %edx,%eax
  1044c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    //若存在位为0,则需要判断create选项
    if (!(*pdep & PTE_P)) {
  1044c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044c7:	8b 00                	mov    (%eax),%eax
  1044c9:	83 e0 01             	and    $0x1,%eax
  1044cc:	85 c0                	test   %eax,%eax
  1044ce:	0f 85 af 00 00 00    	jne    104583 <get_pte+0xda>
        struct Page *page;
        //若create=0，则返回NULL
        //若create=1，则分配一块物理内存，作为新的页表
        if (!create || (page = alloc_page()) == NULL) {
  1044d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044d8:	74 15                	je     1044ef <get_pte+0x46>
  1044da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044e1:	e8 31 f9 ff ff       	call   103e17 <alloc_pages>
  1044e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1044ed:	75 0a                	jne    1044f9 <get_pte+0x50>
            return NULL;
  1044ef:	b8 00 00 00 00       	mov    $0x0,%eax
  1044f4:	e9 e7 00 00 00       	jmp    1045e0 <get_pte+0x137>
        }
        //设置page的引用计数
        set_page_ref(page, 1);
  1044f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104500:	00 
  104501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104504:	89 04 24             	mov    %eax,(%esp)
  104507:	e8 05 f7 ff ff       	call   103c11 <set_page_ref>
        //修改page directory项的标志位，把新页表写入此项
        uintptr_t pa = page2pa(page);
  10450c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10450f:	89 04 24             	mov    %eax,(%esp)
  104512:	e8 d7 f5 ff ff       	call   103aee <page2pa>
  104517:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  10451a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10451d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104523:	c1 e8 0c             	shr    $0xc,%eax
  104526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104529:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  10452e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104531:	72 23                	jb     104556 <get_pte+0xad>
  104533:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104536:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10453a:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  104541:	00 
  104542:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
  104549:	00 
  10454a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104551:	e8 85 c7 ff ff       	call   100cdb <__panic>
  104556:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104559:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10455e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104565:	00 
  104566:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10456d:	00 
  10456e:	89 04 24             	mov    %eax,(%esp)
  104571:	e8 d4 18 00 00       	call   105e4a <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  104576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104579:	83 c8 07             	or     $0x7,%eax
  10457c:	89 c2                	mov    %eax,%edx
  10457e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104581:	89 10                	mov    %edx,(%eax)
    }
    //若存在位不为0,则返回页表项地址
    //对*pdep取高20位得到页表（物理）基址
    //用KADDR将页表物理基址换算为内核虚拟地址
    //从页表虚拟基址取PTX（la）个偏移量得到页表项，返回它的地址
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  104583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104586:	8b 00                	mov    (%eax),%eax
  104588:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10458d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104590:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104593:	c1 e8 0c             	shr    $0xc,%eax
  104596:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104599:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  10459e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1045a1:	72 23                	jb     1045c6 <get_pte+0x11d>
  1045a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045aa:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  1045b1:	00 
  1045b2:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
  1045b9:	00 
  1045ba:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1045c1:	e8 15 c7 ff ff       	call   100cdb <__panic>
  1045c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1045c9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045ce:	89 c2                	mov    %eax,%edx
  1045d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045d3:	c1 e8 0c             	shr    $0xc,%eax
  1045d6:	25 ff 03 00 00       	and    $0x3ff,%eax
  1045db:	c1 e0 02             	shl    $0x2,%eax
  1045de:	01 d0                	add    %edx,%eax
}
  1045e0:	89 ec                	mov    %ebp,%esp
  1045e2:	5d                   	pop    %ebp
  1045e3:	c3                   	ret    

001045e4 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1045e4:	55                   	push   %ebp
  1045e5:	89 e5                	mov    %esp,%ebp
  1045e7:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045f1:	00 
  1045f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1045fc:	89 04 24             	mov    %eax,(%esp)
  1045ff:	e8 a5 fe ff ff       	call   1044a9 <get_pte>
  104604:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104607:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10460b:	74 08                	je     104615 <get_page+0x31>
        *ptep_store = ptep;
  10460d:	8b 45 10             	mov    0x10(%ebp),%eax
  104610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104613:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104619:	74 1b                	je     104636 <get_page+0x52>
  10461b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10461e:	8b 00                	mov    (%eax),%eax
  104620:	83 e0 01             	and    $0x1,%eax
  104623:	85 c0                	test   %eax,%eax
  104625:	74 0f                	je     104636 <get_page+0x52>
        return pte2page(*ptep);
  104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462a:	8b 00                	mov    (%eax),%eax
  10462c:	89 04 24             	mov    %eax,(%esp)
  10462f:	e8 79 f5 ff ff       	call   103bad <pte2page>
  104634:	eb 05                	jmp    10463b <get_page+0x57>
    }
    return NULL;
  104636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10463b:	89 ec                	mov    %ebp,%esp
  10463d:	5d                   	pop    %ebp
  10463e:	c3                   	ret    

0010463f <page_remove_pte>:
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
//释放给定页表ptep关联的page
//去使能地址la对应的TLB
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10463f:	55                   	push   %ebp
  104640:	89 e5                	mov    %esp,%ebp
  104642:	83 ec 28             	sub    $0x28,%esp
                                  //(6) flush tlb
    }
#endif

    //排除页表不存在的情况，确保传入的二级页表是存在的
    if (*ptep & PTE_P) {
  104645:	8b 45 10             	mov    0x10(%ebp),%eax
  104648:	8b 00                	mov    (%eax),%eax
  10464a:	83 e0 01             	and    $0x1,%eax
  10464d:	85 c0                	test   %eax,%eax
  10464f:	74 4d                	je     10469e <page_remove_pte+0x5f>
        //获取该页表项对应的物理页的Page结构
        struct Page *page = pte2page(*ptep);
  104651:	8b 45 10             	mov    0x10(%ebp),%eax
  104654:	8b 00                	mov    (%eax),%eax
  104656:	89 04 24             	mov    %eax,(%esp)
  104659:	e8 4f f5 ff ff       	call   103bad <pte2page>
  10465e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //如果该物理页的引用计数变成0,即不存在任何虚拟页指
        if (page_ref_dec(page) == 0) {
  104661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104664:	89 04 24             	mov    %eax,(%esp)
  104667:	e8 ca f5 ff ff       	call   103c36 <page_ref_dec>
  10466c:	85 c0                	test   %eax,%eax
  10466e:	75 13                	jne    104683 <page_remove_pte+0x44>
            free_page(page);
  104670:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104677:	00 
  104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10467b:	89 04 24             	mov    %eax,(%esp)
  10467e:	e8 ce f7 ff ff       	call   103e51 <free_pages>
        }
        //ptep的存在位设置为0,表明该映射关系无效
        *ptep = 0;
  104683:	8b 45 10             	mov    0x10(%ebp),%eax
  104686:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        //刷新TLB，保证TLB中的缓存不会有错误的映射关系
        tlb_invalidate(pgdir, la);
  10468c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10468f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104693:	8b 45 08             	mov    0x8(%ebp),%eax
  104696:	89 04 24             	mov    %eax,(%esp)
  104699:	e8 07 01 00 00       	call   1047a5 <tlb_invalidate>
    }
}
  10469e:	90                   	nop
  10469f:	89 ec                	mov    %ebp,%esp
  1046a1:	5d                   	pop    %ebp
  1046a2:	c3                   	ret    

001046a3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1046a3:	55                   	push   %ebp
  1046a4:	89 e5                	mov    %esp,%ebp
  1046a6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1046a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046b0:	00 
  1046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1046bb:	89 04 24             	mov    %eax,(%esp)
  1046be:	e8 e6 fd ff ff       	call   1044a9 <get_pte>
  1046c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1046c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046ca:	74 19                	je     1046e5 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1046cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046da:	8b 45 08             	mov    0x8(%ebp),%eax
  1046dd:	89 04 24             	mov    %eax,(%esp)
  1046e0:	e8 5a ff ff ff       	call   10463f <page_remove_pte>
    }
}
  1046e5:	90                   	nop
  1046e6:	89 ec                	mov    %ebp,%esp
  1046e8:	5d                   	pop    %ebp
  1046e9:	c3                   	ret    

001046ea <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1046ea:	55                   	push   %ebp
  1046eb:	89 e5                	mov    %esp,%ebp
  1046ed:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1046f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1046f7:	00 
  1046f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1046fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104702:	89 04 24             	mov    %eax,(%esp)
  104705:	e8 9f fd ff ff       	call   1044a9 <get_pte>
  10470a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10470d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104711:	75 0a                	jne    10471d <page_insert+0x33>
        return -E_NO_MEM;
  104713:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104718:	e9 84 00 00 00       	jmp    1047a1 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10471d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104720:	89 04 24             	mov    %eax,(%esp)
  104723:	e8 f7 f4 ff ff       	call   103c1f <page_ref_inc>
    if (*ptep & PTE_P) {
  104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472b:	8b 00                	mov    (%eax),%eax
  10472d:	83 e0 01             	and    $0x1,%eax
  104730:	85 c0                	test   %eax,%eax
  104732:	74 3e                	je     104772 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104737:	8b 00                	mov    (%eax),%eax
  104739:	89 04 24             	mov    %eax,(%esp)
  10473c:	e8 6c f4 ff ff       	call   103bad <pte2page>
  104741:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104747:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10474a:	75 0d                	jne    104759 <page_insert+0x6f>
            page_ref_dec(page);
  10474c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10474f:	89 04 24             	mov    %eax,(%esp)
  104752:	e8 df f4 ff ff       	call   103c36 <page_ref_dec>
  104757:	eb 19                	jmp    104772 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10475c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104760:	8b 45 10             	mov    0x10(%ebp),%eax
  104763:	89 44 24 04          	mov    %eax,0x4(%esp)
  104767:	8b 45 08             	mov    0x8(%ebp),%eax
  10476a:	89 04 24             	mov    %eax,(%esp)
  10476d:	e8 cd fe ff ff       	call   10463f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104772:	8b 45 0c             	mov    0xc(%ebp),%eax
  104775:	89 04 24             	mov    %eax,(%esp)
  104778:	e8 71 f3 ff ff       	call   103aee <page2pa>
  10477d:	0b 45 14             	or     0x14(%ebp),%eax
  104780:	83 c8 01             	or     $0x1,%eax
  104783:	89 c2                	mov    %eax,%edx
  104785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104788:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10478a:	8b 45 10             	mov    0x10(%ebp),%eax
  10478d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104791:	8b 45 08             	mov    0x8(%ebp),%eax
  104794:	89 04 24             	mov    %eax,(%esp)
  104797:	e8 09 00 00 00       	call   1047a5 <tlb_invalidate>
    return 0;
  10479c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047a1:	89 ec                	mov    %ebp,%esp
  1047a3:	5d                   	pop    %ebp
  1047a4:	c3                   	ret    

001047a5 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1047a5:	55                   	push   %ebp
  1047a6:	89 e5                	mov    %esp,%ebp
  1047a8:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1047ab:	0f 20 d8             	mov    %cr3,%eax
  1047ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1047b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1047b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1047b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047ba:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1047c1:	77 23                	ja     1047e6 <tlb_invalidate+0x41>
  1047c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047ca:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  1047d1:	00 
  1047d2:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  1047d9:	00 
  1047da:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1047e1:	e8 f5 c4 ff ff       	call   100cdb <__panic>
  1047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e9:	05 00 00 00 40       	add    $0x40000000,%eax
  1047ee:	39 d0                	cmp    %edx,%eax
  1047f0:	75 0d                	jne    1047ff <tlb_invalidate+0x5a>
        invlpg((void *)la);
  1047f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1047f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047fb:	0f 01 38             	invlpg (%eax)
}
  1047fe:	90                   	nop
    }
}
  1047ff:	90                   	nop
  104800:	89 ec                	mov    %ebp,%esp
  104802:	5d                   	pop    %ebp
  104803:	c3                   	ret    

00104804 <check_alloc_page>:

static void
check_alloc_page(void) {
  104804:	55                   	push   %ebp
  104805:	89 e5                	mov    %esp,%ebp
  104807:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10480a:	a1 ac be 11 00       	mov    0x11beac,%eax
  10480f:	8b 40 18             	mov    0x18(%eax),%eax
  104812:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104814:	c7 04 24 fc 6b 10 00 	movl   $0x106bfc,(%esp)
  10481b:	e8 36 bb ff ff       	call   100356 <cprintf>
}
  104820:	90                   	nop
  104821:	89 ec                	mov    %ebp,%esp
  104823:	5d                   	pop    %ebp
  104824:	c3                   	ret    

00104825 <check_pgdir>:

static void
check_pgdir(void) {
  104825:	55                   	push   %ebp
  104826:	89 e5                	mov    %esp,%ebp
  104828:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10482b:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104830:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104835:	76 24                	jbe    10485b <check_pgdir+0x36>
  104837:	c7 44 24 0c 1b 6c 10 	movl   $0x106c1b,0xc(%esp)
  10483e:	00 
  10483f:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104846:	00 
  104847:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  10484e:	00 
  10484f:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104856:	e8 80 c4 ff ff       	call   100cdb <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10485b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104860:	85 c0                	test   %eax,%eax
  104862:	74 0e                	je     104872 <check_pgdir+0x4d>
  104864:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104869:	25 ff 0f 00 00       	and    $0xfff,%eax
  10486e:	85 c0                	test   %eax,%eax
  104870:	74 24                	je     104896 <check_pgdir+0x71>
  104872:	c7 44 24 0c 38 6c 10 	movl   $0x106c38,0xc(%esp)
  104879:	00 
  10487a:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104881:	00 
  104882:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  104889:	00 
  10488a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104891:	e8 45 c4 ff ff       	call   100cdb <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104896:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10489b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048a2:	00 
  1048a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048aa:	00 
  1048ab:	89 04 24             	mov    %eax,(%esp)
  1048ae:	e8 31 fd ff ff       	call   1045e4 <get_page>
  1048b3:	85 c0                	test   %eax,%eax
  1048b5:	74 24                	je     1048db <check_pgdir+0xb6>
  1048b7:	c7 44 24 0c 70 6c 10 	movl   $0x106c70,0xc(%esp)
  1048be:	00 
  1048bf:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1048c6:	00 
  1048c7:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  1048ce:	00 
  1048cf:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1048d6:	e8 00 c4 ff ff       	call   100cdb <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1048db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048e2:	e8 30 f5 ff ff       	call   103e17 <alloc_pages>
  1048e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1048ea:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1048f6:	00 
  1048f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048fe:	00 
  1048ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104902:	89 54 24 04          	mov    %edx,0x4(%esp)
  104906:	89 04 24             	mov    %eax,(%esp)
  104909:	e8 dc fd ff ff       	call   1046ea <page_insert>
  10490e:	85 c0                	test   %eax,%eax
  104910:	74 24                	je     104936 <check_pgdir+0x111>
  104912:	c7 44 24 0c 98 6c 10 	movl   $0x106c98,0xc(%esp)
  104919:	00 
  10491a:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104921:	00 
  104922:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104929:	00 
  10492a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104931:	e8 a5 c3 ff ff       	call   100cdb <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104936:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10493b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104942:	00 
  104943:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10494a:	00 
  10494b:	89 04 24             	mov    %eax,(%esp)
  10494e:	e8 56 fb ff ff       	call   1044a9 <get_pte>
  104953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104956:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10495a:	75 24                	jne    104980 <check_pgdir+0x15b>
  10495c:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104963:	00 
  104964:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10496b:	00 
  10496c:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104973:	00 
  104974:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10497b:	e8 5b c3 ff ff       	call   100cdb <__panic>
    assert(pte2page(*ptep) == p1);
  104980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104983:	8b 00                	mov    (%eax),%eax
  104985:	89 04 24             	mov    %eax,(%esp)
  104988:	e8 20 f2 ff ff       	call   103bad <pte2page>
  10498d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104990:	74 24                	je     1049b6 <check_pgdir+0x191>
  104992:	c7 44 24 0c f1 6c 10 	movl   $0x106cf1,0xc(%esp)
  104999:	00 
  10499a:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1049a1:	00 
  1049a2:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  1049a9:	00 
  1049aa:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1049b1:	e8 25 c3 ff ff       	call   100cdb <__panic>
    assert(page_ref(p1) == 1);
  1049b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049b9:	89 04 24             	mov    %eax,(%esp)
  1049bc:	e8 46 f2 ff ff       	call   103c07 <page_ref>
  1049c1:	83 f8 01             	cmp    $0x1,%eax
  1049c4:	74 24                	je     1049ea <check_pgdir+0x1c5>
  1049c6:	c7 44 24 0c 07 6d 10 	movl   $0x106d07,0xc(%esp)
  1049cd:	00 
  1049ce:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1049d5:	00 
  1049d6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1049dd:	00 
  1049de:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1049e5:	e8 f1 c2 ff ff       	call   100cdb <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1049ea:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1049ef:	8b 00                	mov    (%eax),%eax
  1049f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1049f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1049f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049fc:	c1 e8 0c             	shr    $0xc,%eax
  1049ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104a02:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104a07:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104a0a:	72 23                	jb     104a2f <check_pgdir+0x20a>
  104a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a13:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  104a1a:	00 
  104a1b:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104a22:	00 
  104a23:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104a2a:	e8 ac c2 ff ff       	call   100cdb <__panic>
  104a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a32:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104a37:	83 c0 04             	add    $0x4,%eax
  104a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104a3d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a49:	00 
  104a4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a51:	00 
  104a52:	89 04 24             	mov    %eax,(%esp)
  104a55:	e8 4f fa ff ff       	call   1044a9 <get_pte>
  104a5a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  104a5d:	74 24                	je     104a83 <check_pgdir+0x25e>
  104a5f:	c7 44 24 0c 1c 6d 10 	movl   $0x106d1c,0xc(%esp)
  104a66:	00 
  104a67:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104a6e:	00 
  104a6f:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104a76:	00 
  104a77:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104a7e:	e8 58 c2 ff ff       	call   100cdb <__panic>

    p2 = alloc_page();
  104a83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a8a:	e8 88 f3 ff ff       	call   103e17 <alloc_pages>
  104a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a92:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a97:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104aa6:	00 
  104aa7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104aaa:	89 54 24 04          	mov    %edx,0x4(%esp)
  104aae:	89 04 24             	mov    %eax,(%esp)
  104ab1:	e8 34 fc ff ff       	call   1046ea <page_insert>
  104ab6:	85 c0                	test   %eax,%eax
  104ab8:	74 24                	je     104ade <check_pgdir+0x2b9>
  104aba:	c7 44 24 0c 44 6d 10 	movl   $0x106d44,0xc(%esp)
  104ac1:	00 
  104ac2:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104ac9:	00 
  104aca:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104ad1:	00 
  104ad2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104ad9:	e8 fd c1 ff ff       	call   100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ade:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104ae3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aea:	00 
  104aeb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104af2:	00 
  104af3:	89 04 24             	mov    %eax,(%esp)
  104af6:	e8 ae f9 ff ff       	call   1044a9 <get_pte>
  104afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104afe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b02:	75 24                	jne    104b28 <check_pgdir+0x303>
  104b04:	c7 44 24 0c 7c 6d 10 	movl   $0x106d7c,0xc(%esp)
  104b0b:	00 
  104b0c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104b13:	00 
  104b14:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104b1b:	00 
  104b1c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b23:	e8 b3 c1 ff ff       	call   100cdb <__panic>
    assert(*ptep & PTE_U);
  104b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b2b:	8b 00                	mov    (%eax),%eax
  104b2d:	83 e0 04             	and    $0x4,%eax
  104b30:	85 c0                	test   %eax,%eax
  104b32:	75 24                	jne    104b58 <check_pgdir+0x333>
  104b34:	c7 44 24 0c ac 6d 10 	movl   $0x106dac,0xc(%esp)
  104b3b:	00 
  104b3c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104b43:	00 
  104b44:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104b4b:	00 
  104b4c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b53:	e8 83 c1 ff ff       	call   100cdb <__panic>
    assert(*ptep & PTE_W);
  104b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b5b:	8b 00                	mov    (%eax),%eax
  104b5d:	83 e0 02             	and    $0x2,%eax
  104b60:	85 c0                	test   %eax,%eax
  104b62:	75 24                	jne    104b88 <check_pgdir+0x363>
  104b64:	c7 44 24 0c ba 6d 10 	movl   $0x106dba,0xc(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104b73:	00 
  104b74:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104b7b:	00 
  104b7c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104b83:	e8 53 c1 ff ff       	call   100cdb <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b88:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104b8d:	8b 00                	mov    (%eax),%eax
  104b8f:	83 e0 04             	and    $0x4,%eax
  104b92:	85 c0                	test   %eax,%eax
  104b94:	75 24                	jne    104bba <check_pgdir+0x395>
  104b96:	c7 44 24 0c c8 6d 10 	movl   $0x106dc8,0xc(%esp)
  104b9d:	00 
  104b9e:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104ba5:	00 
  104ba6:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104bad:	00 
  104bae:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104bb5:	e8 21 c1 ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 1);
  104bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bbd:	89 04 24             	mov    %eax,(%esp)
  104bc0:	e8 42 f0 ff ff       	call   103c07 <page_ref>
  104bc5:	83 f8 01             	cmp    $0x1,%eax
  104bc8:	74 24                	je     104bee <check_pgdir+0x3c9>
  104bca:	c7 44 24 0c de 6d 10 	movl   $0x106dde,0xc(%esp)
  104bd1:	00 
  104bd2:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104bd9:	00 
  104bda:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104be1:	00 
  104be2:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104be9:	e8 ed c0 ff ff       	call   100cdb <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104bee:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104bf3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104bfa:	00 
  104bfb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c02:	00 
  104c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104c06:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c0a:	89 04 24             	mov    %eax,(%esp)
  104c0d:	e8 d8 fa ff ff       	call   1046ea <page_insert>
  104c12:	85 c0                	test   %eax,%eax
  104c14:	74 24                	je     104c3a <check_pgdir+0x415>
  104c16:	c7 44 24 0c f0 6d 10 	movl   $0x106df0,0xc(%esp)
  104c1d:	00 
  104c1e:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104c25:	00 
  104c26:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104c2d:	00 
  104c2e:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104c35:	e8 a1 c0 ff ff       	call   100cdb <__panic>
    assert(page_ref(p1) == 2);
  104c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c3d:	89 04 24             	mov    %eax,(%esp)
  104c40:	e8 c2 ef ff ff       	call   103c07 <page_ref>
  104c45:	83 f8 02             	cmp    $0x2,%eax
  104c48:	74 24                	je     104c6e <check_pgdir+0x449>
  104c4a:	c7 44 24 0c 1c 6e 10 	movl   $0x106e1c,0xc(%esp)
  104c51:	00 
  104c52:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104c59:	00 
  104c5a:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104c61:	00 
  104c62:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104c69:	e8 6d c0 ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 0);
  104c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c71:	89 04 24             	mov    %eax,(%esp)
  104c74:	e8 8e ef ff ff       	call   103c07 <page_ref>
  104c79:	85 c0                	test   %eax,%eax
  104c7b:	74 24                	je     104ca1 <check_pgdir+0x47c>
  104c7d:	c7 44 24 0c 2e 6e 10 	movl   $0x106e2e,0xc(%esp)
  104c84:	00 
  104c85:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104c8c:	00 
  104c8d:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104c94:	00 
  104c95:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104c9c:	e8 3a c0 ff ff       	call   100cdb <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ca1:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104ca6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cad:	00 
  104cae:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cb5:	00 
  104cb6:	89 04 24             	mov    %eax,(%esp)
  104cb9:	e8 eb f7 ff ff       	call   1044a9 <get_pte>
  104cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cc5:	75 24                	jne    104ceb <check_pgdir+0x4c6>
  104cc7:	c7 44 24 0c 7c 6d 10 	movl   $0x106d7c,0xc(%esp)
  104cce:	00 
  104ccf:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104cd6:	00 
  104cd7:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104cde:	00 
  104cdf:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104ce6:	e8 f0 bf ff ff       	call   100cdb <__panic>
    assert(pte2page(*ptep) == p1);
  104ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cee:	8b 00                	mov    (%eax),%eax
  104cf0:	89 04 24             	mov    %eax,(%esp)
  104cf3:	e8 b5 ee ff ff       	call   103bad <pte2page>
  104cf8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104cfb:	74 24                	je     104d21 <check_pgdir+0x4fc>
  104cfd:	c7 44 24 0c f1 6c 10 	movl   $0x106cf1,0xc(%esp)
  104d04:	00 
  104d05:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104d0c:	00 
  104d0d:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104d14:	00 
  104d15:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104d1c:	e8 ba bf ff ff       	call   100cdb <__panic>
    assert((*ptep & PTE_U) == 0);
  104d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d24:	8b 00                	mov    (%eax),%eax
  104d26:	83 e0 04             	and    $0x4,%eax
  104d29:	85 c0                	test   %eax,%eax
  104d2b:	74 24                	je     104d51 <check_pgdir+0x52c>
  104d2d:	c7 44 24 0c 40 6e 10 	movl   $0x106e40,0xc(%esp)
  104d34:	00 
  104d35:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104d3c:	00 
  104d3d:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104d44:	00 
  104d45:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104d4c:	e8 8a bf ff ff       	call   100cdb <__panic>

    page_remove(boot_pgdir, 0x0);
  104d51:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104d5d:	00 
  104d5e:	89 04 24             	mov    %eax,(%esp)
  104d61:	e8 3d f9 ff ff       	call   1046a3 <page_remove>
    assert(page_ref(p1) == 1);
  104d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d69:	89 04 24             	mov    %eax,(%esp)
  104d6c:	e8 96 ee ff ff       	call   103c07 <page_ref>
  104d71:	83 f8 01             	cmp    $0x1,%eax
  104d74:	74 24                	je     104d9a <check_pgdir+0x575>
  104d76:	c7 44 24 0c 07 6d 10 	movl   $0x106d07,0xc(%esp)
  104d7d:	00 
  104d7e:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104d85:	00 
  104d86:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104d8d:	00 
  104d8e:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104d95:	e8 41 bf ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 0);
  104d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d9d:	89 04 24             	mov    %eax,(%esp)
  104da0:	e8 62 ee ff ff       	call   103c07 <page_ref>
  104da5:	85 c0                	test   %eax,%eax
  104da7:	74 24                	je     104dcd <check_pgdir+0x5a8>
  104da9:	c7 44 24 0c 2e 6e 10 	movl   $0x106e2e,0xc(%esp)
  104db0:	00 
  104db1:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104db8:	00 
  104db9:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104dc0:	00 
  104dc1:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104dc8:	e8 0e bf ff ff       	call   100cdb <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104dcd:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104dd2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104dd9:	00 
  104dda:	89 04 24             	mov    %eax,(%esp)
  104ddd:	e8 c1 f8 ff ff       	call   1046a3 <page_remove>
    assert(page_ref(p1) == 0);
  104de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104de5:	89 04 24             	mov    %eax,(%esp)
  104de8:	e8 1a ee ff ff       	call   103c07 <page_ref>
  104ded:	85 c0                	test   %eax,%eax
  104def:	74 24                	je     104e15 <check_pgdir+0x5f0>
  104df1:	c7 44 24 0c 55 6e 10 	movl   $0x106e55,0xc(%esp)
  104df8:	00 
  104df9:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104e00:	00 
  104e01:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104e08:	00 
  104e09:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104e10:	e8 c6 be ff ff       	call   100cdb <__panic>
    assert(page_ref(p2) == 0);
  104e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e18:	89 04 24             	mov    %eax,(%esp)
  104e1b:	e8 e7 ed ff ff       	call   103c07 <page_ref>
  104e20:	85 c0                	test   %eax,%eax
  104e22:	74 24                	je     104e48 <check_pgdir+0x623>
  104e24:	c7 44 24 0c 2e 6e 10 	movl   $0x106e2e,0xc(%esp)
  104e2b:	00 
  104e2c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104e33:	00 
  104e34:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104e3b:	00 
  104e3c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104e43:	e8 93 be ff ff       	call   100cdb <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104e48:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e4d:	8b 00                	mov    (%eax),%eax
  104e4f:	89 04 24             	mov    %eax,(%esp)
  104e52:	e8 96 ed ff ff       	call   103bed <pde2page>
  104e57:	89 04 24             	mov    %eax,(%esp)
  104e5a:	e8 a8 ed ff ff       	call   103c07 <page_ref>
  104e5f:	83 f8 01             	cmp    $0x1,%eax
  104e62:	74 24                	je     104e88 <check_pgdir+0x663>
  104e64:	c7 44 24 0c 68 6e 10 	movl   $0x106e68,0xc(%esp)
  104e6b:	00 
  104e6c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104e73:	00 
  104e74:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104e7b:	00 
  104e7c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104e83:	e8 53 be ff ff       	call   100cdb <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104e88:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e8d:	8b 00                	mov    (%eax),%eax
  104e8f:	89 04 24             	mov    %eax,(%esp)
  104e92:	e8 56 ed ff ff       	call   103bed <pde2page>
  104e97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e9e:	00 
  104e9f:	89 04 24             	mov    %eax,(%esp)
  104ea2:	e8 aa ef ff ff       	call   103e51 <free_pages>
    boot_pgdir[0] = 0;
  104ea7:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104eac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104eb2:	c7 04 24 8f 6e 10 00 	movl   $0x106e8f,(%esp)
  104eb9:	e8 98 b4 ff ff       	call   100356 <cprintf>
}
  104ebe:	90                   	nop
  104ebf:	89 ec                	mov    %ebp,%esp
  104ec1:	5d                   	pop    %ebp
  104ec2:	c3                   	ret    

00104ec3 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104ec3:	55                   	push   %ebp
  104ec4:	89 e5                	mov    %esp,%ebp
  104ec6:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ec9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104ed0:	e9 ca 00 00 00       	jmp    104f9f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ede:	c1 e8 0c             	shr    $0xc,%eax
  104ee1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104ee4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104ee9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104eec:	72 23                	jb     104f11 <check_boot_pgdir+0x4e>
  104eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ef1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104ef5:	c7 44 24 08 d4 6a 10 	movl   $0x106ad4,0x8(%esp)
  104efc:	00 
  104efd:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104f04:	00 
  104f05:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104f0c:	e8 ca bd ff ff       	call   100cdb <__panic>
  104f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f14:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104f19:	89 c2                	mov    %eax,%edx
  104f1b:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104f20:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104f27:	00 
  104f28:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f2c:	89 04 24             	mov    %eax,(%esp)
  104f2f:	e8 75 f5 ff ff       	call   1044a9 <get_pte>
  104f34:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104f37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104f3b:	75 24                	jne    104f61 <check_boot_pgdir+0x9e>
  104f3d:	c7 44 24 0c ac 6e 10 	movl   $0x106eac,0xc(%esp)
  104f44:	00 
  104f45:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104f4c:	00 
  104f4d:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104f54:	00 
  104f55:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104f5c:	e8 7a bd ff ff       	call   100cdb <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f64:	8b 00                	mov    (%eax),%eax
  104f66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f6b:	89 c2                	mov    %eax,%edx
  104f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f70:	39 c2                	cmp    %eax,%edx
  104f72:	74 24                	je     104f98 <check_boot_pgdir+0xd5>
  104f74:	c7 44 24 0c e9 6e 10 	movl   $0x106ee9,0xc(%esp)
  104f7b:	00 
  104f7c:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  104f83:	00 
  104f84:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  104f8b:	00 
  104f8c:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104f93:	e8 43 bd ff ff       	call   100cdb <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104f98:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104fa2:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104fa7:	39 c2                	cmp    %eax,%edx
  104fa9:	0f 82 26 ff ff ff    	jb     104ed5 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104faf:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104fb4:	05 ac 0f 00 00       	add    $0xfac,%eax
  104fb9:	8b 00                	mov    (%eax),%eax
  104fbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104fc0:	89 c2                	mov    %eax,%edx
  104fc2:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104fca:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104fd1:	77 23                	ja     104ff6 <check_boot_pgdir+0x133>
  104fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104fda:	c7 44 24 08 78 6b 10 	movl   $0x106b78,0x8(%esp)
  104fe1:	00 
  104fe2:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  104fe9:	00 
  104fea:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104ff1:	e8 e5 bc ff ff       	call   100cdb <__panic>
  104ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ff9:	05 00 00 00 40       	add    $0x40000000,%eax
  104ffe:	39 d0                	cmp    %edx,%eax
  105000:	74 24                	je     105026 <check_boot_pgdir+0x163>
  105002:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  105009:	00 
  10500a:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  105011:	00 
  105012:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  105019:	00 
  10501a:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  105021:	e8 b5 bc ff ff       	call   100cdb <__panic>

    assert(boot_pgdir[0] == 0);
  105026:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10502b:	8b 00                	mov    (%eax),%eax
  10502d:	85 c0                	test   %eax,%eax
  10502f:	74 24                	je     105055 <check_boot_pgdir+0x192>
  105031:	c7 44 24 0c 34 6f 10 	movl   $0x106f34,0xc(%esp)
  105038:	00 
  105039:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  105040:	00 
  105041:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  105048:	00 
  105049:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  105050:	e8 86 bc ff ff       	call   100cdb <__panic>

    struct Page *p;
    p = alloc_page();
  105055:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10505c:	e8 b6 ed ff ff       	call   103e17 <alloc_pages>
  105061:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105064:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  105069:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105070:	00 
  105071:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105078:	00 
  105079:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10507c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105080:	89 04 24             	mov    %eax,(%esp)
  105083:	e8 62 f6 ff ff       	call   1046ea <page_insert>
  105088:	85 c0                	test   %eax,%eax
  10508a:	74 24                	je     1050b0 <check_boot_pgdir+0x1ed>
  10508c:	c7 44 24 0c 48 6f 10 	movl   $0x106f48,0xc(%esp)
  105093:	00 
  105094:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10509b:	00 
  10509c:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  1050a3:	00 
  1050a4:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1050ab:	e8 2b bc ff ff       	call   100cdb <__panic>
    assert(page_ref(p) == 1);
  1050b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1050b3:	89 04 24             	mov    %eax,(%esp)
  1050b6:	e8 4c eb ff ff       	call   103c07 <page_ref>
  1050bb:	83 f8 01             	cmp    $0x1,%eax
  1050be:	74 24                	je     1050e4 <check_boot_pgdir+0x221>
  1050c0:	c7 44 24 0c 76 6f 10 	movl   $0x106f76,0xc(%esp)
  1050c7:	00 
  1050c8:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1050cf:	00 
  1050d0:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  1050d7:	00 
  1050d8:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1050df:	e8 f7 bb ff ff       	call   100cdb <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1050e4:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1050e9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1050f0:	00 
  1050f1:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1050f8:	00 
  1050f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1050fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  105100:	89 04 24             	mov    %eax,(%esp)
  105103:	e8 e2 f5 ff ff       	call   1046ea <page_insert>
  105108:	85 c0                	test   %eax,%eax
  10510a:	74 24                	je     105130 <check_boot_pgdir+0x26d>
  10510c:	c7 44 24 0c 88 6f 10 	movl   $0x106f88,0xc(%esp)
  105113:	00 
  105114:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10511b:	00 
  10511c:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105123:	00 
  105124:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10512b:	e8 ab bb ff ff       	call   100cdb <__panic>
    assert(page_ref(p) == 2);
  105130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105133:	89 04 24             	mov    %eax,(%esp)
  105136:	e8 cc ea ff ff       	call   103c07 <page_ref>
  10513b:	83 f8 02             	cmp    $0x2,%eax
  10513e:	74 24                	je     105164 <check_boot_pgdir+0x2a1>
  105140:	c7 44 24 0c bf 6f 10 	movl   $0x106fbf,0xc(%esp)
  105147:	00 
  105148:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  10514f:	00 
  105150:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  105157:	00 
  105158:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  10515f:	e8 77 bb ff ff       	call   100cdb <__panic>

    const char *str = "ucore: Hello world!!";
  105164:	c7 45 e8 d0 6f 10 00 	movl   $0x106fd0,-0x18(%ebp)
    strcpy((void *)0x100, str);
  10516b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10516e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105172:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105179:	e8 fc 09 00 00       	call   105b7a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10517e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105185:	00 
  105186:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10518d:	e8 60 0a 00 00       	call   105bf2 <strcmp>
  105192:	85 c0                	test   %eax,%eax
  105194:	74 24                	je     1051ba <check_boot_pgdir+0x2f7>
  105196:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  10519d:	00 
  10519e:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1051a5:	00 
  1051a6:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  1051ad:	00 
  1051ae:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1051b5:	e8 21 bb ff ff       	call   100cdb <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1051ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051bd:	89 04 24             	mov    %eax,(%esp)
  1051c0:	e8 92 e9 ff ff       	call   103b57 <page2kva>
  1051c5:	05 00 01 00 00       	add    $0x100,%eax
  1051ca:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1051cd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1051d4:	e8 47 09 00 00       	call   105b20 <strlen>
  1051d9:	85 c0                	test   %eax,%eax
  1051db:	74 24                	je     105201 <check_boot_pgdir+0x33e>
  1051dd:	c7 44 24 0c 20 70 10 	movl   $0x107020,0xc(%esp)
  1051e4:	00 
  1051e5:	c7 44 24 08 c1 6b 10 	movl   $0x106bc1,0x8(%esp)
  1051ec:	00 
  1051ed:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  1051f4:	00 
  1051f5:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  1051fc:	e8 da ba ff ff       	call   100cdb <__panic>

    free_page(p);
  105201:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105208:	00 
  105209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10520c:	89 04 24             	mov    %eax,(%esp)
  10520f:	e8 3d ec ff ff       	call   103e51 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105214:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  105219:	8b 00                	mov    (%eax),%eax
  10521b:	89 04 24             	mov    %eax,(%esp)
  10521e:	e8 ca e9 ff ff       	call   103bed <pde2page>
  105223:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10522a:	00 
  10522b:	89 04 24             	mov    %eax,(%esp)
  10522e:	e8 1e ec ff ff       	call   103e51 <free_pages>
    boot_pgdir[0] = 0;
  105233:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  105238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10523e:	c7 04 24 44 70 10 00 	movl   $0x107044,(%esp)
  105245:	e8 0c b1 ff ff       	call   100356 <cprintf>
}
  10524a:	90                   	nop
  10524b:	89 ec                	mov    %ebp,%esp
  10524d:	5d                   	pop    %ebp
  10524e:	c3                   	ret    

0010524f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10524f:	55                   	push   %ebp
  105250:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105252:	8b 45 08             	mov    0x8(%ebp),%eax
  105255:	83 e0 04             	and    $0x4,%eax
  105258:	85 c0                	test   %eax,%eax
  10525a:	74 04                	je     105260 <perm2str+0x11>
  10525c:	b0 75                	mov    $0x75,%al
  10525e:	eb 02                	jmp    105262 <perm2str+0x13>
  105260:	b0 2d                	mov    $0x2d,%al
  105262:	a2 28 bf 11 00       	mov    %al,0x11bf28
    str[1] = 'r';
  105267:	c6 05 29 bf 11 00 72 	movb   $0x72,0x11bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10526e:	8b 45 08             	mov    0x8(%ebp),%eax
  105271:	83 e0 02             	and    $0x2,%eax
  105274:	85 c0                	test   %eax,%eax
  105276:	74 04                	je     10527c <perm2str+0x2d>
  105278:	b0 77                	mov    $0x77,%al
  10527a:	eb 02                	jmp    10527e <perm2str+0x2f>
  10527c:	b0 2d                	mov    $0x2d,%al
  10527e:	a2 2a bf 11 00       	mov    %al,0x11bf2a
    str[3] = '\0';
  105283:	c6 05 2b bf 11 00 00 	movb   $0x0,0x11bf2b
    return str;
  10528a:	b8 28 bf 11 00       	mov    $0x11bf28,%eax
}
  10528f:	5d                   	pop    %ebp
  105290:	c3                   	ret    

00105291 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105291:	55                   	push   %ebp
  105292:	89 e5                	mov    %esp,%ebp
  105294:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105297:	8b 45 10             	mov    0x10(%ebp),%eax
  10529a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10529d:	72 0d                	jb     1052ac <get_pgtable_items+0x1b>
        return 0;
  10529f:	b8 00 00 00 00       	mov    $0x0,%eax
  1052a4:	e9 98 00 00 00       	jmp    105341 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1052a9:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1052ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1052af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052b2:	73 18                	jae    1052cc <get_pgtable_items+0x3b>
  1052b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052be:	8b 45 14             	mov    0x14(%ebp),%eax
  1052c1:	01 d0                	add    %edx,%eax
  1052c3:	8b 00                	mov    (%eax),%eax
  1052c5:	83 e0 01             	and    $0x1,%eax
  1052c8:	85 c0                	test   %eax,%eax
  1052ca:	74 dd                	je     1052a9 <get_pgtable_items+0x18>
    }
    if (start < right) {
  1052cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1052cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052d2:	73 68                	jae    10533c <get_pgtable_items+0xab>
        if (left_store != NULL) {
  1052d4:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1052d8:	74 08                	je     1052e2 <get_pgtable_items+0x51>
            *left_store = start;
  1052da:	8b 45 18             	mov    0x18(%ebp),%eax
  1052dd:	8b 55 10             	mov    0x10(%ebp),%edx
  1052e0:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1052e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1052e5:	8d 50 01             	lea    0x1(%eax),%edx
  1052e8:	89 55 10             	mov    %edx,0x10(%ebp)
  1052eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052f2:	8b 45 14             	mov    0x14(%ebp),%eax
  1052f5:	01 d0                	add    %edx,%eax
  1052f7:	8b 00                	mov    (%eax),%eax
  1052f9:	83 e0 07             	and    $0x7,%eax
  1052fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052ff:	eb 03                	jmp    105304 <get_pgtable_items+0x73>
            start ++;
  105301:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105304:	8b 45 10             	mov    0x10(%ebp),%eax
  105307:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10530a:	73 1d                	jae    105329 <get_pgtable_items+0x98>
  10530c:	8b 45 10             	mov    0x10(%ebp),%eax
  10530f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105316:	8b 45 14             	mov    0x14(%ebp),%eax
  105319:	01 d0                	add    %edx,%eax
  10531b:	8b 00                	mov    (%eax),%eax
  10531d:	83 e0 07             	and    $0x7,%eax
  105320:	89 c2                	mov    %eax,%edx
  105322:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105325:	39 c2                	cmp    %eax,%edx
  105327:	74 d8                	je     105301 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  105329:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10532d:	74 08                	je     105337 <get_pgtable_items+0xa6>
            *right_store = start;
  10532f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105332:	8b 55 10             	mov    0x10(%ebp),%edx
  105335:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105337:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10533a:	eb 05                	jmp    105341 <get_pgtable_items+0xb0>
    }
    return 0;
  10533c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105341:	89 ec                	mov    %ebp,%esp
  105343:	5d                   	pop    %ebp
  105344:	c3                   	ret    

00105345 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105345:	55                   	push   %ebp
  105346:	89 e5                	mov    %esp,%ebp
  105348:	57                   	push   %edi
  105349:	56                   	push   %esi
  10534a:	53                   	push   %ebx
  10534b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10534e:	c7 04 24 64 70 10 00 	movl   $0x107064,(%esp)
  105355:	e8 fc af ff ff       	call   100356 <cprintf>
    size_t left, right = 0, perm;
  10535a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105361:	e9 f2 00 00 00       	jmp    105458 <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105369:	89 04 24             	mov    %eax,(%esp)
  10536c:	e8 de fe ff ff       	call   10524f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105371:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105374:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105377:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105379:	89 d6                	mov    %edx,%esi
  10537b:	c1 e6 16             	shl    $0x16,%esi
  10537e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105381:	89 d3                	mov    %edx,%ebx
  105383:	c1 e3 16             	shl    $0x16,%ebx
  105386:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105389:	89 d1                	mov    %edx,%ecx
  10538b:	c1 e1 16             	shl    $0x16,%ecx
  10538e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105391:	8b 7d e0             	mov    -0x20(%ebp),%edi
  105394:	29 fa                	sub    %edi,%edx
  105396:	89 44 24 14          	mov    %eax,0x14(%esp)
  10539a:	89 74 24 10          	mov    %esi,0x10(%esp)
  10539e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053aa:	c7 04 24 95 70 10 00 	movl   $0x107095,(%esp)
  1053b1:	e8 a0 af ff ff       	call   100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
  1053b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053b9:	c1 e0 0a             	shl    $0xa,%eax
  1053bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053bf:	eb 50                	jmp    105411 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053c4:	89 04 24             	mov    %eax,(%esp)
  1053c7:	e8 83 fe ff ff       	call   10524f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1053cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053cf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  1053d2:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1053d4:	89 d6                	mov    %edx,%esi
  1053d6:	c1 e6 0c             	shl    $0xc,%esi
  1053d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053dc:	89 d3                	mov    %edx,%ebx
  1053de:	c1 e3 0c             	shl    $0xc,%ebx
  1053e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1053e4:	89 d1                	mov    %edx,%ecx
  1053e6:	c1 e1 0c             	shl    $0xc,%ecx
  1053e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1053ec:	8b 7d d8             	mov    -0x28(%ebp),%edi
  1053ef:	29 fa                	sub    %edi,%edx
  1053f1:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053f5:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053f9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105401:	89 54 24 04          	mov    %edx,0x4(%esp)
  105405:	c7 04 24 b4 70 10 00 	movl   $0x1070b4,(%esp)
  10540c:	e8 45 af ff ff       	call   100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105411:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  105416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105419:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10541c:	89 d3                	mov    %edx,%ebx
  10541e:	c1 e3 0a             	shl    $0xa,%ebx
  105421:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105424:	89 d1                	mov    %edx,%ecx
  105426:	c1 e1 0a             	shl    $0xa,%ecx
  105429:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10542c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105430:	8d 55 d8             	lea    -0x28(%ebp),%edx
  105433:	89 54 24 10          	mov    %edx,0x10(%esp)
  105437:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10543b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10543f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105443:	89 0c 24             	mov    %ecx,(%esp)
  105446:	e8 46 fe ff ff       	call   105291 <get_pgtable_items>
  10544b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10544e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105452:	0f 85 69 ff ff ff    	jne    1053c1 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105458:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10545d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105460:	8d 55 dc             	lea    -0x24(%ebp),%edx
  105463:	89 54 24 14          	mov    %edx,0x14(%esp)
  105467:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10546a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10546e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  105472:	89 44 24 08          	mov    %eax,0x8(%esp)
  105476:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10547d:	00 
  10547e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105485:	e8 07 fe ff ff       	call   105291 <get_pgtable_items>
  10548a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10548d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105491:	0f 85 cf fe ff ff    	jne    105366 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105497:	c7 04 24 d8 70 10 00 	movl   $0x1070d8,(%esp)
  10549e:	e8 b3 ae ff ff       	call   100356 <cprintf>
}
  1054a3:	90                   	nop
  1054a4:	83 c4 4c             	add    $0x4c,%esp
  1054a7:	5b                   	pop    %ebx
  1054a8:	5e                   	pop    %esi
  1054a9:	5f                   	pop    %edi
  1054aa:	5d                   	pop    %ebp
  1054ab:	c3                   	ret    

001054ac <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1054ac:	55                   	push   %ebp
  1054ad:	89 e5                	mov    %esp,%ebp
  1054af:	83 ec 58             	sub    $0x58,%esp
  1054b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1054b8:	8b 45 14             	mov    0x14(%ebp),%eax
  1054bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1054be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1054c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1054c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1054ca:	8b 45 18             	mov    0x18(%ebp),%eax
  1054cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1054d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054d9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1054dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1054e6:	74 1c                	je     105504 <printnum+0x58>
  1054e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1054f0:	f7 75 e4             	divl   -0x1c(%ebp)
  1054f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054f9:	ba 00 00 00 00       	mov    $0x0,%edx
  1054fe:	f7 75 e4             	divl   -0x1c(%ebp)
  105501:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105504:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10550a:	f7 75 e4             	divl   -0x1c(%ebp)
  10550d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105510:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105516:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105519:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10551c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10551f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105522:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105525:	8b 45 18             	mov    0x18(%ebp),%eax
  105528:	ba 00 00 00 00       	mov    $0x0,%edx
  10552d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105530:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105533:	19 d1                	sbb    %edx,%ecx
  105535:	72 4c                	jb     105583 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105537:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10553a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10553d:	8b 45 20             	mov    0x20(%ebp),%eax
  105540:	89 44 24 18          	mov    %eax,0x18(%esp)
  105544:	89 54 24 14          	mov    %edx,0x14(%esp)
  105548:	8b 45 18             	mov    0x18(%ebp),%eax
  10554b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10554f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105552:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105555:	89 44 24 08          	mov    %eax,0x8(%esp)
  105559:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10555d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105560:	89 44 24 04          	mov    %eax,0x4(%esp)
  105564:	8b 45 08             	mov    0x8(%ebp),%eax
  105567:	89 04 24             	mov    %eax,(%esp)
  10556a:	e8 3d ff ff ff       	call   1054ac <printnum>
  10556f:	eb 1b                	jmp    10558c <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105571:	8b 45 0c             	mov    0xc(%ebp),%eax
  105574:	89 44 24 04          	mov    %eax,0x4(%esp)
  105578:	8b 45 20             	mov    0x20(%ebp),%eax
  10557b:	89 04 24             	mov    %eax,(%esp)
  10557e:	8b 45 08             	mov    0x8(%ebp),%eax
  105581:	ff d0                	call   *%eax
        while (-- width > 0)
  105583:	ff 4d 1c             	decl   0x1c(%ebp)
  105586:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10558a:	7f e5                	jg     105571 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10558c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10558f:	05 8c 71 10 00       	add    $0x10718c,%eax
  105594:	0f b6 00             	movzbl (%eax),%eax
  105597:	0f be c0             	movsbl %al,%eax
  10559a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10559d:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055a1:	89 04 24             	mov    %eax,(%esp)
  1055a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a7:	ff d0                	call   *%eax
}
  1055a9:	90                   	nop
  1055aa:	89 ec                	mov    %ebp,%esp
  1055ac:	5d                   	pop    %ebp
  1055ad:	c3                   	ret    

001055ae <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1055ae:	55                   	push   %ebp
  1055af:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055b5:	7e 14                	jle    1055cb <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1055b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ba:	8b 00                	mov    (%eax),%eax
  1055bc:	8d 48 08             	lea    0x8(%eax),%ecx
  1055bf:	8b 55 08             	mov    0x8(%ebp),%edx
  1055c2:	89 0a                	mov    %ecx,(%edx)
  1055c4:	8b 50 04             	mov    0x4(%eax),%edx
  1055c7:	8b 00                	mov    (%eax),%eax
  1055c9:	eb 30                	jmp    1055fb <getuint+0x4d>
    }
    else if (lflag) {
  1055cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055cf:	74 16                	je     1055e7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1055d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d4:	8b 00                	mov    (%eax),%eax
  1055d6:	8d 48 04             	lea    0x4(%eax),%ecx
  1055d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1055dc:	89 0a                	mov    %ecx,(%edx)
  1055de:	8b 00                	mov    (%eax),%eax
  1055e0:	ba 00 00 00 00       	mov    $0x0,%edx
  1055e5:	eb 14                	jmp    1055fb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1055e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ea:	8b 00                	mov    (%eax),%eax
  1055ec:	8d 48 04             	lea    0x4(%eax),%ecx
  1055ef:	8b 55 08             	mov    0x8(%ebp),%edx
  1055f2:	89 0a                	mov    %ecx,(%edx)
  1055f4:	8b 00                	mov    (%eax),%eax
  1055f6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055fb:	5d                   	pop    %ebp
  1055fc:	c3                   	ret    

001055fd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055fd:	55                   	push   %ebp
  1055fe:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105600:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105604:	7e 14                	jle    10561a <getint+0x1d>
        return va_arg(*ap, long long);
  105606:	8b 45 08             	mov    0x8(%ebp),%eax
  105609:	8b 00                	mov    (%eax),%eax
  10560b:	8d 48 08             	lea    0x8(%eax),%ecx
  10560e:	8b 55 08             	mov    0x8(%ebp),%edx
  105611:	89 0a                	mov    %ecx,(%edx)
  105613:	8b 50 04             	mov    0x4(%eax),%edx
  105616:	8b 00                	mov    (%eax),%eax
  105618:	eb 28                	jmp    105642 <getint+0x45>
    }
    else if (lflag) {
  10561a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10561e:	74 12                	je     105632 <getint+0x35>
        return va_arg(*ap, long);
  105620:	8b 45 08             	mov    0x8(%ebp),%eax
  105623:	8b 00                	mov    (%eax),%eax
  105625:	8d 48 04             	lea    0x4(%eax),%ecx
  105628:	8b 55 08             	mov    0x8(%ebp),%edx
  10562b:	89 0a                	mov    %ecx,(%edx)
  10562d:	8b 00                	mov    (%eax),%eax
  10562f:	99                   	cltd   
  105630:	eb 10                	jmp    105642 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105632:	8b 45 08             	mov    0x8(%ebp),%eax
  105635:	8b 00                	mov    (%eax),%eax
  105637:	8d 48 04             	lea    0x4(%eax),%ecx
  10563a:	8b 55 08             	mov    0x8(%ebp),%edx
  10563d:	89 0a                	mov    %ecx,(%edx)
  10563f:	8b 00                	mov    (%eax),%eax
  105641:	99                   	cltd   
    }
}
  105642:	5d                   	pop    %ebp
  105643:	c3                   	ret    

00105644 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105644:	55                   	push   %ebp
  105645:	89 e5                	mov    %esp,%ebp
  105647:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10564a:	8d 45 14             	lea    0x14(%ebp),%eax
  10564d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105653:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105657:	8b 45 10             	mov    0x10(%ebp),%eax
  10565a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10565e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105661:	89 44 24 04          	mov    %eax,0x4(%esp)
  105665:	8b 45 08             	mov    0x8(%ebp),%eax
  105668:	89 04 24             	mov    %eax,(%esp)
  10566b:	e8 05 00 00 00       	call   105675 <vprintfmt>
    va_end(ap);
}
  105670:	90                   	nop
  105671:	89 ec                	mov    %ebp,%esp
  105673:	5d                   	pop    %ebp
  105674:	c3                   	ret    

00105675 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105675:	55                   	push   %ebp
  105676:	89 e5                	mov    %esp,%ebp
  105678:	56                   	push   %esi
  105679:	53                   	push   %ebx
  10567a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10567d:	eb 17                	jmp    105696 <vprintfmt+0x21>
            if (ch == '\0') {
  10567f:	85 db                	test   %ebx,%ebx
  105681:	0f 84 bf 03 00 00    	je     105a46 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105687:	8b 45 0c             	mov    0xc(%ebp),%eax
  10568a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10568e:	89 1c 24             	mov    %ebx,(%esp)
  105691:	8b 45 08             	mov    0x8(%ebp),%eax
  105694:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105696:	8b 45 10             	mov    0x10(%ebp),%eax
  105699:	8d 50 01             	lea    0x1(%eax),%edx
  10569c:	89 55 10             	mov    %edx,0x10(%ebp)
  10569f:	0f b6 00             	movzbl (%eax),%eax
  1056a2:	0f b6 d8             	movzbl %al,%ebx
  1056a5:	83 fb 25             	cmp    $0x25,%ebx
  1056a8:	75 d5                	jne    10567f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1056aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1056ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1056b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1056bb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1056c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1056c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1056cb:	8d 50 01             	lea    0x1(%eax),%edx
  1056ce:	89 55 10             	mov    %edx,0x10(%ebp)
  1056d1:	0f b6 00             	movzbl (%eax),%eax
  1056d4:	0f b6 d8             	movzbl %al,%ebx
  1056d7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1056da:	83 f8 55             	cmp    $0x55,%eax
  1056dd:	0f 87 37 03 00 00    	ja     105a1a <vprintfmt+0x3a5>
  1056e3:	8b 04 85 b0 71 10 00 	mov    0x1071b0(,%eax,4),%eax
  1056ea:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1056ec:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1056f0:	eb d6                	jmp    1056c8 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1056f2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1056f6:	eb d0                	jmp    1056c8 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105702:	89 d0                	mov    %edx,%eax
  105704:	c1 e0 02             	shl    $0x2,%eax
  105707:	01 d0                	add    %edx,%eax
  105709:	01 c0                	add    %eax,%eax
  10570b:	01 d8                	add    %ebx,%eax
  10570d:	83 e8 30             	sub    $0x30,%eax
  105710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105713:	8b 45 10             	mov    0x10(%ebp),%eax
  105716:	0f b6 00             	movzbl (%eax),%eax
  105719:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10571c:	83 fb 2f             	cmp    $0x2f,%ebx
  10571f:	7e 38                	jle    105759 <vprintfmt+0xe4>
  105721:	83 fb 39             	cmp    $0x39,%ebx
  105724:	7f 33                	jg     105759 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105726:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105729:	eb d4                	jmp    1056ff <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10572b:	8b 45 14             	mov    0x14(%ebp),%eax
  10572e:	8d 50 04             	lea    0x4(%eax),%edx
  105731:	89 55 14             	mov    %edx,0x14(%ebp)
  105734:	8b 00                	mov    (%eax),%eax
  105736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105739:	eb 1f                	jmp    10575a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10573b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10573f:	79 87                	jns    1056c8 <vprintfmt+0x53>
                width = 0;
  105741:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105748:	e9 7b ff ff ff       	jmp    1056c8 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10574d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105754:	e9 6f ff ff ff       	jmp    1056c8 <vprintfmt+0x53>
            goto process_precision;
  105759:	90                   	nop

        process_precision:
            if (width < 0)
  10575a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10575e:	0f 89 64 ff ff ff    	jns    1056c8 <vprintfmt+0x53>
                width = precision, precision = -1;
  105764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105767:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10576a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105771:	e9 52 ff ff ff       	jmp    1056c8 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105776:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105779:	e9 4a ff ff ff       	jmp    1056c8 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10577e:	8b 45 14             	mov    0x14(%ebp),%eax
  105781:	8d 50 04             	lea    0x4(%eax),%edx
  105784:	89 55 14             	mov    %edx,0x14(%ebp)
  105787:	8b 00                	mov    (%eax),%eax
  105789:	8b 55 0c             	mov    0xc(%ebp),%edx
  10578c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105790:	89 04 24             	mov    %eax,(%esp)
  105793:	8b 45 08             	mov    0x8(%ebp),%eax
  105796:	ff d0                	call   *%eax
            break;
  105798:	e9 a4 02 00 00       	jmp    105a41 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10579d:	8b 45 14             	mov    0x14(%ebp),%eax
  1057a0:	8d 50 04             	lea    0x4(%eax),%edx
  1057a3:	89 55 14             	mov    %edx,0x14(%ebp)
  1057a6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1057a8:	85 db                	test   %ebx,%ebx
  1057aa:	79 02                	jns    1057ae <vprintfmt+0x139>
                err = -err;
  1057ac:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1057ae:	83 fb 06             	cmp    $0x6,%ebx
  1057b1:	7f 0b                	jg     1057be <vprintfmt+0x149>
  1057b3:	8b 34 9d 70 71 10 00 	mov    0x107170(,%ebx,4),%esi
  1057ba:	85 f6                	test   %esi,%esi
  1057bc:	75 23                	jne    1057e1 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1057be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1057c2:	c7 44 24 08 9d 71 10 	movl   $0x10719d,0x8(%esp)
  1057c9:	00 
  1057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d4:	89 04 24             	mov    %eax,(%esp)
  1057d7:	e8 68 fe ff ff       	call   105644 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1057dc:	e9 60 02 00 00       	jmp    105a41 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1057e1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1057e5:	c7 44 24 08 a6 71 10 	movl   $0x1071a6,0x8(%esp)
  1057ec:	00 
  1057ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f7:	89 04 24             	mov    %eax,(%esp)
  1057fa:	e8 45 fe ff ff       	call   105644 <printfmt>
            break;
  1057ff:	e9 3d 02 00 00       	jmp    105a41 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105804:	8b 45 14             	mov    0x14(%ebp),%eax
  105807:	8d 50 04             	lea    0x4(%eax),%edx
  10580a:	89 55 14             	mov    %edx,0x14(%ebp)
  10580d:	8b 30                	mov    (%eax),%esi
  10580f:	85 f6                	test   %esi,%esi
  105811:	75 05                	jne    105818 <vprintfmt+0x1a3>
                p = "(null)";
  105813:	be a9 71 10 00       	mov    $0x1071a9,%esi
            }
            if (width > 0 && padc != '-') {
  105818:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10581c:	7e 76                	jle    105894 <vprintfmt+0x21f>
  10581e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105822:	74 70                	je     105894 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105827:	89 44 24 04          	mov    %eax,0x4(%esp)
  10582b:	89 34 24             	mov    %esi,(%esp)
  10582e:	e8 16 03 00 00       	call   105b49 <strnlen>
  105833:	89 c2                	mov    %eax,%edx
  105835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105838:	29 d0                	sub    %edx,%eax
  10583a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10583d:	eb 16                	jmp    105855 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  10583f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105843:	8b 55 0c             	mov    0xc(%ebp),%edx
  105846:	89 54 24 04          	mov    %edx,0x4(%esp)
  10584a:	89 04 24             	mov    %eax,(%esp)
  10584d:	8b 45 08             	mov    0x8(%ebp),%eax
  105850:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105852:	ff 4d e8             	decl   -0x18(%ebp)
  105855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105859:	7f e4                	jg     10583f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10585b:	eb 37                	jmp    105894 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10585d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105861:	74 1f                	je     105882 <vprintfmt+0x20d>
  105863:	83 fb 1f             	cmp    $0x1f,%ebx
  105866:	7e 05                	jle    10586d <vprintfmt+0x1f8>
  105868:	83 fb 7e             	cmp    $0x7e,%ebx
  10586b:	7e 15                	jle    105882 <vprintfmt+0x20d>
                    putch('?', putdat);
  10586d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105870:	89 44 24 04          	mov    %eax,0x4(%esp)
  105874:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10587b:	8b 45 08             	mov    0x8(%ebp),%eax
  10587e:	ff d0                	call   *%eax
  105880:	eb 0f                	jmp    105891 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105882:	8b 45 0c             	mov    0xc(%ebp),%eax
  105885:	89 44 24 04          	mov    %eax,0x4(%esp)
  105889:	89 1c 24             	mov    %ebx,(%esp)
  10588c:	8b 45 08             	mov    0x8(%ebp),%eax
  10588f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105891:	ff 4d e8             	decl   -0x18(%ebp)
  105894:	89 f0                	mov    %esi,%eax
  105896:	8d 70 01             	lea    0x1(%eax),%esi
  105899:	0f b6 00             	movzbl (%eax),%eax
  10589c:	0f be d8             	movsbl %al,%ebx
  10589f:	85 db                	test   %ebx,%ebx
  1058a1:	74 27                	je     1058ca <vprintfmt+0x255>
  1058a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058a7:	78 b4                	js     10585d <vprintfmt+0x1e8>
  1058a9:	ff 4d e4             	decl   -0x1c(%ebp)
  1058ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1058b0:	79 ab                	jns    10585d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1058b2:	eb 16                	jmp    1058ca <vprintfmt+0x255>
                putch(' ', putdat);
  1058b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1058c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c5:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1058c7:	ff 4d e8             	decl   -0x18(%ebp)
  1058ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058ce:	7f e4                	jg     1058b4 <vprintfmt+0x23f>
            }
            break;
  1058d0:	e9 6c 01 00 00       	jmp    105a41 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1058d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1058df:	89 04 24             	mov    %eax,(%esp)
  1058e2:	e8 16 fd ff ff       	call   1055fd <getint>
  1058e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1058ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058f3:	85 d2                	test   %edx,%edx
  1058f5:	79 26                	jns    10591d <vprintfmt+0x2a8>
                putch('-', putdat);
  1058f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058fe:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105905:	8b 45 08             	mov    0x8(%ebp),%eax
  105908:	ff d0                	call   *%eax
                num = -(long long)num;
  10590a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10590d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105910:	f7 d8                	neg    %eax
  105912:	83 d2 00             	adc    $0x0,%edx
  105915:	f7 da                	neg    %edx
  105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10591a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10591d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105924:	e9 a8 00 00 00       	jmp    1059d1 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10592c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105930:	8d 45 14             	lea    0x14(%ebp),%eax
  105933:	89 04 24             	mov    %eax,(%esp)
  105936:	e8 73 fc ff ff       	call   1055ae <getuint>
  10593b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10593e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105941:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105948:	e9 84 00 00 00       	jmp    1059d1 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10594d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105950:	89 44 24 04          	mov    %eax,0x4(%esp)
  105954:	8d 45 14             	lea    0x14(%ebp),%eax
  105957:	89 04 24             	mov    %eax,(%esp)
  10595a:	e8 4f fc ff ff       	call   1055ae <getuint>
  10595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105962:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105965:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10596c:	eb 63                	jmp    1059d1 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  10596e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105971:	89 44 24 04          	mov    %eax,0x4(%esp)
  105975:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10597c:	8b 45 08             	mov    0x8(%ebp),%eax
  10597f:	ff d0                	call   *%eax
            putch('x', putdat);
  105981:	8b 45 0c             	mov    0xc(%ebp),%eax
  105984:	89 44 24 04          	mov    %eax,0x4(%esp)
  105988:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10598f:	8b 45 08             	mov    0x8(%ebp),%eax
  105992:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105994:	8b 45 14             	mov    0x14(%ebp),%eax
  105997:	8d 50 04             	lea    0x4(%eax),%edx
  10599a:	89 55 14             	mov    %edx,0x14(%ebp)
  10599d:	8b 00                	mov    (%eax),%eax
  10599f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1059a9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1059b0:	eb 1f                	jmp    1059d1 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1059b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b9:	8d 45 14             	lea    0x14(%ebp),%eax
  1059bc:	89 04 24             	mov    %eax,(%esp)
  1059bf:	e8 ea fb ff ff       	call   1055ae <getuint>
  1059c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1059ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1059d1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1059d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059d8:	89 54 24 18          	mov    %edx,0x18(%esp)
  1059dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1059df:	89 54 24 14          	mov    %edx,0x14(%esp)
  1059e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  1059e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059f1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ff:	89 04 24             	mov    %eax,(%esp)
  105a02:	e8 a5 fa ff ff       	call   1054ac <printnum>
            break;
  105a07:	eb 38                	jmp    105a41 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a10:	89 1c 24             	mov    %ebx,(%esp)
  105a13:	8b 45 08             	mov    0x8(%ebp),%eax
  105a16:	ff d0                	call   *%eax
            break;
  105a18:	eb 27                	jmp    105a41 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a21:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105a28:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105a2d:	ff 4d 10             	decl   0x10(%ebp)
  105a30:	eb 03                	jmp    105a35 <vprintfmt+0x3c0>
  105a32:	ff 4d 10             	decl   0x10(%ebp)
  105a35:	8b 45 10             	mov    0x10(%ebp),%eax
  105a38:	48                   	dec    %eax
  105a39:	0f b6 00             	movzbl (%eax),%eax
  105a3c:	3c 25                	cmp    $0x25,%al
  105a3e:	75 f2                	jne    105a32 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105a40:	90                   	nop
    while (1) {
  105a41:	e9 37 fc ff ff       	jmp    10567d <vprintfmt+0x8>
                return;
  105a46:	90                   	nop
        }
    }
}
  105a47:	83 c4 40             	add    $0x40,%esp
  105a4a:	5b                   	pop    %ebx
  105a4b:	5e                   	pop    %esi
  105a4c:	5d                   	pop    %ebp
  105a4d:	c3                   	ret    

00105a4e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a4e:	55                   	push   %ebp
  105a4f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a54:	8b 40 08             	mov    0x8(%eax),%eax
  105a57:	8d 50 01             	lea    0x1(%eax),%edx
  105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a5d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a60:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a63:	8b 10                	mov    (%eax),%edx
  105a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a68:	8b 40 04             	mov    0x4(%eax),%eax
  105a6b:	39 c2                	cmp    %eax,%edx
  105a6d:	73 12                	jae    105a81 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a72:	8b 00                	mov    (%eax),%eax
  105a74:	8d 48 01             	lea    0x1(%eax),%ecx
  105a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a7a:	89 0a                	mov    %ecx,(%edx)
  105a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  105a7f:	88 10                	mov    %dl,(%eax)
    }
}
  105a81:	90                   	nop
  105a82:	5d                   	pop    %ebp
  105a83:	c3                   	ret    

00105a84 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a84:	55                   	push   %ebp
  105a85:	89 e5                	mov    %esp,%ebp
  105a87:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  105a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a97:	8b 45 10             	mov    0x10(%ebp),%eax
  105a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa8:	89 04 24             	mov    %eax,(%esp)
  105aab:	e8 0a 00 00 00       	call   105aba <vsnprintf>
  105ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ab6:	89 ec                	mov    %ebp,%esp
  105ab8:	5d                   	pop    %ebp
  105ab9:	c3                   	ret    

00105aba <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105aba:	55                   	push   %ebp
  105abb:	89 e5                	mov    %esp,%ebp
  105abd:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ac9:	8d 50 ff             	lea    -0x1(%eax),%edx
  105acc:	8b 45 08             	mov    0x8(%ebp),%eax
  105acf:	01 d0                	add    %edx,%eax
  105ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ad4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105adb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105adf:	74 0a                	je     105aeb <vsnprintf+0x31>
  105ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ae4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ae7:	39 c2                	cmp    %eax,%edx
  105ae9:	76 07                	jbe    105af2 <vsnprintf+0x38>
        return -E_INVAL;
  105aeb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105af0:	eb 2a                	jmp    105b1c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105af2:	8b 45 14             	mov    0x14(%ebp),%eax
  105af5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105af9:	8b 45 10             	mov    0x10(%ebp),%eax
  105afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b00:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b07:	c7 04 24 4e 5a 10 00 	movl   $0x105a4e,(%esp)
  105b0e:	e8 62 fb ff ff       	call   105675 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b16:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b1c:	89 ec                	mov    %ebp,%esp
  105b1e:	5d                   	pop    %ebp
  105b1f:	c3                   	ret    

00105b20 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105b20:	55                   	push   %ebp
  105b21:	89 e5                	mov    %esp,%ebp
  105b23:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105b2d:	eb 03                	jmp    105b32 <strlen+0x12>
        cnt ++;
  105b2f:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105b32:	8b 45 08             	mov    0x8(%ebp),%eax
  105b35:	8d 50 01             	lea    0x1(%eax),%edx
  105b38:	89 55 08             	mov    %edx,0x8(%ebp)
  105b3b:	0f b6 00             	movzbl (%eax),%eax
  105b3e:	84 c0                	test   %al,%al
  105b40:	75 ed                	jne    105b2f <strlen+0xf>
    }
    return cnt;
  105b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b45:	89 ec                	mov    %ebp,%esp
  105b47:	5d                   	pop    %ebp
  105b48:	c3                   	ret    

00105b49 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b49:	55                   	push   %ebp
  105b4a:	89 e5                	mov    %esp,%ebp
  105b4c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b56:	eb 03                	jmp    105b5b <strnlen+0x12>
        cnt ++;
  105b58:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b61:	73 10                	jae    105b73 <strnlen+0x2a>
  105b63:	8b 45 08             	mov    0x8(%ebp),%eax
  105b66:	8d 50 01             	lea    0x1(%eax),%edx
  105b69:	89 55 08             	mov    %edx,0x8(%ebp)
  105b6c:	0f b6 00             	movzbl (%eax),%eax
  105b6f:	84 c0                	test   %al,%al
  105b71:	75 e5                	jne    105b58 <strnlen+0xf>
    }
    return cnt;
  105b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b76:	89 ec                	mov    %ebp,%esp
  105b78:	5d                   	pop    %ebp
  105b79:	c3                   	ret    

00105b7a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b7a:	55                   	push   %ebp
  105b7b:	89 e5                	mov    %esp,%ebp
  105b7d:	57                   	push   %edi
  105b7e:	56                   	push   %esi
  105b7f:	83 ec 20             	sub    $0x20,%esp
  105b82:	8b 45 08             	mov    0x8(%ebp),%eax
  105b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b94:	89 d1                	mov    %edx,%ecx
  105b96:	89 c2                	mov    %eax,%edx
  105b98:	89 ce                	mov    %ecx,%esi
  105b9a:	89 d7                	mov    %edx,%edi
  105b9c:	ac                   	lods   %ds:(%esi),%al
  105b9d:	aa                   	stos   %al,%es:(%edi)
  105b9e:	84 c0                	test   %al,%al
  105ba0:	75 fa                	jne    105b9c <strcpy+0x22>
  105ba2:	89 fa                	mov    %edi,%edx
  105ba4:	89 f1                	mov    %esi,%ecx
  105ba6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ba9:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105bb2:	83 c4 20             	add    $0x20,%esp
  105bb5:	5e                   	pop    %esi
  105bb6:	5f                   	pop    %edi
  105bb7:	5d                   	pop    %ebp
  105bb8:	c3                   	ret    

00105bb9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105bb9:	55                   	push   %ebp
  105bba:	89 e5                	mov    %esp,%ebp
  105bbc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105bc5:	eb 1e                	jmp    105be5 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bca:	0f b6 10             	movzbl (%eax),%edx
  105bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bd0:	88 10                	mov    %dl,(%eax)
  105bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bd5:	0f b6 00             	movzbl (%eax),%eax
  105bd8:	84 c0                	test   %al,%al
  105bda:	74 03                	je     105bdf <strncpy+0x26>
            src ++;
  105bdc:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105bdf:	ff 45 fc             	incl   -0x4(%ebp)
  105be2:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105be5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105be9:	75 dc                	jne    105bc7 <strncpy+0xe>
    }
    return dst;
  105beb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105bee:	89 ec                	mov    %ebp,%esp
  105bf0:	5d                   	pop    %ebp
  105bf1:	c3                   	ret    

00105bf2 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105bf2:	55                   	push   %ebp
  105bf3:	89 e5                	mov    %esp,%ebp
  105bf5:	57                   	push   %edi
  105bf6:	56                   	push   %esi
  105bf7:	83 ec 20             	sub    $0x20,%esp
  105bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c0c:	89 d1                	mov    %edx,%ecx
  105c0e:	89 c2                	mov    %eax,%edx
  105c10:	89 ce                	mov    %ecx,%esi
  105c12:	89 d7                	mov    %edx,%edi
  105c14:	ac                   	lods   %ds:(%esi),%al
  105c15:	ae                   	scas   %es:(%edi),%al
  105c16:	75 08                	jne    105c20 <strcmp+0x2e>
  105c18:	84 c0                	test   %al,%al
  105c1a:	75 f8                	jne    105c14 <strcmp+0x22>
  105c1c:	31 c0                	xor    %eax,%eax
  105c1e:	eb 04                	jmp    105c24 <strcmp+0x32>
  105c20:	19 c0                	sbb    %eax,%eax
  105c22:	0c 01                	or     $0x1,%al
  105c24:	89 fa                	mov    %edi,%edx
  105c26:	89 f1                	mov    %esi,%ecx
  105c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c2b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105c2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105c34:	83 c4 20             	add    $0x20,%esp
  105c37:	5e                   	pop    %esi
  105c38:	5f                   	pop    %edi
  105c39:	5d                   	pop    %ebp
  105c3a:	c3                   	ret    

00105c3b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105c3b:	55                   	push   %ebp
  105c3c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c3e:	eb 09                	jmp    105c49 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105c40:	ff 4d 10             	decl   0x10(%ebp)
  105c43:	ff 45 08             	incl   0x8(%ebp)
  105c46:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c4d:	74 1a                	je     105c69 <strncmp+0x2e>
  105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c52:	0f b6 00             	movzbl (%eax),%eax
  105c55:	84 c0                	test   %al,%al
  105c57:	74 10                	je     105c69 <strncmp+0x2e>
  105c59:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5c:	0f b6 10             	movzbl (%eax),%edx
  105c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c62:	0f b6 00             	movzbl (%eax),%eax
  105c65:	38 c2                	cmp    %al,%dl
  105c67:	74 d7                	je     105c40 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c6d:	74 18                	je     105c87 <strncmp+0x4c>
  105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c72:	0f b6 00             	movzbl (%eax),%eax
  105c75:	0f b6 d0             	movzbl %al,%edx
  105c78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c7b:	0f b6 00             	movzbl (%eax),%eax
  105c7e:	0f b6 c8             	movzbl %al,%ecx
  105c81:	89 d0                	mov    %edx,%eax
  105c83:	29 c8                	sub    %ecx,%eax
  105c85:	eb 05                	jmp    105c8c <strncmp+0x51>
  105c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c8c:	5d                   	pop    %ebp
  105c8d:	c3                   	ret    

00105c8e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c8e:	55                   	push   %ebp
  105c8f:	89 e5                	mov    %esp,%ebp
  105c91:	83 ec 04             	sub    $0x4,%esp
  105c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c97:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c9a:	eb 13                	jmp    105caf <strchr+0x21>
        if (*s == c) {
  105c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9f:	0f b6 00             	movzbl (%eax),%eax
  105ca2:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105ca5:	75 05                	jne    105cac <strchr+0x1e>
            return (char *)s;
  105ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  105caa:	eb 12                	jmp    105cbe <strchr+0x30>
        }
        s ++;
  105cac:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105caf:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb2:	0f b6 00             	movzbl (%eax),%eax
  105cb5:	84 c0                	test   %al,%al
  105cb7:	75 e3                	jne    105c9c <strchr+0xe>
    }
    return NULL;
  105cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105cbe:	89 ec                	mov    %ebp,%esp
  105cc0:	5d                   	pop    %ebp
  105cc1:	c3                   	ret    

00105cc2 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105cc2:	55                   	push   %ebp
  105cc3:	89 e5                	mov    %esp,%ebp
  105cc5:	83 ec 04             	sub    $0x4,%esp
  105cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105cce:	eb 0e                	jmp    105cde <strfind+0x1c>
        if (*s == c) {
  105cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd3:	0f b6 00             	movzbl (%eax),%eax
  105cd6:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105cd9:	74 0f                	je     105cea <strfind+0x28>
            break;
        }
        s ++;
  105cdb:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105cde:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce1:	0f b6 00             	movzbl (%eax),%eax
  105ce4:	84 c0                	test   %al,%al
  105ce6:	75 e8                	jne    105cd0 <strfind+0xe>
  105ce8:	eb 01                	jmp    105ceb <strfind+0x29>
            break;
  105cea:	90                   	nop
    }
    return (char *)s;
  105ceb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105cee:	89 ec                	mov    %ebp,%esp
  105cf0:	5d                   	pop    %ebp
  105cf1:	c3                   	ret    

00105cf2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105cf2:	55                   	push   %ebp
  105cf3:	89 e5                	mov    %esp,%ebp
  105cf5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105cf8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105d06:	eb 03                	jmp    105d0b <strtol+0x19>
        s ++;
  105d08:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0e:	0f b6 00             	movzbl (%eax),%eax
  105d11:	3c 20                	cmp    $0x20,%al
  105d13:	74 f3                	je     105d08 <strtol+0x16>
  105d15:	8b 45 08             	mov    0x8(%ebp),%eax
  105d18:	0f b6 00             	movzbl (%eax),%eax
  105d1b:	3c 09                	cmp    $0x9,%al
  105d1d:	74 e9                	je     105d08 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d22:	0f b6 00             	movzbl (%eax),%eax
  105d25:	3c 2b                	cmp    $0x2b,%al
  105d27:	75 05                	jne    105d2e <strtol+0x3c>
        s ++;
  105d29:	ff 45 08             	incl   0x8(%ebp)
  105d2c:	eb 14                	jmp    105d42 <strtol+0x50>
    }
    else if (*s == '-') {
  105d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d31:	0f b6 00             	movzbl (%eax),%eax
  105d34:	3c 2d                	cmp    $0x2d,%al
  105d36:	75 0a                	jne    105d42 <strtol+0x50>
        s ++, neg = 1;
  105d38:	ff 45 08             	incl   0x8(%ebp)
  105d3b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d46:	74 06                	je     105d4e <strtol+0x5c>
  105d48:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d4c:	75 22                	jne    105d70 <strtol+0x7e>
  105d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d51:	0f b6 00             	movzbl (%eax),%eax
  105d54:	3c 30                	cmp    $0x30,%al
  105d56:	75 18                	jne    105d70 <strtol+0x7e>
  105d58:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5b:	40                   	inc    %eax
  105d5c:	0f b6 00             	movzbl (%eax),%eax
  105d5f:	3c 78                	cmp    $0x78,%al
  105d61:	75 0d                	jne    105d70 <strtol+0x7e>
        s += 2, base = 16;
  105d63:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d67:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d6e:	eb 29                	jmp    105d99 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d74:	75 16                	jne    105d8c <strtol+0x9a>
  105d76:	8b 45 08             	mov    0x8(%ebp),%eax
  105d79:	0f b6 00             	movzbl (%eax),%eax
  105d7c:	3c 30                	cmp    $0x30,%al
  105d7e:	75 0c                	jne    105d8c <strtol+0x9a>
        s ++, base = 8;
  105d80:	ff 45 08             	incl   0x8(%ebp)
  105d83:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d8a:	eb 0d                	jmp    105d99 <strtol+0xa7>
    }
    else if (base == 0) {
  105d8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d90:	75 07                	jne    105d99 <strtol+0xa7>
        base = 10;
  105d92:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d99:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9c:	0f b6 00             	movzbl (%eax),%eax
  105d9f:	3c 2f                	cmp    $0x2f,%al
  105da1:	7e 1b                	jle    105dbe <strtol+0xcc>
  105da3:	8b 45 08             	mov    0x8(%ebp),%eax
  105da6:	0f b6 00             	movzbl (%eax),%eax
  105da9:	3c 39                	cmp    $0x39,%al
  105dab:	7f 11                	jg     105dbe <strtol+0xcc>
            dig = *s - '0';
  105dad:	8b 45 08             	mov    0x8(%ebp),%eax
  105db0:	0f b6 00             	movzbl (%eax),%eax
  105db3:	0f be c0             	movsbl %al,%eax
  105db6:	83 e8 30             	sub    $0x30,%eax
  105db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105dbc:	eb 48                	jmp    105e06 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc1:	0f b6 00             	movzbl (%eax),%eax
  105dc4:	3c 60                	cmp    $0x60,%al
  105dc6:	7e 1b                	jle    105de3 <strtol+0xf1>
  105dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  105dcb:	0f b6 00             	movzbl (%eax),%eax
  105dce:	3c 7a                	cmp    $0x7a,%al
  105dd0:	7f 11                	jg     105de3 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd5:	0f b6 00             	movzbl (%eax),%eax
  105dd8:	0f be c0             	movsbl %al,%eax
  105ddb:	83 e8 57             	sub    $0x57,%eax
  105dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105de1:	eb 23                	jmp    105e06 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105de3:	8b 45 08             	mov    0x8(%ebp),%eax
  105de6:	0f b6 00             	movzbl (%eax),%eax
  105de9:	3c 40                	cmp    $0x40,%al
  105deb:	7e 3b                	jle    105e28 <strtol+0x136>
  105ded:	8b 45 08             	mov    0x8(%ebp),%eax
  105df0:	0f b6 00             	movzbl (%eax),%eax
  105df3:	3c 5a                	cmp    $0x5a,%al
  105df5:	7f 31                	jg     105e28 <strtol+0x136>
            dig = *s - 'A' + 10;
  105df7:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfa:	0f b6 00             	movzbl (%eax),%eax
  105dfd:	0f be c0             	movsbl %al,%eax
  105e00:	83 e8 37             	sub    $0x37,%eax
  105e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e09:	3b 45 10             	cmp    0x10(%ebp),%eax
  105e0c:	7d 19                	jge    105e27 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105e0e:	ff 45 08             	incl   0x8(%ebp)
  105e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e14:	0f af 45 10          	imul   0x10(%ebp),%eax
  105e18:	89 c2                	mov    %eax,%edx
  105e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105e1d:	01 d0                	add    %edx,%eax
  105e1f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105e22:	e9 72 ff ff ff       	jmp    105d99 <strtol+0xa7>
            break;
  105e27:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105e28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105e2c:	74 08                	je     105e36 <strtol+0x144>
        *endptr = (char *) s;
  105e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e31:	8b 55 08             	mov    0x8(%ebp),%edx
  105e34:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105e36:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105e3a:	74 07                	je     105e43 <strtol+0x151>
  105e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e3f:	f7 d8                	neg    %eax
  105e41:	eb 03                	jmp    105e46 <strtol+0x154>
  105e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e46:	89 ec                	mov    %ebp,%esp
  105e48:	5d                   	pop    %ebp
  105e49:	c3                   	ret    

00105e4a <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e4a:	55                   	push   %ebp
  105e4b:	89 e5                	mov    %esp,%ebp
  105e4d:	83 ec 28             	sub    $0x28,%esp
  105e50:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e56:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e59:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e60:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105e63:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105e66:	8b 45 10             	mov    0x10(%ebp),%eax
  105e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e6c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e6f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e73:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e76:	89 d7                	mov    %edx,%edi
  105e78:	f3 aa                	rep stos %al,%es:(%edi)
  105e7a:	89 fa                	mov    %edi,%edx
  105e7c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e7f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105e88:	89 ec                	mov    %ebp,%esp
  105e8a:	5d                   	pop    %ebp
  105e8b:	c3                   	ret    

00105e8c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e8c:	55                   	push   %ebp
  105e8d:	89 e5                	mov    %esp,%ebp
  105e8f:	57                   	push   %edi
  105e90:	56                   	push   %esi
  105e91:	53                   	push   %ebx
  105e92:	83 ec 30             	sub    $0x30,%esp
  105e95:	8b 45 08             	mov    0x8(%ebp),%eax
  105e98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  105ea4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eaa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105ead:	73 42                	jae    105ef1 <memmove+0x65>
  105eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105eb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ebe:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ec1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ec4:	c1 e8 02             	shr    $0x2,%eax
  105ec7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105ec9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ecf:	89 d7                	mov    %edx,%edi
  105ed1:	89 c6                	mov    %eax,%esi
  105ed3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ed5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105ed8:	83 e1 03             	and    $0x3,%ecx
  105edb:	74 02                	je     105edf <memmove+0x53>
  105edd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105edf:	89 f0                	mov    %esi,%eax
  105ee1:	89 fa                	mov    %edi,%edx
  105ee3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105ee6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ee9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105eef:	eb 36                	jmp    105f27 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ef4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105efa:	01 c2                	add    %eax,%edx
  105efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eff:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f05:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105f0b:	89 c1                	mov    %eax,%ecx
  105f0d:	89 d8                	mov    %ebx,%eax
  105f0f:	89 d6                	mov    %edx,%esi
  105f11:	89 c7                	mov    %eax,%edi
  105f13:	fd                   	std    
  105f14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f16:	fc                   	cld    
  105f17:	89 f8                	mov    %edi,%eax
  105f19:	89 f2                	mov    %esi,%edx
  105f1b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105f1e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105f21:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105f27:	83 c4 30             	add    $0x30,%esp
  105f2a:	5b                   	pop    %ebx
  105f2b:	5e                   	pop    %esi
  105f2c:	5f                   	pop    %edi
  105f2d:	5d                   	pop    %ebp
  105f2e:	c3                   	ret    

00105f2f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105f2f:	55                   	push   %ebp
  105f30:	89 e5                	mov    %esp,%ebp
  105f32:	57                   	push   %edi
  105f33:	56                   	push   %esi
  105f34:	83 ec 20             	sub    $0x20,%esp
  105f37:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f43:	8b 45 10             	mov    0x10(%ebp),%eax
  105f46:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f4c:	c1 e8 02             	shr    $0x2,%eax
  105f4f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f57:	89 d7                	mov    %edx,%edi
  105f59:	89 c6                	mov    %eax,%esi
  105f5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f5d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f60:	83 e1 03             	and    $0x3,%ecx
  105f63:	74 02                	je     105f67 <memcpy+0x38>
  105f65:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f67:	89 f0                	mov    %esi,%eax
  105f69:	89 fa                	mov    %edi,%edx
  105f6b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f71:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f77:	83 c4 20             	add    $0x20,%esp
  105f7a:	5e                   	pop    %esi
  105f7b:	5f                   	pop    %edi
  105f7c:	5d                   	pop    %ebp
  105f7d:	c3                   	ret    

00105f7e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f7e:	55                   	push   %ebp
  105f7f:	89 e5                	mov    %esp,%ebp
  105f81:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f84:	8b 45 08             	mov    0x8(%ebp),%eax
  105f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f90:	eb 2e                	jmp    105fc0 <memcmp+0x42>
        if (*s1 != *s2) {
  105f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f95:	0f b6 10             	movzbl (%eax),%edx
  105f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f9b:	0f b6 00             	movzbl (%eax),%eax
  105f9e:	38 c2                	cmp    %al,%dl
  105fa0:	74 18                	je     105fba <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105fa5:	0f b6 00             	movzbl (%eax),%eax
  105fa8:	0f b6 d0             	movzbl %al,%edx
  105fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105fae:	0f b6 00             	movzbl (%eax),%eax
  105fb1:	0f b6 c8             	movzbl %al,%ecx
  105fb4:	89 d0                	mov    %edx,%eax
  105fb6:	29 c8                	sub    %ecx,%eax
  105fb8:	eb 18                	jmp    105fd2 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105fba:	ff 45 fc             	incl   -0x4(%ebp)
  105fbd:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  105fc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  105fc6:	89 55 10             	mov    %edx,0x10(%ebp)
  105fc9:	85 c0                	test   %eax,%eax
  105fcb:	75 c5                	jne    105f92 <memcmp+0x14>
    }
    return 0;
  105fcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105fd2:	89 ec                	mov    %ebp,%esp
  105fd4:	5d                   	pop    %ebp
  105fd5:	c3                   	ret    
