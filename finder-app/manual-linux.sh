#!/bin/bash
# Script outline to install and build kernel.
# Author: Siddhant Jajoo.

set -e
set -u
#set -x

OUTDIR=/tmp/aeld
KERNEL_REPO=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
KERNEL_VERSION=v5.15.163
BUSYBOX_VERSION=1_33_1
FINDER_APP_DIR=$(realpath $(dirname $0))
#exporting the files below so that I wont be explicitly calling it every `make` command and
#the target for this assignment is the environment below only
CORES=$(nproc)
export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-

if [ $# -lt 1 ]
then
	echo "Using default directory ${OUTDIR} for output"
else
	OUTDIR=$1
	echo "Using passed directory ${OUTDIR} for output"
fi

mkdir -p ${OUTDIR}

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/linux-stable" ]; then
    #Clone only if the repository does not exist.
	echo "CLONING GIT LINUX STABLE VERSION ${KERNEL_VERSION} IN ${OUTDIR}"
	git clone ${KERNEL_REPO} --depth 1 --single-branch --branch ${KERNEL_VERSION}
fi
if [ ! -e ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ]; then
    cd linux-stable
    echo "Checking out version ${KERNEL_VERSION}"
    git checkout ${KERNEL_VERSION}

    # TODO: Add your kernel build steps here
    # Since I already exported the target build system, i dont need to call it for every make
    #clean
    make mrproper
    #default configuration
    make defconfig
    #build the kernel with all cores in the current system
    make -j${CORES} all
    #modules
    make modules
    #device tree
    make dtbs
fi

echo "Adding the Image in outdir"
#This above should really be a TODO. I was getting Missing kernel image at /tmp/aesd-autograder/Image because there
#is no TODO tag here
cp ${OUTDIR}/linux-stable/arch/${ARCH}/boot/Image ${OUTDIR}

echo "Creating the staging directory for the root filesystem"
cd "$OUTDIR"
if [ -d "${OUTDIR}/rootfs" ]
then
	echo "Deleting rootfs directory at ${OUTDIR}/rootfs and starting over"
    sudo rm  -rf ${OUTDIR}/rootfs
fi

# TODO: Create necessary base directories
mkdir rootfs
cd rootfs
mkdir -p bin dev etc home lib lib64 proc sbin sys tmp usr var
mkdir -p usr/bin usr/lib usr/sbin
mkdir -p var/log

cd "$OUTDIR"
if [ ! -d "${OUTDIR}/busybox" ]
then
git clone git://busybox.net/busybox.git
    cd busybox
    git checkout ${BUSYBOX_VERSION}
    # TODO:  Configure busybox
    make distclean
    make defconfig
else
    cd busybox
fi

# TODO: Make and install busybox
	make
    make CONFIG_PREFIX=${OUTDIR}/rootfs install

cd ${OUTDIR}/rootfs

echo "Library dependencies"
${CROSS_COMPILE}readelf -a bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a bin/busybox | grep "Shared library"

cd ${OUTDIR}/rootfs

# TODO: Add library dependencies to rootfs
#Since the program interpreter and shared libraries were given in the video 
#i wont bother searching for them dynamically

PATH_TO_XCOMPILE=$(dirname $(which ${CROSS_COMPILE}gcc))
PATH_TO_XCOMPILE_PARENT_DIR=$(dirname $PATH_TO_XCOMPILE)
cp ${PATH_TO_XCOMPILE_PARENT_DIR}/aarch64-none-linux-gnu/libc/lib/ld-linux-aarch64.so.1 ${OUTDIR}/rootfs/lib
cp ${PATH_TO_XCOMPILE_PARENT_DIR}/aarch64-none-linux-gnu/libc/lib64/libm.so.6 ${OUTDIR}/rootfs/lib64
cp ${PATH_TO_XCOMPILE_PARENT_DIR}/aarch64-none-linux-gnu/libc/lib64/libresolv.so.2 ${OUTDIR}/rootfs/lib64
cp ${PATH_TO_XCOMPILE_PARENT_DIR}/aarch64-none-linux-gnu/libc/lib64/libc.so.6 ${OUTDIR}/rootfs/lib64

echo "Making dev nodes in"
pwd

# TODO: Make device nodes
sudo mknod -m 666 dev/null c 1 3
sudo mknod -m 666 dev/console c 5 1

# TODO: Clean and build the writer utility
#return to finder app
cd ${FINDER_APP_DIR}
make clean
make all

# TODO: Copy the finder related scripts and executables to the /home directory
# on the target rootfs
cp -fR * ${OUTDIR}/rootfs/home/

# TODO: Chown the root directory
sudo chown root:root ${OUTDIR}/rootfs


# TODO: Create initramfs.cpio.gz
cd ${OUTDIR}/rootfs
find . | cpio -H newc -ov --owner root:root > ${OUTDIR}/initramfs.cpio
cd ${OUTDIR}
gzip -f initramfs.cpio
