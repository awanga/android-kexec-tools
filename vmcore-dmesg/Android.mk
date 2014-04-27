#
# vmcore-dmesg (reading dmesg from vmcore)
#
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := vmcore-dmesg.c

LOCAL_MODULE := vmcore-dmesg
LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE_TAGS := eng

include $(BUILD_EXECUTABLE)


