# Optional external dependency: zlib
include(SanitizeBool)

SanitizeBool(USE_BUNDLED_ZLIB)
if(USE_BUNDLED_ZLIB STREQUAL ON)
	set(USE_BUNDLED_ZLIB "Bundled")
	set(GIT_COMPRESSION_BUILTIN)
endif()

if(USE_BUNDLED_ZLIB STREQUAL "OFF")
	find_package(ZLIB)
	if(ZLIB_FOUND)
		list(APPEND LIBGIT2_SYSTEM_INCLUDES ${ZLIB_INCLUDE_DIRS})
		list(APPEND LIBGIT2_SYSTEM_LIBS ${ZLIB_LIBRARIES})
		if(APPLE OR CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
			list(APPEND LIBGIT2_PC_LIBS "-lz")
		else()
			list(APPEND LIBGIT2_PC_REQUIRES "zlib")
		endif()
		add_feature_info(zlib ON "using system zlib")
	else()
		message(STATUS "zlib was not found; using bundled 3rd-party sources." )
	endif()
	set(GIT_COMPRESSION_ZLIB 1)
endif()
if(USE_BUNDLED_ZLIB STREQUAL "Chromium")
	add_subdirectory("${PROJECT_SOURCE_DIR}/deps/chromium-zlib" "${PROJECT_BINARY_DIR}/deps/chromium-zlib")
	list(APPEND LIBGIT2_DEPENDENCY_INCLUDES "${PROJECT_SOURCE_DIR}/deps/chromium-zlib")
	list(APPEND LIBGIT2_DEPENDENCY_OBJECTS $<TARGET_OBJECTS:chromium_zlib>)
	add_feature_info(zlib ON "using (Chromium) bundled zlib")
elseif(USE_BUNDLED_ZLIB OR NOT ZLIB_FOUND)
	add_subdirectory("${PROJECT_SOURCE_DIR}/deps/zlib" "${PROJECT_BINARY_DIR}/deps/zlib")
	list(APPEND LIBGIT2_DEPENDENCY_INCLUDES "${PROJECT_SOURCE_DIR}/deps/zlib")
	list(APPEND LIBGIT2_DEPENDENCY_OBJECTS $<TARGET_OBJECTS:zlib>)
	add_feature_info(zlib ON "using bundled zlib")
	set(GIT_COMPRESSION_BUILTIN 1)
endif()
