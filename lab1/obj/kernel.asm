
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100023:	e8 99 34 00 00       	call   1034c1 <memset>

    cons_init();                // init the console
  100028:	e8 b8 15 00 00       	call   1015e5 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 60 36 10 00 	movl   $0x103660,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 7c 36 10 00 	movl   $0x10367c,(%esp)
  100042:	e8 e9 02 00 00       	call   100330 <cprintf>

    print_kerninfo();
  100047:	e8 07 08 00 00       	call   100853 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 95 00 00 00       	call   1000e6 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 c2 2a 00 00       	call   102b18 <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 e5 16 00 00       	call   101740 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 6c 18 00 00       	call   1018cc <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 21 0d 00 00       	call   100d86 <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 34 16 00 00       	call   10169e <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006a:	e8 76 01 00 00       	call   1001e5 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006f:	eb fe                	jmp    10006f <kern_init+0x6f>

00100071 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100071:	55                   	push   %ebp
  100072:	89 e5                	mov    %esp,%ebp
  100074:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100077:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007e:	00 
  10007f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100086:	00 
  100087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008e:	e8 0e 0c 00 00       	call   100ca1 <mon_backtrace>
}
  100093:	90                   	nop
  100094:	89 ec                	mov    %ebp,%esp
  100096:	5d                   	pop    %ebp
  100097:	c3                   	ret    

00100098 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100098:	55                   	push   %ebp
  100099:	89 e5                	mov    %esp,%ebp
  10009b:	83 ec 18             	sub    $0x18,%esp
  10009e:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b0 ff ff ff       	call   100071 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d9:	89 04 24             	mov    %eax,(%esp)
  1000dc:	e8 b7 ff ff ff       	call   100098 <grade_backtrace1>
}
  1000e1:	90                   	nop
  1000e2:	89 ec                	mov    %ebp,%esp
  1000e4:	5d                   	pop    %ebp
  1000e5:	c3                   	ret    

001000e6 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ec:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f1:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f8:	ff 
  1000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100104:	e8 c0 ff ff ff       	call   1000c9 <grade_backtrace0>
}
  100109:	90                   	nop
  10010a:	89 ec                	mov    %ebp,%esp
  10010c:	5d                   	pop    %ebp
  10010d:	c3                   	ret    

0010010e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010e:	55                   	push   %ebp
  10010f:	89 e5                	mov    %esp,%ebp
  100111:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100114:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100117:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100120:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100124:	83 e0 03             	and    $0x3,%eax
  100127:	89 c2                	mov    %eax,%edx
  100129:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10012e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100132:	89 44 24 04          	mov    %eax,0x4(%esp)
  100136:	c7 04 24 81 36 10 00 	movl   $0x103681,(%esp)
  10013d:	e8 ee 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100142:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 8f 36 10 00 	movl   $0x10368f,(%esp)
  10015c:	e8 cf 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100161:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100165:	89 c2                	mov    %eax,%edx
  100167:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10016c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100170:	89 44 24 04          	mov    %eax,0x4(%esp)
  100174:	c7 04 24 9d 36 10 00 	movl   $0x10369d,(%esp)
  10017b:	e8 b0 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	89 c2                	mov    %eax,%edx
  100186:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10018b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100193:	c7 04 24 ab 36 10 00 	movl   $0x1036ab,(%esp)
  10019a:	e8 91 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a3:	89 c2                	mov    %eax,%edx
  1001a5:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b2:	c7 04 24 b9 36 10 00 	movl   $0x1036b9,(%esp)
  1001b9:	e8 72 01 00 00       	call   100330 <cprintf>
    round ++;
  1001be:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001c3:	40                   	inc    %eax
  1001c4:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c9:	90                   	nop
  1001ca:	89 ec                	mov    %ebp,%esp
  1001cc:	5d                   	pop    %ebp
  1001cd:	c3                   	ret    

001001ce <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ce:	55                   	push   %ebp
  1001cf:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001d1:	83 ec 08             	sub    $0x8,%esp
  1001d4:	cd 78                	int    $0x78
  1001d6:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d8:	90                   	nop
  1001d9:	5d                   	pop    %ebp
  1001da:	c3                   	ret    

001001db <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001db:	55                   	push   %ebp
  1001dc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001de:	cd 79                	int    $0x79
  1001e0:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001e2:	90                   	nop
  1001e3:	5d                   	pop    %ebp
  1001e4:	c3                   	ret    

001001e5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e5:	55                   	push   %ebp
  1001e6:	89 e5                	mov    %esp,%ebp
  1001e8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001eb:	e8 1e ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001f0:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  1001f7:	e8 34 01 00 00       	call   100330 <cprintf>
    lab1_switch_to_user();
  1001fc:	e8 cd ff ff ff       	call   1001ce <lab1_switch_to_user>
    lab1_print_cur_status();
  100201:	e8 08 ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100206:	c7 04 24 e8 36 10 00 	movl   $0x1036e8,(%esp)
  10020d:	e8 1e 01 00 00       	call   100330 <cprintf>
    lab1_switch_to_kernel();
  100212:	e8 c4 ff ff ff       	call   1001db <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100217:	e8 f2 fe ff ff       	call   10010e <lab1_print_cur_status>
}
  10021c:	90                   	nop
  10021d:	89 ec                	mov    %ebp,%esp
  10021f:	5d                   	pop    %ebp
  100220:	c3                   	ret    

00100221 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
  100224:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10022b:	74 13                	je     100240 <readline+0x1f>
        cprintf("%s", prompt);
  10022d:	8b 45 08             	mov    0x8(%ebp),%eax
  100230:	89 44 24 04          	mov    %eax,0x4(%esp)
  100234:	c7 04 24 07 37 10 00 	movl   $0x103707,(%esp)
  10023b:	e8 f0 00 00 00       	call   100330 <cprintf>
    }
    int i = 0, c;
  100240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100247:	e8 73 01 00 00       	call   1003bf <getchar>
  10024c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10024f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100253:	79 07                	jns    10025c <readline+0x3b>
            return NULL;
  100255:	b8 00 00 00 00       	mov    $0x0,%eax
  10025a:	eb 78                	jmp    1002d4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10025c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100260:	7e 28                	jle    10028a <readline+0x69>
  100262:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100269:	7f 1f                	jg     10028a <readline+0x69>
            cputchar(c);
  10026b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026e:	89 04 24             	mov    %eax,(%esp)
  100271:	e8 e2 00 00 00       	call   100358 <cputchar>
            buf[i ++] = c;
  100276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100279:	8d 50 01             	lea    0x1(%eax),%edx
  10027c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10027f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100282:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100288:	eb 45                	jmp    1002cf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10028a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10028e:	75 16                	jne    1002a6 <readline+0x85>
  100290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100294:	7e 10                	jle    1002a6 <readline+0x85>
            cputchar(c);
  100296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100299:	89 04 24             	mov    %eax,(%esp)
  10029c:	e8 b7 00 00 00       	call   100358 <cputchar>
            i --;
  1002a1:	ff 4d f4             	decl   -0xc(%ebp)
  1002a4:	eb 29                	jmp    1002cf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002a6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002aa:	74 06                	je     1002b2 <readline+0x91>
  1002ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002b0:	75 95                	jne    100247 <readline+0x26>
            cputchar(c);
  1002b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b5:	89 04 24             	mov    %eax,(%esp)
  1002b8:	e8 9b 00 00 00       	call   100358 <cputchar>
            buf[i] = '\0';
  1002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002c0:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002c5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c8:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002cd:	eb 05                	jmp    1002d4 <readline+0xb3>
        c = getchar();
  1002cf:	e9 73 ff ff ff       	jmp    100247 <readline+0x26>
        }
    }
}
  1002d4:	89 ec                	mov    %ebp,%esp
  1002d6:	5d                   	pop    %ebp
  1002d7:	c3                   	ret    

001002d8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002de:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e1:	89 04 24             	mov    %eax,(%esp)
  1002e4:	e8 2b 13 00 00       	call   101614 <cons_putc>
    (*cnt) ++;
  1002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ec:	8b 00                	mov    (%eax),%eax
  1002ee:	8d 50 01             	lea    0x1(%eax),%edx
  1002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f4:	89 10                	mov    %edx,(%eax)
}
  1002f6:	90                   	nop
  1002f7:	89 ec                	mov    %ebp,%esp
  1002f9:	5d                   	pop    %ebp
  1002fa:	c3                   	ret    

001002fb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002fb:	55                   	push   %ebp
  1002fc:	89 e5                	mov    %esp,%ebp
  1002fe:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100308:	8b 45 0c             	mov    0xc(%ebp),%eax
  10030b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10030f:	8b 45 08             	mov    0x8(%ebp),%eax
  100312:	89 44 24 08          	mov    %eax,0x8(%esp)
  100316:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100319:	89 44 24 04          	mov    %eax,0x4(%esp)
  10031d:	c7 04 24 d8 02 10 00 	movl   $0x1002d8,(%esp)
  100324:	e8 c3 29 00 00       	call   102cec <vprintfmt>
    return cnt;
  100329:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032c:	89 ec                	mov    %ebp,%esp
  10032e:	5d                   	pop    %ebp
  10032f:	c3                   	ret    

00100330 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100330:	55                   	push   %ebp
  100331:	89 e5                	mov    %esp,%ebp
  100333:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100336:	8d 45 0c             	lea    0xc(%ebp),%eax
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10033c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	8b 45 08             	mov    0x8(%ebp),%eax
  100346:	89 04 24             	mov    %eax,(%esp)
  100349:	e8 ad ff ff ff       	call   1002fb <vcprintf>
  10034e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100351:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100354:	89 ec                	mov    %ebp,%esp
  100356:	5d                   	pop    %ebp
  100357:	c3                   	ret    

00100358 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100358:	55                   	push   %ebp
  100359:	89 e5                	mov    %esp,%ebp
  10035b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10035e:	8b 45 08             	mov    0x8(%ebp),%eax
  100361:	89 04 24             	mov    %eax,(%esp)
  100364:	e8 ab 12 00 00       	call   101614 <cons_putc>
}
  100369:	90                   	nop
  10036a:	89 ec                	mov    %ebp,%esp
  10036c:	5d                   	pop    %ebp
  10036d:	c3                   	ret    

0010036e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100374:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10037b:	eb 13                	jmp    100390 <cputs+0x22>
        cputch(c, &cnt);
  10037d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100381:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100384:	89 54 24 04          	mov    %edx,0x4(%esp)
  100388:	89 04 24             	mov    %eax,(%esp)
  10038b:	e8 48 ff ff ff       	call   1002d8 <cputch>
    while ((c = *str ++) != '\0') {
  100390:	8b 45 08             	mov    0x8(%ebp),%eax
  100393:	8d 50 01             	lea    0x1(%eax),%edx
  100396:	89 55 08             	mov    %edx,0x8(%ebp)
  100399:	0f b6 00             	movzbl (%eax),%eax
  10039c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10039f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003a3:	75 d8                	jne    10037d <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003ac:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003b3:	e8 20 ff ff ff       	call   1002d8 <cputch>
    return cnt;
  1003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003bb:	89 ec                	mov    %ebp,%esp
  1003bd:	5d                   	pop    %ebp
  1003be:	c3                   	ret    

001003bf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003bf:	55                   	push   %ebp
  1003c0:	89 e5                	mov    %esp,%ebp
  1003c2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003c5:	90                   	nop
  1003c6:	e8 75 12 00 00       	call   101640 <cons_getc>
  1003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d2:	74 f2                	je     1003c6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003d7:	89 ec                	mov    %ebp,%esp
  1003d9:	5d                   	pop    %ebp
  1003da:	c3                   	ret    

001003db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003db:	55                   	push   %ebp
  1003dc:	89 e5                	mov    %esp,%ebp
  1003de:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e4:	8b 00                	mov    (%eax),%eax
  1003e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ec:	8b 00                	mov    (%eax),%eax
  1003ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003f8:	e9 ca 00 00 00       	jmp    1004c7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100400:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100403:	01 d0                	add    %edx,%eax
  100405:	89 c2                	mov    %eax,%edx
  100407:	c1 ea 1f             	shr    $0x1f,%edx
  10040a:	01 d0                	add    %edx,%eax
  10040c:	d1 f8                	sar    %eax
  10040e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100414:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100417:	eb 03                	jmp    10041c <stab_binsearch+0x41>
            m --;
  100419:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7c 1f                	jl     100443 <stab_binsearch+0x68>
  100424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100427:	89 d0                	mov    %edx,%eax
  100429:	01 c0                	add    %eax,%eax
  10042b:	01 d0                	add    %edx,%eax
  10042d:	c1 e0 02             	shl    $0x2,%eax
  100430:	89 c2                	mov    %eax,%edx
  100432:	8b 45 08             	mov    0x8(%ebp),%eax
  100435:	01 d0                	add    %edx,%eax
  100437:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043b:	0f b6 c0             	movzbl %al,%eax
  10043e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100441:	75 d6                	jne    100419 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100446:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100449:	7d 09                	jge    100454 <stab_binsearch+0x79>
            l = true_m + 1;
  10044b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10044e:	40                   	inc    %eax
  10044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100452:	eb 73                	jmp    1004c7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100454:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10045b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045e:	89 d0                	mov    %edx,%eax
  100460:	01 c0                	add    %eax,%eax
  100462:	01 d0                	add    %edx,%eax
  100464:	c1 e0 02             	shl    $0x2,%eax
  100467:	89 c2                	mov    %eax,%edx
  100469:	8b 45 08             	mov    0x8(%ebp),%eax
  10046c:	01 d0                	add    %edx,%eax
  10046e:	8b 40 08             	mov    0x8(%eax),%eax
  100471:	39 45 18             	cmp    %eax,0x18(%ebp)
  100474:	76 11                	jbe    100487 <stab_binsearch+0xac>
            *region_left = m;
  100476:	8b 45 0c             	mov    0xc(%ebp),%eax
  100479:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10047e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100481:	40                   	inc    %eax
  100482:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100485:	eb 40                	jmp    1004c7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100487:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048a:	89 d0                	mov    %edx,%eax
  10048c:	01 c0                	add    %eax,%eax
  10048e:	01 d0                	add    %edx,%eax
  100490:	c1 e0 02             	shl    $0x2,%eax
  100493:	89 c2                	mov    %eax,%edx
  100495:	8b 45 08             	mov    0x8(%ebp),%eax
  100498:	01 d0                	add    %edx,%eax
  10049a:	8b 40 08             	mov    0x8(%eax),%eax
  10049d:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004a0:	73 14                	jae    1004b6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ab:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	48                   	dec    %eax
  1004b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b4:	eb 11                	jmp    1004c7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bc:	89 10                	mov    %edx,(%eax)
            l = m;
  1004be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004c4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004cd:	0f 8e 2a ff ff ff    	jle    1003fd <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004d7:	75 0f                	jne    1004e8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004dc:	8b 00                	mov    (%eax),%eax
  1004de:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004e6:	eb 3e                	jmp    100526 <stab_binsearch+0x14b>
        l = *region_right;
  1004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004eb:	8b 00                	mov    (%eax),%eax
  1004ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004f0:	eb 03                	jmp    1004f5 <stab_binsearch+0x11a>
  1004f2:	ff 4d fc             	decl   -0x4(%ebp)
  1004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f8:	8b 00                	mov    (%eax),%eax
  1004fa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004fd:	7e 1f                	jle    10051e <stab_binsearch+0x143>
  1004ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100502:	89 d0                	mov    %edx,%eax
  100504:	01 c0                	add    %eax,%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	c1 e0 02             	shl    $0x2,%eax
  10050b:	89 c2                	mov    %eax,%edx
  10050d:	8b 45 08             	mov    0x8(%ebp),%eax
  100510:	01 d0                	add    %edx,%eax
  100512:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100516:	0f b6 c0             	movzbl %al,%eax
  100519:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051c:	75 d4                	jne    1004f2 <stab_binsearch+0x117>
        *region_left = l;
  10051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100524:	89 10                	mov    %edx,(%eax)
}
  100526:	90                   	nop
  100527:	89 ec                	mov    %ebp,%esp
  100529:	5d                   	pop    %ebp
  10052a:	c3                   	ret    

0010052b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10052b:	55                   	push   %ebp
  10052c:	89 e5                	mov    %esp,%ebp
  10052e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100531:	8b 45 0c             	mov    0xc(%ebp),%eax
  100534:	c7 00 0c 37 10 00    	movl   $0x10370c,(%eax)
    info->eip_line = 0;
  10053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 40 08 0c 37 10 00 	movl   $0x10370c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	8b 55 08             	mov    0x8(%ebp),%edx
  10055e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10056b:	c7 45 f4 8c 3f 10 00 	movl   $0x103f8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100572:	c7 45 f0 64 be 10 00 	movl   $0x10be64,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100579:	c7 45 ec 65 be 10 00 	movl   $0x10be65,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100580:	c7 45 e8 f0 e7 10 00 	movl   $0x10e7f0,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10058a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10058d:	76 0b                	jbe    10059a <debuginfo_eip+0x6f>
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	48                   	dec    %eax
  100593:	0f b6 00             	movzbl (%eax),%eax
  100596:	84 c0                	test   %al,%al
  100598:	74 0a                	je     1005a4 <debuginfo_eip+0x79>
        return -1;
  10059a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10059f:	e9 ab 02 00 00       	jmp    10084f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005b1:	c1 f8 02             	sar    $0x2,%eax
  1005b4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ba:	48                   	dec    %eax
  1005bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005be:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005c5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005cc:	00 
  1005cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005de:	89 04 24             	mov    %eax,(%esp)
  1005e1:	e8 f5 fd ff ff       	call   1003db <stab_binsearch>
    if (lfile == 0)
  1005e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e9:	85 c0                	test   %eax,%eax
  1005eb:	75 0a                	jne    1005f7 <debuginfo_eip+0xcc>
        return -1;
  1005ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005f2:	e9 58 02 00 00       	jmp    10084f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100600:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100603:	8b 45 08             	mov    0x8(%ebp),%eax
  100606:	89 44 24 10          	mov    %eax,0x10(%esp)
  10060a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100611:	00 
  100612:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100615:	89 44 24 08          	mov    %eax,0x8(%esp)
  100619:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10061c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100623:	89 04 24             	mov    %eax,(%esp)
  100626:	e8 b0 fd ff ff       	call   1003db <stab_binsearch>

    if (lfun <= rfun) {
  10062b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10062e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100631:	39 c2                	cmp    %eax,%edx
  100633:	7f 78                	jg     1006ad <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100638:	89 c2                	mov    %eax,%edx
  10063a:	89 d0                	mov    %edx,%eax
  10063c:	01 c0                	add    %eax,%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	c1 e0 02             	shl    $0x2,%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100648:	01 d0                	add    %edx,%eax
  10064a:	8b 10                	mov    (%eax),%edx
  10064c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100652:	39 c2                	cmp    %eax,%edx
  100654:	73 22                	jae    100678 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100656:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100659:	89 c2                	mov    %eax,%edx
  10065b:	89 d0                	mov    %edx,%eax
  10065d:	01 c0                	add    %eax,%eax
  10065f:	01 d0                	add    %edx,%eax
  100661:	c1 e0 02             	shl    $0x2,%eax
  100664:	89 c2                	mov    %eax,%edx
  100666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100669:	01 d0                	add    %edx,%eax
  10066b:	8b 10                	mov    (%eax),%edx
  10066d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100670:	01 c2                	add    %eax,%edx
  100672:	8b 45 0c             	mov    0xc(%ebp),%eax
  100675:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067b:	89 c2                	mov    %eax,%edx
  10067d:	89 d0                	mov    %edx,%eax
  10067f:	01 c0                	add    %eax,%eax
  100681:	01 d0                	add    %edx,%eax
  100683:	c1 e0 02             	shl    $0x2,%eax
  100686:	89 c2                	mov    %eax,%edx
  100688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068b:	01 d0                	add    %edx,%eax
  10068d:	8b 50 08             	mov    0x8(%eax),%edx
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100696:	8b 45 0c             	mov    0xc(%ebp),%eax
  100699:	8b 40 10             	mov    0x10(%eax),%eax
  10069c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10069f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006ab:	eb 15                	jmp    1006c2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c5:	8b 40 08             	mov    0x8(%eax),%eax
  1006c8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006cf:	00 
  1006d0:	89 04 24             	mov    %eax,(%esp)
  1006d3:	e8 61 2c 00 00       	call   103339 <strfind>
  1006d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006db:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006de:	29 c8                	sub    %ecx,%eax
  1006e0:	89 c2                	mov    %eax,%edx
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ef:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f6:	00 
  1006f7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006fe:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100701:	89 44 24 04          	mov    %eax,0x4(%esp)
  100705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100708:	89 04 24             	mov    %eax,(%esp)
  10070b:	e8 cb fc ff ff       	call   1003db <stab_binsearch>
    if (lline <= rline) {
  100710:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100713:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100716:	39 c2                	cmp    %eax,%edx
  100718:	7f 23                	jg     10073d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10071a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10071d:	89 c2                	mov    %eax,%edx
  10071f:	89 d0                	mov    %edx,%eax
  100721:	01 c0                	add    %eax,%eax
  100723:	01 d0                	add    %edx,%eax
  100725:	c1 e0 02             	shl    $0x2,%eax
  100728:	89 c2                	mov    %eax,%edx
  10072a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072d:	01 d0                	add    %edx,%eax
  10072f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100733:	89 c2                	mov    %eax,%edx
  100735:	8b 45 0c             	mov    0xc(%ebp),%eax
  100738:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	eb 11                	jmp    10074e <debuginfo_eip+0x223>
        return -1;
  10073d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100742:	e9 08 01 00 00       	jmp    10084f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100747:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074a:	48                   	dec    %eax
  10074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10074e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100754:	39 c2                	cmp    %eax,%edx
  100756:	7c 56                	jl     1007ae <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075b:	89 c2                	mov    %eax,%edx
  10075d:	89 d0                	mov    %edx,%eax
  10075f:	01 c0                	add    %eax,%eax
  100761:	01 d0                	add    %edx,%eax
  100763:	c1 e0 02             	shl    $0x2,%eax
  100766:	89 c2                	mov    %eax,%edx
  100768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100771:	3c 84                	cmp    $0x84,%al
  100773:	74 39                	je     1007ae <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100775:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100778:	89 c2                	mov    %eax,%edx
  10077a:	89 d0                	mov    %edx,%eax
  10077c:	01 c0                	add    %eax,%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	c1 e0 02             	shl    $0x2,%eax
  100783:	89 c2                	mov    %eax,%edx
  100785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078e:	3c 64                	cmp    $0x64,%al
  100790:	75 b5                	jne    100747 <debuginfo_eip+0x21c>
  100792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100795:	89 c2                	mov    %eax,%edx
  100797:	89 d0                	mov    %edx,%eax
  100799:	01 c0                	add    %eax,%eax
  10079b:	01 d0                	add    %edx,%eax
  10079d:	c1 e0 02             	shl    $0x2,%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	8b 40 08             	mov    0x8(%eax),%eax
  1007aa:	85 c0                	test   %eax,%eax
  1007ac:	74 99                	je     100747 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b4:	39 c2                	cmp    %eax,%edx
  1007b6:	7c 42                	jl     1007fa <debuginfo_eip+0x2cf>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 10                	mov    (%eax),%edx
  1007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007d5:	39 c2                	cmp    %eax,%edx
  1007d7:	73 21                	jae    1007fa <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dc:	89 c2                	mov    %eax,%edx
  1007de:	89 d0                	mov    %edx,%eax
  1007e0:	01 c0                	add    %eax,%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	c1 e0 02             	shl    $0x2,%eax
  1007e7:	89 c2                	mov    %eax,%edx
  1007e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	8b 10                	mov    (%eax),%edx
  1007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f3:	01 c2                	add    %eax,%edx
  1007f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100800:	39 c2                	cmp    %eax,%edx
  100802:	7d 46                	jge    10084a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100804:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100807:	40                   	inc    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080b:	eb 16                	jmp    100823 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100810:	8b 40 14             	mov    0x14(%eax),%eax
  100813:	8d 50 01             	lea    0x1(%eax),%edx
  100816:	8b 45 0c             	mov    0xc(%ebp),%eax
  100819:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10081c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081f:	40                   	inc    %eax
  100820:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100826:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100829:	39 c2                	cmp    %eax,%edx
  10082b:	7d 1d                	jge    10084a <debuginfo_eip+0x31f>
  10082d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	89 d0                	mov    %edx,%eax
  100834:	01 c0                	add    %eax,%eax
  100836:	01 d0                	add    %edx,%eax
  100838:	c1 e0 02             	shl    $0x2,%eax
  10083b:	89 c2                	mov    %eax,%edx
  10083d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100840:	01 d0                	add    %edx,%eax
  100842:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100846:	3c a0                	cmp    $0xa0,%al
  100848:	74 c3                	je     10080d <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10084a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10084f:	89 ec                	mov    %ebp,%esp
  100851:	5d                   	pop    %ebp
  100852:	c3                   	ret    

00100853 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100853:	55                   	push   %ebp
  100854:	89 e5                	mov    %esp,%ebp
  100856:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100859:	c7 04 24 16 37 10 00 	movl   $0x103716,(%esp)
  100860:	e8 cb fa ff ff       	call   100330 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100865:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086c:	00 
  10086d:	c7 04 24 2f 37 10 00 	movl   $0x10372f,(%esp)
  100874:	e8 b7 fa ff ff       	call   100330 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100879:	c7 44 24 04 4d 36 10 	movl   $0x10364d,0x4(%esp)
  100880:	00 
  100881:	c7 04 24 47 37 10 00 	movl   $0x103747,(%esp)
  100888:	e8 a3 fa ff ff       	call   100330 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10088d:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100894:	00 
  100895:	c7 04 24 5f 37 10 00 	movl   $0x10375f,(%esp)
  10089c:	e8 8f fa ff ff       	call   100330 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a1:	c7 44 24 04 68 0d 11 	movl   $0x110d68,0x4(%esp)
  1008a8:	00 
  1008a9:	c7 04 24 77 37 10 00 	movl   $0x103777,(%esp)
  1008b0:	e8 7b fa ff ff       	call   100330 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b5:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  1008ba:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008bf:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008c4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ca:	85 c0                	test   %eax,%eax
  1008cc:	0f 48 c2             	cmovs  %edx,%eax
  1008cf:	c1 f8 0a             	sar    $0xa,%eax
  1008d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d6:	c7 04 24 90 37 10 00 	movl   $0x103790,(%esp)
  1008dd:	e8 4e fa ff ff       	call   100330 <cprintf>
}
  1008e2:	90                   	nop
  1008e3:	89 ec                	mov    %ebp,%esp
  1008e5:	5d                   	pop    %ebp
  1008e6:	c3                   	ret    

001008e7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e7:	55                   	push   %ebp
  1008e8:	89 e5                	mov    %esp,%ebp
  1008ea:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fa:	89 04 24             	mov    %eax,(%esp)
  1008fd:	e8 29 fc ff ff       	call   10052b <debuginfo_eip>
  100902:	85 c0                	test   %eax,%eax
  100904:	74 15                	je     10091b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100906:	8b 45 08             	mov    0x8(%ebp),%eax
  100909:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090d:	c7 04 24 ba 37 10 00 	movl   $0x1037ba,(%esp)
  100914:	e8 17 fa ff ff       	call   100330 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100919:	eb 6c                	jmp    100987 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100922:	eb 1b                	jmp    10093f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100924:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092a:	01 d0                	add    %edx,%eax
  10092c:	0f b6 10             	movzbl (%eax),%edx
  10092f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100938:	01 c8                	add    %ecx,%eax
  10093a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093c:	ff 45 f4             	incl   -0xc(%ebp)
  10093f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100942:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100945:	7c dd                	jl     100924 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100947:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100955:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100958:	8b 45 08             	mov    0x8(%ebp),%eax
  10095b:	29 d0                	sub    %edx,%eax
  10095d:	89 c1                	mov    %eax,%ecx
  10095f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100962:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100965:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100969:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100973:	89 54 24 08          	mov    %edx,0x8(%esp)
  100977:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097b:	c7 04 24 d6 37 10 00 	movl   $0x1037d6,(%esp)
  100982:	e8 a9 f9 ff ff       	call   100330 <cprintf>
}
  100987:	90                   	nop
  100988:	89 ec                	mov    %ebp,%esp
  10098a:	5d                   	pop    %ebp
  10098b:	c3                   	ret    

