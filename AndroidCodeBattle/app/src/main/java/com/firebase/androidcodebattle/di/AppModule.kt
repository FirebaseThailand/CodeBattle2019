package com.firebase.androidcodebattle.di

import com.firebase.androidcodebattle.util.CameraUtil
import com.firebase.androidcodebattle.util.FileUtil
import com.firebase.androidcodebattle.util.ResizeUtil
import com.firebase.androidcodebattle.util.RotateUtil
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.storage.FirebaseStorage
import org.koin.android.ext.koin.androidContext
import org.koin.dsl.module

val firebaseModule = module {
    single { FirebaseStorage.getInstance() }
    single { FirebaseFirestore.getInstance() }
    single { FileUtil(androidContext()) }
    single { CameraUtil() }
    single { ResizeUtil(androidContext()) }
    single { RotateUtil() }
}
