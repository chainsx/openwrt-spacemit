# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Spacemit Ltd.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

BOOTFS_SIZE_KB := $(shell echo "$(CONFIG_TARGET_KERNEL_PARTSIZE)*1024" | bc)

KERNEL_LOADADDR:=0x1400000
define Build/boot-common
	rm -fR $@.boot
	mkdir -p $@.boot
	$(CP) $(IMAGE_KERNEL) $@.boot/$(KERNEL_IMG)
	$(CP) -r extlinux $@.boot
	$(foreach dts,$(shell echo $(DEVICE_DTS)),cp $(LINUX_DIR)/arch/riscv/boot/dts/$(DEVICE_DTS).dtb $@.boot/spacemit.dtb;)
	
	rm -rf $(KDIR_TMP)/factory
	rm -f $(KDIR_TMP)/env.bin \
	   $(KDIR_TMP)/fw_dynamic.itb \
	   $(KDIR_TMP)/u-boot.itb
	
	mkdir -p $(KDIR_TMP)/factory/
	cp opensbi/fw_dynamic.itb $(KDIR_TMP)
	cp u-boot/u-boot.itb $(KDIR_TMP)
	cp u-boot/env.bin $(KDIR_TMP)
	cp u-boot/bootinfo_emmc.bin $(KDIR_TMP)/factory/
	cp u-boot/FSBL.bin $(KDIR_TMP)/factory/
endef

define Build/sdcard-img
	#./gen_spacemit_sdcard_img.sh $@ $@.boot $(IMAGE_ROOTFS) \
	#	$(CONFIG_TARGET_KERNEL_PARTSIZE) $(CONFIG_TARGET_ROOTFS_PARTSIZE)

	PADDING=1 $(SCRIPT_DIR)/gen_image_generic.sh \
		$@ \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		8192

	#dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-u-boot-rockchip.bin of="$@" seek=64 conv=notrunc
	
	dd if=$(KDIR_TMP)/factory/bootinfo_emmc.bin	of="$@" bs=512		conv=notrunc
	dd if=$(KDIR_TMP)/factory/FSBL.bin		of="$@" bs=512		seek=1		conv=notrunc
	dd if=$(KDIR_TMP)/factory/FSBL.bin		of="$@" bs=512		seek=512	conv=notrunc
	dd if=$(KDIR_TMP)/env.bin			of="$@" bs=512		seek=768	conv=notrunc
	dd if=$(KDIR_TMP)/fw_dynamic.itb		of="$@" bs=512		seek=1280	conv=notrunc
	dd if=$(KDIR_TMP)/u-boot.itb			of="$@" bs=512		seek=2048	conv=notrunc

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
