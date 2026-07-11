#!/usr/bin/env bash

set -euo pipefail

readonly name="${1:-world}"
if [[ -n "$name" && "$name" == world ]]; then
  echo "hello"
else
  exit 1
fi
