# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2021-2022 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8852bs
PKG_RELEASE:=1

PKG_SOURCE_URL:=https://github.com/chainsx/wifi-rtl8852bs.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2025-05-15
PKG_SOURCE_VERSION:=be28e49dca275fffde8f23f4f811c270f55be3af
PKG_MIRROR_HASH:=d6f4e202d2493866f2987d15c777429065b8f412ff6f05eb656e63b58c452a74

PKG_BUILD_PARALLEL:=1

STAMP_CONFIGURED_DEPENDS := $(STAGING_DIR)/usr/include/mac80211-backport/backport/autoconf.h

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/rtl8852bs
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek RTL8852BS SDIO WiFi
  DEPENDS:=+kmod-cfg80211 +kmod-mmc
  FILES:=$(PKG_BUILD_DIR)/rtl8852bs.ko
  AUTOLOAD:=$(call AutoProbe,rtl8852bs)
endef

NOSTDINC_FLAGS:= \
	$(KERNEL_NOSTDINC_FLAGS) \
	-I$(PKG_BUILD_DIR) \
	-I$(PKG_BUILD_DIR)/include \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-I$(STAGING_DIR)/usr/include/mac80211-backport/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-include backport/autoconf.h \
	-include backport/backport.h

NOSTDINC_FLAGS+= \
	-DRTW_SINGLE_WIPHY \
	-DRTW_USE_CFG80211_STA_EVENT \
	-DCONFIG_IOCTL_CFG80211 \
	-DBUILD_OPENWRT

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) \
		M="$(PKG_BUILD_DIR)" \
		NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
		CONFIG_RTL8852BS=m \
		USER_MODULE_NAME=rtl8852bs \
		modules
endef

$(eval $(call KernelPackage,rtl8852bs))