0010098c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098c:	55                   	push   %ebp
  10098d:	89 e5                	mov    %esp,%ebp
  10098f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100992:	8b 45 04             	mov    0x4(%ebp),%eax
  100995:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100998:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099b:	89 ec                	mov    %ebp,%esp
  10099d:	5d                   	pop    %ebp
  10099e:	c3                   	ret    

0010099f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10099f:	55                   	push   %ebp
  1009a0:	89 e5                	mov    %esp,%ebp
  1009a2:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a5:	89 e8                	mov    %ebp,%eax
  1009a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *                   the calling funciton's ebp = ss:[ebp]
      */
      //(1) call read_ebp() to get the value of ebp. the type is (uint32_t);
      //(2) call read_eip() to get the value of eip. the type is (uint32_t);
      //读取ebp eip的值
      uint32_t ebp = read_ebp(), eip = read_eip();
  1009ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009b0:	e8 d7 ff ff ff       	call   10098c <read_eip>
  1009b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      
      int i, j;
      //从栈底开始循环，STACKFRAME_DEPTH是栈帧的深度
      for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009bf:	e9 84 00 00 00       	jmp    100a48 <print_stackframe+0xa9>
              //以16进制输出ebp eip,占8位，不足的左侧补0填补。ebp,eip为32位寄存器，打印出ebp eip的值
              cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d2:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  1009d9:	e8 52 f9 ff ff       	call   100330 <cprintf>
              //args代表的是栈帧中ebp下方的参数 被保存的一些原函数的值
              uint32_t *args = (uint32_t *)ebp + 2;//
  1009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e1:	83 c0 08             	add    $0x8,%eax
  1009e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
              //输出参数地址
              for (j = 0; j < 4; j ++) {
  1009e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009ee:	eb 24                	jmp    100a14 <print_stackframe+0x75>
                  cprintf("0x%08x ", args[j]);//打印ebp之后的四个参数
  1009f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009fd:	01 d0                	add    %edx,%eax
  1009ff:	8b 00                	mov    (%eax),%eax
  100a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a05:	c7 04 24 04 38 10 00 	movl   $0x103804,(%esp)
  100a0c:	e8 1f f9 ff ff       	call   100330 <cprintf>
              for (j = 0; j < 4; j ++) {
  100a11:	ff 45 e8             	incl   -0x18(%ebp)
  100a14:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a18:	7e d6                	jle    1009f0 <print_stackframe+0x51>
              }
              cprintf("\n");
  100a1a:	c7 04 24 0c 38 10 00 	movl   $0x10380c,(%esp)
  100a21:	e8 0a f9 ff ff       	call   100330 <cprintf>
              print_debuginfo(eip - 1);
  100a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a29:	48                   	dec    %eax
  100a2a:	89 04 24             	mov    %eax,(%esp)
  100a2d:	e8 b5 fe ff ff       	call   1008e7 <print_debuginfo>
              eip = ((uint32_t *)ebp)[1];//ebp[1] ebp的下一位，指向的是返回地址，即eip的迭代
  100a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a35:	83 c0 04             	add    $0x4,%eax
  100a38:	8b 00                	mov    (%eax),%eax
  100a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
              ebp = ((uint32_t *)ebp)[0];//ebp[0] 即ebp的所指向的旧的ebp的值
  100a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a40:	8b 00                	mov    (%eax),%eax
  100a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
      for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a45:	ff 45 ec             	incl   -0x14(%ebp)
  100a48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a4c:	74 0a                	je     100a58 <print_stackframe+0xb9>
  100a4e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a52:	0f 8e 6c ff ff ff    	jle    1009c4 <print_stackframe+0x25>

      }
}
  100a58:	90                   	nop
  100a59:	89 ec                	mov    %ebp,%esp
  100a5b:	5d                   	pop    %ebp
  100a5c:	c3                   	ret    

00100a5d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6a:	eb 0c                	jmp    100a78 <parse+0x1b>
            *buf ++ = '\0';
  100a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6f:	8d 50 01             	lea    0x1(%eax),%edx
  100a72:	89 55 08             	mov    %edx,0x8(%ebp)
  100a75:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a78:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7b:	0f b6 00             	movzbl (%eax),%eax
  100a7e:	84 c0                	test   %al,%al
  100a80:	74 1d                	je     100a9f <parse+0x42>
  100a82:	8b 45 08             	mov    0x8(%ebp),%eax
  100a85:	0f b6 00             	movzbl (%eax),%eax
  100a88:	0f be c0             	movsbl %al,%eax
  100a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8f:	c7 04 24 90 38 10 00 	movl   $0x103890,(%esp)
  100a96:	e8 6a 28 00 00       	call   103305 <strchr>
  100a9b:	85 c0                	test   %eax,%eax
  100a9d:	75 cd                	jne    100a6c <parse+0xf>
        }
        if (*buf == '\0') {
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	0f b6 00             	movzbl (%eax),%eax
  100aa5:	84 c0                	test   %al,%al
  100aa7:	74 65                	je     100b0e <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aad:	75 14                	jne    100ac3 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aaf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab6:	00 
  100ab7:	c7 04 24 95 38 10 00 	movl   $0x103895,(%esp)
  100abe:	e8 6d f8 ff ff       	call   100330 <cprintf>
        }
        argv[argc ++] = buf;
  100ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac6:	8d 50 01             	lea    0x1(%eax),%edx
  100ac9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100acc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad6:	01 c2                	add    %eax,%edx
  100ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  100adb:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100add:	eb 03                	jmp    100ae2 <parse+0x85>
            buf ++;
  100adf:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae5:	0f b6 00             	movzbl (%eax),%eax
  100ae8:	84 c0                	test   %al,%al
  100aea:	74 8c                	je     100a78 <parse+0x1b>
  100aec:	8b 45 08             	mov    0x8(%ebp),%eax
  100aef:	0f b6 00             	movzbl (%eax),%eax
  100af2:	0f be c0             	movsbl %al,%eax
  100af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af9:	c7 04 24 90 38 10 00 	movl   $0x103890,(%esp)
  100b00:	e8 00 28 00 00       	call   103305 <strchr>
  100b05:	85 c0                	test   %eax,%eax
  100b07:	74 d6                	je     100adf <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b09:	e9 6a ff ff ff       	jmp    100a78 <parse+0x1b>
            break;
  100b0e:	90                   	nop
        }
    }
    return argc;
  100b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b12:	89 ec                	mov    %ebp,%esp
  100b14:	5d                   	pop    %ebp
  100b15:	c3                   	ret    

00100b16 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b16:	55                   	push   %ebp
  100b17:	89 e5                	mov    %esp,%ebp
  100b19:	83 ec 68             	sub    $0x68,%esp
  100b1c:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b26:	8b 45 08             	mov    0x8(%ebp),%eax
  100b29:	89 04 24             	mov    %eax,(%esp)
  100b2c:	e8 2c ff ff ff       	call   100a5d <parse>
  100b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b38:	75 0a                	jne    100b44 <runcmd+0x2e>
        return 0;
  100b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3f:	e9 83 00 00 00       	jmp    100bc7 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b4b:	eb 5a                	jmp    100ba7 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b4d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b50:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b53:	89 c8                	mov    %ecx,%eax
  100b55:	01 c0                	add    %eax,%eax
  100b57:	01 c8                	add    %ecx,%eax
  100b59:	c1 e0 02             	shl    $0x2,%eax
  100b5c:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b61:	8b 00                	mov    (%eax),%eax
  100b63:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b67:	89 04 24             	mov    %eax,(%esp)
  100b6a:	e8 fa 26 00 00       	call   103269 <strcmp>
  100b6f:	85 c0                	test   %eax,%eax
  100b71:	75 31                	jne    100ba4 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b76:	89 d0                	mov    %edx,%eax
  100b78:	01 c0                	add    %eax,%eax
  100b7a:	01 d0                	add    %edx,%eax
  100b7c:	c1 e0 02             	shl    $0x2,%eax
  100b7f:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b84:	8b 10                	mov    (%eax),%edx
  100b86:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b89:	83 c0 04             	add    $0x4,%eax
  100b8c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b8f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100b95:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9d:	89 1c 24             	mov    %ebx,(%esp)
  100ba0:	ff d2                	call   *%edx
  100ba2:	eb 23                	jmp    100bc7 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba4:	ff 45 f4             	incl   -0xc(%ebp)
  100ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100baa:	83 f8 02             	cmp    $0x2,%eax
  100bad:	76 9e                	jbe    100b4d <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100baf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb6:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  100bbd:	e8 6e f7 ff ff       	call   100330 <cprintf>
    return 0;
  100bc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bca:	89 ec                	mov    %ebp,%esp
  100bcc:	5d                   	pop    %ebp
  100bcd:	c3                   	ret    

00100bce <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bce:	55                   	push   %ebp
  100bcf:	89 e5                	mov    %esp,%ebp
  100bd1:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd4:	c7 04 24 cc 38 10 00 	movl   $0x1038cc,(%esp)
  100bdb:	e8 50 f7 ff ff       	call   100330 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100be0:	c7 04 24 f4 38 10 00 	movl   $0x1038f4,(%esp)
  100be7:	e8 44 f7 ff ff       	call   100330 <cprintf>

    if (tf != NULL) {
  100bec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bf0:	74 0b                	je     100bfd <kmonitor+0x2f>
        print_trapframe(tf);
  100bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf5:	89 04 24             	mov    %eax,(%esp)
  100bf8:	e8 8a 0e 00 00       	call   101a87 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bfd:	c7 04 24 19 39 10 00 	movl   $0x103919,(%esp)
  100c04:	e8 18 f6 ff ff       	call   100221 <readline>
  100c09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c10:	74 eb                	je     100bfd <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c12:	8b 45 08             	mov    0x8(%ebp),%eax
  100c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c1c:	89 04 24             	mov    %eax,(%esp)
  100c1f:	e8 f2 fe ff ff       	call   100b16 <runcmd>
  100c24:	85 c0                	test   %eax,%eax
  100c26:	78 02                	js     100c2a <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c28:	eb d3                	jmp    100bfd <kmonitor+0x2f>
                break;
  100c2a:	90                   	nop
            }
        }
    }
}
  100c2b:	90                   	nop
  100c2c:	89 ec                	mov    %ebp,%esp
  100c2e:	5d                   	pop    %ebp
  100c2f:	c3                   	ret    

00100c30 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c30:	55                   	push   %ebp
  100c31:	89 e5                	mov    %esp,%ebp
  100c33:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c3d:	eb 3d                	jmp    100c7c <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c42:	89 d0                	mov    %edx,%eax
  100c44:	01 c0                	add    %eax,%eax
  100c46:	01 d0                	add    %edx,%eax
  100c48:	c1 e0 02             	shl    $0x2,%eax
  100c4b:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c50:	8b 10                	mov    (%eax),%edx
  100c52:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c55:	89 c8                	mov    %ecx,%eax
  100c57:	01 c0                	add    %eax,%eax
  100c59:	01 c8                	add    %ecx,%eax
  100c5b:	c1 e0 02             	shl    $0x2,%eax
  100c5e:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c63:	8b 00                	mov    (%eax),%eax
  100c65:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c69:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c6d:	c7 04 24 1d 39 10 00 	movl   $0x10391d,(%esp)
  100c74:	e8 b7 f6 ff ff       	call   100330 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c79:	ff 45 f4             	incl   -0xc(%ebp)
  100c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7f:	83 f8 02             	cmp    $0x2,%eax
  100c82:	76 bb                	jbe    100c3f <mon_help+0xf>
    }
    return 0;
  100c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c89:	89 ec                	mov    %ebp,%esp
  100c8b:	5d                   	pop    %ebp
  100c8c:	c3                   	ret    

00100c8d <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c8d:	55                   	push   %ebp
  100c8e:	89 e5                	mov    %esp,%ebp
  100c90:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c93:	e8 bb fb ff ff       	call   100853 <print_kerninfo>
    return 0;
  100c98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9d:	89 ec                	mov    %ebp,%esp
  100c9f:	5d                   	pop    %ebp
  100ca0:	c3                   	ret    

00100ca1 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ca1:	55                   	push   %ebp
  100ca2:	89 e5                	mov    %esp,%ebp
  100ca4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca7:	e8 f3 fc ff ff       	call   10099f <print_stackframe>
    return 0;
  100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb1:	89 ec                	mov    %ebp,%esp
  100cb3:	5d                   	pop    %ebp
  100cb4:	c3                   	ret    

00100cb5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cb5:	55                   	push   %ebp
  100cb6:	89 e5                	mov    %esp,%ebp
  100cb8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cbb:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100cc0:	85 c0                	test   %eax,%eax
  100cc2:	75 5b                	jne    100d1f <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cc4:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100ccb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cce:	8d 45 14             	lea    0x14(%ebp),%eax
  100cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce2:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  100ce9:	e8 42 f6 ff ff       	call   100330 <cprintf>
    vcprintf(fmt, ap);
  100cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf8:	89 04 24             	mov    %eax,(%esp)
  100cfb:	e8 fb f5 ff ff       	call   1002fb <vcprintf>
    cprintf("\n");
  100d00:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100d07:	e8 24 f6 ff ff       	call   100330 <cprintf>
    
    cprintf("stack trackback:\n");
  100d0c:	c7 04 24 44 39 10 00 	movl   $0x103944,(%esp)
  100d13:	e8 18 f6 ff ff       	call   100330 <cprintf>
    print_stackframe();
  100d18:	e8 82 fc ff ff       	call   10099f <print_stackframe>
  100d1d:	eb 01                	jmp    100d20 <__panic+0x6b>
        goto panic_dead;
  100d1f:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d20:	e8 81 09 00 00       	call   1016a6 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2c:	e8 9d fe ff ff       	call   100bce <kmonitor>
  100d31:	eb f2                	jmp    100d25 <__panic+0x70>

00100d33 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d33:	55                   	push   %ebp
  100d34:	89 e5                	mov    %esp,%ebp
  100d36:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d39:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d42:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d46:	8b 45 08             	mov    0x8(%ebp),%eax
  100d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4d:	c7 04 24 56 39 10 00 	movl   $0x103956,(%esp)
  100d54:	e8 d7 f5 ff ff       	call   100330 <cprintf>
    vcprintf(fmt, ap);
  100d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d60:	8b 45 10             	mov    0x10(%ebp),%eax
  100d63:	89 04 24             	mov    %eax,(%esp)
  100d66:	e8 90 f5 ff ff       	call   1002fb <vcprintf>
    cprintf("\n");
  100d6b:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100d72:	e8 b9 f5 ff ff       	call   100330 <cprintf>
    va_end(ap);
}
  100d77:	90                   	nop
  100d78:	89 ec                	mov    %ebp,%esp
  100d7a:	5d                   	pop    %ebp
  100d7b:	c3                   	ret    

00100d7c <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7c:	55                   	push   %ebp
  100d7d:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7f:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d84:	5d                   	pop    %ebp
  100d85:	c3                   	ret    

00100d86 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d86:	55                   	push   %ebp
  100d87:	89 e5                	mov    %esp,%ebp
  100d89:	83 ec 28             	sub    $0x28,%esp
  100d8c:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d92:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d96:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d9a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d9e:	ee                   	out    %al,(%dx)
}
  100d9f:	90                   	nop
  100da0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100daa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dae:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db2:	ee                   	out    %al,(%dx)
}
  100db3:	90                   	nop
  100db4:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dba:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dbe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dc2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc6:	ee                   	out    %al,(%dx)
}
  100dc7:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc8:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd2:	c7 04 24 74 39 10 00 	movl   $0x103974,(%esp)
  100dd9:	e8 52 f5 ff ff       	call   100330 <cprintf>
    pic_enable(IRQ_TIMER);
  100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de5:	e8 21 09 00 00       	call   10170b <pic_enable>
}
  100dea:	90                   	nop
  100deb:	89 ec                	mov    %ebp,%esp
  100ded:	5d                   	pop    %ebp
  100dee:	c3                   	ret    

00100def <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100def:	55                   	push   %ebp
  100df0:	89 e5                	mov    %esp,%ebp
  100df2:	83 ec 10             	sub    $0x10,%esp
  100df5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dfb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dff:	89 c2                	mov    %eax,%edx
  100e01:	ec                   	in     (%dx),%al
  100e02:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e05:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e0b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0f:	89 c2                	mov    %eax,%edx
  100e11:	ec                   	in     (%dx),%al
  100e12:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e15:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e1b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e1f:	89 c2                	mov    %eax,%edx
  100e21:	ec                   	in     (%dx),%al
  100e22:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e25:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e2b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e2f:	89 c2                	mov    %eax,%edx
  100e31:	ec                   	in     (%dx),%al
  100e32:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e35:	90                   	nop
  100e36:	89 ec                	mov    %ebp,%esp
  100e38:	5d                   	pop    %ebp
  100e39:	c3                   	ret    

00100e3a <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e3a:	55                   	push   %ebp
  100e3b:	89 e5                	mov    %esp,%ebp
  100e3d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e40:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4a:	0f b7 00             	movzwl (%eax),%eax
  100e4d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e54:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5c:	0f b7 00             	movzwl (%eax),%eax
  100e5f:	0f b7 c0             	movzwl %ax,%eax
  100e62:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e67:	74 12                	je     100e7b <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e69:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e70:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e77:	b4 03 
  100e79:	eb 13                	jmp    100e8e <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e82:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e85:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e8c:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e8e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e95:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e99:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ea1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ea5:	ee                   	out    %al,(%dx)
}
  100ea6:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ea7:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eae:	40                   	inc    %eax
  100eaf:	0f b7 c0             	movzwl %ax,%eax
  100eb2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100eba:	89 c2                	mov    %eax,%edx
  100ebc:	ec                   	in     (%dx),%al
  100ebd:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ec0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec4:	0f b6 c0             	movzbl %al,%eax
  100ec7:	c1 e0 08             	shl    $0x8,%eax
  100eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ecd:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ed4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ed8:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100edc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ee0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ee4:	ee                   	out    %al,(%dx)
}
  100ee5:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ee6:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eed:	40                   	inc    %eax
  100eee:	0f b7 c0             	movzwl %ax,%eax
  100ef1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ef9:	89 c2                	mov    %eax,%edx
  100efb:	ec                   	in     (%dx),%al
  100efc:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eff:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f03:	0f b6 c0             	movzbl %al,%eax
  100f06:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0c:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f14:	0f b7 c0             	movzwl %ax,%eax
  100f17:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f1d:	90                   	nop
  100f1e:	89 ec                	mov    %ebp,%esp
  100f20:	5d                   	pop    %ebp
  100f21:	c3                   	ret    

