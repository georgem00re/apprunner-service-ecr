import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

plugins {
    kotlin("jvm") version "2.1.10"
    application

    // This plugin allows us to run ./gradlew shadowJar
    // which generates a 'fat' JAR file in ./app/libs/.
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

group = "com.example.app"
version = "0.1.0"

repositories {
    mavenCentral()
}

val ktorVersion = "3.1.2"

val ktorDependencies = listOf(
    "io.ktor:ktor-server-cio",
    "io.ktor:ktor-server-default-headers"
)

dependencies {
    implementation(kotlin("stdlib"))
    ktorDependencies.forEach { implementation("$it:$ktorVersion") }
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)
    }
}

application {
    val entryPoint = "com.example.AppKt"
    mainClass.set(entryPoint)
}

tasks.withType<ShadowJar> {
    archiveFileName.set("app.jar")
}
