# EECE 435L Lab 11 - Software Packaging

**Student:** Hussein Yaacoub  
**Email:** hmy03@mail.aub.edu  
**Course:** EECE 435L - Software Engineering Lab  
**Date:** November 14, 2025

## Overview

This lab demonstrates software packaging for multiple platforms:
- **Windows MSI Package** (using WiX Toolset)
- **Debian DEB Package** (using dpkg-deb)
- **RedHat RPM Package** (optional, using rpmbuild)

## Project Structure

```
lab11/
├── windows-msi/          # Windows MSI package
│   ├── helloworld.cpp
│   ├── Product.wxs
│   └── build-msi.bat
├── linux-deb/           # Debian DEB package
│   ├── helloworld.c
│   ├── build-deb.sh
│   └── myapp/DEBIAN/control
├── linux-rpm/           # RedHat RPM package (optional)
│   ├── helloworld.c
│   ├── myapp.spec
│   └── build-rpm.sh
└── docs/                # Documentation
    ├── README.md
    └── user_guide.txt
```

## Prerequisites

### Linux (DEB/RPM)
```bash
sudo apt-get install build-essential dpkg-dev
```

### Windows (MSI)
- WiX Toolset: https://wixtoolset.org/
- Visual Studio (C++) or MinGW-w64

## Building Packages

### 1. Linux DEB Package

```bash
cd linux-deb
./build-deb.sh
```

Output: `helloworld_hussein_yaacoub.deb`

**Test:**
```bash
sudo dpkg -i helloworld_hussein_yaacoub.deb
helloworld
sudo dpkg -r myapp
```

### 2. Windows MSI Package

**IMPORTANT:** Before building, edit `windows-msi/Product.wxs` and replace all `PUT-GUID` placeholders with unique GUIDs.

Generate GUIDs:
- Online: https://www.guidgenerator.com/
- Linux: `uuidgen`
- PowerShell: `[guid]::NewGuid()`

```cmd
cd windows-msi
build-msi.bat
```

Output: `helloworld_hussein_yaacoub.msi`

**Test:**
```cmd
msiexec /i helloworld_hussein_yaacoub.msi
"C:\Program Files\HelloWorld\helloworld.exe"
```

### 3. RPM Package (Optional)

```bash
cd linux-rpm
./build-rpm.sh
```

Output: `helloworld_hussein_yaacoub.rpm`

## Submission Files

- `helloworld_hussein_yaacoub.msi` - Windows installer
- `helloworld_hussein_yaacoub.deb` - Debian package
- `source.zip` - All source code
- `docs/README.md` - Technical documentation
- `docs/user_guide.txt` - User manual
- `linux-deb/myapp/DEBIAN/control` - DEB metadata
- Screenshots (11 minimum):
  - MSI creation, installation, execution (5)
  - DEB creation, installation, execution (6)

## Quick Commands

```bash
# Verify DEB package
dpkg-deb -c helloworld_hussein_yaacoub.deb  # List contents
dpkg-deb -I helloworld_hussein_yaacoub.deb  # Show metadata

# Check installed DEB
dpkg -l | grep myapp

# Create source archive
zip -r source.zip windows-msi/ linux-deb/ linux-rpm/ docs/ -x "*.exe" "*.o" "*.deb" "*.msi"
```

## Troubleshooting

**DEB build fails:**
- Install dependencies: `sudo apt-get install build-essential dpkg-dev`
- Make script executable: `chmod +x build-deb.sh`

**MSI build fails:**
- Ensure WiX is in PATH
- Replace all GUIDs in Product.wxs
- Install Visual Studio or MinGW

**Application won't run:**
- Linux: Ensure `/usr/local/bin` is in PATH
- Windows: Run from full path or add to PATH

## Expected Output

Both applications should display:
```
Hello, World from Hussein_Yaacoub!
```
