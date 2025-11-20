@echo off
REM Build script for Windows MSI package
REM This script compiles the C++ application and builds the MSI installer

echo ========================================
echo Building Hello World MSI Package
echo ========================================
echo.

REM Check if WiX is installed
where candle.exe >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: WiX Toolset not found in PATH!
    echo Please install WiX Toolset from https://wixtoolset.org/
    echo Add the bin directory to your PATH environment variable.
    pause
    exit /b 1
)

echo Step 1: Compiling C++ application...
echo.

REM Try to compile with cl (MSVC)
where cl.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Using Microsoft Visual C++ Compiler...
    cl /EHsc helloworld.cpp /Fe:helloworld.exe
    if %ERRORLEVEL% NEQ 0 (
        echo ERROR: Compilation failed!
        pause
        exit /b 1
    )
) else (
    REM Try to compile with g++ (MinGW)
    where g++.exe >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Using MinGW g++ compiler...
        g++ -o helloworld.exe helloworld.cpp
        if %ERRORLEVEL% NEQ 0 (
            echo ERROR: Compilation failed!
            pause
            exit /b 1
        )
    ) else (
        echo ERROR: No C++ compiler found!
        echo Please install Visual Studio or MinGW-w64.
        pause
        exit /b 1
    )
)

echo.
echo Compilation successful!
echo.

REM Test the executable
echo Step 2: Testing the executable...
echo.
helloworld.exe
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: Executable test failed!
)
echo.

echo Step 3: Building MSI installer...
echo.

REM Check if Product.wxs exists
if not exist Product.wxs (
    echo ERROR: Product.wxs not found!
    pause
    exit /b 1
)

REM Note: You need to replace GUIDs in Product.wxs before building!
echo NOTE: Make sure you have replaced all GUIDs in Product.wxs!
echo      Use 'uuidgen' command or an online GUID generator.
echo.
echo Press any key to continue with MSI build...
pause >nul

REM Compile WiX source file
echo Compiling WiX source file...
candle Product.wxs
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: WiX compilation failed!
    pause
    exit /b 1
)

REM Link to create MSI
echo Linking to create MSI package...
light -ext WixUIExtension Product.wixobj -o helloworld_ali_salman.msi
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: MSI creation failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo MSI package created: helloworld_ali_salman.msi
echo.
echo Next steps:
echo 1. Test the MSI by installing it
echo 2. Verify installation in Control Panel
echo 3. Run the installed application
echo 4. Take screenshots for submission
echo.
pause
