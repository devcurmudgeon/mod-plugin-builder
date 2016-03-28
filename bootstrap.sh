#!/bin/bash

source .common

#######################################################################################################################
# download and extract crosstool-ng

if [ ! -f ${DOWNLOAD_DIR}/${CT_NG_FILE} ]; then
  wget ${CT_NG_LINK}/${CT_NG_FILE} -O ${DOWNLOAD_DIR}/${CT_NG_FILE}
fi

if [ ! -d ${BUILD_DIR}/${CT_NG_VERSION} ]; then
  tar xf ${DOWNLOAD_DIR}/${CT_NG_FILE} -C ${BUILD_DIR}
fi

#######################################################################################################################
# build crosstool-ng

cd ${BUILD_DIR}/${CT_NG_VERSION}

if [ ! -f .config ]; then
  cp ${SOURCE_DIR}/toolchain/modduo.config .config
  sed -i "s|CT_LOCAL_TARBALLS_DIR=.*|CT_LOCAL_TARBALLS_DIR=\"${DOWNLOAD_DIR}\"|" .config
  sed -i "s|CT_PREFIX_DIR=.*|CT_PREFIX_DIR=\"${TOOLCHAIN_DIR}\"|" .config
fi

if [ ! -f .stamp_configured ]; then
  ./configure --enable-local
  touch .stamp_configured
fi

if [ ! -f .stamp_built1 ]; then
  make
  touch .stamp_built1
fi

if [ ! -f .stamp_built2 ]; then
  ./ct-ng build
  touch .stamp_built2
fi

#######################################################################################################################
# download and extract buildroot

if [ ! -f ${DOWNLOAD_DIR}/${BUILDROOT_FILE} ]; then
  wget ${BUILDROOT_LINK}/${BUILDROOT_FILE} -O ${DOWNLOAD_DIR}/${BUILDROOT_FILE}
fi

if [ ! -d ${BUILD_DIR}/${BUILDROOT_VERSION} ]; then
  tar xf ${DOWNLOAD_DIR}/${BUILDROOT_FILE} -C ${BUILD_DIR}
fi

#######################################################################################################################
# buildroot setup

export DOWNLOAD_PATH=${DOWNLOAD_DIR}
export TOOLCHAIN_PATH=${TOOLCHAIN_DIR}

mkdir -p /tmp/skeleton

#######################################################################################################################
# initial first build

cd ${BUILD_DIR}/${BUILDROOT_VERSION}

for dir in `ls ${SOURCE_DIR}/global-packages`; do
    rm -rf package/${dir}
    cp -r ${SOURCE_DIR}/global-packages/${dir} package/${dir}
done

make O=${WORKDIR}/${build} BR2_EXTERNAL=${SOURCE_DIR}/${build} modduo_defconfig

if [[ "${build}" == "plugins-dep" ]]; then
  make O=${WORKDIR}/${build} BR2_EXTERNAL=${SOURCE_DIR}/${build}
fi

#######################################################################################################################