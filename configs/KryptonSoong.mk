# Copyright 2021 AOSP-Krypton Project
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

# Krypton soong configs
PATH_OVERRIDE_SOONG := $(shell echo $(PATH_OVERRIDE))

# Add variables that we wish to make available to soong here.
EXPORT_TO_SOONG := \
    BUILD_ROOT_LOC \
    KERNEL_ARCH \
    KERNEL_CROSS_COMPILE \
    KERNEL_CROSS_COMPILE_ARM32 \
    MAKE \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_MAKE_ENV_SOONG \
    TARGET_KERNEL_SOURCE

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += kryptonVarsPlugin

SOONG_CONFIG_kryptonVarsPlugin :=

define addVar
  SOONG_CONFIG_kryptonVarsPlugin += $(1)
  SOONG_CONFIG_kryptonVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

SOONG_CONFIG_NAMESPACES += kryptonGlobalVars
SOONG_CONFIG_kryptonGlobalVars += \
    target_init_vendor_lib \
    target_surfaceflinger_udfps_lib \
    target_ld_shim_libs \
    has_legacy_camera_hal1 \
    camera_needs_client_info \
    bootloader_message_offset

SOONG_CONFIG_NAMESPACES += kryptonQcomVars
SOONG_CONFIG_kryptonQcomVars += \
    uses_pre_uplink_features_netmgrd \
    supports_hw_fde \
    supports_hw_fde_perf \
    no_camera_smooth_apis \
    uses_qti_camera_device \
    qcom_display_headers_namespace

# Set default values
TARGET_INIT_VENDOR_LIB ?= vendor_init
TARGET_SURFACEFLINGER_UDFPS_LIB ?= surfaceflinger_udfps_lib
BOOTLOADER_MESSAGE_OFFSET ?= 0

# Soong bool variables
SOONG_CONFIG_kryptonQcomVars_uses_pre_uplink_features_netmgrd := $(TARGET_USES_PRE_UPLINK_FEATURES_NETMGRD)

# Soong value variables
SOONG_CONFIG_kryptonGlobalVars_target_init_vendor_lib := $(TARGET_INIT_VENDOR_LIB)
SOONG_CONFIG_kryptonGlobalVars_target_surfaceflinger_udfps_lib := $(TARGET_SURFACEFLINGER_UDFPS_LIB)
SOONG_CONFIG_kryptonGlobalVars_target_ld_shim_libs := $(subst $(space),:,$(TARGET_LD_SHIM_LIBS))
SOONG_CONFIG_kryptonGlobalVars_has_legacy_camera_hal1 := $(TARGET_HAS_LEGACY_CAMERA_HAL1)
SOONG_CONFIG_kryptonGlobalVars_camera_needs_client_info := $(TARGET_CAMERA_NEEDS_CLIENT_INFO)
SOONG_CONFIG_kryptonGlobalVars_bootloader_message_offset := $(BOOTLOADER_MESSAGE_OFFSET)
SOONG_CONFIG_kryptonQcomVars_supports_hw_fde := $(TARGET_HW_DISK_ENCRYPTION)
SOONG_CONFIG_kryptonQcomVars_supports_hw_fde_perf := $(TARGET_HW_DISK_ENCRYPTION_PERF)
SOONG_CONFIG_kryptonQcomVars_uses_qti_camera_device := $(TARGET_USES_QTI_CAMERA_DEVICE)
SOONG_CONFIG_kryptonQcomVars_no_camera_smooth_apis := $(TARGET_HAS_NO_CAMERA_SMOOTH_APIS)
SOONG_CONFIG_kryptonQcomVars_qcom_display_headers_namespace := vendor/qcom/opensource/display-commonsys-intf
