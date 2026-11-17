# Setup dependency

include(FetchContent)

message(STATUS "Fetching MbedTLS")

set(USE_SHARED_MBEDTLS_LIBRARY OFF CACHE BOOL "" FORCE)
set(USE_STATIC_MBEDTLS_LIBRARY ON CACHE BOOL "" FORCE)
set(ENABLE_PROGRAMS OFF CACHE BOOL "" FORCE)
set(ENABLE_TESTING OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
    mbedtls
    GIT_REPOSITORY https://github.com/Mbed-TLS/mbedtls.git
    GIT_TAG v4.2.0
    GIT_SHALLOW TRUE
    GIT_SUBMODULES_RECURSE TRUE
)

FetchContent_MakeAvailable(mbedtls)

foreach(target mbedtls mbedx509 tfpsacrypto)
    if(NOT TARGET ${target})
        message(FATAL_ERROR
            "Missing Mbed target: ${target}"
        )
    endif()
endforeach()


message(STATUS "Fetching of MbedTLS done!")