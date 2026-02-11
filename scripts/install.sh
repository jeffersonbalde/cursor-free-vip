#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logo
print_logo() {
    echo -e "${CYAN}"
    cat << "EOF"
   ██████╗██╗   ██╗██████╗ ███████╗ ██████╗ ██████╗      ██████╗ ██████╗  ██████╗   
  ██╔════╝██║   ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗     ██╔══██╗██╔══██╗██╔═══██╗  
  ██║     ██║   ██║██████╔╝███████╗██║   ██║██████╔╝     ██████╔╝██████╔╝██║   ██║  
  ██║     ██║   ██║██╔══██╗╚════██║██║   ██║██╔══██╗     ██╔═══╝ ██╔══██╗██║   ██║  
  ╚██████╗╚██████╔╝██║  ██║███████║╚██████╔╝██║  ██║     ██║     ██║  ██║╚██████╔╝  
   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝  
EOF
    echo -e "${NC}"
}

# Get download folder path
get_downloads_dir() {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "$HOME/Downloads"
    else
        if [ -f "$HOME/.config/user-dirs.dirs" ]; then
            . "$HOME/.config/user-dirs.dirs"
            echo "${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"
        else
            echo "$HOME/Downloads"
        fi
    fi
}

# Detect system type and architecture
detect_os() {
    if [[ "$(uname)" == "Darwin" ]]; then
        ARCH=$(uname -m)
        if [[ "$ARCH" == "arm64" ]]; then
            OS="mac_arm64"
            echo -e "${CYAN}ℹ️ Detected macOS ARM64 architecture${NC}"
        else
            OS="mac_intel"
            echo -e "${CYAN}ℹ️ Detected macOS Intel architecture${NC}"
        fi
    elif [[ "$(uname)" == "Linux" ]]; then
        ARCH=$(uname -m)
        if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
            OS="linux_arm64"
            echo -e "${CYAN}ℹ️ Detected Linux ARM64 architecture${NC}"
        else
            OS="linux_x64"
            echo -e "${CYAN}ℹ️ Detected Linux x64 architecture${NC}"
        fi
    else
        OS="windows"
        echo -e "${CYAN}ℹ️ Detected Windows system${NC}"
    fi
}

# Install and download
install_cursor_free_vip() {
    local downloads_dir=$(get_downloads_dir)
    
    # Hardcode the version you want to use
    VERSION="1.0.0"
    
    local binary_name="CursorFreeVIP_${VERSION}_${OS}"
    local binary_path="${downloads_dir}/${binary_name}"
    local download_url="https://github.com/yeongpin/cursor-free-vip/releases/download/v${VERSION}/${binary_name}"
    
    # Check if file already exists
    if [ -f "${binary_path}" ]; then
        echo -e "${GREEN}✅ Found existing installation file${NC}"
        echo -e "${CYAN}ℹ️ Location: ${binary_path}${NC}"
        
        if [ "$EUID" -ne 0 ]; then
            echo -e "${YELLOW}⚠️ Requesting administrator privileges...${NC}"
            if command -v sudo >/dev/null 2>&1; then
                sudo chmod +x "${binary_path}"
                sudo "${binary_path}"
            else
                chmod +x "${binary_path}"
                "${binary_path}"
            fi
        else
            chmod +x "${binary_path}"
            "${binary_path}"
        fi
        return
    fi
    
    echo -e "${CYAN}ℹ️ Downloading to ${downloads_dir}...${NC}"
    echo -e "${CYAN}ℹ️ Download link: ${download_url}${NC}"
    
    if ! curl -L -o "${binary_path}" "$download_url"; then
        echo -e "${RED}❌ Download failed${NC}"
        exit 1
    fi
    
    chmod +x "${binary_path}"
    echo -e "${GREEN}✅ Installation completed!${NC}"
    echo -e "${CYAN}ℹ️ Program downloaded to: ${binary_path}${NC}"
    echo -e "${CYAN}ℹ️ Starting program...${NC}"
    
    "${binary_path}"
}

# Main program
main() {
    print_logo
    detect_os
    install_cursor_free_vip
}

# Run main program
main
