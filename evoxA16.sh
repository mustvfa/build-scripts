#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init
repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

# Local manifests
git clone https://github.com/mustvfa/local_manifests- -b slsi .repo/local_manifests

# Clean clang before sync
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
/opt/crave/resync.sh
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags
echo "======================= Repo Sync Done =========================="

#errors fixs
rm -rf hardware/samsung/hidl/touch
rm -rf hardware/samsung_slsi-linaro/openmax
git clone -b lineage-22.2 https://github.com/mustvfa/android_hardware_samsung_slsi-linaro_openmax hardware/samsung_slsi-linaro/openmax

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.0
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b evox
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b evox
git clone https://github.com/mustvfa/upstream_exynos850 kernel/samsung/exynos850 -b master

# kernel
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="
#build signing
git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && cd vendor/evolution-priv/keys && ./keys.sh
cd ../../..

# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
