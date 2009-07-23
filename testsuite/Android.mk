# Copyright 2007 The Android Open Source Project
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
include $(CLEAR_VARS)


#
# Common definitions for host and target
#

# Single test file to use when doing default build. For the target
# (device), this is the only way to build and run tests, but for the
# host you can use the "run-ffi-tests" script in this directory to
# run all the tests.
FFI_SINGLE_TEST_FILE := libffi.call/struct5.c


#
# Build rules for the target.
#

# We only build ffi at all for non-arm targets.
ifneq ($(TARGET_ARCH),arm)

    include $(CLEAR_VARS)

    LOCAL_SRC_FILES := $(FFI_SINGLE_TEST_FILE)
    LOCAL_C_INCLUDES := external/libffi/$(TARGET_OS)-$(TARGET_ARCH)
    LOCAL_SHARED_LIBRARIES := libffi

    LOCAL_MODULE := ffi-test
    LOCAL_MODULE_TAGS := tests

    include $(BUILD_EXECUTABLE)

endif


#
# Build rules for the host.
#

ifeq ($(WITH_HOST_DALVIK),true)

    include $(CLEAR_VARS)

    LOCAL_SRC_FILES := $(FFI_SINGLE_TEST_FILE)
    LOCAL_C_INCLUDES := external/libffi/$(HOST_OS)-$(HOST_ARCH)
    LOCAL_SHARED_LIBRARIES := libffi-host

    LOCAL_MODULE := ffi-test-host
    LOCAL_MODULE_TAGS := tests

    include $(BUILD_HOST_EXECUTABLE)

endif
