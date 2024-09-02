#!/bin/bash
set -e

# Define base directories and build output directories
BASE_DIR="en_us"
BUILD_DIR="_build/html"
DOCTREES_DIR="_build/doctrees"

# List of directories to build
DIRECTORIES=(
    "contribute"
    "students_redirect"
    "enterprise_api"
    "open_edx_students"
    "open_edx_course_authors"
    "open_edx_release_notes"
    "course_authors"
    "olx"
    "install_operations"
    "links"
    "xblock-tutorial"
    "discovery_api"
    "course_catalog_api_user_guide"
    "landing_page"
    "data"
    "edx_style_guide"
    "developers"
)

# Make sure the build directories exist
mkdir -p $BUILD_DIR
mkdir -p $DOCTREES_DIR

# Build each directory
for DIR in "${DIRECTORIES[@]}"; do
    echo "Building documentation for $DIR..."
    sphinx-build -b html "$BASE_DIR/$DIR/source" "$BUILD_DIR/$DIR" -d "$DOCTREES_DIR/$DIR"
done

echo "Documentation build complete!"