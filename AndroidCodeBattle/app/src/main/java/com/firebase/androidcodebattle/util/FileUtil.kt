package com.firebase.androidcodebattle.util

import android.content.Context
import java.io.File

class FileUtil(var context: Context) {
    fun createImageFile(filename: String, mimeType: String = ".jpg"): File {
        return File.createTempFile(filename, mimeType, context.filesDir)
    }
}
