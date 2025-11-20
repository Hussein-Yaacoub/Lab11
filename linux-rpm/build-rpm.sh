#!/bin/bash
# Build script for RPM package (OPTIONAL)
# For RedHat/Fedora/CentOS systems

echo "========================================"
echo "Building Hello World RPM Package"
echo "========================================"
echo ""
echo "NOTE: This is OPTIONAL for the lab!"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if rpm-build is installed
if ! command -v rpmbuild &> /dev/null; then
    echo -e "${RED}ERROR: rpmbuild not found!${NC}"
    echo "Please install it with:"
    echo "  sudo yum install rpm-build   (RHEL/CentOS)"
    echo "  sudo dnf install rpm-build   (Fedora)"
    exit 1
fi

echo "Step 1: Setting up rpmbuild directory structure..."
echo ""

# Create rpmbuild directory structure
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo "Step 2: Preparing source tarball..."
echo ""

# Create source directory
mkdir -p ~/rpmbuild/SOURCES/myapp-1.0

# Compile the application
echo "Compiling application..."
gcc -o helloworld helloworld.c
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Compilation failed!${NC}"
    exit 1
fi

# Copy files to source directory
cp helloworld ~/rpmbuild/SOURCES/myapp-1.0/
cp ../docs/README.md ~/rpmbuild/SOURCES/myapp-1.0/
cp ../docs/user_guide.txt ~/rpmbuild/SOURCES/myapp-1.0/

# Create source tarball
cd ~/rpmbuild/SOURCES
tar -czf myapp-1.0.tar.gz myapp-1.0/
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Failed to create source tarball!${NC}"
    exit 1
fi

echo -e "${GREEN}Source tarball created!${NC}"
echo ""

echo "Step 3: Copying spec file..."
echo ""

# Go back to original directory
cd - > /dev/null

# Copy spec file
cp myapp.spec ~/rpmbuild/SPECS/

echo "Step 4: Building RPM package..."
echo ""

# Build the RPM
rpmbuild -ba ~/rpmbuild/SPECS/myapp.spec
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: RPM build failed!${NC}"
    echo "Check the error messages above."
    exit 1
fi

echo ""
echo "========================================"
echo "BUILD SUCCESSFUL!"
echo "========================================"
echo ""

# Find and display the created RPM
RPM_FILE=$(find ~/rpmbuild/RPMS -name "myapp-*.rpm" | head -n 1)
if [ -n "$RPM_FILE" ]; then
    echo -e "${GREEN}RPM package created at:${NC}"
    echo "$RPM_FILE"
    echo ""
    
    # Copy to current directory
    cp "$RPM_FILE" ./helloworld_hussein_yaacoub.rpm
    echo -e "${GREEN}Copied to: ./helloworld_hussein_yaacoub.rpm${NC}"
    echo ""
    
    # Show package info
    echo "Package information:"
    echo "-------------------"
    rpm -qip "$RPM_FILE"
    echo ""
    
    echo "Package contents:"
    echo "----------------"
    rpm -qlp "$RPM_FILE"
    echo ""
fi

echo "Next steps:"
echo "1. Test installation: sudo rpm -i helloworld_hussein_yaacoub.rpm"
echo "2. Verify: rpm -q myapp"
echo "3. Run: helloworld"
echo "4. Uninstall: sudo rpm -e myapp"
echo ""
echo "Remember: RPM package is OPTIONAL for this lab!"
echo ""
