#include "http_test.hpp"

#include <cstdio>
#include <thread>
#include <chrono>

#include <httplib.h>

bool http_get(const char *hostname, Uint16 port, const char *path) {
    // 1. Resolve hostname
    NET_Address *address = NET_ResolveHostname(hostname);
    if (!address) {
        SDL_Log("Failed to resolve hostname: %s", SDL_GetError());
        return false;
    }

    // Wait up to 3 seconds for resolution to finish
    if (NET_WaitUntilResolved(address, 3000) != NET_Status::NET_SUCCESS) {
        SDL_Log("Resolution timed out or failed: %s", SDL_GetError());
        NET_UnrefAddress(address);
        return false;
    }

    // 2. Create client stream socket
    NET_StreamSocket *sock = NET_CreateClient(address, port, 0);
    NET_UnrefAddress(address); // Address object is no longer needed after connection attempt

    if (!sock) {
        SDL_Log("Failed to create client socket: %s", SDL_GetError());
        return false;
    }

    // Wait up to 3 seconds to establish the connection
    if (!NET_WaitUntilConnected(sock, 3000)) {
        SDL_Log("Connection timed out or failed: %s", SDL_GetError());
        NET_DestroyStreamSocket(sock);
        return false;
    }

    // 3. Format the HTTP GET request
    char request[1024];
    int req_len = snprintf(request, sizeof(request),
        "GET %s HTTP/1.0\r\n"
        "Host: %s\r\n"
        "Connection: close\r\n\r\n",
        path, hostname);

    // 4. Send the request
    if (!NET_WriteToStreamSocket(sock, request, req_len)) {
        SDL_Log("Failed to send request: %s", SDL_GetError());
        NET_DestroyStreamSocket(sock);
        return false;
    }

    // Ensure data is completely sent
    NET_WaitUntilStreamSocketDrained(sock, 3000);

    // 5. Read the response loop
    char buffer[1024];
    int bytes_read;
    SDL_Log("--- Response from %s ---", hostname);
    
    while (true) {
        bytes_read = NET_ReadFromStreamSocket(sock, buffer, sizeof(buffer) - 1);
        if (bytes_read > 0) {
            buffer[bytes_read] = '\0';
            printf("%s", buffer);
        } else if (bytes_read < 0) {
            //SDL_Log("Error reading from socket: %s", SDL_GetError());
            break;
        } else {
            std::this_thread::sleep_for(std::chrono::milliseconds(50));
        }
    }
    printf("\n---------------------------\n");

    // 6. Cleanup
    NET_DestroyStreamSocket(sock);
    return true;
}

bool http_get_cpphttplib(const char* hostname, const char* path) {
    httplib::Client cli(hostname);
    cli.set_follow_location(true);
    auto res = cli.Get(path);

    if (!res) {
        const auto err = res.error();

        switch (err) {
            case httplib::Error::SSLConnection:
                std::cout << "SSL connection failed, SSL error: "
                        << res.ssl_error() << std::endl;
            break;

            case httplib::Error::SSLLoadingCerts:
                std::cout << "SSL cert loading failed, backend error: "
                        << std::hex << res.ssl_backend_error() << std::endl;
            break;

            case httplib::Error::SSLServerVerification:
                std::cout << "SSL verification failed, verify error: "
                        << res.ssl_backend_error() << std::endl;
            break;

            case httplib::Error::SSLServerHostnameVerification:
                std::cout << "SSL hostname verification failed, verify error: "
                        << res.ssl_backend_error() << std::endl;
            break;

            default:
                std::cout << "HTTP error: " << httplib::to_string(err) << std::endl;
                break;
        }
        return false;
    }

    printf("\n%s\n", res->body.c_str());
    return true;
}