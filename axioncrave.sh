#!/bin/bash
rm -rf out/
#build
source build/envsetup.sh && axion a21s va && ax -br -j24

rm -rf out/target/product/a21s/lineage_a21s-ota.zip
echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
