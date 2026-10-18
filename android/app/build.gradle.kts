import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Google Services plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Keystore properties load karne ka sahi tareeka
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.skhan.joblink"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Signing configuration 'android' block ke andar honi chahiye
    signingConfigs {
        create("release") {
            val alias = keystoreProperties["keyAlias"] as String?
            val keyPass = keystoreProperties["keyPassword"] as String?
            val storePass = keystoreProperties["storePassword"] as String?
            val rawPath = keystoreProperties["storeFile"] as String?

            if (alias != null && keyPass != null && storePass != null && rawPath != null) {
                val f1 = file(rawPath)
                val f2 = rootProject.file(rawPath)
                val targetFile = if (f1.exists()) f1 else if (f2.exists()) f2 else null

                if (targetFile != null && targetFile.exists()) {
                    keyAlias = alias
                    keyPassword = keyPass
                    storePassword = storePass
                    storeFile = targetFile
                } else {
                    initWith(getByName("debug"))
                }
            } else {
                initWith(getByName("debug"))
            }
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.skhan.joblink"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Yahan humne debug ki jagah 'release' config connect kar di hai
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}