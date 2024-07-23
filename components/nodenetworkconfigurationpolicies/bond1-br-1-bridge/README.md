# Bond1-BR-1 Bridge Configuration

This directory contains configuration files for setting up a network policy and network attachment definition using a bond interface and a Linux bridge.

## Files

- `kustomization.yaml`: This file lists the resources to be included in the configuration. It currently includes `base-network-policy.yaml` and has commented out `nad-bridge.yaml`.

- `base-network-policy.yaml`: This file defines a NodeNetworkConfigurationPolicy (`NodeNetworkConfigurationPolicy`) for configuring a bond interface (`bond1`) and a Linux bridge (`br-1`). The bond interface aggregates two ports (`enp8s0` and `enp9s0`) in `802.3ad` mode with `miimon` set to `140`. A VLAN interface (`bond1.1925`) is created on top of the bond interface with VLAN ID `1925`. The Linux bridge is configured to use the VLAN interface as a port and has STP enabled. The policy is applied to a specific node (`lab-worker-4`).

- `nad-bridge.yaml`: This file defines a NetworkAttachmentDefinition (`NetworkAttachmentDefinition`) for a Linux bridge (`br-1`) with VLAN ID `1925`. The bridge is configured to act as a gateway and has an empty IPAM section, indicating DHCP is enabled for the VLAN.

## Usage

To apply these configurations, ensure that the necessary resources are uncommented in `kustomization.yaml` and use `kustomize` to build and apply the configuration to your Kubernetes cluster.

Example:
```sh
kustomize build . | kubectl apply -f -
```

For more details on each resource type, refer to the official Kubernetes documentation.
