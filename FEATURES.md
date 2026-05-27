# Features present in this repo

This repository implements an `omni` Terraform provider (Go), with the following capabilities registered in `internal/provider/provider.go`.

## Provider configuration

The `omni` provider requires:

- `uri` (String)
- `service_account` (String)

## Resources

1. `omni_cluster`
   - Required input: `template` (String) YAML template for managing an Omni cluster
   - Read-only output: `id` (String) Cluster ID

2. `omni_kubeconfig`
   - Required input: `cluster_name` (String)
   - Optional inputs: `groups` (List of String), `user` (String)
   - Read-only outputs: `kubeconfig` (String), `id` (String)

## Data sources

1. `omni_machine`
   - Optional inputs: `hardware_address` (String), `uuid` (String), `wait_for_registration` (Boolean)
   - Read-only outputs: `id` (String)

2. `omni_talosconfig`
   - Required input: `cluster_name` (String)
   - Read-only outputs: `talosconfig` (String), `id` (String)

## Functions

No Terraform functions are currently registered by the provider (`Functions()` returns an empty list).

