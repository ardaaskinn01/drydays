plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.aasoft.drydays"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    // Java 17'yi kullanma
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    lintOptions {
        isCheckReleaseBuilds = false  // "checkReleaseBuilds" yerine "isCheckReleaseBuilds" kullanılıyor
        disable("InvalidPackage")     // "disable" kısmı da bu şekilde olmalı
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.aasoft.drydays"
        minSdk = 23
        targetSdk = 33
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Desugaring bağımlılığını buraya ekleyin
    dependencies {
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    }
}

flutter {
    source = "../.."
}