# Copyright 2007 The Android Open Source Project

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

# List of test cases.  Note that closures are not supported on ARM, so
# none of "closure*" or "cls*" will work there.
FFI_TEST_BASE := $(LOCAL_PATH)
FFI_TEST_FILES := \
		closure_fn0.c \
		closure_fn1.c \
		closure_fn2.c \
		closure_fn3.c \
		closure_fn4.c \
		closure_fn5.c \
		closure_fn6.c \
		cls_12byte.c \
		cls_16byte.c \
		cls_18byte.c \
		cls_19byte.c \
		cls_1_1byte.c \
		cls_20byte.c \
		cls_20byte1.c \
		cls_24byte.c \
		cls_2byte.c \
		cls_3_1byte.c \
		cls_3byte1.c \
		cls_3byte2.c \
		cls_4_1byte.c \
		cls_4byte.c \
		cls_5_1_byte.c \
		cls_5byte.c \
		cls_64byte.c \
		cls_6_1_byte.c \
		cls_6byte.c \
		cls_7_1_byte.c \
		cls_7byte.c \
		cls_8byte.c \
		cls_9byte1.c \
		cls_9byte2.c \
		cls_align_double.c \
		cls_align_float.c \
		cls_align_longdouble.c \
		cls_align_pointer.c \
		cls_align_sint16.c \
		cls_align_sint32.c \
		cls_align_sint64.c \
		cls_align_uint16.c \
		cls_align_uint32.c \
		cls_align_uint64.c \
		cls_double.c \
		cls_float.c \
		cls_multi_schar.c \
		cls_multi_sshort.c \
		cls_multi_sshortchar.c \
		cls_multi_uchar.c \
		cls_multi_ushort.c \
		cls_multi_ushortchar.c \
		cls_schar.c \
		cls_sint.c \
		cls_sshort.c \
		cls_uchar.c \
		cls_uint.c \
		cls_ulonglong.c \
		cls_ushort.c \
		float.c \
		float1.c \
		float2.c \
		float3.c \
		float4.c \
		many.c \
		negint.c \
		nested_struct.c \
		nested_struct1.c \
		nested_struct10.c \
		nested_struct2.c \
		nested_struct3.c \
		nested_struct4.c \
		nested_struct5.c \
		nested_struct6.c \
		nested_struct7.c \
		nested_struct8.c \
		nested_struct9.c \
		problem1.c \
		promotion.c \
		pyobjc-tc.c \
		return_dbl.c \
		return_dbl1.c \
		return_dbl2.c \
		return_fl.c \
		return_fl1.c \
		return_fl2.c \
		return_fl3.c \
		return_ll.c \
		return_ll1.c \
		return_sc.c \
		return_uc.c \
		return_ul.c \
		strlen.c \
		struct1.c \
		struct2.c \
		struct3.c \
		struct4.c \
		struct5.c \
		struct6.c \
		struct7.c \
		struct8.c \
		struct9.c

#		many_win32.c \
#		strlen_win32.c \
#

# define this to make it stop on the first error
#FFI_EXIT := exit 1
FFI_EXIT := true

#
# Build and run each test individually.  This doesn't work for device builds.
# The alternative is to build and install all of the little tests on the
# device, but that seems silly.
#
ffitests:
	@echo "Testing with LD_LIBRARY_PATH=$(TARGET_OUT_SHARED_LIBRARIES) /tmp/android-ffi-test"
	@(for file in $(FFI_TEST_FILES); do \
		echo -n $$file ;\
		$(CC) -g -Iexternal/libffi/$(TARGET_OS)-$(TARGET_ARCH) \
			-o /tmp/android-ffi-test \
			$(FFI_TEST_BASE)/libffi.call/$$file \
			-L$(TARGET_OUT_SHARED_LIBRARIES) -lffi ;\
		LD_LIBRARY_PATH=$(TARGET_OUT_SHARED_LIBRARIES) /tmp/android-ffi-test > /tmp/android-ffi-out ;\
		if [ "$$?" -eq 0 ]; then \
		    echo " OK" ;\
		else \
		    echo " FAIL" ;\
			cat /tmp/android-ffi-out ;\
			$(FFI_EXIT) ;\
		fi ;\
		done ;\
	)
	rm -f /tmp/android-ffi-test

#
# Build and install one test, so we have something to try on the device.
#
LOCAL_MODULE := ffitest_struct5
LOCAL_SRC_FILES := libffi.call/struct5.c
LOCAL_C_INCLUDES := external/libffi/$(TARGET_OS)-$(TARGET_ARCH)
LOCAL_SHARED_LIBRARIES := libffi

LOCAL_MODULE_TAGS := tests

include $(BUILD_EXECUTABLE)
