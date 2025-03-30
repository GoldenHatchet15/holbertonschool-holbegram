buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.1'
        classpath 'com.google.gms:google-services:4.3.13' // ✅ As required
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}

plugins {
    // ... (plugins)
    id("com.google.gms.google-services") version "4.4.2" apply false
}