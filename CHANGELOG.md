# 0.1.0 (Unreleased)

FEATURES:

- **Provider configuration**
  - Require `uri` and `service_account`.

- **Resources**
  - Add `omni_cluster` resource (manage a cluster via YAML `template`).
  - Add `omni_kubeconfig` resource (fetch kubeconfig for a cluster, with optional `user`/`groups`).

- **Data sources**
  - Add `omni_machine` data source (lookup by `uuid` or `hardware_address`, optionally wait for registration).
  - Add `omni_talosconfig` data source (fetch talosconfig for a cluster).
