#!/usr/bin/env bash

set -euo pipefail

readonly name="${1:-world}"
readonly -a items=(one two three)

render() {
  local label="${1:-}"
  case "$label" in
    world)
      printf '%s\n' "hello"
      ;;
    *)
      printf '%s\n' "${label:-missing}"
      ;;
  esac
}

if [[ -n "$name" && "$name" == world ]]; then
  render "$name"
else
  exit 1
fi