00100f22 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f22:	55                   	push   %ebp
  100f23:	89 e5                	mov    %esp,%ebp
  100f25:	83 ec 48             	sub    $0x48,%esp
  100f28:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f2e:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f32:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f36:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
}
  100f3b:	90                   	nop
  100f3c:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f42:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f46:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f4a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f4e:	ee                   	out    %al,(%dx)
}
  100f4f:	90                   	nop
  100f50:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f56:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f5a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f5e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f62:	ee                   	out    %al,(%dx)
}
  100f63:	90                   	nop
  100f64:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f6a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f6e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f72:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f76:	ee                   	out    %al,(%dx)
}
  100f77:	90                   	nop
  100f78:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f7e:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f82:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f86:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f8a:	ee                   	out    %al,(%dx)
}
  100f8b:	90                   	nop
  100f8c:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f92:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f96:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f9a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f9e:	ee                   	out    %al,(%dx)
}
  100f9f:	90                   	nop
  100fa0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa6:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100faa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb2:	ee                   	out    %al,(%dx)
}
  100fb3:	90                   	nop
  100fb4:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fba:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fbe:	89 c2                	mov    %eax,%edx
  100fc0:	ec                   	in     (%dx),%al
  100fc1:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fc4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc8:	3c ff                	cmp    $0xff,%al
  100fca:	0f 95 c0             	setne  %al
  100fcd:	0f b6 c0             	movzbl %al,%eax
  100fd0:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fd5:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fdb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fe5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100feb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fef:	89 c2                	mov    %eax,%edx
  100ff1:	ec                   	in     (%dx),%al
  100ff2:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff5:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100ffa:	85 c0                	test   %eax,%eax
  100ffc:	74 0c                	je     10100a <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  100ffe:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101005:	e8 01 07 00 00       	call   10170b <pic_enable>
    }
}
  10100a:	90                   	nop
  10100b:	89 ec                	mov    %ebp,%esp
  10100d:	5d                   	pop    %ebp
  10100e:	c3                   	ret    

0010100f <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10100f:	55                   	push   %ebp
  101010:	89 e5                	mov    %esp,%ebp
  101012:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101015:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10101c:	eb 08                	jmp    101026 <lpt_putc_sub+0x17>
        delay();
  10101e:	e8 cc fd ff ff       	call   100def <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101023:	ff 45 fc             	incl   -0x4(%ebp)
  101026:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10102c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101030:	89 c2                	mov    %eax,%edx
  101032:	ec                   	in     (%dx),%al
  101033:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101036:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10103a:	84 c0                	test   %al,%al
  10103c:	78 09                	js     101047 <lpt_putc_sub+0x38>
  10103e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101045:	7e d7                	jle    10101e <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101047:	8b 45 08             	mov    0x8(%ebp),%eax
  10104a:	0f b6 c0             	movzbl %al,%eax
  10104d:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101053:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101056:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10105a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10105e:	ee                   	out    %al,(%dx)
}
  10105f:	90                   	nop
  101060:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101066:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10106a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101072:	ee                   	out    %al,(%dx)
}
  101073:	90                   	nop
  101074:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10107a:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10107e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101082:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101086:	ee                   	out    %al,(%dx)
}
  101087:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101088:	90                   	nop
  101089:	89 ec                	mov    %ebp,%esp
  10108b:	5d                   	pop    %ebp
  10108c:	c3                   	ret    

0010108d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10108d:	55                   	push   %ebp
  10108e:	89 e5                	mov    %esp,%ebp
  101090:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101093:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101097:	74 0d                	je     1010a6 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	89 04 24             	mov    %eax,(%esp)
  10109f:	e8 6b ff ff ff       	call   10100f <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010a4:	eb 24                	jmp    1010ca <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ad:	e8 5d ff ff ff       	call   10100f <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010b2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010b9:	e8 51 ff ff ff       	call   10100f <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010be:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c5:	e8 45 ff ff ff       	call   10100f <lpt_putc_sub>
}
  1010ca:	90                   	nop
  1010cb:	89 ec                	mov    %ebp,%esp
  1010cd:	5d                   	pop    %ebp
  1010ce:	c3                   	ret    

001010cf <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010cf:	55                   	push   %ebp
  1010d0:	89 e5                	mov    %esp,%ebp
  1010d2:	83 ec 38             	sub    $0x38,%esp
  1010d5:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010db:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010e0:	85 c0                	test   %eax,%eax
  1010e2:	75 07                	jne    1010eb <cga_putc+0x1c>
        c |= 0x0700;
  1010e4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ee:	0f b6 c0             	movzbl %al,%eax
  1010f1:	83 f8 0d             	cmp    $0xd,%eax
  1010f4:	74 72                	je     101168 <cga_putc+0x99>
  1010f6:	83 f8 0d             	cmp    $0xd,%eax
  1010f9:	0f 8f a3 00 00 00    	jg     1011a2 <cga_putc+0xd3>
  1010ff:	83 f8 08             	cmp    $0x8,%eax
  101102:	74 0a                	je     10110e <cga_putc+0x3f>
  101104:	83 f8 0a             	cmp    $0xa,%eax
  101107:	74 4c                	je     101155 <cga_putc+0x86>
  101109:	e9 94 00 00 00       	jmp    1011a2 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10110e:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101115:	85 c0                	test   %eax,%eax
  101117:	0f 84 af 00 00 00    	je     1011cc <cga_putc+0xfd>
            crt_pos --;
  10111d:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101124:	48                   	dec    %eax
  101125:	0f b7 c0             	movzwl %ax,%eax
  101128:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10112e:	8b 45 08             	mov    0x8(%ebp),%eax
  101131:	98                   	cwtl   
  101132:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101137:	98                   	cwtl   
  101138:	83 c8 20             	or     $0x20,%eax
  10113b:	98                   	cwtl   
  10113c:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  101142:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101149:	01 d2                	add    %edx,%edx
  10114b:	01 ca                	add    %ecx,%edx
  10114d:	0f b7 c0             	movzwl %ax,%eax
  101150:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101153:	eb 77                	jmp    1011cc <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101155:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10115c:	83 c0 50             	add    $0x50,%eax
  10115f:	0f b7 c0             	movzwl %ax,%eax
  101162:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101168:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10116f:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101176:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10117b:	89 c8                	mov    %ecx,%eax
  10117d:	f7 e2                	mul    %edx
  10117f:	c1 ea 06             	shr    $0x6,%edx
  101182:	89 d0                	mov    %edx,%eax
  101184:	c1 e0 02             	shl    $0x2,%eax
  101187:	01 d0                	add    %edx,%eax
  101189:	c1 e0 04             	shl    $0x4,%eax
  10118c:	29 c1                	sub    %eax,%ecx
  10118e:	89 ca                	mov    %ecx,%edx
  101190:	0f b7 d2             	movzwl %dx,%edx
  101193:	89 d8                	mov    %ebx,%eax
  101195:	29 d0                	sub    %edx,%eax
  101197:	0f b7 c0             	movzwl %ax,%eax
  10119a:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011a0:	eb 2b                	jmp    1011cd <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a2:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011a8:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011af:	8d 50 01             	lea    0x1(%eax),%edx
  1011b2:	0f b7 d2             	movzwl %dx,%edx
  1011b5:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011bc:	01 c0                	add    %eax,%eax
  1011be:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c4:	0f b7 c0             	movzwl %ax,%eax
  1011c7:	66 89 02             	mov    %ax,(%edx)
        break;
  1011ca:	eb 01                	jmp    1011cd <cga_putc+0xfe>
        break;
  1011cc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011cd:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011d4:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011d9:	76 5e                	jbe    101239 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011db:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e6:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011eb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f2:	00 
  1011f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f7:	89 04 24             	mov    %eax,(%esp)
  1011fa:	e8 04 23 00 00       	call   103503 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ff:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101206:	eb 15                	jmp    10121d <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101208:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10120e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101211:	01 c0                	add    %eax,%eax
  101213:	01 d0                	add    %edx,%eax
  101215:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121a:	ff 45 f4             	incl   -0xc(%ebp)
  10121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101224:	7e e2                	jle    101208 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101226:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10122d:	83 e8 50             	sub    $0x50,%eax
  101230:	0f b7 c0             	movzwl %ax,%eax
  101233:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101239:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101240:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101244:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101248:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10124c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101250:	ee                   	out    %al,(%dx)
}
  101251:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101252:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101259:	c1 e8 08             	shr    $0x8,%eax
  10125c:	0f b7 c0             	movzwl %ax,%eax
  10125f:	0f b6 c0             	movzbl %al,%eax
  101262:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101269:	42                   	inc    %edx
  10126a:	0f b7 d2             	movzwl %dx,%edx
  10126d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101271:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101274:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101278:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10127c:	ee                   	out    %al,(%dx)
}
  10127d:	90                   	nop
    outb(addr_6845, 15);
  10127e:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101285:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101289:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10128d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101291:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101295:	ee                   	out    %al,(%dx)
}
  101296:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101297:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10129e:	0f b6 c0             	movzbl %al,%eax
  1012a1:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012a8:	42                   	inc    %edx
  1012a9:	0f b7 d2             	movzwl %dx,%edx
  1012ac:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012b0:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012b7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012bb:	ee                   	out    %al,(%dx)
}
  1012bc:	90                   	nop
}
  1012bd:	90                   	nop
  1012be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012c1:	89 ec                	mov    %ebp,%esp
  1012c3:	5d                   	pop    %ebp
  1012c4:	c3                   	ret    

001012c5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c5:	55                   	push   %ebp
  1012c6:	89 e5                	mov    %esp,%ebp
  1012c8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d2:	eb 08                	jmp    1012dc <serial_putc_sub+0x17>
        delay();
  1012d4:	e8 16 fb ff ff       	call   100def <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d9:	ff 45 fc             	incl   -0x4(%ebp)
  1012dc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e6:	89 c2                	mov    %eax,%edx
  1012e8:	ec                   	in     (%dx),%al
  1012e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f0:	0f b6 c0             	movzbl %al,%eax
  1012f3:	83 e0 20             	and    $0x20,%eax
  1012f6:	85 c0                	test   %eax,%eax
  1012f8:	75 09                	jne    101303 <serial_putc_sub+0x3e>
  1012fa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101301:	7e d1                	jle    1012d4 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101303:	8b 45 08             	mov    0x8(%ebp),%eax
  101306:	0f b6 c0             	movzbl %al,%eax
  101309:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130f:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101312:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101316:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131a:	ee                   	out    %al,(%dx)
}
  10131b:	90                   	nop
}
  10131c:	90                   	nop
  10131d:	89 ec                	mov    %ebp,%esp
  10131f:	5d                   	pop    %ebp
  101320:	c3                   	ret    

00101321 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101321:	55                   	push   %ebp
  101322:	89 e5                	mov    %esp,%ebp
  101324:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101327:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10132b:	74 0d                	je     10133a <serial_putc+0x19>
        serial_putc_sub(c);
  10132d:	8b 45 08             	mov    0x8(%ebp),%eax
  101330:	89 04 24             	mov    %eax,(%esp)
  101333:	e8 8d ff ff ff       	call   1012c5 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101338:	eb 24                	jmp    10135e <serial_putc+0x3d>
        serial_putc_sub('\b');
  10133a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101341:	e8 7f ff ff ff       	call   1012c5 <serial_putc_sub>
        serial_putc_sub(' ');
  101346:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134d:	e8 73 ff ff ff       	call   1012c5 <serial_putc_sub>
        serial_putc_sub('\b');
  101352:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101359:	e8 67 ff ff ff       	call   1012c5 <serial_putc_sub>
}
  10135e:	90                   	nop
  10135f:	89 ec                	mov    %ebp,%esp
  101361:	5d                   	pop    %ebp
  101362:	c3                   	ret    

00101363 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101363:	55                   	push   %ebp
  101364:	89 e5                	mov    %esp,%ebp
  101366:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101369:	eb 33                	jmp    10139e <cons_intr+0x3b>
        if (c != 0) {
  10136b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136f:	74 2d                	je     10139e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101371:	a1 84 00 11 00       	mov    0x110084,%eax
  101376:	8d 50 01             	lea    0x1(%eax),%edx
  101379:	89 15 84 00 11 00    	mov    %edx,0x110084
  10137f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101382:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101388:	a1 84 00 11 00       	mov    0x110084,%eax
  10138d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101392:	75 0a                	jne    10139e <cons_intr+0x3b>
                cons.wpos = 0;
  101394:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  10139b:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10139e:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a1:	ff d0                	call   *%eax
  1013a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013aa:	75 bf                	jne    10136b <cons_intr+0x8>
            }
        }
    }
}
  1013ac:	90                   	nop
  1013ad:	90                   	nop
  1013ae:	89 ec                	mov    %ebp,%esp
  1013b0:	5d                   	pop    %ebp
  1013b1:	c3                   	ret    

001013b2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013b2:	55                   	push   %ebp
  1013b3:	89 e5                	mov    %esp,%ebp
  1013b5:	83 ec 10             	sub    $0x10,%esp
  1013b8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013be:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013c2:	89 c2                	mov    %eax,%edx
  1013c4:	ec                   	in     (%dx),%al
  1013c5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013cc:	0f b6 c0             	movzbl %al,%eax
  1013cf:	83 e0 01             	and    $0x1,%eax
  1013d2:	85 c0                	test   %eax,%eax
  1013d4:	75 07                	jne    1013dd <serial_proc_data+0x2b>
        return -1;
  1013d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013db:	eb 2a                	jmp    101407 <serial_proc_data+0x55>
  1013dd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e7:	89 c2                	mov    %eax,%edx
  1013e9:	ec                   	in     (%dx),%al
  1013ea:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013ed:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013f1:	0f b6 c0             	movzbl %al,%eax
  1013f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013fb:	75 07                	jne    101404 <serial_proc_data+0x52>
        c = '\b';
  1013fd:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101404:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101407:	89 ec                	mov    %ebp,%esp
  101409:	5d                   	pop    %ebp
  10140a:	c3                   	ret    

0010140b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10140b:	55                   	push   %ebp
  10140c:	89 e5                	mov    %esp,%ebp
  10140e:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101411:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101416:	85 c0                	test   %eax,%eax
  101418:	74 0c                	je     101426 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10141a:	c7 04 24 b2 13 10 00 	movl   $0x1013b2,(%esp)
  101421:	e8 3d ff ff ff       	call   101363 <cons_intr>
    }
}
  101426:	90                   	nop
  101427:	89 ec                	mov    %ebp,%esp
  101429:	5d                   	pop    %ebp
  10142a:	c3                   	ret    

0010142b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10142b:	55                   	push   %ebp
  10142c:	89 e5                	mov    %esp,%ebp
  10142e:	83 ec 38             	sub    $0x38,%esp
  101431:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10143a:	89 c2                	mov    %eax,%edx
  10143c:	ec                   	in     (%dx),%al
  10143d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101440:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101444:	0f b6 c0             	movzbl %al,%eax
  101447:	83 e0 01             	and    $0x1,%eax
  10144a:	85 c0                	test   %eax,%eax
  10144c:	75 0a                	jne    101458 <kbd_proc_data+0x2d>
        return -1;
  10144e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101453:	e9 56 01 00 00       	jmp    1015ae <kbd_proc_data+0x183>
  101458:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10145e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101461:	89 c2                	mov    %eax,%edx
  101463:	ec                   	in     (%dx),%al
  101464:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101467:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10146b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10146e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101472:	75 17                	jne    10148b <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101474:	a1 88 00 11 00       	mov    0x110088,%eax
  101479:	83 c8 40             	or     $0x40,%eax
  10147c:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  101481:	b8 00 00 00 00       	mov    $0x0,%eax
  101486:	e9 23 01 00 00       	jmp    1015ae <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  10148b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148f:	84 c0                	test   %al,%al
  101491:	79 45                	jns    1014d8 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101493:	a1 88 00 11 00       	mov    0x110088,%eax
  101498:	83 e0 40             	and    $0x40,%eax
  10149b:	85 c0                	test   %eax,%eax
  10149d:	75 08                	jne    1014a7 <kbd_proc_data+0x7c>
  10149f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a3:	24 7f                	and    $0x7f,%al
  1014a5:	eb 04                	jmp    1014ab <kbd_proc_data+0x80>
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b2:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014b9:	0c 40                	or     $0x40,%al
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	f7 d0                	not    %eax
  1014c0:	89 c2                	mov    %eax,%edx
  1014c2:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c7:	21 d0                	and    %edx,%eax
  1014c9:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d3:	e9 d6 00 00 00       	jmp    1015ae <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014d8:	a1 88 00 11 00       	mov    0x110088,%eax
  1014dd:	83 e0 40             	and    $0x40,%eax
  1014e0:	85 c0                	test   %eax,%eax
  1014e2:	74 11                	je     1014f5 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014e4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e8:	a1 88 00 11 00       	mov    0x110088,%eax
  1014ed:	83 e0 bf             	and    $0xffffffbf,%eax
  1014f0:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  1014f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f9:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  101500:	0f b6 d0             	movzbl %al,%edx
  101503:	a1 88 00 11 00       	mov    0x110088,%eax
  101508:	09 d0                	or     %edx,%eax
  10150a:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101513:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  10151a:	0f b6 d0             	movzbl %al,%edx
  10151d:	a1 88 00 11 00       	mov    0x110088,%eax
  101522:	31 d0                	xor    %edx,%eax
  101524:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101529:	a1 88 00 11 00       	mov    0x110088,%eax
  10152e:	83 e0 03             	and    $0x3,%eax
  101531:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101538:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153c:	01 d0                	add    %edx,%eax
  10153e:	0f b6 00             	movzbl (%eax),%eax
  101541:	0f b6 c0             	movzbl %al,%eax
  101544:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101547:	a1 88 00 11 00       	mov    0x110088,%eax
  10154c:	83 e0 08             	and    $0x8,%eax
  10154f:	85 c0                	test   %eax,%eax
  101551:	74 22                	je     101575 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101553:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101557:	7e 0c                	jle    101565 <kbd_proc_data+0x13a>
  101559:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10155d:	7f 06                	jg     101565 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10155f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101563:	eb 10                	jmp    101575 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101565:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101569:	7e 0a                	jle    101575 <kbd_proc_data+0x14a>
  10156b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10156f:	7f 04                	jg     101575 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101571:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101575:	a1 88 00 11 00       	mov    0x110088,%eax
  10157a:	f7 d0                	not    %eax
  10157c:	83 e0 06             	and    $0x6,%eax
  10157f:	85 c0                	test   %eax,%eax
  101581:	75 28                	jne    1015ab <kbd_proc_data+0x180>
  101583:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10158a:	75 1f                	jne    1015ab <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  10158c:	c7 04 24 8f 39 10 00 	movl   $0x10398f,(%esp)
  101593:	e8 98 ed ff ff       	call   100330 <cprintf>
  101598:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10159e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015a2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015a9:	ee                   	out    %al,(%dx)
}
  1015aa:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ae:	89 ec                	mov    %ebp,%esp
  1015b0:	5d                   	pop    %ebp
  1015b1:	c3                   	ret    

001015b2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015b2:	55                   	push   %ebp
  1015b3:	89 e5                	mov    %esp,%ebp
  1015b5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b8:	c7 04 24 2b 14 10 00 	movl   $0x10142b,(%esp)
  1015bf:	e8 9f fd ff ff       	call   101363 <cons_intr>
}
  1015c4:	90                   	nop
  1015c5:	89 ec                	mov    %ebp,%esp
  1015c7:	5d                   	pop    %ebp
  1015c8:	c3                   	ret    

001015c9 <kbd_init>:

static void
kbd_init(void) {
  1015c9:	55                   	push   %ebp
  1015ca:	89 e5                	mov    %esp,%ebp
  1015cc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015cf:	e8 de ff ff ff       	call   1015b2 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015db:	e8 2b 01 00 00       	call   10170b <pic_enable>
}
  1015e0:	90                   	nop
  1015e1:	89 ec                	mov    %ebp,%esp
  1015e3:	5d                   	pop    %ebp
  1015e4:	c3                   	ret    

001015e5 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e5:	55                   	push   %ebp
  1015e6:	89 e5                	mov    %esp,%ebp
  1015e8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015eb:	e8 4a f8 ff ff       	call   100e3a <cga_init>
    serial_init();
  1015f0:	e8 2d f9 ff ff       	call   100f22 <serial_init>
    kbd_init();
  1015f5:	e8 cf ff ff ff       	call   1015c9 <kbd_init>
    if (!serial_exists) {
  1015fa:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1015ff:	85 c0                	test   %eax,%eax
  101601:	75 0c                	jne    10160f <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101603:	c7 04 24 9b 39 10 00 	movl   $0x10399b,(%esp)
  10160a:	e8 21 ed ff ff       	call   100330 <cprintf>
    }
}
  10160f:	90                   	nop
  101610:	89 ec                	mov    %ebp,%esp
  101612:	5d                   	pop    %ebp
  101613:	c3                   	ret    

00101614 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10161a:	8b 45 08             	mov    0x8(%ebp),%eax
  10161d:	89 04 24             	mov    %eax,(%esp)
  101620:	e8 68 fa ff ff       	call   10108d <lpt_putc>
    cga_putc(c);
  101625:	8b 45 08             	mov    0x8(%ebp),%eax
  101628:	89 04 24             	mov    %eax,(%esp)
  10162b:	e8 9f fa ff ff       	call   1010cf <cga_putc>
    serial_putc(c);
  101630:	8b 45 08             	mov    0x8(%ebp),%eax
  101633:	89 04 24             	mov    %eax,(%esp)
  101636:	e8 e6 fc ff ff       	call   101321 <serial_putc>
}
  10163b:	90                   	nop
  10163c:	89 ec                	mov    %ebp,%esp
  10163e:	5d                   	pop    %ebp
  10163f:	c3                   	ret    

00101640 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101640:	55                   	push   %ebp
  101641:	89 e5                	mov    %esp,%ebp
  101643:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101646:	e8 c0 fd ff ff       	call   10140b <serial_intr>
    kbd_intr();
  10164b:	e8 62 ff ff ff       	call   1015b2 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101650:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101656:	a1 84 00 11 00       	mov    0x110084,%eax
  10165b:	39 c2                	cmp    %eax,%edx
  10165d:	74 36                	je     101695 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10165f:	a1 80 00 11 00       	mov    0x110080,%eax
  101664:	8d 50 01             	lea    0x1(%eax),%edx
  101667:	89 15 80 00 11 00    	mov    %edx,0x110080
  10166d:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101674:	0f b6 c0             	movzbl %al,%eax
  101677:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10167a:	a1 80 00 11 00       	mov    0x110080,%eax
  10167f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101684:	75 0a                	jne    101690 <cons_getc+0x50>
            cons.rpos = 0;
  101686:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  10168d:	00 00 00 
        }
        return c;
  101690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101693:	eb 05                	jmp    10169a <cons_getc+0x5a>
    }
    return 0;
  101695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10169a:	89 ec                	mov    %ebp,%esp
  10169c:	5d                   	pop    %ebp
  10169d:	c3                   	ret    

0010169e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10169e:	55                   	push   %ebp
  10169f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a1:	fb                   	sti    
}
  1016a2:	90                   	nop
    sti();
}
  1016a3:	90                   	nop
  1016a4:	5d                   	pop    %ebp
  1016a5:	c3                   	ret    

001016a6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a6:	55                   	push   %ebp
  1016a7:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1016a9:	fa                   	cli    
}
  1016aa:	90                   	nop
    cli();
}
  1016ab:	90                   	nop
  1016ac:	5d                   	pop    %ebp
  1016ad:	c3                   	ret    

001016ae <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ae:	55                   	push   %ebp
  1016af:	89 e5                	mov    %esp,%ebp
  1016b1:	83 ec 14             	sub    $0x14,%esp
  1016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016be:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016c4:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016c9:	85 c0                	test   %eax,%eax
  1016cb:	74 39                	je     101706 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016d0:	0f b6 c0             	movzbl %al,%eax
  1016d3:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016d9:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016dc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
}
  1016e5:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016e6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ea:	c1 e8 08             	shr    $0x8,%eax
  1016ed:	0f b7 c0             	movzwl %ax,%eax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016f9:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016fc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101700:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
}
  101705:	90                   	nop
    }
}
  101706:	90                   	nop
  101707:	89 ec                	mov    %ebp,%esp
  101709:	5d                   	pop    %ebp
  10170a:	c3                   	ret    

