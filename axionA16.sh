#!/bin/bash
rm -rf out

source build/envsetup.sh && axionSync
axion a21s && ax -br
rm -rf out/target/product/a21s/lineage_a21s-ota.zip
echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
