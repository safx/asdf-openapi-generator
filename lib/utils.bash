#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/OpenAPITools/openapi-generator"
TOOL_NAME="openapi-generator"
TOOL_TEST="openapi-generator-cli version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if openapi-generator is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  # Note: some old packages are unable to download from maven repository.
  url="https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/${version}/${TOOL_NAME}-cli-${version}.jar"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if ! which java >/dev/null; then
    echo "You need a Java Runtime already installed on your computer."
    echo "Follow the instructions for your platform or download it"
    echo "from http://java.com/en/download"
    exit 1
  fi

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  local release_file="$install_path/$TOOL_NAME-cli-$version.jar"
  local script_file="$install_path/bin/$TOOL_NAME-cli"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    # command line parameters are copied from openapi-generator-cli.sh (https://github.com/OpenAPITools/openapi-generator/blob/master/bin/utils/openapi-generator-cli.sh)
    echo '#!/bin/sh' >"$script_file"
    echo 'java -ea ${JAVA_OPTS} -Xms512M -Xmx1024M -server -jar '"$release_file"' "$@"' >>"$script_file"
    chmod +x "$script_file"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
