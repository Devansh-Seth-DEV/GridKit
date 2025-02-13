#!/bin/bash

FRAMEWORK_NAME="GridKit"

# Output directories
ARCHIVE_DIR="./archives"
OUTPUT_XCFRAMEWORK="${FRAMEWORK_NAME}.xcframework"

# Create archive directories if they don't exist
mkdir -p "$ARCHIVE_DIR"

echo "🔨 Building for iOS..."
xcodebuild archive \
  -scheme "$FRAMEWORK_NAME" \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_DIR/ios.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty

echo "🔨 Building for iOS Simulator..."
xcodebuild archive \
  -scheme "$FRAMEWORK_NAME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$ARCHIVE_DIR/iossim.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty

echo "📦 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$ARCHIVE_DIR/ios.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$ARCHIVE_DIR/iossim.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$OUTPUT_XCFRAMEWORK"

echo "✅ XCFramework created: $OUTPUT_XCFRAMEWORK"

