#!/bin/bash
# =============================================================================
# Insight CLI Installer
# =============================================================================
# Quick install script for Insight CLI — accessibility code analysis tool.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/signfordeaf/insight-code-cli/main/install.sh | bash
#   curl -sSL https://raw.githubusercontent.com/signfordeaf/insight-code-cli/main/install.sh | bash -s -- --version 0.1.0
# =============================================================================

set -euo pipefail

REPO="signfordeaf/insight-code-cli"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="insight"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Parse args
VERSION=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --version|-v)
            VERSION="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# Detect OS and architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    arm64|aarch64) ARCH="arm64" ;;
    *)
        echo -e "${RED}❌ Desteklenmeyen mimari: ${ARCH}${NC}"
        exit 1
        ;;
esac

case "$OS" in
    linux|darwin) ;;
    mingw*|msys*|cygwin*)
        echo -e "${YELLOW}⚠️  Windows için GitHub Releases'den .zip indirin:${NC}"
        echo "   https://github.com/${REPO}/releases"
        exit 1
        ;;
    *)
        echo -e "${RED}❌ Desteklenmeyen OS: ${OS}${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Insight CLI Installer${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"

# Get latest version if not specified
if [ -z "$VERSION" ]; then
    echo -e "${BLUE}📡 En son sürüm kontrol ediliyor...${NC}"
    VERSION=$(curl -sI "https://github.com/${REPO}/releases/latest" \
        | grep -i "^location:" \
        | sed 's/.*tag\/v//' \
        | tr -d '\r\n')
    
    if [ -z "$VERSION" ]; then
        echo -e "${RED}❌ Sürüm bilgisi alınamadı. --version ile belirtin.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}📦 Version: v${VERSION}${NC}"
echo -e "${GREEN}💻 Platform: ${OS}/${ARCH}${NC}"

# Download
ARCHIVE="insight_${VERSION}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/${REPO}/releases/download/v${VERSION}/${ARCHIVE}"

echo -e "\n${BLUE}⬇️  İndiriliyor: ${ARCHIVE}${NC}"

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

if ! curl -sfL "$URL" -o "${TMP_DIR}/${ARCHIVE}"; then
    echo -e "${RED}❌ İndirme başarısız: ${URL}${NC}"
    echo -e "${YELLOW}   Mevcut sürümleri kontrol edin: https://github.com/${REPO}/releases${NC}"
    exit 1
fi

# Extract
echo -e "${BLUE}📂 Çıkartılıyor...${NC}"
tar xzf "${TMP_DIR}/${ARCHIVE}" -C "$TMP_DIR"

# Install
echo -e "${BLUE}📥 Yükleniyor → ${INSTALL_DIR}/${BINARY_NAME}${NC}"

if [ -w "$INSTALL_DIR" ]; then
    mv "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
    sudo mv "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

# Verify
echo ""
if command -v "$BINARY_NAME" &>/dev/null; then
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✅ Insight CLI v${VERSION} başarıyla yüklendi!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${BLUE}Başlangıç:${NC}"
    echo "    insight scan ./my-project"
    echo "    insight rules"
    echo "    insight version"
else
    echo -e "${RED}❌ Kurulum doğrulanamadı. PATH kontrol edin.${NC}"
    exit 1
fi