0010170b <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170b:	55                   	push   %ebp
  10170c:	89 e5                	mov    %esp,%ebp
  10170e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101711:	8b 45 08             	mov    0x8(%ebp),%eax
  101714:	ba 01 00 00 00       	mov    $0x1,%edx
  101719:	88 c1                	mov    %al,%cl
  10171b:	d3 e2                	shl    %cl,%edx
  10171d:	89 d0                	mov    %edx,%eax
  10171f:	98                   	cwtl   
  101720:	f7 d0                	not    %eax
  101722:	0f bf d0             	movswl %ax,%edx
  101725:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10172c:	98                   	cwtl   
  10172d:	21 d0                	and    %edx,%eax
  10172f:	98                   	cwtl   
  101730:	0f b7 c0             	movzwl %ax,%eax
  101733:	89 04 24             	mov    %eax,(%esp)
  101736:	e8 73 ff ff ff       	call   1016ae <pic_setmask>
}
  10173b:	90                   	nop
  10173c:	89 ec                	mov    %ebp,%esp
  10173e:	5d                   	pop    %ebp
  10173f:	c3                   	ret    

00101740 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101740:	55                   	push   %ebp
  101741:	89 e5                	mov    %esp,%ebp
  101743:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101746:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  10174d:	00 00 00 
  101750:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101756:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10175a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10175e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
}
  101763:	90                   	nop
  101764:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10176a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10176e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101772:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101776:	ee                   	out    %al,(%dx)
}
  101777:	90                   	nop
  101778:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10177e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101782:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101786:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10178a:	ee                   	out    %al,(%dx)
}
  10178b:	90                   	nop
  10178c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101792:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101796:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10179a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
}
  10179f:	90                   	nop
  1017a0:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017a6:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017aa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017ae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017b2:	ee                   	out    %al,(%dx)
}
  1017b3:	90                   	nop
  1017b4:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017ba:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017be:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017c2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
}
  1017c7:	90                   	nop
  1017c8:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017ce:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017d2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017da:	ee                   	out    %al,(%dx)
}
  1017db:	90                   	nop
  1017dc:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017e2:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017ea:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ee:	ee                   	out    %al,(%dx)
}
  1017ef:	90                   	nop
  1017f0:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017f6:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017fa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017fe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
}
  101803:	90                   	nop
  101804:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10180a:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101812:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101816:	ee                   	out    %al,(%dx)
}
  101817:	90                   	nop
  101818:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10181e:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101822:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101826:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10182a:	ee                   	out    %al,(%dx)
}
  10182b:	90                   	nop
  10182c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101832:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101836:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10183a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10183e:	ee                   	out    %al,(%dx)
}
  10183f:	90                   	nop
  101840:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101846:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10184a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10184e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101852:	ee                   	out    %al,(%dx)
}
  101853:	90                   	nop
  101854:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10185a:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101862:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101866:	ee                   	out    %al,(%dx)
}
  101867:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101868:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10186f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101874:	74 0f                	je     101885 <pic_init+0x145>
        pic_setmask(irq_mask);
  101876:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10187d:	89 04 24             	mov    %eax,(%esp)
  101880:	e8 29 fe ff ff       	call   1016ae <pic_setmask>
    }
}
  101885:	90                   	nop
  101886:	89 ec                	mov    %ebp,%esp
  101888:	5d                   	pop    %ebp
  101889:	c3                   	ret    

0010188a <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10188a:	55                   	push   %ebp
  10188b:	89 e5                	mov    %esp,%ebp
  10188d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101890:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101897:	00 
  101898:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  10189f:	e8 8c ea ff ff       	call   100330 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018a4:	c7 04 24 ca 39 10 00 	movl   $0x1039ca,(%esp)
  1018ab:	e8 80 ea ff ff       	call   100330 <cprintf>
    panic("EOT: kernel seems ok.");
  1018b0:	c7 44 24 08 d8 39 10 	movl   $0x1039d8,0x8(%esp)
  1018b7:	00 
  1018b8:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018bf:	00 
  1018c0:	c7 04 24 ee 39 10 00 	movl   $0x1039ee,(%esp)
  1018c7:	e8 e9 f3 ff ff       	call   100cb5 <__panic>

001018cc <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018cc:	55                   	push   %ebp
  1018cd:	89 e5                	mov    %esp,%ebp
  1018cf:	83 ec 10             	sub    $0x10,%esp
    extern uintptr_t __vectors[];
    int i;
    // 首先通过tools/vector.c通过程序生成/kern/trap/verctor.S,并在加载内核时对之前已经声明的全局变量__vectors进行整体的赋值
    // __vectors数组中的每一项对应于中断描述符的中断服务例程的入口地址，在SETGATE宏的使用中可以体现出来
    // 将__vectors数组中每一项关于中断描述符的描述设置到下标相同的idt中，通过宏SETGATE构造出最终的中断描述符结构
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018d9:	e9 c4 00 00 00       	jmp    1019a2 <idt_init+0xd6>
        //遍历idt数组，将其中的内容(中断描述符)设置进IDT中断描述符表中(默认的DPL特权级都是内核态DPL_KERNEL=0)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e1:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018e8:	0f b7 d0             	movzwl %ax,%edx
  1018eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ee:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  1018f5:	00 
  1018f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f9:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  101900:	00 08 00 
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  10190d:	00 
  10190e:	80 e2 e0             	and    $0xe0,%dl
  101911:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101918:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191b:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  101922:	00 
  101923:	80 e2 1f             	and    $0x1f,%dl
  101926:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  10192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101930:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101937:	00 
  101938:	80 e2 f0             	and    $0xf0,%dl
  10193b:	80 ca 0e             	or     $0xe,%dl
  10193e:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101945:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101948:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  10194f:	00 
  101950:	80 e2 ef             	and    $0xef,%dl
  101953:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195d:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101964:	00 
  101965:	80 e2 9f             	and    $0x9f,%dl
  101968:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101972:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101979:	00 
  10197a:	80 ca 80             	or     $0x80,%dl
  10197d:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10198e:	c1 e8 10             	shr    $0x10,%eax
  101991:	0f b7 d0             	movzwl %ax,%edx
  101994:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101997:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  10199e:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10199f:	ff 45 fc             	incl   -0x4(%ebp)
  1019a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a5:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019aa:	0f 86 2e ff ff ff    	jbe    1018de <idt_init+0x12>
    }
    
    // set for switch from user to kernel
    // 用户态与内核态的互相转化是通过中断实现的，单独为其一个中断描述符
    // 由于需要允许用户态的程序访问使用该中断，DPL特权级为用户态DPL_USER=3
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019b0:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  1019b5:	0f b7 c0             	movzwl %ax,%eax
  1019b8:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  1019be:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  1019c5:	08 00 
  1019c7:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019ce:	24 e0                	and    $0xe0,%al
  1019d0:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019d5:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019dc:	24 1f                	and    $0x1f,%al
  1019de:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019e3:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019ea:	24 f0                	and    $0xf0,%al
  1019ec:	0c 0e                	or     $0xe,%al
  1019ee:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019f3:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019fa:	24 ef                	and    $0xef,%al
  1019fc:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a01:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a08:	0c 60                	or     $0x60,%al
  101a0a:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a0f:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  101a16:	0c 80                	or     $0x80,%al
  101a18:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a1d:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a22:	c1 e8 10             	shr    $0x10,%eax
  101a25:	0f b7 c0             	movzwl %ax,%eax
  101a28:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  101a2e:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a38:	0f 01 18             	lidtl  (%eax)
}
  101a3b:	90                   	nop
    // load the IDT令IDTR中断描述符表寄存器指向idt_pd，加载IDT
    // idt_pd结构体中的前16位为描述符表的界限，pd_base指向之前完成了赋值操作的idt数组的起始位置
    lidt(&idt_pd);
}
  101a3c:	90                   	nop
  101a3d:	89 ec                	mov    %ebp,%esp
  101a3f:	5d                   	pop    %ebp
  101a40:	c3                   	ret    

00101a41 <trapname>:

static const char *
trapname(int trapno) {
  101a41:	55                   	push   %ebp
  101a42:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a44:	8b 45 08             	mov    0x8(%ebp),%eax
  101a47:	83 f8 13             	cmp    $0x13,%eax
  101a4a:	77 0c                	ja     101a58 <trapname+0x17>
        return excnames[trapno];
  101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4f:	8b 04 85 40 3d 10 00 	mov    0x103d40(,%eax,4),%eax
  101a56:	eb 18                	jmp    101a70 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a58:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a5c:	7e 0d                	jle    101a6b <trapname+0x2a>
  101a5e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a62:	7f 07                	jg     101a6b <trapname+0x2a>
        return "Hardware Interrupt";
  101a64:	b8 ff 39 10 00       	mov    $0x1039ff,%eax
  101a69:	eb 05                	jmp    101a70 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a6b:	b8 12 3a 10 00       	mov    $0x103a12,%eax
}
  101a70:	5d                   	pop    %ebp
  101a71:	c3                   	ret    

00101a72 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a72:	55                   	push   %ebp
  101a73:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a75:	8b 45 08             	mov    0x8(%ebp),%eax
  101a78:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a7c:	83 f8 08             	cmp    $0x8,%eax
  101a7f:	0f 94 c0             	sete   %al
  101a82:	0f b6 c0             	movzbl %al,%eax
}
  101a85:	5d                   	pop    %ebp
  101a86:	c3                   	ret    

00101a87 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a87:	55                   	push   %ebp
  101a88:	89 e5                	mov    %esp,%ebp
  101a8a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a94:	c7 04 24 53 3a 10 00 	movl   $0x103a53,(%esp)
  101a9b:	e8 90 e8 ff ff       	call   100330 <cprintf>
    print_regs(&tf->tf_regs);
  101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa3:	89 04 24             	mov    %eax,(%esp)
  101aa6:	e8 8f 01 00 00       	call   101c3a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab6:	c7 04 24 64 3a 10 00 	movl   $0x103a64,(%esp)
  101abd:	e8 6e e8 ff ff       	call   100330 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acd:	c7 04 24 77 3a 10 00 	movl   $0x103a77,(%esp)
  101ad4:	e8 57 e8 ff ff       	call   100330 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae4:	c7 04 24 8a 3a 10 00 	movl   $0x103a8a,(%esp)
  101aeb:	e8 40 e8 ff ff       	call   100330 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afb:	c7 04 24 9d 3a 10 00 	movl   $0x103a9d,(%esp)
  101b02:	e8 29 e8 ff ff       	call   100330 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b07:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0a:	8b 40 30             	mov    0x30(%eax),%eax
  101b0d:	89 04 24             	mov    %eax,(%esp)
  101b10:	e8 2c ff ff ff       	call   101a41 <trapname>
  101b15:	8b 55 08             	mov    0x8(%ebp),%edx
  101b18:	8b 52 30             	mov    0x30(%edx),%edx
  101b1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b1f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b23:	c7 04 24 b0 3a 10 00 	movl   $0x103ab0,(%esp)
  101b2a:	e8 01 e8 ff ff       	call   100330 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b32:	8b 40 34             	mov    0x34(%eax),%eax
  101b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b39:	c7 04 24 c2 3a 10 00 	movl   $0x103ac2,(%esp)
  101b40:	e8 eb e7 ff ff       	call   100330 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b45:	8b 45 08             	mov    0x8(%ebp),%eax
  101b48:	8b 40 38             	mov    0x38(%eax),%eax
  101b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4f:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101b56:	e8 d5 e7 ff ff       	call   100330 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b66:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101b6d:	e8 be e7 ff ff       	call   100330 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	8b 40 40             	mov    0x40(%eax),%eax
  101b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7c:	c7 04 24 f3 3a 10 00 	movl   $0x103af3,(%esp)
  101b83:	e8 a8 e7 ff ff       	call   100330 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b96:	eb 3d                	jmp    101bd5 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	8b 50 40             	mov    0x40(%eax),%edx
  101b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ba1:	21 d0                	and    %edx,%eax
  101ba3:	85 c0                	test   %eax,%eax
  101ba5:	74 28                	je     101bcf <print_trapframe+0x148>
  101ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101baa:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101bb1:	85 c0                	test   %eax,%eax
  101bb3:	74 1a                	je     101bcf <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb8:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc3:	c7 04 24 02 3b 10 00 	movl   $0x103b02,(%esp)
  101bca:	e8 61 e7 ff ff       	call   100330 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bcf:	ff 45 f4             	incl   -0xc(%ebp)
  101bd2:	d1 65 f0             	shll   -0x10(%ebp)
  101bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd8:	83 f8 17             	cmp    $0x17,%eax
  101bdb:	76 bb                	jbe    101b98 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	8b 40 40             	mov    0x40(%eax),%eax
  101be3:	c1 e8 0c             	shr    $0xc,%eax
  101be6:	83 e0 03             	and    $0x3,%eax
  101be9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bed:	c7 04 24 06 3b 10 00 	movl   $0x103b06,(%esp)
  101bf4:	e8 37 e7 ff ff       	call   100330 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfc:	89 04 24             	mov    %eax,(%esp)
  101bff:	e8 6e fe ff ff       	call   101a72 <trap_in_kernel>
  101c04:	85 c0                	test   %eax,%eax
  101c06:	75 2d                	jne    101c35 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 44             	mov    0x44(%eax),%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 0f 3b 10 00 	movl   $0x103b0f,(%esp)
  101c19:	e8 12 e7 ff ff       	call   100330 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c21:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 1e 3b 10 00 	movl   $0x103b1e,(%esp)
  101c30:	e8 fb e6 ff ff       	call   100330 <cprintf>
    }
}
  101c35:	90                   	nop
  101c36:	89 ec                	mov    %ebp,%esp
  101c38:	5d                   	pop    %ebp
  101c39:	c3                   	ret    

00101c3a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c3a:	55                   	push   %ebp
  101c3b:	89 e5                	mov    %esp,%ebp
  101c3d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 00                	mov    (%eax),%eax
  101c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c49:	c7 04 24 31 3b 10 00 	movl   $0x103b31,(%esp)
  101c50:	e8 db e6 ff ff       	call   100330 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c55:	8b 45 08             	mov    0x8(%ebp),%eax
  101c58:	8b 40 04             	mov    0x4(%eax),%eax
  101c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5f:	c7 04 24 40 3b 10 00 	movl   $0x103b40,(%esp)
  101c66:	e8 c5 e6 ff ff       	call   100330 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6e:	8b 40 08             	mov    0x8(%eax),%eax
  101c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c75:	c7 04 24 4f 3b 10 00 	movl   $0x103b4f,(%esp)
  101c7c:	e8 af e6 ff ff       	call   100330 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c81:	8b 45 08             	mov    0x8(%ebp),%eax
  101c84:	8b 40 0c             	mov    0xc(%eax),%eax
  101c87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8b:	c7 04 24 5e 3b 10 00 	movl   $0x103b5e,(%esp)
  101c92:	e8 99 e6 ff ff       	call   100330 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c97:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9a:	8b 40 10             	mov    0x10(%eax),%eax
  101c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca1:	c7 04 24 6d 3b 10 00 	movl   $0x103b6d,(%esp)
  101ca8:	e8 83 e6 ff ff       	call   100330 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cad:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb0:	8b 40 14             	mov    0x14(%eax),%eax
  101cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb7:	c7 04 24 7c 3b 10 00 	movl   $0x103b7c,(%esp)
  101cbe:	e8 6d e6 ff ff       	call   100330 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc6:	8b 40 18             	mov    0x18(%eax),%eax
  101cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccd:	c7 04 24 8b 3b 10 00 	movl   $0x103b8b,(%esp)
  101cd4:	e8 57 e6 ff ff       	call   100330 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdc:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce3:	c7 04 24 9a 3b 10 00 	movl   $0x103b9a,(%esp)
  101cea:	e8 41 e6 ff ff       	call   100330 <cprintf>
}
  101cef:	90                   	nop
  101cf0:	89 ec                	mov    %ebp,%esp
  101cf2:	5d                   	pop    %ebp
  101cf3:	c3                   	ret    

00101cf4 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cf4:	55                   	push   %ebp
  101cf5:	89 e5                	mov    %esp,%ebp
  101cf7:	83 ec 28             	sub    $0x28,%esp
  101cfa:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char c;

    switch (tf->tf_trapno) {
  101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101d00:	8b 40 30             	mov    0x30(%eax),%eax
  101d03:	83 f8 79             	cmp    $0x79,%eax
  101d06:	0f 84 6c 01 00 00    	je     101e78 <trap_dispatch+0x184>
  101d0c:	83 f8 79             	cmp    $0x79,%eax
  101d0f:	0f 87 e0 01 00 00    	ja     101ef5 <trap_dispatch+0x201>
  101d15:	83 f8 78             	cmp    $0x78,%eax
  101d18:	0f 84 d0 00 00 00    	je     101dee <trap_dispatch+0xfa>
  101d1e:	83 f8 78             	cmp    $0x78,%eax
  101d21:	0f 87 ce 01 00 00    	ja     101ef5 <trap_dispatch+0x201>
  101d27:	83 f8 2f             	cmp    $0x2f,%eax
  101d2a:	0f 87 c5 01 00 00    	ja     101ef5 <trap_dispatch+0x201>
  101d30:	83 f8 2e             	cmp    $0x2e,%eax
  101d33:	0f 83 f1 01 00 00    	jae    101f2a <trap_dispatch+0x236>
  101d39:	83 f8 24             	cmp    $0x24,%eax
  101d3c:	74 5e                	je     101d9c <trap_dispatch+0xa8>
  101d3e:	83 f8 24             	cmp    $0x24,%eax
  101d41:	0f 87 ae 01 00 00    	ja     101ef5 <trap_dispatch+0x201>
  101d47:	83 f8 20             	cmp    $0x20,%eax
  101d4a:	74 0a                	je     101d56 <trap_dispatch+0x62>
  101d4c:	83 f8 21             	cmp    $0x21,%eax
  101d4f:	74 74                	je     101dc5 <trap_dispatch+0xd1>
  101d51:	e9 9f 01 00 00       	jmp    101ef5 <trap_dispatch+0x201>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d56:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d5b:	40                   	inc    %eax
  101d5c:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks % TICK_NUM == 0) {
  101d61:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101d67:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d6c:	89 c8                	mov    %ecx,%eax
  101d6e:	f7 e2                	mul    %edx
  101d70:	c1 ea 05             	shr    $0x5,%edx
  101d73:	89 d0                	mov    %edx,%eax
  101d75:	c1 e0 02             	shl    $0x2,%eax
  101d78:	01 d0                	add    %edx,%eax
  101d7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d81:	01 d0                	add    %edx,%eax
  101d83:	c1 e0 02             	shl    $0x2,%eax
  101d86:	29 c1                	sub    %eax,%ecx
  101d88:	89 ca                	mov    %ecx,%edx
  101d8a:	85 d2                	test   %edx,%edx
  101d8c:	0f 85 9b 01 00 00    	jne    101f2d <trap_dispatch+0x239>
            print_ticks();
  101d92:	e8 f3 fa ff ff       	call   10188a <print_ticks>
        }
        break;
  101d97:	e9 91 01 00 00       	jmp    101f2d <trap_dispatch+0x239>
        
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d9c:	e8 9f f8 ff ff       	call   101640 <cons_getc>
  101da1:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101da4:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dac:	89 54 24 08          	mov    %edx,0x8(%esp)
  101db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db4:	c7 04 24 a9 3b 10 00 	movl   $0x103ba9,(%esp)
  101dbb:	e8 70 e5 ff ff       	call   100330 <cprintf>
        break;
  101dc0:	e9 6f 01 00 00       	jmp    101f34 <trap_dispatch+0x240>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dc5:	e8 76 f8 ff ff       	call   101640 <cons_getc>
  101dca:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dcd:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dd1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dd5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddd:	c7 04 24 bb 3b 10 00 	movl   $0x103bbb,(%esp)
  101de4:	e8 47 e5 ff ff       	call   100330 <cprintf>
        break;
  101de9:	e9 46 01 00 00       	jmp    101f34 <trap_dispatch+0x240>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101dee:	8b 45 08             	mov    0x8(%ebp),%eax
  101df1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101df5:	83 f8 1b             	cmp    $0x1b,%eax
  101df8:	0f 84 32 01 00 00    	je     101f30 <trap_dispatch+0x23c>
            switchk2u = *tf;
  101dfe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  101e01:	b8 4c 00 00 00       	mov    $0x4c,%eax
  101e06:	83 e0 fc             	and    $0xfffffffc,%eax
  101e09:	89 c3                	mov    %eax,%ebx
  101e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  101e10:	8b 14 01             	mov    (%ecx,%eax,1),%edx
  101e13:	89 90 a0 00 11 00    	mov    %edx,0x1100a0(%eax)
  101e19:	83 c0 04             	add    $0x4,%eax
  101e1c:	39 d8                	cmp    %ebx,%eax
  101e1e:	72 f0                	jb     101e10 <trap_dispatch+0x11c>
            switchk2u.tf_cs = USER_CS;
  101e20:	66 c7 05 dc 00 11 00 	movw   $0x1b,0x1100dc
  101e27:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e29:	66 c7 05 e8 00 11 00 	movw   $0x23,0x1100e8
  101e30:	23 00 
  101e32:	0f b7 05 e8 00 11 00 	movzwl 0x1100e8,%eax
  101e39:	66 a3 c8 00 11 00    	mov    %ax,0x1100c8
  101e3f:	0f b7 05 c8 00 11 00 	movzwl 0x1100c8,%eax
  101e46:	66 a3 cc 00 11 00    	mov    %ax,0x1100cc
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4f:	83 c0 44             	add    $0x44,%eax
  101e52:	a3 e4 00 11 00       	mov    %eax,0x1100e4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e57:	a1 e0 00 11 00       	mov    0x1100e0,%eax
  101e5c:	0d 00 30 00 00       	or     $0x3000,%eax
  101e61:	a3 e0 00 11 00       	mov    %eax,0x1100e0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e66:	8b 45 08             	mov    0x8(%ebp),%eax
  101e69:	83 e8 04             	sub    $0x4,%eax
  101e6c:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101e71:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e73:	e9 b8 00 00 00       	jmp    101f30 <trap_dispatch+0x23c>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e78:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e7f:	83 f8 08             	cmp    $0x8,%eax
  101e82:	0f 84 ab 00 00 00    	je     101f33 <trap_dispatch+0x23f>
            tf->tf_cs = KERNEL_CS;
  101e88:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8b:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e91:	8b 45 08             	mov    0x8(%ebp),%eax
  101e94:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea4:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  101eab:	8b 40 40             	mov    0x40(%eax),%eax
  101eae:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101eb3:	89 c2                	mov    %eax,%edx
  101eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb8:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ebe:	8b 40 44             	mov    0x44(%eax),%eax
  101ec1:	83 e8 44             	sub    $0x44,%eax
  101ec4:	a3 ec 00 11 00       	mov    %eax,0x1100ec
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101ec9:	a1 ec 00 11 00       	mov    0x1100ec,%eax
  101ece:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ed5:	00 
  101ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  101ed9:	89 54 24 04          	mov    %edx,0x4(%esp)
  101edd:	89 04 24             	mov    %eax,(%esp)
  101ee0:	e8 1e 16 00 00       	call   103503 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ee5:	8b 15 ec 00 11 00    	mov    0x1100ec,%edx
  101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  101eee:	83 e8 04             	sub    $0x4,%eax
  101ef1:	89 10                	mov    %edx,(%eax)
        }
        break;
  101ef3:	eb 3e                	jmp    101f33 <trap_dispatch+0x23f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101efc:	83 e0 03             	and    $0x3,%eax
  101eff:	85 c0                	test   %eax,%eax
  101f01:	75 31                	jne    101f34 <trap_dispatch+0x240>
            print_trapframe(tf);
  101f03:	8b 45 08             	mov    0x8(%ebp),%eax
  101f06:	89 04 24             	mov    %eax,(%esp)
  101f09:	e8 79 fb ff ff       	call   101a87 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f0e:	c7 44 24 08 ca 3b 10 	movl   $0x103bca,0x8(%esp)
  101f15:	00 
  101f16:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  101f1d:	00 
  101f1e:	c7 04 24 ee 39 10 00 	movl   $0x1039ee,(%esp)
  101f25:	e8 8b ed ff ff       	call   100cb5 <__panic>
        break;
  101f2a:	90                   	nop
  101f2b:	eb 07                	jmp    101f34 <trap_dispatch+0x240>
        break;
  101f2d:	90                   	nop
  101f2e:	eb 04                	jmp    101f34 <trap_dispatch+0x240>
        break;
  101f30:	90                   	nop
  101f31:	eb 01                	jmp    101f34 <trap_dispatch+0x240>
        break;
  101f33:	90                   	nop
        }
    }
}
  101f34:	90                   	nop
  101f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101f38:	89 ec                	mov    %ebp,%esp
  101f3a:	5d                   	pop    %ebp
  101f3b:	c3                   	ret    

