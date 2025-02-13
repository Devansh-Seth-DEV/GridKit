#!/bin/bash

set -e  # Exit on error

echo "📥 Cloning GridKit repository..."
git clone --depth=1 --filter=blob:none --sparse https://github.com/Devansh-Seth-DEV/GridKit.git

cd GridKit

echo "🔍 Checking out GridKit.xcframework..."
git sparse-checkout set GridKit.xcframework

echo "✅ Installation complete!"
