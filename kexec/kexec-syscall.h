#ifndef KEXEC_SYSCALL_H
#define KEXEC_SYSCALL_H

#define __LIBRARY__
#include <sys/syscall.h>
#include <unistd.h>

#define LINUX_REBOOT_CMD_KEXEC_OLD	0x81726354
#define LINUX_REBOOT_CMD_KEXEC_OLD2	0x18263645
#define LINUX_REBOOT_CMD_KEXEC		0x45584543

#ifndef __NR_kexec_load
#ifdef __i386__
#define __NR_kexec_load		283
#endif
#ifdef __sh__
#define __NR_kexec_load		283
#endif
#ifdef __cris__
#ifndef __NR_kexec_load
#define __NR_kexec_load		283
#endif
#endif
#ifdef __ia64__
#define __NR_kexec_load		1268
#endif
#ifdef __powerpc64__
#define __NR_kexec_load		268
#endif
#ifdef __powerpc__
#define __NR_kexec_load		268
#endif
#ifdef __x86_64__
#define __NR_kexec_load		246
#endif
#ifdef __s390x__
#define __NR_kexec_load		277
#endif
#ifdef __s390__
#define __NR_kexec_load		277
#endif
#ifdef __arm__
#define __NR_kexec_load		__NR_SYSCALL_BASE + 347  
#endif
#if defined(__mips__)
#define __NR_kexec_load                4311
#endif
#ifdef __m68k__
#define __NR_kexec_load                313
#endif
#ifndef __NR_kexec_load
#error Unknown processor architecture.  Needs a kexec_load syscall number.
#endif
#endif /*ifndef __NR_kexec_load*/

struct kexec_segment;

static inline long kexec_load(void *entry, unsigned long nr_segments,
			struct kexec_segment *segments, unsigned long flags)
{
	return (long) syscall(__NR_kexec_load, entry, nr_segments, segments, flags);
}

#define KEXEC_ON_CRASH		0x00000001
#define KEXEC_PRESERVE_CONTEXT	0x00000002
#define KEXEC_ARCH_MASK		0xffff0000

/* These values match the ELF architecture values. 
 * Unless there is a good reason that should continue to be the case.
 */
#define KEXEC_ARCH_DEFAULT ( 0 << 16)
#define KEXEC_ARCH_386     ( 3 << 16)
#define KEXEC_ARCH_68K     ( 4 << 16)
#define KEXEC_ARCH_X86_64  (62 << 16)
#define KEXEC_ARCH_PPC     (20 << 16)
#define KEXEC_ARCH_PPC64   (21 << 16)
#define KEXEC_ARCH_IA_64   (50 << 16)
#define KEXEC_ARCH_ARM     (40 << 16)
#define KEXEC_ARCH_S390    (22 << 16)
#define KEXEC_ARCH_SH      (42 << 16)
#define KEXEC_ARCH_MIPS_LE (10 << 16)
#define KEXEC_ARCH_MIPS    ( 8 << 16)
#define KEXEC_ARCH_CRIS    (76 << 16)

#define KEXEC_MAX_SEGMENTS 16

#ifdef __i386__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_386
#endif
#ifdef __sh__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_SH
#endif
#ifdef __cris__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_CRIS
#endif
#ifdef __ia64__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_IA_64
#endif
#ifdef __powerpc64__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_PPC64
#else
 #ifdef __powerpc__
 #define KEXEC_ARCH_NATIVE	KEXEC_ARCH_PPC
 #endif
#endif
#ifdef __x86_64__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_X86_64
#endif
#ifdef __s390x__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_S390
#endif
#ifdef __s390__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_S390
#endif
#ifdef __arm__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_ARM
#endif
#if defined(__mips__)
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_MIPS
#endif
#ifdef __m68k__
#define KEXEC_ARCH_NATIVE	KEXEC_ARCH_68K
#endif

#endif /* KEXEC_SYSCALL_H */
