# Setup dependency

include(FetchContent)

if (NOT SDL3PLUS_ENABLE_EMBED)
    message(STATUS "Skipping BatteryEmbed: it was not enabled.")
    return()
endif()

message(STATUS "Fetching BatteryEmbed")

set(B_PRODUCTION_MODE ON)

FetchContent_Declare(
    battery-embed
    GIT_REPOSITORY  https://github.com/batterycenter/embed.git
    GIT_TAG         v1.2.19
)
FetchContent_MakeAvailable(battery-embed)

message(STATUS "Fetching of BatteryEmbed done!")