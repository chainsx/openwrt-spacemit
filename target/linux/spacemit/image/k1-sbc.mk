# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Spacemit Ltd.

define Device/MUSE-Pi-Pro
  DEVICE_VENDOR := Spacemit
  DEVICE_MODEL :=k1-x pro board
  DEVICE_DTS := spacemit/k1-x_MUSE-Pi-Pro
  SOC := KeyStone
  KERNEL_NAME := Image
  KERNEL_IMG := Image.itb
  KERNEL := kernel-bin | fit none
  IMAGE := $(KERNEL_IMG) | boot-common | sdcard-img
  DEVICE_PACKAGES := kmod-rtl8852bs
endef
TARGET_DEVICES += MUSE-Pi-Pro

