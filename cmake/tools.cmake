
function(sdl3plus_setup_android TARGET_NAME)
    # Only configure Android packaging for desktop builds.
    if(ANDROID)
        return()
    endif()

    message(STATUS "Configuring SDL3plus Android project...")

    # Where the generated Android project will live.
    set(GAMEBASE_ANDROID_DIR
        "${CMAKE_BINARY_DIR}/_sdl3plus/android/${TARGET_NAME}"
    )

    # Location of the original template.
    set(GAMEBASE_ANDROID_TEMPLATE_DIR
        "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/../android-project"
    )

    # Copy the Android template.
    file(COPY
        "${GAMEBASE_ANDROID_TEMPLATE_DIR}/"
        DESTINATION "${GAMEBASE_ANDROID_DIR}"
    )

    # Configure the Android application.
    set(GAMEBASE_ANDROID_TARGET "${TARGET_NAME}")
    set(GAME_CMAKE_PROJECT "${CMAKE_SOURCE_DIR}/CMakeLists.txt")

    configure_file(
        "${GAMEBASE_ANDROID_TEMPLATE_DIR}/app/build.gradle.in"
        "${GAMEBASE_ANDROID_DIR}/app/build.gradle"
        @ONLY
    )

    # Gradle wrapper.
    if(WIN32)
        set(GAMEBASE_GRADLE
            "${GAMEBASE_ANDROID_DIR}/gradlew.bat"
        )
    else()
        set(GAMEBASE_GRADLE
            "${GAMEBASE_ANDROID_DIR}/gradlew"
        )

        # Ensure the wrapper is executable.
        file(CHMOD
            "${GAMEBASE_GRADLE}"
            PERMISSIONS
                OWNER_READ OWNER_WRITE OWNER_EXECUTE
                GROUP_READ GROUP_EXECUTE
                WORLD_READ WORLD_EXECUTE
        )
    endif()

    # Android debug APK.
    #add_custom_target(${TARGET_NAME}_android
    #    COMMAND "${GAMEBASE_GRADLE}"
    #        assembleDebug
    #        "-PgameName=${TARGET_NAME}"
    #        "-PoutputDir=${CMAKE_BINARY_DIR}/bin"
    #    WORKING_DIRECTORY "${GAMEBASE_ANDROID_DIR}"
    #    USES_TERMINAL
    #    COMMENT "Building Android debug APK..."
    #    VERBATIM
    #)

    # Android release APK.
    add_custom_target(${TARGET_NAME}_android_release
        COMMAND "${GAMEBASE_GRADLE}" 
            assembleRelease
            copyRelease
            "-PgameName=${TARGET_NAME}"
            "-PoutputDir=${CMAKE_BINARY_DIR}/bin"
        WORKING_DIRECTORY "${GAMEBASE_ANDROID_DIR}"
        USES_TERMINAL
        COMMENT "Building Android release APK..."
        VERBATIM
    )

    # Android release AAB.
    #add_custom_target(${TARGET_NAME}_android_bundle
    #    COMMAND "${GAMEBASE_GRADLE}"
    #        bundleRelease
    #        "-PgameName=${TARGET_NAME}"
    #        "-PoutputDir=${CMAKE_BINARY_DIR}/bin"
    #    WORKING_DIRECTORY "${GAMEBASE_ANDROID_DIR}"
    #    USES_TERMINAL
    #    COMMENT "Building Android release AAB..."
    #    VERBATIM
    #)

    message(STATUS "Android project configured.")
endfunction()


function(sdl3plus_add_game TARGET_NAME)
    message(STATUS "Adding game ${TARGET_NAME}...")

    if(ANDROID)
        add_library(${TARGET_NAME} SHARED ${ARGN})

        set_target_properties(${TARGET_NAME} PROPERTIES
            OUTPUT_NAME main
        )
    else()
        add_executable(${TARGET_NAME} ${ARGN})

        set_target_properties(${TARGET_NAME} PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
        )
    endif()

    target_link_libraries(${TARGET_NAME} PRIVATE
        SDL3Plus::SDL3Plus
    )

    target_compile_definitions(${TARGET_NAME} PRIVATE
        IS_ANDROID=$<BOOL:${ANDROID}>
    )

    if(SDL3PLUS_ENABLE_ANDROID AND NOT ANDROID)
        message(STATUS "Preparing Android version for ${TARGET_NAME}...")
        sdl3plus_setup_android(${TARGET_NAME})
    endif()
endfunction()