# Purgatory (an uncomfortable intermediate state)
#            In this case the code that runs between kernels
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

PURGATORY_SRCS = \
	purgatory.c \
	printf.c \
	string.c

ARCH_FLAGS :=

ifeq ($(TARGET_ARCH),arm)
	# no arch-specific files
	ARCH_SRCS :=
else ifeq ($(TARGET_ARCH),mips)
	ARCH_SRCS := \
		arch/mips/purgatory-mips.c \
		arch/mips/console-mips.c
else ifeq ($(TARGET_ARCH),x86)
	ARCH_SRCS := \
		arch/i386/entry32-16.S \
		arch/i386/entry32-16-debug.S \
		arch/i386/entry32.S \
		arch/i386/setup-x86.S \
		arch/i386/stack.S \
		arch/i386/compat_x86_64.S \
		arch/i386/purgatory-x86.c \
		arch/i386/console-x86.c \
		arch/i386/vga.c \
		arch/i386/pic.c \
		arch/i386/crashdump_backup.c
else ifeq ($(TARGET_ARCH),x86_64)
	ARCH_SRCS := \
		arch/x86_64/entry64-32.S \
		arch/x86_64/entry64.S \
		arch/x86_64/setup-x86_64.S \
		arch/x86_64/stack.S \
		arch/x86_64/purgatory-x86_64.c \
		arch/i386/entry32-16.S \
		arch/i386/entry32-16-debug.S \
		arch/i386/crashdump_backup.c \
		arch/i386/console-x86.c \
		arch/i386/vga.c \
		arch/i386/pic.c
	ARCH_FLAGS += -mcmodel=large
endif

LOCAL_CFLAGS := $(ARCH_FLAGS) \
	-I$(LOCAL_PATH)/include  -I$(LOCAL_PATH)/../util_lib/include \
	-pipe -fno-strict-aliasing -Wall -Wstrict-prototypes \
	-fno-zero-initialized-in-bss \
	-Os -fno-builtin -ffreestanding

LOCAL_SRC_FILES := \
	$(PURGATORY_SRCS) \
	$(ARCH_SRCS)

LOCAL_MODULE := purgatory
LOCAL_ARM_MODE := arm
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_OUT_INTERMEDIATES)
LOCAL_MODULE_TAGS := eng
LOCAL_STATIC_LIBRARIES := libsha-kexec

# Force partial link for later use
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_SUFFIX := 
LOCAL_FORCE_STATIC_EXECUTABLE := true

include $(BUILD_SYSTEM)/binary.mk

$(all_objects) : PRIVATE_TARGET_PROJECT_INCLUDES :=
$(all_objects) : PRIVATE_TARGET_GLOBAL_CFLAGS :=
$(all_objects) : PRIVATE_TARGET_GLOBAL_CPPFLAGS :=

$(LOCAL_BUILT_MODULE): $(all_objects) $(all_libraries)
	@$(mkdir -p $(dir $@)
	@echo -e ${CL_GRN}"target PartialLink:"${CL_RST}" $(PRIVATE_MODULE)"
	$(hide) $(PRIVATE_CC) \
		-Wl,-rpath-link=$(TARGET_OUT_INTERMEDIATE_LIBRARIES) \
		-Wl,--no-undefined -nostartfiles -nostdlib \
		-nodefaultlibs -e purgatory_start -r \
		$(PRIVATE_ALL_OBJECTS) -o $@

#
# sha256.c needs to be compiled without optimization, else
# purgatory fails to execute on ia64.
#
include $(CLEAR_VARS)

LOCAL_CFLAGS := -O0 -pipe -fno-strict-aliasing -Wall -Wstrict-prototypes \
				-I$(LOCAL_PATH)/../util_lib/include

LOCAL_SRC_FILES := ../util_lib/sha256.c

LOCAL_MODULE:= libsha-kexec
LOCAL_MODULE_TAGS := eng
#LOCAL_REQUIRED_MODULES := libc_bionic

include $(BUILD_STATIC_LIBRARY)