# Setup dependency

include(FetchContent)

if (NOT SDL3PLUS_ENABLE_HTTP)
    message(STATUS "Skipping CppHttpLib/MbedTLS: it was not enabled.")
    return()
endif()

include(cmake/auto/installMbedTLS.cmake)

message(STATUS "Fetching CppHttpLib")

set(HTTPLIB_COMPILE OFF CACHE BOOL "" FORCE)
set(HTTPLIB_INSTALL OFF CACHE BOOL "" FORCE)
set(HTTPLIB_TEST OFF CACHE BOOL "" FORCE)

set(HTTPLIB_USE_OPENSSL_IF_AVAILABLE OFF CACHE BOOL "" FORCE)
set(HTTPLIB_USE_MBEDTLS_IF_AVAILABLE OFF CACHE BOOL "" FORCE)

set(HTTPLIB_USE_ZLIB_IF_AVAILABLE OFF CACHE BOOL "" FORCE)
set(HTTPLIB_USE_BROTLI_IF_AVAILABLE OFF CACHE BOOL "" FORCE)
set(HTTPLIB_USE_ZSTD_IF_AVAILABLE OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
    httplib
    GIT_REPOSITORY https://github.com/yhirose/cpp-httplib.git
    GIT_TAG v0.66.0
    GIT_SHALLOW TRUE
)

FetchContent_MakeAvailable(httplib)

include(cmake/auto/integrateCppHttpLib.cmake)

message(STATUS "Fetching of CppHttpLib done!")