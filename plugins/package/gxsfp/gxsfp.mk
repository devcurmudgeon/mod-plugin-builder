######################################
#
# gxsfp
#
######################################

GXSFP_VERSION = a4083118d75205842db2952ccba67a8126d6022c
GXSFP_SITE = $(call github,brummer10,GxSuperFuzz.lv2,$(GXSFP_VERSION))
GXSFP_BUNDLES = gx_sfp.lv2

GXSFP_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) SSE_CFLAGS="-O3 -mfpu=vfpv3" -C $(@D)

define GXSFP_BUILD_CMDS
	$(GXSFP_TARGET_MAKE) mod
endef

define GXSFP_INSTALL_TARGET_CMDS
	$(GXSFP_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
endef

$(eval $(generic-package))
