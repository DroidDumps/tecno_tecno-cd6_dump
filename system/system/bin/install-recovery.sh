#!/system/bin/sh
if ! applypatch --check EMMC:/dev/block/platform/bootdevice/by-name/recovery:40894464:f65482047c91890a46252563268331cfc657e17a; then
  applypatch  \
          --patch /system/recovery-from-boot.p \
          --source EMMC:/dev/block/platform/bootdevice/by-name/boot:33554432:5238575ec6d5dbaa5f6e7c0822f905648592681a \
          --target EMMC:/dev/block/platform/bootdevice/by-name/recovery:40894464:f65482047c91890a46252563268331cfc657e17a && \
      log -t recovery "Installing new recovery image: succeeded" || \
      log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
