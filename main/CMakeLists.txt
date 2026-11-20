cmake_minimum_required(VERSION 3.28)

set(MAIN_PROJECT "MyGame")

file(GLOB_RECURSE MAIN_SOURCES CONFIGURE_DEPENDS
    "src/*.cpp"
)

sdl3plus_add_game(${MAIN_PROJECT} ${MAIN_SOURCES})

#if (ANDROID)
#    add_library(${MAIN_PROJECT} SHARED ${MAIN_SOURCES})
#    target_link_libraries(${MAIN_PROJECT} PUBLIC SDL3Plus::SDL3Plus)
#    target_compile_definitions(${MAIN_PROJECT} PUBLIC IS_ANDROID=1)
#else()
#    add_executable(${MAIN_PROJECT} WIN32 ${MAIN_SOURCES})
#    target_link_libraries(${MAIN_PROJECT} PRIVATE SDL3Plus::SDL3Plus)
#    target_compile_definitions(${MAIN_PROJECT} PUBLIC IS_ANDROID=0)
#
#    set_target_properties(${MAIN_PROJECT}
#        PROPERTIES
#        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
#    )
#endif()

target_include_directories(${MAIN_PROJECT} PUBLIC "include")
