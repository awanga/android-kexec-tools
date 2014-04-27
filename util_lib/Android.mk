#
# Utility function library
#
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_CFLAGS += -I$(LOCAL_PATH)/include -I$(LOCAL_PATH)/util_lib/include

LOCAL_SRC_FILES := compute_ip_checksum.c sha256.c

LOCAL_MODULE:= libutil-kexec
LOCAL_MODULE_TAGS := eng

include $(BUILD_HOST_STATIC_LIBRARY)

