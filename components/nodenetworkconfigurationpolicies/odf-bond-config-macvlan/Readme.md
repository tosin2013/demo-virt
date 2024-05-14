# OpenShift Virtualization with External ODF and VM migration Network Configuration

This README provides a comprehensive guide on setting up an external network for OpenShift Data Foundation and a migration network for OpenShift Virtualization using NodeNetworkConfigurationPolicy and NetworkAttachmentDefinition.

## Overview

The configuration aims to enhance OpenShift Virtualization by integrating external networking capabilities. This setup involves creating a bonded interface with VLAN on a specific node, and defining network attachment definitions for OpenShift Data Foundation and migration purposes.

## Prerequisites

- OpenShift Container Platform 4.x
- NMState Operator installed on the cluster
- Administrative privileges on the OpenShift cluster

## Configuration Details

### Node Network Configuration

The `NodeNetworkConfigurationPolicy` is used to set up a bonded interface (`bond1`) with VLAN (`bond1.1925`) and a Linux bridge (`br-1`) on a specific node (`lab-worker-4`). This configuration ensures that the node can handle network traffic efficiently and is crucial for performance-sensitive applications like data storage and VM migration.

#### Bond and VLAN Configuration

- **Bond Interface (`bond1`)**: Combines `enp8s0` and `enp9s0` interfaces into a single bonded interface using the 802.3ad protocol, which provides link aggregation for increased bandwidth and redundancy.
- **VLAN Interface (`bond1.1925`)**: Creates a VLAN with ID 1925 on top of the bonded interface, allowing network segmentation and isolation.
- **Linux Bridge (`br-1`)**: Bridges the VLAN interface, enabling connectivity between the bonded interfaces and the rest of the network.

### Network Attachment Definitions

Two `NetworkAttachmentDefinition` resources are defined for different purposes:

1. **ODF Public Network (`odf-public`)**:
   - Used by OpenShift Data Foundation for external access to storage resources.
   - Configured with a `macvlan` that bridges traffic to the Linux bridge `br-1`.
   - IPAM configured with Whereabouts to manage IP allocation in the `192.168.52.0/24` range.

2. **Migration Network (`migration-network`)**:
   - Facilitates the migration of virtual machines within OpenShift Virtualization.
   - Similar configuration to the ODF network, ensuring consistency and ease of management.
   - Uses the same IP range and bridge, simplifying the network architecture.

## Applying the Configuration

To apply this configuration, follow these steps:

```
oc apply -k components/nodenetworkconfigurationpolicies/odf-bond-config-macvlan/
```