00101f3c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f3c:	55                   	push   %ebp
  101f3d:	89 e5                	mov    %esp,%ebp
  101f3f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f42:	8b 45 08             	mov    0x8(%ebp),%eax
  101f45:	89 04 24             	mov    %eax,(%esp)
  101f48:	e8 a7 fd ff ff       	call   101cf4 <trap_dispatch>
}
  101f4d:	90                   	nop
  101f4e:	89 ec                	mov    %ebp,%esp
  101f50:	5d                   	pop    %ebp
  101f51:	c3                   	ret    

00101f52 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f52:	1e                   	push   %ds
    pushl %es
  101f53:	06                   	push   %es
    pushl %fs
  101f54:	0f a0                	push   %fs
    pushl %gs
  101f56:	0f a8                	push   %gs
    pushal
  101f58:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f59:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f5e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f60:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f62:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f63:	e8 d4 ff ff ff       	call   101f3c <trap>

    # pop the pushed stack pointer
    popl %esp
  101f68:	5c                   	pop    %esp

00101f69 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f69:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f6a:	0f a9                	pop    %gs
    popl %fs
  101f6c:	0f a1                	pop    %fs
    popl %es
  101f6e:	07                   	pop    %es
    popl %ds
  101f6f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f70:	83 c4 08             	add    $0x8,%esp
    iret
  101f73:	cf                   	iret   

00101f74 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $0
  101f76:	6a 00                	push   $0x0
  jmp __alltraps
  101f78:	e9 d5 ff ff ff       	jmp    101f52 <__alltraps>

00101f7d <vector1>:
.globl vector1
vector1:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $1
  101f7f:	6a 01                	push   $0x1
  jmp __alltraps
  101f81:	e9 cc ff ff ff       	jmp    101f52 <__alltraps>

00101f86 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $2
  101f88:	6a 02                	push   $0x2
  jmp __alltraps
  101f8a:	e9 c3 ff ff ff       	jmp    101f52 <__alltraps>

00101f8f <vector3>:
.globl vector3
vector3:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $3
  101f91:	6a 03                	push   $0x3
  jmp __alltraps
  101f93:	e9 ba ff ff ff       	jmp    101f52 <__alltraps>

00101f98 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $4
  101f9a:	6a 04                	push   $0x4
  jmp __alltraps
  101f9c:	e9 b1 ff ff ff       	jmp    101f52 <__alltraps>

00101fa1 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $5
  101fa3:	6a 05                	push   $0x5
  jmp __alltraps
  101fa5:	e9 a8 ff ff ff       	jmp    101f52 <__alltraps>

00101faa <vector6>:
.globl vector6
vector6:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $6
  101fac:	6a 06                	push   $0x6
  jmp __alltraps
  101fae:	e9 9f ff ff ff       	jmp    101f52 <__alltraps>

00101fb3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $7
  101fb5:	6a 07                	push   $0x7
  jmp __alltraps
  101fb7:	e9 96 ff ff ff       	jmp    101f52 <__alltraps>

00101fbc <vector8>:
.globl vector8
vector8:
  pushl $8
  101fbc:	6a 08                	push   $0x8
  jmp __alltraps
  101fbe:	e9 8f ff ff ff       	jmp    101f52 <__alltraps>

00101fc3 <vector9>:
.globl vector9
vector9:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $9
  101fc5:	6a 09                	push   $0x9
  jmp __alltraps
  101fc7:	e9 86 ff ff ff       	jmp    101f52 <__alltraps>

00101fcc <vector10>:
.globl vector10
vector10:
  pushl $10
  101fcc:	6a 0a                	push   $0xa
  jmp __alltraps
  101fce:	e9 7f ff ff ff       	jmp    101f52 <__alltraps>

00101fd3 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fd3:	6a 0b                	push   $0xb
  jmp __alltraps
  101fd5:	e9 78 ff ff ff       	jmp    101f52 <__alltraps>

00101fda <vector12>:
.globl vector12
vector12:
  pushl $12
  101fda:	6a 0c                	push   $0xc
  jmp __alltraps
  101fdc:	e9 71 ff ff ff       	jmp    101f52 <__alltraps>

00101fe1 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fe1:	6a 0d                	push   $0xd
  jmp __alltraps
  101fe3:	e9 6a ff ff ff       	jmp    101f52 <__alltraps>

00101fe8 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fe8:	6a 0e                	push   $0xe
  jmp __alltraps
  101fea:	e9 63 ff ff ff       	jmp    101f52 <__alltraps>

00101fef <vector15>:
.globl vector15
vector15:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $15
  101ff1:	6a 0f                	push   $0xf
  jmp __alltraps
  101ff3:	e9 5a ff ff ff       	jmp    101f52 <__alltraps>

00101ff8 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $16
  101ffa:	6a 10                	push   $0x10
  jmp __alltraps
  101ffc:	e9 51 ff ff ff       	jmp    101f52 <__alltraps>

00102001 <vector17>:
.globl vector17
vector17:
  pushl $17
  102001:	6a 11                	push   $0x11
  jmp __alltraps
  102003:	e9 4a ff ff ff       	jmp    101f52 <__alltraps>

00102008 <vector18>:
.globl vector18
vector18:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $18
  10200a:	6a 12                	push   $0x12
  jmp __alltraps
  10200c:	e9 41 ff ff ff       	jmp    101f52 <__alltraps>

00102011 <vector19>:
.globl vector19
vector19:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $19
  102013:	6a 13                	push   $0x13
  jmp __alltraps
  102015:	e9 38 ff ff ff       	jmp    101f52 <__alltraps>

0010201a <vector20>:
.globl vector20
vector20:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $20
  10201c:	6a 14                	push   $0x14
  jmp __alltraps
  10201e:	e9 2f ff ff ff       	jmp    101f52 <__alltraps>

00102023 <vector21>:
.globl vector21
vector21:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $21
  102025:	6a 15                	push   $0x15
  jmp __alltraps
  102027:	e9 26 ff ff ff       	jmp    101f52 <__alltraps>

0010202c <vector22>:
.globl vector22
vector22:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $22
  10202e:	6a 16                	push   $0x16
  jmp __alltraps
  102030:	e9 1d ff ff ff       	jmp    101f52 <__alltraps>

00102035 <vector23>:
.globl vector23
vector23:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $23
  102037:	6a 17                	push   $0x17
  jmp __alltraps
  102039:	e9 14 ff ff ff       	jmp    101f52 <__alltraps>

0010203e <vector24>:
.globl vector24
vector24:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $24
  102040:	6a 18                	push   $0x18
  jmp __alltraps
  102042:	e9 0b ff ff ff       	jmp    101f52 <__alltraps>

00102047 <vector25>:
.globl vector25
vector25:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $25
  102049:	6a 19                	push   $0x19
  jmp __alltraps
  10204b:	e9 02 ff ff ff       	jmp    101f52 <__alltraps>

00102050 <vector26>:
.globl vector26
vector26:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $26
  102052:	6a 1a                	push   $0x1a
  jmp __alltraps
  102054:	e9 f9 fe ff ff       	jmp    101f52 <__alltraps>

00102059 <vector27>:
.globl vector27
vector27:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $27
  10205b:	6a 1b                	push   $0x1b
  jmp __alltraps
  10205d:	e9 f0 fe ff ff       	jmp    101f52 <__alltraps>

00102062 <vector28>:
.globl vector28
vector28:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $28
  102064:	6a 1c                	push   $0x1c
  jmp __alltraps
  102066:	e9 e7 fe ff ff       	jmp    101f52 <__alltraps>

0010206b <vector29>:
.globl vector29
vector29:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $29
  10206d:	6a 1d                	push   $0x1d
  jmp __alltraps
  10206f:	e9 de fe ff ff       	jmp    101f52 <__alltraps>

00102074 <vector30>:
.globl vector30
vector30:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $30
  102076:	6a 1e                	push   $0x1e
  jmp __alltraps
  102078:	e9 d5 fe ff ff       	jmp    101f52 <__alltraps>

0010207d <vector31>:
.globl vector31
vector31:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $31
  10207f:	6a 1f                	push   $0x1f
  jmp __alltraps
  102081:	e9 cc fe ff ff       	jmp    101f52 <__alltraps>

00102086 <vector32>:
.globl vector32
vector32:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $32
  102088:	6a 20                	push   $0x20
  jmp __alltraps
  10208a:	e9 c3 fe ff ff       	jmp    101f52 <__alltraps>

0010208f <vector33>:
.globl vector33
vector33:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $33
  102091:	6a 21                	push   $0x21
  jmp __alltraps
  102093:	e9 ba fe ff ff       	jmp    101f52 <__alltraps>

00102098 <vector34>:
.globl vector34
vector34:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $34
  10209a:	6a 22                	push   $0x22
  jmp __alltraps
  10209c:	e9 b1 fe ff ff       	jmp    101f52 <__alltraps>

001020a1 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $35
  1020a3:	6a 23                	push   $0x23
  jmp __alltraps
  1020a5:	e9 a8 fe ff ff       	jmp    101f52 <__alltraps>

001020aa <vector36>:
.globl vector36
vector36:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $36
  1020ac:	6a 24                	push   $0x24
  jmp __alltraps
  1020ae:	e9 9f fe ff ff       	jmp    101f52 <__alltraps>

001020b3 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $37
  1020b5:	6a 25                	push   $0x25
  jmp __alltraps
  1020b7:	e9 96 fe ff ff       	jmp    101f52 <__alltraps>

001020bc <vector38>:
.globl vector38
vector38:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $38
  1020be:	6a 26                	push   $0x26
  jmp __alltraps
  1020c0:	e9 8d fe ff ff       	jmp    101f52 <__alltraps>

001020c5 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $39
  1020c7:	6a 27                	push   $0x27
  jmp __alltraps
  1020c9:	e9 84 fe ff ff       	jmp    101f52 <__alltraps>

001020ce <vector40>:
.globl vector40
vector40:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $40
  1020d0:	6a 28                	push   $0x28
  jmp __alltraps
  1020d2:	e9 7b fe ff ff       	jmp    101f52 <__alltraps>

001020d7 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $41
  1020d9:	6a 29                	push   $0x29
  jmp __alltraps
  1020db:	e9 72 fe ff ff       	jmp    101f52 <__alltraps>

001020e0 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $42
  1020e2:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020e4:	e9 69 fe ff ff       	jmp    101f52 <__alltraps>

001020e9 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $43
  1020eb:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020ed:	e9 60 fe ff ff       	jmp    101f52 <__alltraps>

001020f2 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $44
  1020f4:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020f6:	e9 57 fe ff ff       	jmp    101f52 <__alltraps>

001020fb <vector45>:
.globl vector45
vector45:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $45
  1020fd:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020ff:	e9 4e fe ff ff       	jmp    101f52 <__alltraps>

00102104 <vector46>:
.globl vector46
vector46:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $46
  102106:	6a 2e                	push   $0x2e
  jmp __alltraps
  102108:	e9 45 fe ff ff       	jmp    101f52 <__alltraps>

0010210d <vector47>:
.globl vector47
vector47:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $47
  10210f:	6a 2f                	push   $0x2f
  jmp __alltraps
  102111:	e9 3c fe ff ff       	jmp    101f52 <__alltraps>

00102116 <vector48>:
.globl vector48
vector48:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $48
  102118:	6a 30                	push   $0x30
  jmp __alltraps
  10211a:	e9 33 fe ff ff       	jmp    101f52 <__alltraps>

0010211f <vector49>:
.globl vector49
vector49:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $49
  102121:	6a 31                	push   $0x31
  jmp __alltraps
  102123:	e9 2a fe ff ff       	jmp    101f52 <__alltraps>

00102128 <vector50>:
.globl vector50
vector50:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $50
  10212a:	6a 32                	push   $0x32
  jmp __alltraps
  10212c:	e9 21 fe ff ff       	jmp    101f52 <__alltraps>

00102131 <vector51>:
.globl vector51
vector51:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $51
  102133:	6a 33                	push   $0x33
  jmp __alltraps
  102135:	e9 18 fe ff ff       	jmp    101f52 <__alltraps>

0010213a <vector52>:
.globl vector52
vector52:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $52
  10213c:	6a 34                	push   $0x34
  jmp __alltraps
  10213e:	e9 0f fe ff ff       	jmp    101f52 <__alltraps>

00102143 <vector53>:
.globl vector53
vector53:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $53
  102145:	6a 35                	push   $0x35
  jmp __alltraps
  102147:	e9 06 fe ff ff       	jmp    101f52 <__alltraps>

0010214c <vector54>:
.globl vector54
vector54:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $54
  10214e:	6a 36                	push   $0x36
  jmp __alltraps
  102150:	e9 fd fd ff ff       	jmp    101f52 <__alltraps>

00102155 <vector55>:
.globl vector55
vector55:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $55
  102157:	6a 37                	push   $0x37
  jmp __alltraps
  102159:	e9 f4 fd ff ff       	jmp    101f52 <__alltraps>

0010215e <vector56>:
.globl vector56
vector56:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $56
  102160:	6a 38                	push   $0x38
  jmp __alltraps
  102162:	e9 eb fd ff ff       	jmp    101f52 <__alltraps>

00102167 <vector57>:
.globl vector57
vector57:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $57
  102169:	6a 39                	push   $0x39
  jmp __alltraps
  10216b:	e9 e2 fd ff ff       	jmp    101f52 <__alltraps>

00102170 <vector58>:
.globl vector58
vector58:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $58
  102172:	6a 3a                	push   $0x3a
  jmp __alltraps
  102174:	e9 d9 fd ff ff       	jmp    101f52 <__alltraps>

00102179 <vector59>:
.globl vector59
vector59:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $59
  10217b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10217d:	e9 d0 fd ff ff       	jmp    101f52 <__alltraps>

00102182 <vector60>:
.globl vector60
vector60:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $60
  102184:	6a 3c                	push   $0x3c
  jmp __alltraps
  102186:	e9 c7 fd ff ff       	jmp    101f52 <__alltraps>

0010218b <vector61>:
.globl vector61
vector61:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $61
  10218d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10218f:	e9 be fd ff ff       	jmp    101f52 <__alltraps>

00102194 <vector62>:
.globl vector62
vector62:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $62
  102196:	6a 3e                	push   $0x3e
  jmp __alltraps
  102198:	e9 b5 fd ff ff       	jmp    101f52 <__alltraps>

0010219d <vector63>:
.globl vector63
vector63:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $63
  10219f:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021a1:	e9 ac fd ff ff       	jmp    101f52 <__alltraps>

001021a6 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $64
  1021a8:	6a 40                	push   $0x40
  jmp __alltraps
  1021aa:	e9 a3 fd ff ff       	jmp    101f52 <__alltraps>

001021af <vector65>:
.globl vector65
vector65:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $65
  1021b1:	6a 41                	push   $0x41
  jmp __alltraps
  1021b3:	e9 9a fd ff ff       	jmp    101f52 <__alltraps>

001021b8 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $66
  1021ba:	6a 42                	push   $0x42
  jmp __alltraps
  1021bc:	e9 91 fd ff ff       	jmp    101f52 <__alltraps>

001021c1 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $67
  1021c3:	6a 43                	push   $0x43
  jmp __alltraps
  1021c5:	e9 88 fd ff ff       	jmp    101f52 <__alltraps>

001021ca <vector68>:
.globl vector68
vector68:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $68
  1021cc:	6a 44                	push   $0x44
  jmp __alltraps
  1021ce:	e9 7f fd ff ff       	jmp    101f52 <__alltraps>

001021d3 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $69
  1021d5:	6a 45                	push   $0x45
  jmp __alltraps
  1021d7:	e9 76 fd ff ff       	jmp    101f52 <__alltraps>

001021dc <vector70>:
.globl vector70
vector70:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $70
  1021de:	6a 46                	push   $0x46
  jmp __alltraps
  1021e0:	e9 6d fd ff ff       	jmp    101f52 <__alltraps>

001021e5 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $71
  1021e7:	6a 47                	push   $0x47
  jmp __alltraps
  1021e9:	e9 64 fd ff ff       	jmp    101f52 <__alltraps>

001021ee <vector72>:
.globl vector72
vector72:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $72
  1021f0:	6a 48                	push   $0x48
  jmp __alltraps
  1021f2:	e9 5b fd ff ff       	jmp    101f52 <__alltraps>

001021f7 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $73
  1021f9:	6a 49                	push   $0x49
  jmp __alltraps
  1021fb:	e9 52 fd ff ff       	jmp    101f52 <__alltraps>

00102200 <vector74>:
.globl vector74
vector74:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $74
  102202:	6a 4a                	push   $0x4a
  jmp __alltraps
  102204:	e9 49 fd ff ff       	jmp    101f52 <__alltraps>

00102209 <vector75>:
.globl vector75
vector75:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $75
  10220b:	6a 4b                	push   $0x4b
  jmp __alltraps
  10220d:	e9 40 fd ff ff       	jmp    101f52 <__alltraps>

00102212 <vector76>:
.globl vector76
vector76:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $76
  102214:	6a 4c                	push   $0x4c
  jmp __alltraps
  102216:	e9 37 fd ff ff       	jmp    101f52 <__alltraps>

0010221b <vector77>:
.globl vector77
vector77:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $77
  10221d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10221f:	e9 2e fd ff ff       	jmp    101f52 <__alltraps>

00102224 <vector78>:
.globl vector78
vector78:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $78
  102226:	6a 4e                	push   $0x4e
  jmp __alltraps
  102228:	e9 25 fd ff ff       	jmp    101f52 <__alltraps>

0010222d <vector79>:
.globl vector79
vector79:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $79
  10222f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102231:	e9 1c fd ff ff       	jmp    101f52 <__alltraps>

00102236 <vector80>:
.globl vector80
vector80:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $80
  102238:	6a 50                	push   $0x50
  jmp __alltraps
  10223a:	e9 13 fd ff ff       	jmp    101f52 <__alltraps>

0010223f <vector81>:
.globl vector81
vector81:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $81
  102241:	6a 51                	push   $0x51
  jmp __alltraps
  102243:	e9 0a fd ff ff       	jmp    101f52 <__alltraps>

00102248 <vector82>:
.globl vector82
vector82:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $82
  10224a:	6a 52                	push   $0x52
  jmp __alltraps
  10224c:	e9 01 fd ff ff       	jmp    101f52 <__alltraps>

00102251 <vector83>:
.globl vector83
vector83:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $83
  102253:	6a 53                	push   $0x53
  jmp __alltraps
  102255:	e9 f8 fc ff ff       	jmp    101f52 <__alltraps>

0010225a <vector84>:
.globl vector84
vector84:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $84
  10225c:	6a 54                	push   $0x54
  jmp __alltraps
  10225e:	e9 ef fc ff ff       	jmp    101f52 <__alltraps>

00102263 <vector85>:
.globl vector85
vector85:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $85
  102265:	6a 55                	push   $0x55
  jmp __alltraps
  102267:	e9 e6 fc ff ff       	jmp    101f52 <__alltraps>

0010226c <vector86>:
.globl vector86
vector86:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $86
  10226e:	6a 56                	push   $0x56
  jmp __alltraps
  102270:	e9 dd fc ff ff       	jmp    101f52 <__alltraps>

00102275 <vector87>:
.globl vector87
vector87:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $87
  102277:	6a 57                	push   $0x57
  jmp __alltraps
  102279:	e9 d4 fc ff ff       	jmp    101f52 <__alltraps>

0010227e <vector88>:
.globl vector88
vector88:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $88
  102280:	6a 58                	push   $0x58
  jmp __alltraps
  102282:	e9 cb fc ff ff       	jmp    101f52 <__alltraps>

00102287 <vector89>:
.globl vector89
vector89:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $89
  102289:	6a 59                	push   $0x59
  jmp __alltraps
  10228b:	e9 c2 fc ff ff       	jmp    101f52 <__alltraps>

00102290 <vector90>:
.globl vector90
vector90:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $90
  102292:	6a 5a                	push   $0x5a
  jmp __alltraps
  102294:	e9 b9 fc ff ff       	jmp    101f52 <__alltraps>

00102299 <vector91>:
.globl vector91
vector91:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $91
  10229b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10229d:	e9 b0 fc ff ff       	jmp    101f52 <__alltraps>

001022a2 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $92
  1022a4:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022a6:	e9 a7 fc ff ff       	jmp    101f52 <__alltraps>

001022ab <vector93>:
.globl vector93
vector93:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $93
  1022ad:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022af:	e9 9e fc ff ff       	jmp    101f52 <__alltraps>

001022b4 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $94
  1022b6:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022b8:	e9 95 fc ff ff       	jmp    101f52 <__alltraps>

001022bd <vector95>:
.globl vector95
vector95:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $95
  1022bf:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022c1:	e9 8c fc ff ff       	jmp    101f52 <__alltraps>

001022c6 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $96
  1022c8:	6a 60                	push   $0x60
  jmp __alltraps
  1022ca:	e9 83 fc ff ff       	jmp    101f52 <__alltraps>

001022cf <vector97>:
.globl vector97
vector97:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $97
  1022d1:	6a 61                	push   $0x61
  jmp __alltraps
  1022d3:	e9 7a fc ff ff       	jmp    101f52 <__alltraps>

001022d8 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $98
  1022da:	6a 62                	push   $0x62
  jmp __alltraps
  1022dc:	e9 71 fc ff ff       	jmp    101f52 <__alltraps>

001022e1 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $99
  1022e3:	6a 63                	push   $0x63
  jmp __alltraps
  1022e5:	e9 68 fc ff ff       	jmp    101f52 <__alltraps>

001022ea <vector100>:
.globl vector100
vector100:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $100
  1022ec:	6a 64                	push   $0x64
  jmp __alltraps
  1022ee:	e9 5f fc ff ff       	jmp    101f52 <__alltraps>

001022f3 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $101
  1022f5:	6a 65                	push   $0x65
  jmp __alltraps
  1022f7:	e9 56 fc ff ff       	jmp    101f52 <__alltraps>

001022fc <vector102>:
.globl vector102
vector102:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $102
  1022fe:	6a 66                	push   $0x66
  jmp __alltraps
  102300:	e9 4d fc ff ff       	jmp    101f52 <__alltraps>

