package com.firebase.androidcodebattle.util

import android.app.Activity
import android.content.Intent
import android.provider.MediaStore
import androidx.core.content.FileProvider
import com.firebase.androidcodebattle.BuildConfig
import java.io.File

class CameraUtil {
    private var onCameraTaken: ((File) -> Unit)? = null
    private var file: File? = null

    companion object {
        const val REQUEST_CODE_CAMERA = 2718
        const val PROVIDER = BuildConfig.APPLICATION_ID + ".provider"
    }

    fun openCamera(activity: Activity, file: File, onCameraTaken: ((File) -> Unit)?) {
        this.file = file
        this.onCameraTaken = onCameraTaken
        val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        val photoURI = FileProvider.getUriForFile(activity, PROVIDER, file)
        intent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI)
        activity.startActivityForResult(intent, REQUEST_CODE_CAMERA)
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_CODE_CAMERA && resultCode == Activity.RESULT_OK) {
            file?.let { file ->
                onCameraTaken?.invoke(file)
            }
        }
    }
}
