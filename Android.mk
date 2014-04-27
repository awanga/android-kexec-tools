#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(my-dir)

ifeq ($(TARGET_ARCH),arm)
	ARCH := arm
else ifeq ($(TARGET_ARCH),mips)
	ARCH := mips
else ifeq ($(TARGET_ARCH),x86)
	ARCH := i386
else ifeq ($(TARGET_ARCH),x86_64)
	ARCH := x86_64
endif

include $(call first-makefiles-under,$(LOCAL_PATH))