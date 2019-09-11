#!/usr/bin/env bash

version=$1
if [ -z $version ]; then
  echo "usage $0 <version>"
fi

echo "Tagging release v${version}"
git tag -a v${version} -m "Release v${version}"
git push origin v${version}

echo "Building executables"
rm -fr bin
env GOOS=darwin GOARCH=amd64 go build -o bin/pat-darwin-amd64-${version}
env GOOS=linux GOARCH=amd64 go build -o bin/pat-linux-amd64-${version}
env GOOS=windows GOARCH=amd64 go build -o bin/pat-windows-amd64-${version}.exe
cd bin
shasum -a 256 * > shasum256.txt
cd ..

echo "Create release on GitHub"
hub release create -a "bin/pat-darwin-amd64-${version}#pat ${version} for macOS" \
                   -a "bin/pat-linux-amd64-${version}#pat ${version} for Linux 64-bit" \
                   -a "bin/pat-windows-amd64-${version}.exe#pat ${version} for Windows 64-bit" \
                   -a "bin/shasum256.txt#SHA256 sums for binaries" \
                   -m "Release v${version}" v${version}
