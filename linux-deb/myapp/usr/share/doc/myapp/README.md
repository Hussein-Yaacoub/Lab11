# Hello World Application

**Author:** Hussein Yaacoub  
**Email:** hmy03@mail.aub.edu  
**Version:** 1.0  
**Date:** November 14, 2025

## Overview

This is a simple "Hello World" application packaged for both Windows (MSI) and Linux (DEB) systems as part of EECE 435L Lab 11.

## Project Structure

```
lab11/
├── windows-msi/          # Windows MSI package files
│   ├── helloworld.cpp    # C++ source code
│   ├── Product.wxs       # WiX installer configuration
│   └── build-msi.bat     # Build script for Windows
├── linux-deb/            # Linux DEB package files
│   ├── helloworld.c      # C source code
│   ├── myapp/            # DEB package structure
│   └── build-deb.sh      # Build script for Linux
└── docs/                 # Shared documentation
    ├── README.md         # This file
    └── user_guide.txt    # User guide
```

## Compilation Instructions

### Windows (C++ Application)

**Prerequisites:**
- Microsoft Visual C++ Compiler (MSVC) or MinGW-w64
- WiX Toolset v3.11 or later (for creating MSI)

**Compile using Visual Studio Developer Command Prompt:**
```cmd
cd windows-msi
cl /EHsc helloworld.cpp /Fe:helloworld.exe
```

**OR using MinGW on Windows:**
```cmd
cd windows-msi
g++ -o helloworld.exe helloworld.cpp
```

**Build the MSI package:**
1. Install WiX Toolset from https://wixtoolset.org/
2. Update the GUIDs in `Product.wxs` (use `uuidgen` or online GUID generator)
3. Run the build script:
```cmd
build-msi.bat
```

**OR manually:**
```cmd
candle Product.wxs
light -ext WixUIExtension Product.wixobj -o helloworld_hussein_yaacoub.msi
```

### Linux (C Application)

**Prerequisites:**
- GCC compiler
- dpkg-dev package

**Install prerequisites on Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install build-essential dpkg-dev
```

**Compile the application:**
```bash
cd linux-deb
gcc -o helloworld helloworld.c
```

**Build the DEB package:**
```bash
chmod +x build-deb.sh
./build-deb.sh
```

**OR manually:**
```bash
# Copy binary and docs to package structure
cp helloworld myapp/usr/local/bin/
cp ../docs/README.md myapp/usr/share/doc/myapp/
cp ../docs/user_guide.txt myapp/usr/share/doc/myapp/

# Set proper permissions
chmod 755 myapp/usr/local/bin/helloworld

# Build the package
dpkg-deb --build myapp
mv myapp.deb helloworld_hussein_yaacoub.deb
```

## Running the Application

### Windows

**After installing the MSI:**
1. Navigate to `C:\Program Files\HelloWorld\`
2. Double-click `helloworld.exe`

**OR from Command Prompt:**
```cmd
"C:\Program Files\HelloWorld\helloworld.exe"
```

### Linux

**After installing the DEB:**
```bash
helloworld
```

The binary is installed to `/usr/local/bin/` which should be in your PATH.

## Installation Instructions

### Windows MSI

```cmd
msiexec /i helloworld_hussein_yaacoub.msi
```

**OR** double-click the MSI file and follow the installer wizard.

**To uninstall:**
- Go to Control Panel → Programs and Features
- Select "HelloWorld Application" and click Uninstall

### Linux DEB

```bash
sudo dpkg -i helloworld_hussein_yaacoub.deb
```

**To verify installation:**
```bash
dpkg -l | grep myapp
# OR
apt list --installed | grep myapp
```

**To uninstall:**
```bash
sudo dpkg -r myapp
```

## Package Contents

Both packages include:
- Compiled binary (helloworld.exe / helloworld)
- README.md (this file)
- user_guide.txt (user documentation)

## Verification

### Check DEB package contents:
```bash
dpkg-deb -c helloworld_hussein_yaacoub.deb
```

### Check DEB package metadata:
```bash
dpkg-deb -I helloworld_hussein_yaacoub.deb
```

### Check MSI package properties:
Right-click the MSI file → Properties → Details tab

## Troubleshooting

### Windows
- **Error: MSVC not found** - Install Visual Studio Build Tools or use MinGW
- **Error: WiX not found** - Add WiX bin directory to PATH environment variable

### Linux
- **Error: Permission denied** - Use `chmod +x` on the binary or run with `sudo`
- **Error: dpkg-dev not found** - Install with `sudo apt-get install dpkg-dev`

## License

This is an educational project for EECE 435L - Software Engineering Lab.

## Contact

For questions or issues, contact:  
**Hussein Yaacoub** - hmy03@mail.aub.edu
