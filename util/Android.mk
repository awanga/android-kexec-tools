#
# bin-to-hex
#
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := bin-to-hex.c

LOCAL_MODULE := bin-to-hex
LOCAL_MODULE_TAGS := eng
LOCAL_STATIC_LIBRARIES := libutil-kexec

include $(BUILD_HOST_EXECUTABLE)

