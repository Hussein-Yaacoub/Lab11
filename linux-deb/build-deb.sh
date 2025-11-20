#!/bin/bash
# Build script for Linux DEB package
# This script compiles the C application and builds the DEB package

echo "========================================"
echo "Building Hello World DEB Package"
echo "========================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if gcc is installed
if ! command -v gcc &> /dev/null; then
    echo -e "${RED}ERROR: gcc compiler not found!${NC}"
    echo "Please install it with: sudo apt-get install build-essential"
    exit 1
fi

# Check if dpkg-deb is available
if ! command -v dpkg-deb &> /dev/null; then
    echo -e "${RED}ERROR: dpkg-deb not found!${NC}"
    echo "Please install it with: sudo apt-get install dpkg-dev"
    exit 1
fi

echo "Step 1: Compiling C application..."
echo ""

# Compile the application
gcc -o helloworld helloworld.c
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Compilation failed!${NC}"
    exit 1
fi

echo -e "${GREEN}Compilation successful!${NC}"
echo ""

# Test the executable
echo "Step 2: Testing the executable..."
echo ""
./helloworld
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}WARNING: Executable test returned non-zero exit code!${NC}"
fi
echo ""

echo "Step 3: Preparing DEB package structure..."
echo ""

# Ensure directory structure exists
mkdir -p myapp/DEBIAN
mkdir -p myapp/usr/local/bin
mkdir -p myapp/usr/share/doc/myapp

# Copy files to package structure
echo "Copying binary to package..."
cp helloworld myapp/usr/local/bin/
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to copy binary!${NC}"
    exit 1
fi

echo "Copying documentation files..."
cp ../docs/README.md myapp/usr/share/doc/myapp/
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}WARNING: README.md not found in ../docs/${NC}"
fi

cp ../docs/user_guide.txt myapp/usr/share/doc/myapp/
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}WARNING: user_guide.txt not found in ../docs/${NC}"
fi

# Set proper permissions
echo "Setting file permissions..."
chmod 755 myapp/usr/local/bin/helloworld
chmod 644 myapp/usr/share/doc/myapp/* 2>/dev/null
chmod 755 myapp/DEBIAN

# Verify control file exists
if [ ! -f myapp/DEBIAN/control ]; then
    echo -e "${RED}ERROR: Control file not found at myapp/DEBIAN/control${NC}"
    exit 1
fi

# Show control file content
echo ""
echo "Control file contents:"
echo "----------------------"
cat myapp/DEBIAN/control
echo "----------------------"
echo ""

echo "Step 4: Building DEB package..."
echo ""

# Build the DEB package
dpkg-deb --build myapp
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: DEB package creation failed!${NC}"
    exit 1
fi

# Rename the package with proper naming
mv myapp.deb helloworld_ali_salman.deb
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}WARNING: Could not rename package file${NC}"
else
    echo -e "${GREEN}Package renamed to: helloworld_ali_salman.deb${NC}"
fi

echo ""
echo "========================================"
echo "BUILD SUCCESSFUL!"
echo "========================================"
echo ""
echo "DEB package created: helloworld_ali_salman.deb"
echo ""
echo "Package verification:"
echo "--------------------"

# Show package contents
echo ""
echo "Package contents:"
dpkg-deb -c helloworld_ali_salman.deb 2>/dev/null || dpkg-deb -c myapp.deb
echo ""

echo "Package metadata:"
dpkg-deb -I helloworld_ali_salman.deb 2>/dev/null || dpkg-deb -I myapp.deb
echo ""

echo "Next steps:"
echo "1. Test installation: sudo dpkg -i helloworld_ali_salman.deb"
echo "2. Verify: dpkg -l | grep myapp"
echo "3. Run: helloworld"
echo "4. Take screenshots for submission"
echo "5. Uninstall: sudo dpkg -r myapp"
echo ""
