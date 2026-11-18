cmake_minimum_required(VERSION 3.28)

set(CORE_LIB "GameBase")

project(GameBase
    VERSION 2.0
    DESCRIPTION "FlappyBlock is a remake of a popular game made in C/C++ with SDL3"
    LANGUAGES C CXX
)
 
include(cmake/projectFlags.cmake)
include(cmake/installBatteryEmbed.cmake)
include(cmake/installSDL3.cmake)
include(cmake/installJson.cmake)
include(cmake/installMbedTLS.cmake)
include(cmake/installCppHttpLib.cmake)

add_library(${CORE_LIB} INTERFACE)

target_link_libraries(${CORE_LIB} INTERFACE
    SDL3::SDL3-static
    SDL3_ttf::SDL3_ttf
    SDL3_mixer::SDL3_mixer
    SDL3_image::SDL3_image
    SDL3_net::SDL3_net
    httplib::httplib
)

if (NOT DEFINED DISABLE_MAIN_TEST)
    add_subdirectory(main)
endif()
