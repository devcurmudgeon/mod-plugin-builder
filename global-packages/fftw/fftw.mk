################################################################################
#
# fftw
#
################################################################################

FFTW_VERSION = 3.3.4+git20151030
FFTW_SITE = http://web1.moddevices.com/shared
FFTW_SOURCE = fftw-$(FFTWF_VERSION).tar.gz
FFTW_LICENSE = GPLv2+
FFTW_LICENSE_FILES = COPYING
FFTW_INSTALL_STAGING = YES

FFTW_CONF_OPTS  = --enable-openmp
FFTW_CONF_OPTS += --enable-threads
FFTW_CONF_OPTS += --disable-doc
FFTW_CONF_OPTS += --disable-debug
ifdef BR2_x86_64
FFTW_CONF_OPTS += --enable-sse2
endif

FFTW_CONF_OPTS += CFLAGS="$(TARGET_CFLAGS) -fstrict-aliasing" CXXFLAGS="$(TARGET_CXXFLAGS) -fstrict-aliasing"

$(eval $(autotools-package))
$(eval $(host-autotools-package))