#!/bin/bash

cat system/system/app/TranssionCamera/TranssionCamera.apk.* 2>/dev/null >> system/system/app/TranssionCamera/TranssionCamera.apk
rm -f system/system/app/TranssionCamera/TranssionCamera.apk.* 2>/dev/null
cat system/system/apex/com.android.runtime.release.apex.* 2>/dev/null >> system/system/apex/com.android.runtime.release.apex
rm -f system/system/apex/com.android.runtime.release.apex.* 2>/dev/null
cat product/priv-app/GmsCore/GmsCore.apk.* 2>/dev/null >> product/priv-app/GmsCore/GmsCore.apk
rm -f product/priv-app/GmsCore/GmsCore.apk.* 2>/dev/null
cat product/priv-app/Velvet/Velvet.apk.* 2>/dev/null >> product/priv-app/Velvet/Velvet.apk
rm -f product/priv-app/Velvet/Velvet.apk.* 2>/dev/null
cat product/app/WebViewGoogle/WebViewGoogle.apk.* 2>/dev/null >> product/app/WebViewGoogle/WebViewGoogle.apk
rm -f product/app/WebViewGoogle/WebViewGoogle.apk.* 2>/dev/null
cat product/operator/app/Photos/Photos.apk.* 2>/dev/null >> product/operator/app/Photos/Photos.apk
rm -f product/operator/app/Photos/Photos.apk.* 2>/dev/null
