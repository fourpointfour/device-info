package com.testapp.device_info

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.device_info.app/vaibhav"
    private lateinit var cameraManager: CameraManager
    private lateinit var cameraId: String

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "toggleTorch") {
                toggleTorch(call.argument("torchValue")!!)
                result.success("Toggled torch successfully!")
            } else {
                result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun toggleTorch(status: Boolean) : String {
        val isFlashAvailable = applicationContext.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)
        if(!isFlashAvailable)
        {
            return "No Flash Available!"
        }
        cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            cameraId = cameraManager.cameraIdList[0]
        } catch(e: CameraAccessException) {
            e.printStackTrace()
        }
        switchFlashlight(status)
        return "Flashlight turned on successfully!"
    }

    private fun switchFlashlight(status : Boolean)
    {
        try {
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
                cameraManager.setTorchMode(cameraId, status)
        } catch (e : CameraAccessException) {
            e.printStackTrace()
        }
    }
}
