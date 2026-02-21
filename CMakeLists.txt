cmake_minimum_required(VERSION 3.12)
if (MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

project("encodec" C CXX)

if (NOT XCODE AND NOT MSVC AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)	

if (MSVC)
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Od /Zi")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Od /Zi")
    else()
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /O2")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /O2")
    endif()
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(ENCODEC_STANDALONE ON)
else()
    set(ENCODEC_STANDALONE OFF)
endif()

option(ENCODEC_USE_SYSTEM_GGML "encodec: use system-installed GGML library" OFF)
option(ENCODEC_BUILD_EXAMPLES  "encodec: build examples" ${ENCODEC_STANDALONE})

if (ENCODEC_USE_SYSTEM_GGML)
	find_package(ggml REQUIRED)
	if (NOT ggml_FOUND)
		message(FATAL_ERROR "System-installed GGML library not found.")
	endif()
	add_library(ggml ALIAS ggml::ggml)
else()
	message(FATAL_ERROR "GGML library is missing.")
endif()

# Build libraries

set(ENCODEC_LIB encodec)
option(BUILD_SHARED_LIBS "build shared libraries" OFF)



add_library(
    ${ENCODEC_LIB}
    encodec.cpp
    encodec.h
    encoder.h
    decoder.h
    quantizer.h
    ops.cpp
    ops.h
    utils.h
    lstm.h
)

if (ENCODEC_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

target_link_libraries(${ENCODEC_LIB} PUBLIC ggml)
target_include_directories(${ENCODEC_LIB} PUBLIC .)
target_compile_features(${ENCODEC_LIB} PUBLIC cxx_std_11)
