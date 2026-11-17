cmake_minimum_required(VERSION 3.28)

set(MAIN_PROJECT "MyGame")

file(GLOB_RECURSE MAIN_SOURCES CONFIGURE_DEPENDS
    "src/*.cpp"
)

add_executable(${MAIN_PROJECT} WIN32 ${MAIN_SOURCES})

target_include_directories(${MAIN_PROJECT} PUBLIC "include")

target_link_libraries(${MAIN_PROJECT} PRIVATE ${CORE_LIB})