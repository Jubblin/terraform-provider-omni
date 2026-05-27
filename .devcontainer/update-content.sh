#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(bash "${script_dir}/verify-workspace.sh")"

go mod download
(cd tools && go mod download)
