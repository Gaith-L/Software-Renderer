@echo off
echo Building with debug information...
odin build .\src -show-timings -debug -out:software_renderer.exe
if %ERRORLEVEL% EQU 0 (
    echo Build successful!
) else (
    echo Build failed with error code %ERRORLEVEL%
)
@REM pause

