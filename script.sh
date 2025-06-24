#!/bin/bash
rm -rf .repo/local_manifests
repo init -u https://github.com/RisingOS-Revived/android -b qpr2 --git-lfs
git clone https://github.com/samsungexynos850/local_manifests  -b slsi .repo/local_manifests
/opt/crave/resync.sh
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b master
source build/envsetup.sh 
riseup a21s && rise b
