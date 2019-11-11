package com.firebase.androidcodebattle

import android.app.Application
import com.firebase.androidcodebattle.di.firebaseModule
import org.koin.android.ext.koin.androidContext
import org.koin.core.context.startKoin

class CodeBattleApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        startKoin {
            androidContext(this@CodeBattleApplication)
            modules(firebaseModule)
        }
    }
}
