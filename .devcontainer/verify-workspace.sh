#!/usr/bin/env bash
# Resolve the mounted repo and verify read/write access. Prints workspace path on stdout.
set -euo pipefail

resolve_workspace() {
  local candidates=()

  if [[ -n "${CONTAINER_WORKSPACE_FOLDER:-}" ]]; then
    candidates+=("${CONTAINER_WORKSPACE_FOLDER}")
  fi
  candidates+=("/workspaces/terraform-provider-omni")

  local dir
  for dir in "${candidates[@]}" "$(pwd)"; do
    if [[ -f "${dir}/go.mod" ]]; then
      printf '%s' "${dir}"
      return 0
    fi
  done

  return 1
}

workspace="$(resolve_workspace)" || {
  echo "Repository workspace not found (go.mod missing)." >&2
  echo "  CONTAINER_WORKSPACE_FOLDER=${CONTAINER_WORKSPACE_FOLDER:-<unset>}" >&2
  echo "  pwd=$(pwd)" >&2
  if [[ -d /workspaces ]]; then
    echo "  /workspaces contents:" >&2
    ls -la /workspaces >&2 || true
  fi
  exit 1
}

cd "${workspace}"

echo "Workspace: ${workspace}" >&2
echo "User: $(id)" >&2
echo "Repo files: $(find . -maxdepth 1 -type f | wc -l | tr -d ' ') at top level" >&2

if [[ ! -r go.mod ]]; then
  echo "go.mod is not readable." >&2
  exit 1
fi

probe=".devcontainer-workspace-probe-$$"
if ! touch "${probe}" 2>/dev/null; then
  echo "Cannot write to workspace (check Docker file sharing and folder permissions)." >&2
  echo "  Try enabling updateRemoteUserUID or add the repo path in Docker Desktop > Settings > File sharing." >&2
  exit 1
fi
rm -f "${probe}"

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Git: $(git rev-parse --short HEAD 2>/dev/null || echo unknown)" >&2
else
  echo "Git: not available or not a work tree (non-fatal)" >&2
fi

printf '%s' "${workspace}"
