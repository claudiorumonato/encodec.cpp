@echo off

set "BUILD_TYPE=%1"
set "GGML_DIR=D:/libs/dist/%BUILD_TYPE%/lib/cmake/ggml"

cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DENCODEC_USE_SYSTEM_GGML=ON "-Dggml_DIR=%GGML_DIR%" --fresh
cmake --build build --config %BUILD_TYPE% -j --clean-first
REM cmake --install build --config %BUILD_TYPE% --prefix "dist/%BUILD_TYPE%"