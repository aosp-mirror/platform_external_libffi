# Copyright (C) 2015 The Android Open Source Project
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

LOCAL_PATH:= $(call my-dir)

LIBFFI_TEMPLATE_SUBST := -e s/@VERSION@/3.2.1/
LIBFFI_TEMPLATE_SUBST += -e s/@TARGET@/FAKE_TARGET_/
LIBFFI_TEMPLATE_SUBST += -e s/@HAVE_LONG_DOUBLE@/CONF_HAVE_LONG_DOUBLE/
LIBFFI_TEMPLATE_SUBST += -e s/@HAVE_LONG_DOUBLE_VARIANT@/CONF_HAVE_LONG_DOUBLE_VARIANT/
LIBFFI_TEMPLATE_SUBST += -e s/@FFI_EXEC_TRAMPOLINE_TABLE@/CONF_FFI_EXEC_TRAMPOLINE_TABLE/

include $(CLEAR_VARS)

# Note: AOSP has (or had) a platform/external/libffi used by Dalvik/MIPS.
# To avoid confusion, we call our version of the library cheets-libffi.
LOCAL_MODULE := cheets-libffi
LOCAL_MODULE_TAGS := optional

ffi_arch := $(TARGET_ARCH)
ffi_os := $(TARGET_OS)

# Note: We created the "<OS>-<arch>" include directories to ease configuration
# for each target.
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/$(ffi_os)-$(ffi_arch) \

LOCAL_CFLAGS += -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-sign-compare

ifeq ($(ffi_os)-$(ffi_arch),linux-arm)
LOCAL_SRC_FILES := src/arm/sysv.S src/arm/ffi.c
endif

ifeq ($(ffi_os)-$(ffi_arch),linux-x86)
LOCAL_SRC_FILES := src/x86/ffi.c src/x86/sysv.S
LOCAL_ASFLAGS += -DHAVE_AS_X86_PCREL
endif

ifeq ($(ffi_os)-$(ffi_arch),linux-x86_64)
LOCAL_SRC_FILES := src/x86/ffi64.c src/x86/unix64.S
LOCAL_ASFLAGS += -DHAVE_AS_X86_PCREL
endif

ifeq ($(LOCAL_SRC_FILES),)
$(error The os/architecture $(ffi_os)-$(ffi_arch) is not supported by cheets-libffi.)
endif

LOCAL_SRC_FILES += \
	src/debug.c \
	src/java_raw_api.c \
	src/prep_cif.c \
	src/raw_api.c \
	src/types.c

# --- Generate include/ffi-real.h from include/ffi.h.in
GEN := $(addprefix $(LOCAL_PATH)/include/, \
						ffi.h \
				)
LOCAL_ADDITIONAL_DEPENDENCIES += $(GEN)
$(GEN) : PRIVATE_PATH := $(LOCAL_PATH)
$(GEN) : PRIVATE_CUSTOM_TOOL = sed $(LIBFFI_TEMPLATE_SUBST) < $< > $@
$(GEN) : $(LOCAL_PATH)/include/%.h : $(LOCAL_PATH)/include/%.h.in
	$(transform-generated-source)
# Note: The line above must be indented with tabs.

include $(BUILD_STATIC_LIBRARY)