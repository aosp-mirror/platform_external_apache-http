# Copyright (C) 2014 The Android Open Source Project
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
LOCAL_PATH:= $(call my-dir)

apache_http_src_files := \
    $(call all-java-files-under,src) \
    $(call all-java-files-under,android)

apache_http_java_libs := conscrypt

include $(CLEAR_VARS)
LOCAL_MODULE := org.apache.http.legacy.boot
LOCAL_MODULE_TAGS := optional
LOCAL_JAVA_LIBRARIES := $(apache_http_java_libs)
LOCAL_SRC_FILES := $(apache_http_src_files)
LOCAL_MODULE_TAGS := optional
include $(BUILD_JAVA_LIBRARY)

APACHE_HTTP_LEGACY_API_FILE := $(LOCAL_PATH)/api/apache-http-legacy-current.txt
APACHE_HTTP_LEGACY_REMOVED_API_FILE := $(LOCAL_PATH)/api/apache-http-legacy-removed.txt

# For unbundled build we'll use the prebuilt jar from prebuilts/sdk.
ifeq (,$(TARGET_BUILD_APPS)$(filter true,$(TARGET_BUILD_PDK)))

full_classes_jar := $(call intermediates-dir-for,JAVA_LIBRARIES,org.apache.http.legacy,,COMMON)/classes.jar
# Archive a copy of the classes.jar in SDK build.
$(call dist-for-goals,sdk win_sdk,$(full_classes_jar):org.apache.http.legacy.jar)

# Check that the org.apache.http.legacy.stubs library has not changed
# ===================================================================

# Check that the API we're building hasn't changed from the not-yet-released
# SDK version.
$(eval $(call check-api, \
    check-apache-http-legacy-api-current, \
    $(APACHE_HTTP_LEGACY_API_FILE), \
    $(INTERNAL_PLATFORM_APACHE_HTTP_API_FILE), \
    $(APACHE_HTTP_LEGACY_REMOVED_API_FILE), \
    $(INTERNAL_PLATFORM_APACHE_HTTP_REMOVED_API_FILE), \
    -error 2 -error 3 -error 4 -error 5 -error 6 \
    -error 7 -error 8 -error 9 -error 10 -error 11 -error 12 -error 13 -error 14 -error 15 \
    -error 16 -error 17 -error 18 -error 19 -error 20 -error 21 -error 23 -error 24 \
    -error 25 -error 26 -error 27, \
    cat $(LOCAL_PATH)/api/apicheck_msg_apache_http_legacy.txt, \
    check-apache-http-legacy-api, \
    $(OUT_DOCS)/apache-http-stubs-gen-docs-stubs.srcjar \
    ))

.PHONY: check-apache-http-legacy-api
checkapi: check-apache-http-legacy-api

.PHONY: update-apache-http-legacy-api
update-api: update-apache-http-legacy-api

update-apache-http-legacy-api: $(INTERNAL_PLATFORM_APACHE_HTTP_API_FILE) | $(ACP)
	@echo Copying apache-http-legacy-current.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_APACHE_HTTP_API_FILE) $(APACHE_HTTP_LEGACY_API_FILE)
	@echo Copying apache-http-legacy-removed.txt
	$(hide) $(ACP) $(INTERNAL_PLATFORM_APACHE_HTTP_REMOVED_API_FILE) $(APACHE_HTTP_LEGACY_REMOVED_API_FILE)

endif  # not TARGET_BUILD_APPS

apache_http_src_files :=
apache_http_java_libs :=
