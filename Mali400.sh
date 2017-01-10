#!/bin/bash
set -e
##############################################
##
## Compile Mali450
##
##############################################
if [ -z $ROOT ]; then
	ROOT=`cd .. && pwd`
fi

# Knernel Direct
LINUX=$ROOT/kernel
# Compile Toolchain
TOOLS=$ROOT/toolchain/gcc-linaro-aarch/bin/aarch64-linux-gnu-
# OUTPUT DIRECT
BUILD=$ROOT/output
UMP_KO=$ROOT/kernel/modules/gpu/mali400/kernel_mode/driver/src/devicedrv
MALI_DRM=$ROOT/kernel/modules/gpu/mali400/kernel_mode/driver/src/egl/x11/drm_module/mali_drm
CORES=$((`cat /proc/cpuinfo | grep processor | wc -l` - 1))

if [ ! -d $BUILD ]; then
	mkdir -p $BUILD
fi 

echo -e "\e[1;31m Compile Mali400 Module \e[0m"
if [ ! -d $BUILD/lib ]; then
	mkdir -p $BUILD/lib
fi 

# Compile Mali450 driver
make -C ${LINUX}/modules/gpu ARCH=arm64 CROSS_COMPILE=$TOOLS LICHEE_KDIR=${LINUX} \
	LICHEE_MOD_DIR=$BUILD/lib LICHEE_PLATFORM=linux

# Install mali driver
MALI_MOD_DIR=$BUILD/lib/modules/`cat $LINUX/include/config/kernel.release 2> /dev/null`/kernel/drivers/gpu
install -d $MALI_MOD_DIR
cp $UMP_KO/mali/mali.ko $MALI_MOD_DIR
cp $UMP_KO/ump/ump.ko   $MALI_MOD_DIR
cp $UMP_KO/umplock/umplock.ko $MALI_MOD_DIR
cp $MALI_DRM/mali_drm.ko $MALI_MOD_DIR








