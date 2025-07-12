#!/bin/bash
echo "====================== BUILD STARTED ======================"
rm -rf out/
# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
