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

$(xcrun --find docc) preview Sources/RSTree/Documentation.docc \
    --fallback-display-name RSTree \
    --fallback-bundle-identifier com.github.heckj.RSTree \
    --fallback-bundle-version 0.1.0 \
    --additional-symbol-graph-dir .build/symbol-graphs