00102305 <vector103>:
.globl vector103
vector103:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $103
  102307:	6a 67                	push   $0x67
  jmp __alltraps
  102309:	e9 44 fc ff ff       	jmp    101f52 <__alltraps>

0010230e <vector104>:
.globl vector104
vector104:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $104
  102310:	6a 68                	push   $0x68
  jmp __alltraps
  102312:	e9 3b fc ff ff       	jmp    101f52 <__alltraps>

00102317 <vector105>:
.globl vector105
vector105:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $105
  102319:	6a 69                	push   $0x69
  jmp __alltraps
  10231b:	e9 32 fc ff ff       	jmp    101f52 <__alltraps>

00102320 <vector106>:
.globl vector106
vector106:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $106
  102322:	6a 6a                	push   $0x6a
  jmp __alltraps
  102324:	e9 29 fc ff ff       	jmp    101f52 <__alltraps>

00102329 <vector107>:
.globl vector107
vector107:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $107
  10232b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10232d:	e9 20 fc ff ff       	jmp    101f52 <__alltraps>

00102332 <vector108>:
.globl vector108
vector108:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $108
  102334:	6a 6c                	push   $0x6c
  jmp __alltraps
  102336:	e9 17 fc ff ff       	jmp    101f52 <__alltraps>

0010233b <vector109>:
.globl vector109
vector109:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $109
  10233d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10233f:	e9 0e fc ff ff       	jmp    101f52 <__alltraps>

00102344 <vector110>:
.globl vector110
vector110:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $110
  102346:	6a 6e                	push   $0x6e
  jmp __alltraps
  102348:	e9 05 fc ff ff       	jmp    101f52 <__alltraps>

0010234d <vector111>:
.globl vector111
vector111:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $111
  10234f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102351:	e9 fc fb ff ff       	jmp    101f52 <__alltraps>

00102356 <vector112>:
.globl vector112
vector112:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $112
  102358:	6a 70                	push   $0x70
  jmp __alltraps
  10235a:	e9 f3 fb ff ff       	jmp    101f52 <__alltraps>

0010235f <vector113>:
.globl vector113
vector113:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $113
  102361:	6a 71                	push   $0x71
  jmp __alltraps
  102363:	e9 ea fb ff ff       	jmp    101f52 <__alltraps>

00102368 <vector114>:
.globl vector114
vector114:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $114
  10236a:	6a 72                	push   $0x72
  jmp __alltraps
  10236c:	e9 e1 fb ff ff       	jmp    101f52 <__alltraps>

00102371 <vector115>:
.globl vector115
vector115:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $115
  102373:	6a 73                	push   $0x73
  jmp __alltraps
  102375:	e9 d8 fb ff ff       	jmp    101f52 <__alltraps>

0010237a <vector116>:
.globl vector116
vector116:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $116
  10237c:	6a 74                	push   $0x74
  jmp __alltraps
  10237e:	e9 cf fb ff ff       	jmp    101f52 <__alltraps>

00102383 <vector117>:
.globl vector117
vector117:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $117
  102385:	6a 75                	push   $0x75
  jmp __alltraps
  102387:	e9 c6 fb ff ff       	jmp    101f52 <__alltraps>

0010238c <vector118>:
.globl vector118
vector118:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $118
  10238e:	6a 76                	push   $0x76
  jmp __alltraps
  102390:	e9 bd fb ff ff       	jmp    101f52 <__alltraps>

00102395 <vector119>:
.globl vector119
vector119:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $119
  102397:	6a 77                	push   $0x77
  jmp __alltraps
  102399:	e9 b4 fb ff ff       	jmp    101f52 <__alltraps>

0010239e <vector120>:
.globl vector120
vector120:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $120
  1023a0:	6a 78                	push   $0x78
  jmp __alltraps
  1023a2:	e9 ab fb ff ff       	jmp    101f52 <__alltraps>

001023a7 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $121
  1023a9:	6a 79                	push   $0x79
  jmp __alltraps
  1023ab:	e9 a2 fb ff ff       	jmp    101f52 <__alltraps>

001023b0 <vector122>:
.globl vector122
vector122:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $122
  1023b2:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023b4:	e9 99 fb ff ff       	jmp    101f52 <__alltraps>

001023b9 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $123
  1023bb:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023bd:	e9 90 fb ff ff       	jmp    101f52 <__alltraps>

001023c2 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $124
  1023c4:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023c6:	e9 87 fb ff ff       	jmp    101f52 <__alltraps>

001023cb <vector125>:
.globl vector125
vector125:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $125
  1023cd:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023cf:	e9 7e fb ff ff       	jmp    101f52 <__alltraps>

001023d4 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $126
  1023d6:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023d8:	e9 75 fb ff ff       	jmp    101f52 <__alltraps>

001023dd <vector127>:
.globl vector127
vector127:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $127
  1023df:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023e1:	e9 6c fb ff ff       	jmp    101f52 <__alltraps>

001023e6 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $128
  1023e8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023ed:	e9 60 fb ff ff       	jmp    101f52 <__alltraps>

001023f2 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $129
  1023f4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023f9:	e9 54 fb ff ff       	jmp    101f52 <__alltraps>

001023fe <vector130>:
.globl vector130
vector130:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $130
  102400:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102405:	e9 48 fb ff ff       	jmp    101f52 <__alltraps>

0010240a <vector131>:
.globl vector131
vector131:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $131
  10240c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102411:	e9 3c fb ff ff       	jmp    101f52 <__alltraps>

00102416 <vector132>:
.globl vector132
vector132:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $132
  102418:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10241d:	e9 30 fb ff ff       	jmp    101f52 <__alltraps>

00102422 <vector133>:
.globl vector133
vector133:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $133
  102424:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102429:	e9 24 fb ff ff       	jmp    101f52 <__alltraps>

0010242e <vector134>:
.globl vector134
vector134:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $134
  102430:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102435:	e9 18 fb ff ff       	jmp    101f52 <__alltraps>

0010243a <vector135>:
.globl vector135
vector135:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $135
  10243c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102441:	e9 0c fb ff ff       	jmp    101f52 <__alltraps>

00102446 <vector136>:
.globl vector136
vector136:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $136
  102448:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10244d:	e9 00 fb ff ff       	jmp    101f52 <__alltraps>

00102452 <vector137>:
.globl vector137
vector137:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $137
  102454:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102459:	e9 f4 fa ff ff       	jmp    101f52 <__alltraps>

0010245e <vector138>:
.globl vector138
vector138:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $138
  102460:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102465:	e9 e8 fa ff ff       	jmp    101f52 <__alltraps>

0010246a <vector139>:
.globl vector139
vector139:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $139
  10246c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102471:	e9 dc fa ff ff       	jmp    101f52 <__alltraps>

00102476 <vector140>:
.globl vector140
vector140:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $140
  102478:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10247d:	e9 d0 fa ff ff       	jmp    101f52 <__alltraps>

00102482 <vector141>:
.globl vector141
vector141:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $141
  102484:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102489:	e9 c4 fa ff ff       	jmp    101f52 <__alltraps>

0010248e <vector142>:
.globl vector142
vector142:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $142
  102490:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102495:	e9 b8 fa ff ff       	jmp    101f52 <__alltraps>

0010249a <vector143>:
.globl vector143
vector143:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $143
  10249c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024a1:	e9 ac fa ff ff       	jmp    101f52 <__alltraps>

001024a6 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $144
  1024a8:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024ad:	e9 a0 fa ff ff       	jmp    101f52 <__alltraps>

001024b2 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $145
  1024b4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024b9:	e9 94 fa ff ff       	jmp    101f52 <__alltraps>

001024be <vector146>:
.globl vector146
vector146:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $146
  1024c0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024c5:	e9 88 fa ff ff       	jmp    101f52 <__alltraps>

001024ca <vector147>:
.globl vector147
vector147:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $147
  1024cc:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024d1:	e9 7c fa ff ff       	jmp    101f52 <__alltraps>

001024d6 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $148
  1024d8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024dd:	e9 70 fa ff ff       	jmp    101f52 <__alltraps>

001024e2 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $149
  1024e4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024e9:	e9 64 fa ff ff       	jmp    101f52 <__alltraps>

001024ee <vector150>:
.globl vector150
vector150:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $150
  1024f0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024f5:	e9 58 fa ff ff       	jmp    101f52 <__alltraps>

001024fa <vector151>:
.globl vector151
vector151:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $151
  1024fc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102501:	e9 4c fa ff ff       	jmp    101f52 <__alltraps>

00102506 <vector152>:
.globl vector152
vector152:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $152
  102508:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10250d:	e9 40 fa ff ff       	jmp    101f52 <__alltraps>

00102512 <vector153>:
.globl vector153
vector153:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $153
  102514:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102519:	e9 34 fa ff ff       	jmp    101f52 <__alltraps>

0010251e <vector154>:
.globl vector154
vector154:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $154
  102520:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102525:	e9 28 fa ff ff       	jmp    101f52 <__alltraps>

0010252a <vector155>:
.globl vector155
vector155:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $155
  10252c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102531:	e9 1c fa ff ff       	jmp    101f52 <__alltraps>

00102536 <vector156>:
.globl vector156
vector156:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $156
  102538:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10253d:	e9 10 fa ff ff       	jmp    101f52 <__alltraps>

00102542 <vector157>:
.globl vector157
vector157:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $157
  102544:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102549:	e9 04 fa ff ff       	jmp    101f52 <__alltraps>

0010254e <vector158>:
.globl vector158
vector158:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $158
  102550:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102555:	e9 f8 f9 ff ff       	jmp    101f52 <__alltraps>

0010255a <vector159>:
.globl vector159
vector159:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $159
  10255c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102561:	e9 ec f9 ff ff       	jmp    101f52 <__alltraps>

00102566 <vector160>:
.globl vector160
vector160:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $160
  102568:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10256d:	e9 e0 f9 ff ff       	jmp    101f52 <__alltraps>

00102572 <vector161>:
.globl vector161
vector161:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $161
  102574:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102579:	e9 d4 f9 ff ff       	jmp    101f52 <__alltraps>

0010257e <vector162>:
.globl vector162
vector162:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $162
  102580:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102585:	e9 c8 f9 ff ff       	jmp    101f52 <__alltraps>

0010258a <vector163>:
.globl vector163
vector163:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $163
  10258c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102591:	e9 bc f9 ff ff       	jmp    101f52 <__alltraps>

00102596 <vector164>:
.globl vector164
vector164:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $164
  102598:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10259d:	e9 b0 f9 ff ff       	jmp    101f52 <__alltraps>

001025a2 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $165
  1025a4:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025a9:	e9 a4 f9 ff ff       	jmp    101f52 <__alltraps>

001025ae <vector166>:
.globl vector166
vector166:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $166
  1025b0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025b5:	e9 98 f9 ff ff       	jmp    101f52 <__alltraps>

001025ba <vector167>:
.globl vector167
vector167:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $167
  1025bc:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025c1:	e9 8c f9 ff ff       	jmp    101f52 <__alltraps>

001025c6 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $168
  1025c8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025cd:	e9 80 f9 ff ff       	jmp    101f52 <__alltraps>

001025d2 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $169
  1025d4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025d9:	e9 74 f9 ff ff       	jmp    101f52 <__alltraps>

001025de <vector170>:
.globl vector170
vector170:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $170
  1025e0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025e5:	e9 68 f9 ff ff       	jmp    101f52 <__alltraps>

001025ea <vector171>:
.globl vector171
vector171:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $171
  1025ec:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025f1:	e9 5c f9 ff ff       	jmp    101f52 <__alltraps>

001025f6 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $172
  1025f8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025fd:	e9 50 f9 ff ff       	jmp    101f52 <__alltraps>

00102602 <vector173>:
.globl vector173
vector173:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $173
  102604:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102609:	e9 44 f9 ff ff       	jmp    101f52 <__alltraps>

0010260e <vector174>:
.globl vector174
vector174:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $174
  102610:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102615:	e9 38 f9 ff ff       	jmp    101f52 <__alltraps>

0010261a <vector175>:
.globl vector175
vector175:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $175
  10261c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102621:	e9 2c f9 ff ff       	jmp    101f52 <__alltraps>

00102626 <vector176>:
.globl vector176
vector176:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $176
  102628:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10262d:	e9 20 f9 ff ff       	jmp    101f52 <__alltraps>

00102632 <vector177>:
.globl vector177
vector177:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $177
  102634:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102639:	e9 14 f9 ff ff       	jmp    101f52 <__alltraps>

0010263e <vector178>:
.globl vector178
vector178:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $178
  102640:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102645:	e9 08 f9 ff ff       	jmp    101f52 <__alltraps>

0010264a <vector179>:
.globl vector179
vector179:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $179
  10264c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102651:	e9 fc f8 ff ff       	jmp    101f52 <__alltraps>

00102656 <vector180>:
.globl vector180
vector180:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $180
  102658:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10265d:	e9 f0 f8 ff ff       	jmp    101f52 <__alltraps>

00102662 <vector181>:
.globl vector181
vector181:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $181
  102664:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102669:	e9 e4 f8 ff ff       	jmp    101f52 <__alltraps>

0010266e <vector182>:
.globl vector182
vector182:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $182
  102670:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102675:	e9 d8 f8 ff ff       	jmp    101f52 <__alltraps>

0010267a <vector183>:
.globl vector183
vector183:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $183
  10267c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102681:	e9 cc f8 ff ff       	jmp    101f52 <__alltraps>

00102686 <vector184>:
.globl vector184
vector184:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $184
  102688:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10268d:	e9 c0 f8 ff ff       	jmp    101f52 <__alltraps>

00102692 <vector185>:
.globl vector185
vector185:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $185
  102694:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102699:	e9 b4 f8 ff ff       	jmp    101f52 <__alltraps>

0010269e <vector186>:
.globl vector186
vector186:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $186
  1026a0:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026a5:	e9 a8 f8 ff ff       	jmp    101f52 <__alltraps>

001026aa <vector187>:
.globl vector187
vector187:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $187
  1026ac:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026b1:	e9 9c f8 ff ff       	jmp    101f52 <__alltraps>

001026b6 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $188
  1026b8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026bd:	e9 90 f8 ff ff       	jmp    101f52 <__alltraps>

001026c2 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $189
  1026c4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026c9:	e9 84 f8 ff ff       	jmp    101f52 <__alltraps>

001026ce <vector190>:
.globl vector190
vector190:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $190
  1026d0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026d5:	e9 78 f8 ff ff       	jmp    101f52 <__alltraps>

001026da <vector191>:
.globl vector191
vector191:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $191
  1026dc:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026e1:	e9 6c f8 ff ff       	jmp    101f52 <__alltraps>

001026e6 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $192
  1026e8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026ed:	e9 60 f8 ff ff       	jmp    101f52 <__alltraps>

001026f2 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $193
  1026f4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026f9:	e9 54 f8 ff ff       	jmp    101f52 <__alltraps>

001026fe <vector194>:
.globl vector194
vector194:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $194
  102700:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102705:	e9 48 f8 ff ff       	jmp    101f52 <__alltraps>

0010270a <vector195>:
.globl vector195
vector195:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $195
  10270c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102711:	e9 3c f8 ff ff       	jmp    101f52 <__alltraps>

00102716 <vector196>:
.globl vector196
vector196:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $196
  102718:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10271d:	e9 30 f8 ff ff       	jmp    101f52 <__alltraps>

00102722 <vector197>:
.globl vector197
vector197:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $197
  102724:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102729:	e9 24 f8 ff ff       	jmp    101f52 <__alltraps>

0010272e <vector198>:
.globl vector198
vector198:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $198
  102730:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102735:	e9 18 f8 ff ff       	jmp    101f52 <__alltraps>

0010273a <vector199>:
.globl vector199
vector199:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $199
  10273c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102741:	e9 0c f8 ff ff       	jmp    101f52 <__alltraps>

00102746 <vector200>:
.globl vector200
vector200:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $200
  102748:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10274d:	e9 00 f8 ff ff       	jmp    101f52 <__alltraps>

00102752 <vector201>:
.globl vector201
vector201:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $201
  102754:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102759:	e9 f4 f7 ff ff       	jmp    101f52 <__alltraps>

0010275e <vector202>:
.globl vector202
vector202:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $202
  102760:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102765:	e9 e8 f7 ff ff       	jmp    101f52 <__alltraps>

0010276a <vector203>:
.globl vector203
vector203:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $203
  10276c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102771:	e9 dc f7 ff ff       	jmp    101f52 <__alltraps>

00102776 <vector204>:
.globl vector204
vector204:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $204
  102778:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10277d:	e9 d0 f7 ff ff       	jmp    101f52 <__alltraps>

00102782 <vector205>:
.globl vector205
vector205:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $205
  102784:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102789:	e9 c4 f7 ff ff       	jmp    101f52 <__alltraps>

0010278e <vector206>:
.globl vector206
vector206:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $206
  102790:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102795:	e9 b8 f7 ff ff       	jmp    101f52 <__alltraps>

0010279a <vector207>:
.globl vector207
vector207:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $207
  10279c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027a1:	e9 ac f7 ff ff       	jmp    101f52 <__alltraps>

001027a6 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $208
  1027a8:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027ad:	e9 a0 f7 ff ff       	jmp    101f52 <__alltraps>

001027b2 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $209
  1027b4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027b9:	e9 94 f7 ff ff       	jmp    101f52 <__alltraps>

001027be <vector210>:
.globl vector210
vector210:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $210
  1027c0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027c5:	e9 88 f7 ff ff       	jmp    101f52 <__alltraps>

001027ca <vector211>:
.globl vector211
vector211:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $211
  1027cc:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027d1:	e9 7c f7 ff ff       	jmp    101f52 <__alltraps>

001027d6 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $212
  1027d8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027dd:	e9 70 f7 ff ff       	jmp    101f52 <__alltraps>

001027e2 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $213
  1027e4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027e9:	e9 64 f7 ff ff       	jmp    101f52 <__alltraps>

001027ee <vector214>:
.globl vector214
vector214:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $214
  1027f0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027f5:	e9 58 f7 ff ff       	jmp    101f52 <__alltraps>

001027fa <vector215>:
.globl vector215
vector215:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $215
  1027fc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102801:	e9 4c f7 ff ff       	jmp    101f52 <__alltraps>

00102806 <vector216>:
.globl vector216
vector216:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $216
  102808:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10280d:	e9 40 f7 ff ff       	jmp    101f52 <__alltraps>

00102812 <vector217>:
.globl vector217
vector217:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $217
  102814:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102819:	e9 34 f7 ff ff       	jmp    101f52 <__alltraps>

0010281e <vector218>:
.globl vector218
vector218:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $218
  102820:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102825:	e9 28 f7 ff ff       	jmp    101f52 <__alltraps>

0010282a <vector219>:
.globl vector219
vector219:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $219
  10282c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102831:	e9 1c f7 ff ff       	jmp    101f52 <__alltraps>

00102836 <vector220>:
.globl vector220
vector220:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $220
  102838:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10283d:	e9 10 f7 ff ff       	jmp    101f52 <__alltraps>

00102842 <vector221>:
.globl vector221
vector221:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $221
  102844:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102849:	e9 04 f7 ff ff       	jmp    101f52 <__alltraps>

0010284e <vector222>:
.globl vector222
vector222:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $222
  102850:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102855:	e9 f8 f6 ff ff       	jmp    101f52 <__alltraps>

0010285a <vector223>:
.globl vector223
vector223:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $223
  10285c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102861:	e9 ec f6 ff ff       	jmp    101f52 <__alltraps>

00102866 <vector224>:
.globl vector224
vector224:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $224
  102868:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10286d:	e9 e0 f6 ff ff       	jmp    101f52 <__alltraps>

00102872 <vector225>:
.globl vector225
vector225:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $225
  102874:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102879:	e9 d4 f6 ff ff       	jmp    101f52 <__alltraps>

0010287e <vector226>:
.globl vector226
vector226:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $226
  102880:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102885:	e9 c8 f6 ff ff       	jmp    101f52 <__alltraps>

0010288a <vector227>:
.globl vector227
vector227:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $227
  10288c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102891:	e9 bc f6 ff ff       	jmp    101f52 <__alltraps>

00102896 <vector228>:
.globl vector228
vector228:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $228
  102898:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10289d:	e9 b0 f6 ff ff       	jmp    101f52 <__alltraps>

001028a2 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $229
  1028a4:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028a9:	e9 a4 f6 ff ff       	jmp    101f52 <__alltraps>

001028ae <vector230>:
.globl vector230
vector230:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $230
  1028b0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028b5:	e9 98 f6 ff ff       	jmp    101f52 <__alltraps>

001028ba <vector231>:
.globl vector231
vector231:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $231
  1028bc:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028c1:	e9 8c f6 ff ff       	jmp    101f52 <__alltraps>

001028c6 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $232
  1028c8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028cd:	e9 80 f6 ff ff       	jmp    101f52 <__alltraps>

001028d2 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $233
  1028d4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028d9:	e9 74 f6 ff ff       	jmp    101f52 <__alltraps>

001028de <vector234>:
.globl vector234
vector234:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $234
  1028e0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028e5:	e9 68 f6 ff ff       	jmp    101f52 <__alltraps>

001028ea <vector235>:
.globl vector235
vector235:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $235
  1028ec:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028f1:	e9 5c f6 ff ff       	jmp    101f52 <__alltraps>

001028f6 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $236
  1028f8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028fd:	e9 50 f6 ff ff       	jmp    101f52 <__alltraps>

00102902 <vector237>:
.globl vector237
vector237:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $237
  102904:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102909:	e9 44 f6 ff ff       	jmp    101f52 <__alltraps>

0010290e <vector238>:
.globl vector238
vector238:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $238
  102910:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102915:	e9 38 f6 ff ff       	jmp    101f52 <__alltraps>

0010291a <vector239>:
.globl vector239
vector239:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $239
  10291c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102921:	e9 2c f6 ff ff       	jmp    101f52 <__alltraps>

00102926 <vector240>:
.globl vector240
vector240:
  pushl $0
  102926:	6a 00                	push   $0x0
  pushl $240
  102928:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10292d:	e9 20 f6 ff ff       	jmp    101f52 <__alltraps>

00102932 <vector241>:
.globl vector241
vector241:
  pushl $0
  102932:	6a 00                	push   $0x0
  pushl $241
  102934:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102939:	e9 14 f6 ff ff       	jmp    101f52 <__alltraps>

0010293e <vector242>:
.globl vector242
vector242:
  pushl $0
  10293e:	6a 00                	push   $0x0
  pushl $242
  102940:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102945:	e9 08 f6 ff ff       	jmp    101f52 <__alltraps>

0010294a <vector243>:
.globl vector243
vector243:
  pushl $0
  10294a:	6a 00                	push   $0x0
  pushl $243
  10294c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102951:	e9 fc f5 ff ff       	jmp    101f52 <__alltraps>

00102956 <vector244>:
.globl vector244
vector244:
  pushl $0
  102956:	6a 00                	push   $0x0
  pushl $244
  102958:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10295d:	e9 f0 f5 ff ff       	jmp    101f52 <__alltraps>

00102962 <vector245>:
.globl vector245
vector245:
  pushl $0
  102962:	6a 00                	push   $0x0
  pushl $245
  102964:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102969:	e9 e4 f5 ff ff       	jmp    101f52 <__alltraps>

0010296e <vector246>:
.globl vector246
vector246:
  pushl $0
  10296e:	6a 00                	push   $0x0
  pushl $246
  102970:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102975:	e9 d8 f5 ff ff       	jmp    101f52 <__alltraps>

0010297a <vector247>:
.globl vector247
vector247:
  pushl $0
  10297a:	6a 00                	push   $0x0
  pushl $247
  10297c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102981:	e9 cc f5 ff ff       	jmp    101f52 <__alltraps>

