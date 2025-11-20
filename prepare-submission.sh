#!/bin/bash
# Script to prepare submission files for Lab 11

echo "=========================================="
echo "Lab 11 Submission Package Creator"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m'

# Check current directory
if [ ! -d "windows-msi" ] || [ ! -d "linux-deb" ]; then
    echo -e "${RED}ERROR: Please run this script from the lab11 directory!${NC}"
    exit 1
fi

echo -e "${BLUE}Step 1: Creating source.zip${NC}"
echo ""

# Create source.zip with all necessary files
echo "Including files:"
echo "  - windows-msi/ (source code and WiX config)"
echo "  - linux-deb/ (source code and control file)"
echo "  - linux-rpm/ (optional, if exists)"
echo "  - docs/ (README and user guide)"
echo ""

# Remove old source.zip if exists
rm -f source.zip

# Create source.zip, excluding compiled binaries and build artifacts
zip -r source.zip \
    windows-msi/helloworld.cpp \
    windows-msi/Product.wxs \
    windows-msi/build-msi.bat \
    linux-deb/helloworld.c \
    linux-deb/build-deb.sh \
    linux-deb/myapp/DEBIAN/control \
    docs/README.md \
    docs/user_guide.txt \
    README.md \
    CHECKLIST.txt \
    -x "*.exe" "*.o" "*.deb" "*.msi" "*.wixobj" "*.wixpdb" "*myapp/usr/*" "*.rpm"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ source.zip created successfully${NC}"
else
    echo -e "${RED}✗ Failed to create source.zip${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Step 2: Creating submission folder structure${NC}"
echo ""

# Create submission directory structure
mkdir -p submission/packages
mkdir -p submission/source
mkdir -p submission/documentation
mkdir -p submission/screenshots

echo -e "${GREEN}✓ Submission folders created${NC}"
echo ""

echo -e "${BLUE}Step 3: Copying files to submission folder${NC}"
echo ""

# Copy source.zip
cp source.zip submission/source/
echo "  ✓ Copied source.zip"

# Copy documentation
cp docs/README.md submission/documentation/
echo "  ✓ Copied README.md"

cp docs/user_guide.txt submission/documentation/
echo "  ✓ Copied user_guide.txt"

cp linux-deb/myapp/DEBIAN/control submission/documentation/
echo "  ✓ Copied control file"

# Copy packages if they exist
if [ -f "linux-deb/helloworld_hussein_yaacoub.deb" ]; then
    cp linux-deb/helloworld_hussein_yaacoub.deb submission/packages/
    echo -e "  ${GREEN}✓ Copied DEB package${NC}"
elif [ -f "linux-deb/myapp.deb" ]; then
    cp linux-deb/myapp.deb submission/packages/helloworld_hussein_yaacoub.deb
    echo -e "  ${YELLOW}⚠ Copied DEB package (check filename!)${NC}"
else
    echo -e "  ${YELLOW}⚠ DEB package not found - you need to build it first${NC}"
fi

# Note about MSI (can't be built on Linux)
if [ -f "windows-msi/helloworld_hussein_yaacoub.msi" ]; then
    cp windows-msi/helloworld_hussein_yaacoub.msi submission/packages/
    echo -e "  ${GREEN}✓ Copied MSI package${NC}"
else
    echo -e "  ${YELLOW}⚠ MSI package not found - build it on Windows${NC}"
fi

# Optional RPM
if [ -f "linux-rpm/helloworld_hussein_yaacoub.rpm" ]; then
    cp linux-rpm/helloworld_hussein_yaacoub.rpm submission/packages/
    echo -e "  ${GREEN}✓ Copied RPM package (optional)${NC}"
fi

echo ""
echo -e "${BLUE}Step 4: Creating screenshots README${NC}"
echo ""

# Create a README for screenshots folder
cat > submission/screenshots/README_SCREENSHOTS.txt << 'EOF'
SCREENSHOTS REQUIRED FOR SUBMISSION
====================================

Place all your screenshots in this folder with the following names:

WINDOWS MSI (5 screenshots):
  01_msi_creation_tool.png       - WiX project or build process
  02_windows_installed_programs.png - Control Panel showing installed app
  03_msi_installation.png        - Installation wizard or command
  04_windows_app_running.png     - Application output
  05_msi_metadata.png            - MSI properties/metadata

LINUX DEB (6 screenshots):
  06_deb_build_command.png       - dpkg-deb build command
  07_deb_contents.png            - dpkg-deb -c output
  08_deb_installation.png        - sudo dpkg -i command
  09_deb_installed_verification.png - dpkg -l | grep myapp
  10_linux_app_running.png       - helloworld command output
  11_deb_metadata.png            - dpkg-deb -I output

OPTIONAL (recommended):
  12_project_structure.png       - Directory tree
  13_source_code.png             - Code in editor

Make sure all screenshots are:
- Clear and readable
- Show the full terminal/window
- Include command and output
- Labeled correctly
EOF

echo -e "${GREEN}✓ Created screenshots README${NC}"

echo ""
echo "=========================================="
echo "SUBMISSION PACKAGE SUMMARY"
echo "=========================================="
echo ""

# Show submission structure
echo "Submission folder structure:"
tree submission/ 2>/dev/null || find submission/ -type f

echo ""
echo -e "${GREEN}✓ Submission preparation complete!${NC}"
echo ""

echo "=========================================="
echo "NEXT STEPS"
echo "=========================================="
echo ""
echo "1. Build your packages if not already done:"
echo "   ${YELLOW}cd linux-deb && ./build-deb.sh${NC}"
echo "   ${YELLOW}cd windows-msi && build-msi.bat (on Windows)${NC}"
echo ""
echo "2. Copy built packages to submission/packages/"
echo ""
echo "3. Take all required screenshots"
echo "   See: submission/screenshots/README_SCREENSHOTS.txt"
echo ""
echo "4. Verify everything in submission/ folder"
echo ""
echo "5. Create final submission archive:"
echo "   ${YELLOW}zip -r lab11_submission.zip submission/${NC}"
echo ""
echo "6. Double-check SUBMISSION_CHECKLIST.txt"
echo ""

echo "=========================================="
echo "IMPORTANT REMINDERS"
echo "=========================================="
echo ""
echo -e "${RED}⚠ Replace GUIDs in Product.wxs before building MSI!${NC}"
echo -e "${RED}⚠ Test both packages before submitting!${NC}"
echo ""

echo "Good luck! 🚀"
echo ""
