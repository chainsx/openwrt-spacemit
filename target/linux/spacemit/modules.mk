define KernelPackage/rtl8852bs
  TITLE:=rtl8852bs sdio wifi driver
  KCONFIG:=CONFIG_RTL8852BS
  SUBMENU:=Wireless Drivers
  DEPENDS+=+kmod-mac80211
  FILES:=$(LINUX_DIR)/drivers/net/wireless/realtek/rtl8852bs/8852bs.ko
  AUTOLOAD:=$(call AutoLoad,99,8852bs)
endef

define KernelPackage/rtl8852bs/description
 Kernel modules for rtl8852bs sdio wifi
endef

$(eval $(call KernelPackage,rtl8852bs))


