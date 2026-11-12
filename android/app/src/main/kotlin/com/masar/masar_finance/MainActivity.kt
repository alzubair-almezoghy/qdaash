package com.masar.masar_finance

import android.view.WindowManager
import android.content.Intent
import androidx.core.content.FileProvider
import java.io.File
import java.util.TimeZone
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "gaddash/privacy")
            .setMethodCallHandler { call, result ->
                if (call.method == "setSecure") {
                    if (call.arguments == true) {
                        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    } else {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                    result.success(null)
                } else if (call.method == "getTimezone") {
                    result.success(TimeZone.getDefault().id)
                } else if (call.method == "getAppInfo") {
                    val info = packageManager.getPackageInfo(packageName, 0)
                    val build = if (android.os.Build.VERSION.SDK_INT >= 28) {
                        info.longVersionCode.toString()
                    } else {
                        @Suppress("DEPRECATION")
                        info.versionCode.toString()
                    }
                    result.success(mapOf("version" to info.versionName, "build" to build))
                } else if (call.method == "shareFile") {
                    val file = File(call.arguments as String).canonicalFile
                    if (!file.path.startsWith(cacheDir.canonicalPath + File.separator) || !file.isFile) {
                        result.error("invalid_file", "File must be in the app cache", null)
                    } else {
                        val uri = FileProvider.getUriForFile(this,
                            "$packageName.fileprovider", file)
                        val mime = when (file.extension.lowercase()) {
                            "pdf" -> "application/pdf"
                            "csv" -> "text/csv"
                            else -> "application/json"
                        }
                        val intent = Intent(Intent.ACTION_SEND).apply {
                            type = mime
                            putExtra(Intent.EXTRA_STREAM, uri)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }
                        startActivity(Intent.createChooser(intent, "Share Gaddash file"))
                        result.success(null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
