package com.example.cryptographer_tool

import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.content.ContentValues
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "cryptographer.image/save"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "saveImageToGallery") {
                val bytes = call.argument<ByteArray>("bytes")
                val name = call.argument<String>("name")

                try {
                    if (bytes != null && name != null) {
                        val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)

                        val contentValues = ContentValues().apply {
                            put(MediaStore.Images.Media.DISPLAY_NAME, name)
                            put(MediaStore.Images.Media.MIME_TYPE, "image/png")
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/Cryptographer")
                                put(MediaStore.Images.Media.IS_PENDING, 1)
                            }
                        }

                        val resolver = applicationContext.contentResolver
                        val uri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)

                        if (uri != null) {
                            val outputStream: OutputStream? = resolver.openOutputStream(uri)
                            if (outputStream != null) {
                                bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
                                outputStream.close()

                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                    contentValues.clear()
                                    contentValues.put(MediaStore.Images.Media.IS_PENDING, 0)
                                    resolver.update(uri, contentValues, null, null)
                                }

                                result.success(true)
                            } else {
                                result.success(false)
                            }
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                } catch (e: Exception) {
                    Log.e("SaveImage", "Error saving image: ${e.message}")
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
