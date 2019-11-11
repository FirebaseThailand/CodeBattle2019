package com.firebase.androidcodebattle.util

import android.content.Context
import android.graphics.Bitmap
import me.echodev.resizer.Resizer
import java.io.File

class ResizeUtil(private val context: Context) {
    fun resize(file: File?, targetSize: Int = 1000): File? = Resizer(context)
        .setOutputFormat(Bitmap.CompressFormat.JPEG)
        .setQuality(90)
        .setTargetLength(targetSize)
        .setSourceImage(file)
        .resizedFile
}