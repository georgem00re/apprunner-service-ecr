package com.example

import io.ktor.server.application.Application
import io.ktor.server.application.install
import io.ktor.server.cio.CIO
import io.ktor.server.engine.embeddedServer
import io.ktor.server.plugins.defaultheaders.DefaultHeaders
import io.ktor.server.response.respondText
import io.ktor.server.routing.get
import io.ktor.server.routing.routing

class PortNotSpecified : Exception("The PORT env variable is not specified")

fun main() {
    val port = System.getenv("PORT")?.toInt() ?: throw PortNotSpecified()

    embeddedServer(CIO, port = port) {
        installPlugins()
        configureRoutes()
    }.start(wait = true)
}

fun Application.installPlugins() {
    // Automatically adds a few standard HTTP headers to every response.
    install(DefaultHeaders)
}

fun Application.configureRoutes() {
    routing {
        get("/health") {
            call.respondText("OK")
        }
    }
}
