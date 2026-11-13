package com.veerens.veerens_floating_api

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Automatic store-install check for the floating API button.
 *
 * Reports whether this app was installed by a known app store (Play
 * Store, Galaxy Store, Amazon Appstore, Huawei AppGallery, …) rather
 * than sideloaded (adb install, a direct testing APK, a file manager,
 * etc). The Dart side combines this with a manual flag so the button
 * stays hidden on a real store install even if a developer forgets to
 * flip the manual flag off before a store release.
 */
class VeerensFloatingApiPlugin :
    FlutterPlugin,
    MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var appContext: Context

    private val knownStoreInstallers = setOf(
        "com.android.vending", // Google Play
        "com.sec.android.app.samsungapps", // Galaxy Store
        "com.amazon.venezia", // Amazon Appstore
        "com.huawei.appmarket", // Huawei AppGallery
    )

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        appContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "veerens_floating_api")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "isStoreInstall") {
            result.success(isStoreInstall())
        } else {
            result.notImplemented()
        }
    }

    private fun isStoreInstall(): Boolean {
        val installer = installerPackageName() ?: return false
        return knownStoreInstallers.contains(installer)
    }

    private fun installerPackageName(): String? {
        return try {
            val packageManager = appContext.packageManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                packageManager.getInstallSourceInfo(appContext.packageName).installingPackageName
            } else {
                @Suppress("DEPRECATION")
                packageManager.getInstallerPackageName(appContext.packageName)
            }
        } catch (e: PackageManager.NameNotFoundException) {
            null
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