00102986 <vector248>:
.globl vector248
vector248:
  pushl $0
  102986:	6a 00                	push   $0x0
  pushl $248
  102988:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10298d:	e9 c0 f5 ff ff       	jmp    101f52 <__alltraps>

00102992 <vector249>:
.globl vector249
vector249:
  pushl $0
  102992:	6a 00                	push   $0x0
  pushl $249
  102994:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102999:	e9 b4 f5 ff ff       	jmp    101f52 <__alltraps>

0010299e <vector250>:
.globl vector250
vector250:
  pushl $0
  10299e:	6a 00                	push   $0x0
  pushl $250
  1029a0:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029a5:	e9 a8 f5 ff ff       	jmp    101f52 <__alltraps>

001029aa <vector251>:
.globl vector251
vector251:
  pushl $0
  1029aa:	6a 00                	push   $0x0
  pushl $251
  1029ac:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029b1:	e9 9c f5 ff ff       	jmp    101f52 <__alltraps>

001029b6 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029b6:	6a 00                	push   $0x0
  pushl $252
  1029b8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029bd:	e9 90 f5 ff ff       	jmp    101f52 <__alltraps>

001029c2 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029c2:	6a 00                	push   $0x0
  pushl $253
  1029c4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029c9:	e9 84 f5 ff ff       	jmp    101f52 <__alltraps>

001029ce <vector254>:
.globl vector254
vector254:
  pushl $0
  1029ce:	6a 00                	push   $0x0
  pushl $254
  1029d0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029d5:	e9 78 f5 ff ff       	jmp    101f52 <__alltraps>

001029da <vector255>:
.globl vector255
vector255:
  pushl $0
  1029da:	6a 00                	push   $0x0
  pushl $255
  1029dc:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029e1:	e9 6c f5 ff ff       	jmp    101f52 <__alltraps>

001029e6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029e6:	55                   	push   %ebp
  1029e7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ec:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029ef:	b8 23 00 00 00       	mov    $0x23,%eax
  1029f4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029f6:	b8 23 00 00 00       	mov    $0x23,%eax
  1029fb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029fd:	b8 10 00 00 00       	mov    $0x10,%eax
  102a02:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a04:	b8 10 00 00 00       	mov    $0x10,%eax
  102a09:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a0b:	b8 10 00 00 00       	mov    $0x10,%eax
  102a10:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a12:	ea 19 2a 10 00 08 00 	ljmp   $0x8,$0x102a19
}
  102a19:	90                   	nop
  102a1a:	5d                   	pop    %ebp
  102a1b:	c3                   	ret    

00102a1c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a1c:	55                   	push   %ebp
  102a1d:	89 e5                	mov    %esp,%ebp
  102a1f:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a22:	b8 00 09 11 00       	mov    $0x110900,%eax
  102a27:	05 00 04 00 00       	add    $0x400,%eax
  102a2c:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  102a31:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  102a38:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a3a:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102a41:	68 00 
  102a43:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a48:	0f b7 c0             	movzwl %ax,%eax
  102a4b:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102a51:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a56:	c1 e8 10             	shr    $0x10,%eax
  102a59:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102a5e:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a65:	24 f0                	and    $0xf0,%al
  102a67:	0c 09                	or     $0x9,%al
  102a69:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a6e:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a75:	0c 10                	or     $0x10,%al
  102a77:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a7c:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a83:	24 9f                	and    $0x9f,%al
  102a85:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a8a:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a91:	0c 80                	or     $0x80,%al
  102a93:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a98:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a9f:	24 f0                	and    $0xf0,%al
  102aa1:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102aa6:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102aad:	24 ef                	and    $0xef,%al
  102aaf:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ab4:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102abb:	24 df                	and    $0xdf,%al
  102abd:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ac2:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ac9:	0c 40                	or     $0x40,%al
  102acb:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ad0:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ad7:	24 7f                	and    $0x7f,%al
  102ad9:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ade:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102ae3:	c1 e8 18             	shr    $0x18,%eax
  102ae6:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102aeb:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102af2:	24 ef                	and    $0xef,%al
  102af4:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102af9:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102b00:	e8 e1 fe ff ff       	call   1029e6 <lgdt>
  102b05:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102b0b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b0f:	0f 00 d8             	ltr    %ax
}
  102b12:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102b13:	90                   	nop
  102b14:	89 ec                	mov    %ebp,%esp
  102b16:	5d                   	pop    %ebp
  102b17:	c3                   	ret    

00102b18 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b18:	55                   	push   %ebp
  102b19:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b1b:	e8 fc fe ff ff       	call   102a1c <gdt_init>
}
  102b20:	90                   	nop
  102b21:	5d                   	pop    %ebp
  102b22:	c3                   	ret    

00102b23 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102b23:	55                   	push   %ebp
  102b24:	89 e5                	mov    %esp,%ebp
  102b26:	83 ec 58             	sub    $0x58,%esp
  102b29:	8b 45 10             	mov    0x10(%ebp),%eax
  102b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  102b32:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102b35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b38:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b3e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102b41:	8b 45 18             	mov    0x18(%ebp),%eax
  102b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b50:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b5d:	74 1c                	je     102b7b <printnum+0x58>
  102b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b62:	ba 00 00 00 00       	mov    $0x0,%edx
  102b67:	f7 75 e4             	divl   -0x1c(%ebp)
  102b6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b70:	ba 00 00 00 00       	mov    $0x0,%edx
  102b75:	f7 75 e4             	divl   -0x1c(%ebp)
  102b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b81:	f7 75 e4             	divl   -0x1c(%ebp)
  102b84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b87:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b90:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b93:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b99:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b9c:	8b 45 18             	mov    0x18(%ebp),%eax
  102b9f:	ba 00 00 00 00       	mov    $0x0,%edx
  102ba4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102ba7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102baa:	19 d1                	sbb    %edx,%ecx
  102bac:	72 4c                	jb     102bfa <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102bae:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102bb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  102bb4:	8b 45 20             	mov    0x20(%ebp),%eax
  102bb7:	89 44 24 18          	mov    %eax,0x18(%esp)
  102bbb:	89 54 24 14          	mov    %edx,0x14(%esp)
  102bbf:	8b 45 18             	mov    0x18(%ebp),%eax
  102bc2:	89 44 24 10          	mov    %eax,0x10(%esp)
  102bc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bd0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bde:	89 04 24             	mov    %eax,(%esp)
  102be1:	e8 3d ff ff ff       	call   102b23 <printnum>
  102be6:	eb 1b                	jmp    102c03 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bef:	8b 45 20             	mov    0x20(%ebp),%eax
  102bf2:	89 04 24             	mov    %eax,(%esp)
  102bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf8:	ff d0                	call   *%eax
        while (-- width > 0)
  102bfa:	ff 4d 1c             	decl   0x1c(%ebp)
  102bfd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102c01:	7f e5                	jg     102be8 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102c03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c06:	05 10 3e 10 00       	add    $0x103e10,%eax
  102c0b:	0f b6 00             	movzbl (%eax),%eax
  102c0e:	0f be c0             	movsbl %al,%eax
  102c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c14:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c18:	89 04 24             	mov    %eax,(%esp)
  102c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1e:	ff d0                	call   *%eax
}
  102c20:	90                   	nop
  102c21:	89 ec                	mov    %ebp,%esp
  102c23:	5d                   	pop    %ebp
  102c24:	c3                   	ret    

00102c25 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102c25:	55                   	push   %ebp
  102c26:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c28:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c2c:	7e 14                	jle    102c42 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c31:	8b 00                	mov    (%eax),%eax
  102c33:	8d 48 08             	lea    0x8(%eax),%ecx
  102c36:	8b 55 08             	mov    0x8(%ebp),%edx
  102c39:	89 0a                	mov    %ecx,(%edx)
  102c3b:	8b 50 04             	mov    0x4(%eax),%edx
  102c3e:	8b 00                	mov    (%eax),%eax
  102c40:	eb 30                	jmp    102c72 <getuint+0x4d>
    }
    else if (lflag) {
  102c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c46:	74 16                	je     102c5e <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102c48:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4b:	8b 00                	mov    (%eax),%eax
  102c4d:	8d 48 04             	lea    0x4(%eax),%ecx
  102c50:	8b 55 08             	mov    0x8(%ebp),%edx
  102c53:	89 0a                	mov    %ecx,(%edx)
  102c55:	8b 00                	mov    (%eax),%eax
  102c57:	ba 00 00 00 00       	mov    $0x0,%edx
  102c5c:	eb 14                	jmp    102c72 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c61:	8b 00                	mov    (%eax),%eax
  102c63:	8d 48 04             	lea    0x4(%eax),%ecx
  102c66:	8b 55 08             	mov    0x8(%ebp),%edx
  102c69:	89 0a                	mov    %ecx,(%edx)
  102c6b:	8b 00                	mov    (%eax),%eax
  102c6d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c72:	5d                   	pop    %ebp
  102c73:	c3                   	ret    

00102c74 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c74:	55                   	push   %ebp
  102c75:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c77:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c7b:	7e 14                	jle    102c91 <getint+0x1d>
        return va_arg(*ap, long long);
  102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c80:	8b 00                	mov    (%eax),%eax
  102c82:	8d 48 08             	lea    0x8(%eax),%ecx
  102c85:	8b 55 08             	mov    0x8(%ebp),%edx
  102c88:	89 0a                	mov    %ecx,(%edx)
  102c8a:	8b 50 04             	mov    0x4(%eax),%edx
  102c8d:	8b 00                	mov    (%eax),%eax
  102c8f:	eb 28                	jmp    102cb9 <getint+0x45>
    }
    else if (lflag) {
  102c91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c95:	74 12                	je     102ca9 <getint+0x35>
        return va_arg(*ap, long);
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	8b 00                	mov    (%eax),%eax
  102c9c:	8d 48 04             	lea    0x4(%eax),%ecx
  102c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  102ca2:	89 0a                	mov    %ecx,(%edx)
  102ca4:	8b 00                	mov    (%eax),%eax
  102ca6:	99                   	cltd   
  102ca7:	eb 10                	jmp    102cb9 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cac:	8b 00                	mov    (%eax),%eax
  102cae:	8d 48 04             	lea    0x4(%eax),%ecx
  102cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  102cb4:	89 0a                	mov    %ecx,(%edx)
  102cb6:	8b 00                	mov    (%eax),%eax
  102cb8:	99                   	cltd   
    }
}
  102cb9:	5d                   	pop    %ebp
  102cba:	c3                   	ret    

00102cbb <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102cbb:	55                   	push   %ebp
  102cbc:	89 e5                	mov    %esp,%ebp
  102cbe:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102cc1:	8d 45 14             	lea    0x14(%ebp),%eax
  102cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cce:	8b 45 10             	mov    0x10(%ebp),%eax
  102cd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdf:	89 04 24             	mov    %eax,(%esp)
  102ce2:	e8 05 00 00 00       	call   102cec <vprintfmt>
    va_end(ap);
}
  102ce7:	90                   	nop
  102ce8:	89 ec                	mov    %ebp,%esp
  102cea:	5d                   	pop    %ebp
  102ceb:	c3                   	ret    

00102cec <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102cec:	55                   	push   %ebp
  102ced:	89 e5                	mov    %esp,%ebp
  102cef:	56                   	push   %esi
  102cf0:	53                   	push   %ebx
  102cf1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cf4:	eb 17                	jmp    102d0d <vprintfmt+0x21>
            if (ch == '\0') {
  102cf6:	85 db                	test   %ebx,%ebx
  102cf8:	0f 84 bf 03 00 00    	je     1030bd <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d05:	89 1c 24             	mov    %ebx,(%esp)
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  102d10:	8d 50 01             	lea    0x1(%eax),%edx
  102d13:	89 55 10             	mov    %edx,0x10(%ebp)
  102d16:	0f b6 00             	movzbl (%eax),%eax
  102d19:	0f b6 d8             	movzbl %al,%ebx
  102d1c:	83 fb 25             	cmp    $0x25,%ebx
  102d1f:	75 d5                	jne    102cf6 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102d21:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102d25:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d32:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  102d42:	8d 50 01             	lea    0x1(%eax),%edx
  102d45:	89 55 10             	mov    %edx,0x10(%ebp)
  102d48:	0f b6 00             	movzbl (%eax),%eax
  102d4b:	0f b6 d8             	movzbl %al,%ebx
  102d4e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102d51:	83 f8 55             	cmp    $0x55,%eax
  102d54:	0f 87 37 03 00 00    	ja     103091 <vprintfmt+0x3a5>
  102d5a:	8b 04 85 34 3e 10 00 	mov    0x103e34(,%eax,4),%eax
  102d61:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102d63:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d67:	eb d6                	jmp    102d3f <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d69:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d6d:	eb d0                	jmp    102d3f <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d79:	89 d0                	mov    %edx,%eax
  102d7b:	c1 e0 02             	shl    $0x2,%eax
  102d7e:	01 d0                	add    %edx,%eax
  102d80:	01 c0                	add    %eax,%eax
  102d82:	01 d8                	add    %ebx,%eax
  102d84:	83 e8 30             	sub    $0x30,%eax
  102d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  102d8d:	0f b6 00             	movzbl (%eax),%eax
  102d90:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d93:	83 fb 2f             	cmp    $0x2f,%ebx
  102d96:	7e 38                	jle    102dd0 <vprintfmt+0xe4>
  102d98:	83 fb 39             	cmp    $0x39,%ebx
  102d9b:	7f 33                	jg     102dd0 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102d9d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102da0:	eb d4                	jmp    102d76 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102da2:	8b 45 14             	mov    0x14(%ebp),%eax
  102da5:	8d 50 04             	lea    0x4(%eax),%edx
  102da8:	89 55 14             	mov    %edx,0x14(%ebp)
  102dab:	8b 00                	mov    (%eax),%eax
  102dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102db0:	eb 1f                	jmp    102dd1 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102db2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102db6:	79 87                	jns    102d3f <vprintfmt+0x53>
                width = 0;
  102db8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102dbf:	e9 7b ff ff ff       	jmp    102d3f <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102dc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102dcb:	e9 6f ff ff ff       	jmp    102d3f <vprintfmt+0x53>
            goto process_precision;
  102dd0:	90                   	nop

        process_precision:
            if (width < 0)
  102dd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dd5:	0f 89 64 ff ff ff    	jns    102d3f <vprintfmt+0x53>
                width = precision, precision = -1;
  102ddb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102dde:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102de1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102de8:	e9 52 ff ff ff       	jmp    102d3f <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102ded:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102df0:	e9 4a ff ff ff       	jmp    102d3f <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102df5:	8b 45 14             	mov    0x14(%ebp),%eax
  102df8:	8d 50 04             	lea    0x4(%eax),%edx
  102dfb:	89 55 14             	mov    %edx,0x14(%ebp)
  102dfe:	8b 00                	mov    (%eax),%eax
  102e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e03:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e07:	89 04 24             	mov    %eax,(%esp)
  102e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0d:	ff d0                	call   *%eax
            break;
  102e0f:	e9 a4 02 00 00       	jmp    1030b8 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102e14:	8b 45 14             	mov    0x14(%ebp),%eax
  102e17:	8d 50 04             	lea    0x4(%eax),%edx
  102e1a:	89 55 14             	mov    %edx,0x14(%ebp)
  102e1d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102e1f:	85 db                	test   %ebx,%ebx
  102e21:	79 02                	jns    102e25 <vprintfmt+0x139>
                err = -err;
  102e23:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102e25:	83 fb 06             	cmp    $0x6,%ebx
  102e28:	7f 0b                	jg     102e35 <vprintfmt+0x149>
  102e2a:	8b 34 9d f4 3d 10 00 	mov    0x103df4(,%ebx,4),%esi
  102e31:	85 f6                	test   %esi,%esi
  102e33:	75 23                	jne    102e58 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102e35:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102e39:	c7 44 24 08 21 3e 10 	movl   $0x103e21,0x8(%esp)
  102e40:	00 
  102e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e48:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4b:	89 04 24             	mov    %eax,(%esp)
  102e4e:	e8 68 fe ff ff       	call   102cbb <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102e53:	e9 60 02 00 00       	jmp    1030b8 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102e58:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102e5c:	c7 44 24 08 2a 3e 10 	movl   $0x103e2a,0x8(%esp)
  102e63:	00 
  102e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e67:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6e:	89 04 24             	mov    %eax,(%esp)
  102e71:	e8 45 fe ff ff       	call   102cbb <printfmt>
            break;
  102e76:	e9 3d 02 00 00       	jmp    1030b8 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e7b:	8b 45 14             	mov    0x14(%ebp),%eax
  102e7e:	8d 50 04             	lea    0x4(%eax),%edx
  102e81:	89 55 14             	mov    %edx,0x14(%ebp)
  102e84:	8b 30                	mov    (%eax),%esi
  102e86:	85 f6                	test   %esi,%esi
  102e88:	75 05                	jne    102e8f <vprintfmt+0x1a3>
                p = "(null)";
  102e8a:	be 2d 3e 10 00       	mov    $0x103e2d,%esi
            }
            if (width > 0 && padc != '-') {
  102e8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e93:	7e 76                	jle    102f0b <vprintfmt+0x21f>
  102e95:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e99:	74 70                	je     102f0b <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea2:	89 34 24             	mov    %esi,(%esp)
  102ea5:	e8 16 03 00 00       	call   1031c0 <strnlen>
  102eaa:	89 c2                	mov    %eax,%edx
  102eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102eaf:	29 d0                	sub    %edx,%eax
  102eb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102eb4:	eb 16                	jmp    102ecc <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102eb6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ebd:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ec1:	89 04 24             	mov    %eax,(%esp)
  102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec7:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ec9:	ff 4d e8             	decl   -0x18(%ebp)
  102ecc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ed0:	7f e4                	jg     102eb6 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ed2:	eb 37                	jmp    102f0b <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ed4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ed8:	74 1f                	je     102ef9 <vprintfmt+0x20d>
  102eda:	83 fb 1f             	cmp    $0x1f,%ebx
  102edd:	7e 05                	jle    102ee4 <vprintfmt+0x1f8>
  102edf:	83 fb 7e             	cmp    $0x7e,%ebx
  102ee2:	7e 15                	jle    102ef9 <vprintfmt+0x20d>
                    putch('?', putdat);
  102ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eeb:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef5:	ff d0                	call   *%eax
  102ef7:	eb 0f                	jmp    102f08 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102efc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f00:	89 1c 24             	mov    %ebx,(%esp)
  102f03:	8b 45 08             	mov    0x8(%ebp),%eax
  102f06:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102f08:	ff 4d e8             	decl   -0x18(%ebp)
  102f0b:	89 f0                	mov    %esi,%eax
  102f0d:	8d 70 01             	lea    0x1(%eax),%esi
  102f10:	0f b6 00             	movzbl (%eax),%eax
  102f13:	0f be d8             	movsbl %al,%ebx
  102f16:	85 db                	test   %ebx,%ebx
  102f18:	74 27                	je     102f41 <vprintfmt+0x255>
  102f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f1e:	78 b4                	js     102ed4 <vprintfmt+0x1e8>
  102f20:	ff 4d e4             	decl   -0x1c(%ebp)
  102f23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f27:	79 ab                	jns    102ed4 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102f29:	eb 16                	jmp    102f41 <vprintfmt+0x255>
                putch(' ', putdat);
  102f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f32:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102f39:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3c:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102f3e:	ff 4d e8             	decl   -0x18(%ebp)
  102f41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f45:	7f e4                	jg     102f2b <vprintfmt+0x23f>
            }
            break;
  102f47:	e9 6c 01 00 00       	jmp    1030b8 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f53:	8d 45 14             	lea    0x14(%ebp),%eax
  102f56:	89 04 24             	mov    %eax,(%esp)
  102f59:	e8 16 fd ff ff       	call   102c74 <getint>
  102f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f6a:	85 d2                	test   %edx,%edx
  102f6c:	79 26                	jns    102f94 <vprintfmt+0x2a8>
                putch('-', putdat);
  102f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f75:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7f:	ff d0                	call   *%eax
                num = -(long long)num;
  102f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f87:	f7 d8                	neg    %eax
  102f89:	83 d2 00             	adc    $0x0,%edx
  102f8c:	f7 da                	neg    %edx
  102f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f91:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f94:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f9b:	e9 a8 00 00 00       	jmp    103048 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102fa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa7:	8d 45 14             	lea    0x14(%ebp),%eax
  102faa:	89 04 24             	mov    %eax,(%esp)
  102fad:	e8 73 fc ff ff       	call   102c25 <getuint>
  102fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102fb8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102fbf:	e9 84 00 00 00       	jmp    103048 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102fc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fcb:	8d 45 14             	lea    0x14(%ebp),%eax
  102fce:	89 04 24             	mov    %eax,(%esp)
  102fd1:	e8 4f fc ff ff       	call   102c25 <getuint>
  102fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102fdc:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102fe3:	eb 63                	jmp    103048 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fec:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff6:	ff d0                	call   *%eax
            putch('x', putdat);
  102ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fff:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103006:	8b 45 08             	mov    0x8(%ebp),%eax
  103009:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10300b:	8b 45 14             	mov    0x14(%ebp),%eax
  10300e:	8d 50 04             	lea    0x4(%eax),%edx
  103011:	89 55 14             	mov    %edx,0x14(%ebp)
  103014:	8b 00                	mov    (%eax),%eax
  103016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103019:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103020:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103027:	eb 1f                	jmp    103048 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103029:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10302c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103030:	8d 45 14             	lea    0x14(%ebp),%eax
  103033:	89 04 24             	mov    %eax,(%esp)
  103036:	e8 ea fb ff ff       	call   102c25 <getuint>
  10303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10303e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103041:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103048:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10304c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10304f:	89 54 24 18          	mov    %edx,0x18(%esp)
  103053:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103056:	89 54 24 14          	mov    %edx,0x14(%esp)
  10305a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103064:	89 44 24 08          	mov    %eax,0x8(%esp)
  103068:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10306c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103073:	8b 45 08             	mov    0x8(%ebp),%eax
  103076:	89 04 24             	mov    %eax,(%esp)
  103079:	e8 a5 fa ff ff       	call   102b23 <printnum>
            break;
  10307e:	eb 38                	jmp    1030b8 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103080:	8b 45 0c             	mov    0xc(%ebp),%eax
  103083:	89 44 24 04          	mov    %eax,0x4(%esp)
  103087:	89 1c 24             	mov    %ebx,(%esp)
  10308a:	8b 45 08             	mov    0x8(%ebp),%eax
  10308d:	ff d0                	call   *%eax
            break;
  10308f:	eb 27                	jmp    1030b8 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103091:	8b 45 0c             	mov    0xc(%ebp),%eax
  103094:	89 44 24 04          	mov    %eax,0x4(%esp)
  103098:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10309f:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1030a4:	ff 4d 10             	decl   0x10(%ebp)
  1030a7:	eb 03                	jmp    1030ac <vprintfmt+0x3c0>
  1030a9:	ff 4d 10             	decl   0x10(%ebp)
  1030ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1030af:	48                   	dec    %eax
  1030b0:	0f b6 00             	movzbl (%eax),%eax
  1030b3:	3c 25                	cmp    $0x25,%al
  1030b5:	75 f2                	jne    1030a9 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1030b7:	90                   	nop
    while (1) {
  1030b8:	e9 37 fc ff ff       	jmp    102cf4 <vprintfmt+0x8>
                return;
  1030bd:	90                   	nop
        }
    }
}
  1030be:	83 c4 40             	add    $0x40,%esp
  1030c1:	5b                   	pop    %ebx
  1030c2:	5e                   	pop    %esi
  1030c3:	5d                   	pop    %ebp
  1030c4:	c3                   	ret    

