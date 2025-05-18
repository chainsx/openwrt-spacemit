include $(TOPDIR)/rules.mk

PKG_NAME:=spacemit-boot-firmware
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/spacemit-boot-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Spacemit boot Firmware
  DEPENDS:=@TARGET_spacemit_k1_sbc
endef

define Build/Compile
endef

define Package/spacemit-boot-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/
	$(INSTALL_DATA) \
		./files/esos.elf \
		$(1)/lib/firmware/esos.elf
endef

$(eval $(call BuildPackage,spacemit-boot-firmware))
