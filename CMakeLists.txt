cmake_minimum_required(VERSION 3.28)

project(GameBase
    VERSION 1.0
    DESCRIPTION "Base for game dev with SDL3 + useful extras built in"
    LANGUAGES C CXX
)

option(SDL3PLUS_ENABLE_GRAPHICS     "Enable image and ttf dependencies" ON)
option(SDL3PLUS_ENABLE_AUDIO        "Enable audio dependencies" ON)
option(SDL3PLUS_ENABLE_SOCKETS      "Enable net dependencies" ON)
option(SDL3PLUS_ENABLE_HTTP         "Enable http dependencies" ON)
option(SDL3PLUS_ENABLE_JSON         "Enable JSON dependencies" ON)
option(SDL3PLUS_ENABLE_EMBED        "Enable embed dependencies" ON)
option(SDL3PLUS_ENABLE_ANDROID      "Enable Android stuff" ON)

option(SDL3PLUS_BUILD_EXAMPLE "Build GameBase example application" ${PROJECT_IS_TOP_LEVEL})


include(cmake/projectFlags.cmake)
include(cmake/installBatteryEmbed.cmake)
include(cmake/installSDL3.cmake)
include(cmake/installJson.cmake)
include(cmake/installCppHttpLib.cmake)
include(cmake/tools.cmake)

add_library(SDL3Plus INTERFACE)
add_library(SDL3Plus::SDL3Plus ALIAS SDL3Plus)

target_link_libraries(SDL3Plus INTERFACE
    SDL3::SDL3
    SDL3_ttf::SDL3_ttf
    SDL3_mixer::SDL3_mixer
    SDL3_image::SDL3_image
    SDL3_net::SDL3_net
    httplib::httplib
)

if(SDL3PLUS_BUILD_EXAMPLE)
    add_subdirectory(main)
endif()