001030c5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030c5:	55                   	push   %ebp
  1030c6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030cb:	8b 40 08             	mov    0x8(%eax),%eax
  1030ce:	8d 50 01             	lea    0x1(%eax),%edx
  1030d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030da:	8b 10                	mov    (%eax),%edx
  1030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030df:	8b 40 04             	mov    0x4(%eax),%eax
  1030e2:	39 c2                	cmp    %eax,%edx
  1030e4:	73 12                	jae    1030f8 <sprintputch+0x33>
        *b->buf ++ = ch;
  1030e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e9:	8b 00                	mov    (%eax),%eax
  1030eb:	8d 48 01             	lea    0x1(%eax),%ecx
  1030ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030f1:	89 0a                	mov    %ecx,(%edx)
  1030f3:	8b 55 08             	mov    0x8(%ebp),%edx
  1030f6:	88 10                	mov    %dl,(%eax)
    }
}
  1030f8:	90                   	nop
  1030f9:	5d                   	pop    %ebp
  1030fa:	c3                   	ret    

001030fb <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1030fb:	55                   	push   %ebp
  1030fc:	89 e5                	mov    %esp,%ebp
  1030fe:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103101:	8d 45 14             	lea    0x14(%ebp),%eax
  103104:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10310a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10310e:	8b 45 10             	mov    0x10(%ebp),%eax
  103111:	89 44 24 08          	mov    %eax,0x8(%esp)
  103115:	8b 45 0c             	mov    0xc(%ebp),%eax
  103118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10311c:	8b 45 08             	mov    0x8(%ebp),%eax
  10311f:	89 04 24             	mov    %eax,(%esp)
  103122:	e8 0a 00 00 00       	call   103131 <vsnprintf>
  103127:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10312d:	89 ec                	mov    %ebp,%esp
  10312f:	5d                   	pop    %ebp
  103130:	c3                   	ret    

00103131 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103131:	55                   	push   %ebp
  103132:	89 e5                	mov    %esp,%ebp
  103134:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103137:	8b 45 08             	mov    0x8(%ebp),%eax
  10313a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10313d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103140:	8d 50 ff             	lea    -0x1(%eax),%edx
  103143:	8b 45 08             	mov    0x8(%ebp),%eax
  103146:	01 d0                	add    %edx,%eax
  103148:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10314b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103156:	74 0a                	je     103162 <vsnprintf+0x31>
  103158:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10315e:	39 c2                	cmp    %eax,%edx
  103160:	76 07                	jbe    103169 <vsnprintf+0x38>
        return -E_INVAL;
  103162:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103167:	eb 2a                	jmp    103193 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103169:	8b 45 14             	mov    0x14(%ebp),%eax
  10316c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103170:	8b 45 10             	mov    0x10(%ebp),%eax
  103173:	89 44 24 08          	mov    %eax,0x8(%esp)
  103177:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10317a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10317e:	c7 04 24 c5 30 10 00 	movl   $0x1030c5,(%esp)
  103185:	e8 62 fb ff ff       	call   102cec <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10318a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10318d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103190:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103193:	89 ec                	mov    %ebp,%esp
  103195:	5d                   	pop    %ebp
  103196:	c3                   	ret    

00103197 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103197:	55                   	push   %ebp
  103198:	89 e5                	mov    %esp,%ebp
  10319a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10319d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1031a4:	eb 03                	jmp    1031a9 <strlen+0x12>
        cnt ++;
  1031a6:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ac:	8d 50 01             	lea    0x1(%eax),%edx
  1031af:	89 55 08             	mov    %edx,0x8(%ebp)
  1031b2:	0f b6 00             	movzbl (%eax),%eax
  1031b5:	84 c0                	test   %al,%al
  1031b7:	75 ed                	jne    1031a6 <strlen+0xf>
    }
    return cnt;
  1031b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031bc:	89 ec                	mov    %ebp,%esp
  1031be:	5d                   	pop    %ebp
  1031bf:	c3                   	ret    

001031c0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1031c0:	55                   	push   %ebp
  1031c1:	89 e5                	mov    %esp,%ebp
  1031c3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031cd:	eb 03                	jmp    1031d2 <strnlen+0x12>
        cnt ++;
  1031cf:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1031d8:	73 10                	jae    1031ea <strnlen+0x2a>
  1031da:	8b 45 08             	mov    0x8(%ebp),%eax
  1031dd:	8d 50 01             	lea    0x1(%eax),%edx
  1031e0:	89 55 08             	mov    %edx,0x8(%ebp)
  1031e3:	0f b6 00             	movzbl (%eax),%eax
  1031e6:	84 c0                	test   %al,%al
  1031e8:	75 e5                	jne    1031cf <strnlen+0xf>
    }
    return cnt;
  1031ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031ed:	89 ec                	mov    %ebp,%esp
  1031ef:	5d                   	pop    %ebp
  1031f0:	c3                   	ret    

001031f1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1031f1:	55                   	push   %ebp
  1031f2:	89 e5                	mov    %esp,%ebp
  1031f4:	57                   	push   %edi
  1031f5:	56                   	push   %esi
  1031f6:	83 ec 20             	sub    $0x20,%esp
  1031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103202:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103205:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10320b:	89 d1                	mov    %edx,%ecx
  10320d:	89 c2                	mov    %eax,%edx
  10320f:	89 ce                	mov    %ecx,%esi
  103211:	89 d7                	mov    %edx,%edi
  103213:	ac                   	lods   %ds:(%esi),%al
  103214:	aa                   	stos   %al,%es:(%edi)
  103215:	84 c0                	test   %al,%al
  103217:	75 fa                	jne    103213 <strcpy+0x22>
  103219:	89 fa                	mov    %edi,%edx
  10321b:	89 f1                	mov    %esi,%ecx
  10321d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103220:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103223:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103226:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103229:	83 c4 20             	add    $0x20,%esp
  10322c:	5e                   	pop    %esi
  10322d:	5f                   	pop    %edi
  10322e:	5d                   	pop    %ebp
  10322f:	c3                   	ret    

00103230 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103230:	55                   	push   %ebp
  103231:	89 e5                	mov    %esp,%ebp
  103233:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103236:	8b 45 08             	mov    0x8(%ebp),%eax
  103239:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10323c:	eb 1e                	jmp    10325c <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  10323e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103241:	0f b6 10             	movzbl (%eax),%edx
  103244:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103247:	88 10                	mov    %dl,(%eax)
  103249:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10324c:	0f b6 00             	movzbl (%eax),%eax
  10324f:	84 c0                	test   %al,%al
  103251:	74 03                	je     103256 <strncpy+0x26>
            src ++;
  103253:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  103256:	ff 45 fc             	incl   -0x4(%ebp)
  103259:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  10325c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103260:	75 dc                	jne    10323e <strncpy+0xe>
    }
    return dst;
  103262:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103265:	89 ec                	mov    %ebp,%esp
  103267:	5d                   	pop    %ebp
  103268:	c3                   	ret    

00103269 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103269:	55                   	push   %ebp
  10326a:	89 e5                	mov    %esp,%ebp
  10326c:	57                   	push   %edi
  10326d:	56                   	push   %esi
  10326e:	83 ec 20             	sub    $0x20,%esp
  103271:	8b 45 08             	mov    0x8(%ebp),%eax
  103274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103277:	8b 45 0c             	mov    0xc(%ebp),%eax
  10327a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10327d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103283:	89 d1                	mov    %edx,%ecx
  103285:	89 c2                	mov    %eax,%edx
  103287:	89 ce                	mov    %ecx,%esi
  103289:	89 d7                	mov    %edx,%edi
  10328b:	ac                   	lods   %ds:(%esi),%al
  10328c:	ae                   	scas   %es:(%edi),%al
  10328d:	75 08                	jne    103297 <strcmp+0x2e>
  10328f:	84 c0                	test   %al,%al
  103291:	75 f8                	jne    10328b <strcmp+0x22>
  103293:	31 c0                	xor    %eax,%eax
  103295:	eb 04                	jmp    10329b <strcmp+0x32>
  103297:	19 c0                	sbb    %eax,%eax
  103299:	0c 01                	or     $0x1,%al
  10329b:	89 fa                	mov    %edi,%edx
  10329d:	89 f1                	mov    %esi,%ecx
  10329f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032a2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1032a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1032a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1032ab:	83 c4 20             	add    $0x20,%esp
  1032ae:	5e                   	pop    %esi
  1032af:	5f                   	pop    %edi
  1032b0:	5d                   	pop    %ebp
  1032b1:	c3                   	ret    

001032b2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1032b2:	55                   	push   %ebp
  1032b3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032b5:	eb 09                	jmp    1032c0 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1032b7:	ff 4d 10             	decl   0x10(%ebp)
  1032ba:	ff 45 08             	incl   0x8(%ebp)
  1032bd:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032c4:	74 1a                	je     1032e0 <strncmp+0x2e>
  1032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c9:	0f b6 00             	movzbl (%eax),%eax
  1032cc:	84 c0                	test   %al,%al
  1032ce:	74 10                	je     1032e0 <strncmp+0x2e>
  1032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d3:	0f b6 10             	movzbl (%eax),%edx
  1032d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	38 c2                	cmp    %al,%dl
  1032de:	74 d7                	je     1032b7 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032e4:	74 18                	je     1032fe <strncmp+0x4c>
  1032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e9:	0f b6 00             	movzbl (%eax),%eax
  1032ec:	0f b6 d0             	movzbl %al,%edx
  1032ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f2:	0f b6 00             	movzbl (%eax),%eax
  1032f5:	0f b6 c8             	movzbl %al,%ecx
  1032f8:	89 d0                	mov    %edx,%eax
  1032fa:	29 c8                	sub    %ecx,%eax
  1032fc:	eb 05                	jmp    103303 <strncmp+0x51>
  1032fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103303:	5d                   	pop    %ebp
  103304:	c3                   	ret    

00103305 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103305:	55                   	push   %ebp
  103306:	89 e5                	mov    %esp,%ebp
  103308:	83 ec 04             	sub    $0x4,%esp
  10330b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103311:	eb 13                	jmp    103326 <strchr+0x21>
        if (*s == c) {
  103313:	8b 45 08             	mov    0x8(%ebp),%eax
  103316:	0f b6 00             	movzbl (%eax),%eax
  103319:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10331c:	75 05                	jne    103323 <strchr+0x1e>
            return (char *)s;
  10331e:	8b 45 08             	mov    0x8(%ebp),%eax
  103321:	eb 12                	jmp    103335 <strchr+0x30>
        }
        s ++;
  103323:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103326:	8b 45 08             	mov    0x8(%ebp),%eax
  103329:	0f b6 00             	movzbl (%eax),%eax
  10332c:	84 c0                	test   %al,%al
  10332e:	75 e3                	jne    103313 <strchr+0xe>
    }
    return NULL;
  103330:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103335:	89 ec                	mov    %ebp,%esp
  103337:	5d                   	pop    %ebp
  103338:	c3                   	ret    

00103339 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103339:	55                   	push   %ebp
  10333a:	89 e5                	mov    %esp,%ebp
  10333c:	83 ec 04             	sub    $0x4,%esp
  10333f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103342:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103345:	eb 0e                	jmp    103355 <strfind+0x1c>
        if (*s == c) {
  103347:	8b 45 08             	mov    0x8(%ebp),%eax
  10334a:	0f b6 00             	movzbl (%eax),%eax
  10334d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103350:	74 0f                	je     103361 <strfind+0x28>
            break;
        }
        s ++;
  103352:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  103355:	8b 45 08             	mov    0x8(%ebp),%eax
  103358:	0f b6 00             	movzbl (%eax),%eax
  10335b:	84 c0                	test   %al,%al
  10335d:	75 e8                	jne    103347 <strfind+0xe>
  10335f:	eb 01                	jmp    103362 <strfind+0x29>
            break;
  103361:	90                   	nop
    }
    return (char *)s;
  103362:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103365:	89 ec                	mov    %ebp,%esp
  103367:	5d                   	pop    %ebp
  103368:	c3                   	ret    

00103369 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103369:	55                   	push   %ebp
  10336a:	89 e5                	mov    %esp,%ebp
  10336c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10336f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103376:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10337d:	eb 03                	jmp    103382 <strtol+0x19>
        s ++;
  10337f:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  103382:	8b 45 08             	mov    0x8(%ebp),%eax
  103385:	0f b6 00             	movzbl (%eax),%eax
  103388:	3c 20                	cmp    $0x20,%al
  10338a:	74 f3                	je     10337f <strtol+0x16>
  10338c:	8b 45 08             	mov    0x8(%ebp),%eax
  10338f:	0f b6 00             	movzbl (%eax),%eax
  103392:	3c 09                	cmp    $0x9,%al
  103394:	74 e9                	je     10337f <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  103396:	8b 45 08             	mov    0x8(%ebp),%eax
  103399:	0f b6 00             	movzbl (%eax),%eax
  10339c:	3c 2b                	cmp    $0x2b,%al
  10339e:	75 05                	jne    1033a5 <strtol+0x3c>
        s ++;
  1033a0:	ff 45 08             	incl   0x8(%ebp)
  1033a3:	eb 14                	jmp    1033b9 <strtol+0x50>
    }
    else if (*s == '-') {
  1033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a8:	0f b6 00             	movzbl (%eax),%eax
  1033ab:	3c 2d                	cmp    $0x2d,%al
  1033ad:	75 0a                	jne    1033b9 <strtol+0x50>
        s ++, neg = 1;
  1033af:	ff 45 08             	incl   0x8(%ebp)
  1033b2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1033b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033bd:	74 06                	je     1033c5 <strtol+0x5c>
  1033bf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1033c3:	75 22                	jne    1033e7 <strtol+0x7e>
  1033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c8:	0f b6 00             	movzbl (%eax),%eax
  1033cb:	3c 30                	cmp    $0x30,%al
  1033cd:	75 18                	jne    1033e7 <strtol+0x7e>
  1033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d2:	40                   	inc    %eax
  1033d3:	0f b6 00             	movzbl (%eax),%eax
  1033d6:	3c 78                	cmp    $0x78,%al
  1033d8:	75 0d                	jne    1033e7 <strtol+0x7e>
        s += 2, base = 16;
  1033da:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1033de:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1033e5:	eb 29                	jmp    103410 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  1033e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033eb:	75 16                	jne    103403 <strtol+0x9a>
  1033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f0:	0f b6 00             	movzbl (%eax),%eax
  1033f3:	3c 30                	cmp    $0x30,%al
  1033f5:	75 0c                	jne    103403 <strtol+0x9a>
        s ++, base = 8;
  1033f7:	ff 45 08             	incl   0x8(%ebp)
  1033fa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103401:	eb 0d                	jmp    103410 <strtol+0xa7>
    }
    else if (base == 0) {
  103403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103407:	75 07                	jne    103410 <strtol+0xa7>
        base = 10;
  103409:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103410:	8b 45 08             	mov    0x8(%ebp),%eax
  103413:	0f b6 00             	movzbl (%eax),%eax
  103416:	3c 2f                	cmp    $0x2f,%al
  103418:	7e 1b                	jle    103435 <strtol+0xcc>
  10341a:	8b 45 08             	mov    0x8(%ebp),%eax
  10341d:	0f b6 00             	movzbl (%eax),%eax
  103420:	3c 39                	cmp    $0x39,%al
  103422:	7f 11                	jg     103435 <strtol+0xcc>
            dig = *s - '0';
  103424:	8b 45 08             	mov    0x8(%ebp),%eax
  103427:	0f b6 00             	movzbl (%eax),%eax
  10342a:	0f be c0             	movsbl %al,%eax
  10342d:	83 e8 30             	sub    $0x30,%eax
  103430:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103433:	eb 48                	jmp    10347d <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103435:	8b 45 08             	mov    0x8(%ebp),%eax
  103438:	0f b6 00             	movzbl (%eax),%eax
  10343b:	3c 60                	cmp    $0x60,%al
  10343d:	7e 1b                	jle    10345a <strtol+0xf1>
  10343f:	8b 45 08             	mov    0x8(%ebp),%eax
  103442:	0f b6 00             	movzbl (%eax),%eax
  103445:	3c 7a                	cmp    $0x7a,%al
  103447:	7f 11                	jg     10345a <strtol+0xf1>
            dig = *s - 'a' + 10;
  103449:	8b 45 08             	mov    0x8(%ebp),%eax
  10344c:	0f b6 00             	movzbl (%eax),%eax
  10344f:	0f be c0             	movsbl %al,%eax
  103452:	83 e8 57             	sub    $0x57,%eax
  103455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103458:	eb 23                	jmp    10347d <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10345a:	8b 45 08             	mov    0x8(%ebp),%eax
  10345d:	0f b6 00             	movzbl (%eax),%eax
  103460:	3c 40                	cmp    $0x40,%al
  103462:	7e 3b                	jle    10349f <strtol+0x136>
  103464:	8b 45 08             	mov    0x8(%ebp),%eax
  103467:	0f b6 00             	movzbl (%eax),%eax
  10346a:	3c 5a                	cmp    $0x5a,%al
  10346c:	7f 31                	jg     10349f <strtol+0x136>
            dig = *s - 'A' + 10;
  10346e:	8b 45 08             	mov    0x8(%ebp),%eax
  103471:	0f b6 00             	movzbl (%eax),%eax
  103474:	0f be c0             	movsbl %al,%eax
  103477:	83 e8 37             	sub    $0x37,%eax
  10347a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103480:	3b 45 10             	cmp    0x10(%ebp),%eax
  103483:	7d 19                	jge    10349e <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  103485:	ff 45 08             	incl   0x8(%ebp)
  103488:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10348b:	0f af 45 10          	imul   0x10(%ebp),%eax
  10348f:	89 c2                	mov    %eax,%edx
  103491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103494:	01 d0                	add    %edx,%eax
  103496:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103499:	e9 72 ff ff ff       	jmp    103410 <strtol+0xa7>
            break;
  10349e:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  10349f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1034a3:	74 08                	je     1034ad <strtol+0x144>
        *endptr = (char *) s;
  1034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1034ab:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1034ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1034b1:	74 07                	je     1034ba <strtol+0x151>
  1034b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034b6:	f7 d8                	neg    %eax
  1034b8:	eb 03                	jmp    1034bd <strtol+0x154>
  1034ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1034bd:	89 ec                	mov    %ebp,%esp
  1034bf:	5d                   	pop    %ebp
  1034c0:	c3                   	ret    

001034c1 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1034c1:	55                   	push   %ebp
  1034c2:	89 e5                	mov    %esp,%ebp
  1034c4:	83 ec 28             	sub    $0x28,%esp
  1034c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1034ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034cd:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1034d0:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1034da:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1034dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1034e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1034e3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1034e6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1034ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1034ed:	89 d7                	mov    %edx,%edi
  1034ef:	f3 aa                	rep stos %al,%es:(%edi)
  1034f1:	89 fa                	mov    %edi,%edx
  1034f3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1034f6:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1034f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1034fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1034ff:	89 ec                	mov    %ebp,%esp
  103501:	5d                   	pop    %ebp
  103502:	c3                   	ret    

00103503 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103503:	55                   	push   %ebp
  103504:	89 e5                	mov    %esp,%ebp
  103506:	57                   	push   %edi
  103507:	56                   	push   %esi
  103508:	53                   	push   %ebx
  103509:	83 ec 30             	sub    $0x30,%esp
  10350c:	8b 45 08             	mov    0x8(%ebp),%eax
  10350f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103512:	8b 45 0c             	mov    0xc(%ebp),%eax
  103515:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103518:	8b 45 10             	mov    0x10(%ebp),%eax
  10351b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10351e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103521:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103524:	73 42                	jae    103568 <memmove+0x65>
  103526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10352c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10352f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103535:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103538:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10353b:	c1 e8 02             	shr    $0x2,%eax
  10353e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103540:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103546:	89 d7                	mov    %edx,%edi
  103548:	89 c6                	mov    %eax,%esi
  10354a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10354c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10354f:	83 e1 03             	and    $0x3,%ecx
  103552:	74 02                	je     103556 <memmove+0x53>
  103554:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103556:	89 f0                	mov    %esi,%eax
  103558:	89 fa                	mov    %edi,%edx
  10355a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10355d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103560:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103566:	eb 36                	jmp    10359e <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10356b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10356e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103571:	01 c2                	add    %eax,%edx
  103573:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103576:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10357c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10357f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103582:	89 c1                	mov    %eax,%ecx
  103584:	89 d8                	mov    %ebx,%eax
  103586:	89 d6                	mov    %edx,%esi
  103588:	89 c7                	mov    %eax,%edi
  10358a:	fd                   	std    
  10358b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10358d:	fc                   	cld    
  10358e:	89 f8                	mov    %edi,%eax
  103590:	89 f2                	mov    %esi,%edx
  103592:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103595:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103598:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10359b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10359e:	83 c4 30             	add    $0x30,%esp
  1035a1:	5b                   	pop    %ebx
  1035a2:	5e                   	pop    %esi
  1035a3:	5f                   	pop    %edi
  1035a4:	5d                   	pop    %ebp
  1035a5:	c3                   	ret    

001035a6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1035a6:	55                   	push   %ebp
  1035a7:	89 e5                	mov    %esp,%ebp
  1035a9:	57                   	push   %edi
  1035aa:	56                   	push   %esi
  1035ab:	83 ec 20             	sub    $0x20,%esp
  1035ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ba:	8b 45 10             	mov    0x10(%ebp),%eax
  1035bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1035c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c3:	c1 e8 02             	shr    $0x2,%eax
  1035c6:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1035c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ce:	89 d7                	mov    %edx,%edi
  1035d0:	89 c6                	mov    %eax,%esi
  1035d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035d4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1035d7:	83 e1 03             	and    $0x3,%ecx
  1035da:	74 02                	je     1035de <memcpy+0x38>
  1035dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1035de:	89 f0                	mov    %esi,%eax
  1035e0:	89 fa                	mov    %edi,%edx
  1035e2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1035e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1035e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1035ee:	83 c4 20             	add    $0x20,%esp
  1035f1:	5e                   	pop    %esi
  1035f2:	5f                   	pop    %edi
  1035f3:	5d                   	pop    %ebp
  1035f4:	c3                   	ret    

001035f5 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1035f5:	55                   	push   %ebp
  1035f6:	89 e5                	mov    %esp,%ebp
  1035f8:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1035fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103601:	8b 45 0c             	mov    0xc(%ebp),%eax
  103604:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103607:	eb 2e                	jmp    103637 <memcmp+0x42>
        if (*s1 != *s2) {
  103609:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10360c:	0f b6 10             	movzbl (%eax),%edx
  10360f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103612:	0f b6 00             	movzbl (%eax),%eax
  103615:	38 c2                	cmp    %al,%dl
  103617:	74 18                	je     103631 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103619:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10361c:	0f b6 00             	movzbl (%eax),%eax
  10361f:	0f b6 d0             	movzbl %al,%edx
  103622:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103625:	0f b6 00             	movzbl (%eax),%eax
  103628:	0f b6 c8             	movzbl %al,%ecx
  10362b:	89 d0                	mov    %edx,%eax
  10362d:	29 c8                	sub    %ecx,%eax
  10362f:	eb 18                	jmp    103649 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  103631:	ff 45 fc             	incl   -0x4(%ebp)
  103634:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103637:	8b 45 10             	mov    0x10(%ebp),%eax
  10363a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10363d:	89 55 10             	mov    %edx,0x10(%ebp)
  103640:	85 c0                	test   %eax,%eax
  103642:	75 c5                	jne    103609 <memcmp+0x14>
    }
    return 0;
  103644:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103649:	89 ec                	mov    %ebp,%esp
  10364b:	5d                   	pop    %ebp
  10364c:	c3                   	ret    
