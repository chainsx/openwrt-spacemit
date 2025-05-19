# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Spacemit Ltd.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

PARTITION_FILE=$(PWD)/image/partition_tables/partition_universal.json
BOOTFS_SIZE := $(shell jq -r '.partitions[] | select(.name=="bootfs") | .size' $(PARTITION_FILE))
BOOTFS_SIZE_KB := $(shell echo "$(BOOTFS_SIZE)" | sed 's/M/*1024/' | bc)

KERNEL_LOADADDR:=0x1400000
define Build/boot-common
	rm -f $@.boot
	mkfs.fat -n boot -C $@.boot $(BOOTFS_SIZE_KB)
	
	mcopy -i $@.boot $(IMAGE_KERNEL) ::$(KERNEL_IMG)
	mcopy -i $@.boot -s extlinux ::/
	$(foreach dts,$(shell echo $(DEVICE_DTS)),mcopy -i $@.boot $(LINUX_DIR)/arch/riscv/boot/dts/$(DEVICE_DTS).dtb ::spacemit.dtb;)
	
	rm -rf $(KDIR_TMP)/factory
	rm -f $(KDIR_TMP)/env.bin \
	   $(KDIR_TMP)/fw_dynamic.itb \
	   $(KDIR_TMP)/u-boot.itb
	
	mkdir -p $(KDIR_TMP)/factory/
	cp opensbi/fw_dynamic.itb $(KDIR_TMP)
	cp u-boot/u-boot.itb $(KDIR_TMP)
	cp u-boot/env.bin $(KDIR_TMP)
	cp u-boot/bootinfo_sd.bin $(KDIR_TMP)/factory/
	cp u-boot/FSBL.bin $(KDIR_TMP)/factory/
endef

define Build/sdcard-img
	./gen_spacemit_sdcard_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
		$(PARTITION_FILE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)

endef

define Device/Default
  PROFILES := Default
  KERNEL_NAME := Image
  KERNEL_IMG := Image.itb
  KERNEL := kernel-bin | fit none
  IMAGES := sdcard.img.gz
  IMAGE/sdcard.img.gz := $(KERNEL_IMG) | boot-common | sdcard-img | gzip | append-metadata
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
