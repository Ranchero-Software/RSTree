#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

rm -rf .build
mkdir -p .build/symbol-graphs

$(xcrun --find swift) build --target RSTree \
    -Xswiftc -emit-symbol-graph \
    -Xswiftc -emit-symbol-graph-dir -Xswiftc .build/symbol-graphs

$(xcrun --find docc) convert Sources/RSTree/Documentation.docc \
    --analyze \
    --fallback-display-name RSTree \
    --fallback-bundle-identifier com.github.heckj.RSTree \
    --fallback-bundle-version 0.1.0 \
    --additional-symbol-graph-dir .build/symbol-graphs \
    --experimental-documentation-coverage \
    --level brief

# Generating a parsable coverage file with `docbuild`:
# xcodebuild docbuild -scheme RSTree \
#     -derivedDataPath ~/Desktop/RSTreeBuild \
#     -destination platform=macOS \
#     OTHER_DOCC_FLAGS="--experimental-documentation-coverage --level brief”
# Coverage file in JSON format at
# ~/Desktop/RSTreeBuild/Build/Products/Debug/RSTree.doccarchive/documentation-coverage.json