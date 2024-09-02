#!/bin/bash

rm -rf target/linux package/kernel package/boot package/firmware package/network/utils/fullconenat-nft

mkdir new; cp -rf .git new/.git
cd new
git reset --hard origin/master

cp -rf --parents target/linux package/kernel package/boot package/network/utils/fullconenat-nft package/firmware include/kernel* config/Config-images.in config/Config-kernel.in include/image*.mk include/trusted-firmware-a.mk scripts/ubinize-image.sh package/utils/bcm27xx-utils package/devel/perf ../
cd ..

echo 'src-git xd https://github.com/shiyu1314/openwrt-packages' >>feeds.conf.default
git clone -b master --depth 1 --single-branch https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone -b v5-lua --depth 1 --single-branch https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns
git clone -b master --depth 1 --single-branch https://github.com/shiyu1314/luci-app-homeproxy package/xd/luci-app-homeproxy
git clone https://github.com/QiuSimons/luci-app-daed package/dae


./scripts/feeds update -a
rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/v2ray-geodata

./scripts/feeds update -a
./scripts/feeds install -a

sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

sudo rm -rf package/base-files/files/etc/banner

sed -i "s/%D %V %C/%D $(TZ=UTC-8 date +%Y.%m.%d)/" package/base-files/files/etc/openwrt_release

sed -i "s/%R/by $OP_author/" package/base-files/files/etc/openwrt_release


date=$(date +"%Y-%m-%d")
echo "                                                    " >> package/base-files/files/etc/banner
echo ".___                               __         .__" >> package/base-files/files/etc/banner
echo "|   | _____   _____   ____________/  |______  |  |" >> package/base-files/files/etc/banner
echo "|   |/     \ /     \ /  _ \_  __ \   __\__  \ |  |" >> package/base-files/files/etc/banner
echo "|   |  Y Y  \  Y Y  (  <_> )  | \/|  |  / __ \|  |__" >> package/base-files/files/etc/banner
echo "|___|__|_|  /__|_|  /\____/|__|   |__| (____  /____/" >> package/base-files/files/etc/banner
echo "          \/      \/                        \/      " >> package/base-files/files/etc/banner
echo " -----------------------------------------------------" >> package/base-files/files/etc/banner
echo "         %D ${date} by $OP_author                     " >> package/base-files/files/etc/banner
echo " -----------------------------------------------------" >> package/base-files/files/etc/banner
echo "                                                      " >> package/base-files/files/etc/banner
