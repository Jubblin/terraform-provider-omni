#!/usr/bin/env bash
set -euo pipefail

install_terraform() {
  if command -v terraform >/dev/null 2>&1; then
    return 0
  fi

  local version="${TERRAFORM_VERSION:-1.11.4}"
  local arch
  arch="$(dpkg --print-architecture)"
  case "${arch}" in
    amd64 | arm64) ;;
    *)
      echo "unsupported architecture: ${arch}" >&2
      return 1
      ;;
  esac

  curl -fsSL \
    "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_${arch}.zip" \
    -o /tmp/terraform.zip
  if command -v sudo >/dev/null 2>&1; then
    sudo unzip -qo /tmp/terraform.zip -d /usr/local/bin
  else
    unzip -qo /tmp/terraform.zip -d /usr/local/bin
  fi
  rm -f /tmp/terraform.zip
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$(bash "${script_dir}/verify-workspace.sh")"

install_terraform

go mod download
(cd tools && go mod download)

go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/goreleaser/goreleaser/v2@latest

terraform version
