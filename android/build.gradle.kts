buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.2.1") // Make sure this is updated
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.21") // Kotlin plugin
        classpath("com.google.gms:google-services:4.3.15") // Firebase Google Services Plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Flutter Build Directory Fix (For Multi-Module Projects)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean Task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
