#
# kexec (linux booting linux)
#
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

PURGATORY_HEX_C := $(LOCAL_PATH)/purgatory.c

$(PURGATORY_HEX_C):
	$(HOST_OUT_EXECUTABLES)/bin-to-hex purgatory < $(TARGET_OUT_INTERMEDIATES)/purgatory > $@

.INTERMEDIATE:	$(PURGATORY_HEX_C)

KEXEC_SRCS := \
	kexec.c \
	ifdown.c \
	kexec-elf.c \
	kexec-elf-exec.c \
	kexec-elf-core.c \
	kexec-elf-rel.c \
	kexec-elf-boot.c \
	kexec-iomem.c \
	firmware_memmap.c \
	crashdump.c \
	crashdump-xen.c \
	phys_arch.c \
	kernel_version.c \
	lzma.c \
	zlib.c \
	../util_lib/sha256.c \
	kexec-xen.c \
	purgatory.c

ARCH_COMMON_SRCS := \
	proc_iomem.c \
	virt_to_phys.c \
	add_segment.c \
	add_buffer.c \
	arch_reuse_initrd.c

ARCH_FLAGS :=

FDT_COMMON_FLAGS := -I$(LOCAL_PATH)/libfdt

FDT_COMMON_SRCS := \
	libfdt/fdt.c \
	libfdt/fdt_ro.c \
	libfdt/fdt_wip.c \
	libfdt/fdt_sw.c \
	libfdt/fdt_rw.c \
	libfdt/fdt_strerror.c

ifeq ($(TARGET_ARCH),arm)
	ARCH_FLAGS += \
		-I$(LOCAL_PATH)/../kexec/arch/$(ARCH)/include \
		-include $(LOCAL_PATH)/../kexec/arch/arm/crashdump-arm.h \
		-include $(LOCAL_PATH)/../kexec/arch/arm/kexec-arm.h \
		$(FDT_COMMON_FLAGS)


	ARCH_SRCS := \
		arch/arm/kexec-elf-rel-arm.c \
		arch/arm/kexec-zImage-arm.c \
		arch/arm/kexec-uImage-arm.c \
		arch/arm/kexec-arm.c \
		arch/arm/crashdump-arm.c \
		arch/arm/phys_to_virt.c \
		kexec-uImage.c \
		$(FDT_COMMON_SRCS) \
		fs2dt.c

else ifeq ($(TARGET_ARCH),mips)
	ARCH_SRCS := \
		arch/mips/kexec-mips.c \
		arch/mips/kexec-elf-mips.c \
		arch/mips/kexec-elf-rel-mips.c \
		arch/mips/crashdump-mips.c \
		phys_to_virt.c
	
else ifeq ($(TARGET_ARCH),x86)
	ARCH_SRCS := \
		arch/i386/kexec-x86.c \
		arch/i386/kexec-x86-common.c \
		arch/i386/kexec-elf-x86.c \
		arch/i386/kexec-elf-rel-x86.c \
		arch/i386/kexec-bzImage.c \
		arch/i386/kexec-multiboot-x86.c \
		arch/i386/kexec-beoboot-x86.c \
		arch/i386/kexec-nbi.c \
		arch/i386/x86-linux-setup.c \
		arch/i386/crashdump-x86.c \
		phys_to_virt.c

else ifeq ($(TARGET_ARCH),x86_64)
	ARCH_SRCS := \
		arch/i386/kexec-elf-x86.c \
		arch/i386/kexec-bzImage.c \
		arch/i386/kexec-multiboot-x86.c \
		arch/i386/kexec-beoboot-x86.c \
		arch/i386/kexec-nbi.c \
		arch/i386/x86-linux-setup.c \
		arch/i386/kexec-x86-common.c \
		arch/i386/crashdump-x86.c \
		arch/x86_64/kexec-x86_64.c \
		arch/x86_64/kexec-elf-x86_64.c \
		arch/x86_64/kexec-elf-rel-x86_64.c \
		arch/x86_64/kexec-bzImage64.c \
		phys_to_virt.c

endif

LOCAL_CFLAGS += -Os -pipe -fno-strict-aliasing -Wall -Wstrict-prototypes \
				-I$(LOCAL_PATH)/ -I$(LOCAL_PATH)/../include \
				-I$(LOCAL_PATH)/../util_lib/include $(ARCH_FLAGS)

LOCAL_SRC_FILES := $(KEXEC_SRCS) $(ARCH_COMMON_SRCS) $(ARCH_SRCS)
LOCAL_LDLIBS := -lz -llzma

LOCAL_MODULE := kexec
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng
LOCAL_REQUIRED_MODULES := purgatory bin-to-hex

LOCAL_STATIC_LIBRARIES := liblzma libz
#LOCAL_SHARED_LIBARAIES := libz

include $(BUILD_EXECUTABLE)
