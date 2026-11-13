group = "com.veerens.veerens_floating_api"
version = "1.0-SNAPSHOT"

buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// No versions here — both plugins resolve to whatever version the
// consuming app's own root project already declared (every Flutter
// Android app's settings.gradle.kts declares both in its
// pluginManagement block), so this module never pins, and so never
// conflicts with, its own version of either.
plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.veerens.veerens_floating_api"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // `src/main/kotlin` is picked up automatically once the Kotlin
    // plugin is applied — no extra sourceSets wiring needed.

    defaultConfig {
        minSdk = 21
    }
}

// A JVM toolchain, not `kotlinOptions {}` or `compilerOptions {}`: those
// two DSLs each only exist on one side of a Kotlin/AGP version split
// (old vs. AGP 9's "new DSL"), and using either broke the build on the
// other side. `jvmToolchain` has been stable since Kotlin 1.9 and keeps
// the Java and Kotlin compile tasks aligned on the same JVM target
// everywhere, avoiding the "Inconsistent JVM Target Compatibility" error.
kotlin {
    jvmToolchain(17)
}
