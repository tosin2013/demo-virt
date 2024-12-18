# VMs with Firewall Demo

Testing of L2 overlay networks

[Front Net](components/l2-front) will have [Left Server](../../components/vms/server-left) attached at `10.111.111.1/24`

[Back Net](components/l2-back) will have [Right Server](../../components/vms/server-right) attached at `10.222.222.2/24`

[Firewall Server](../../components/vms/firewall) will be attached to both at `10.111.111.254` and `10.222.222.254`

Left and Right servers will have a static route defined allowing them to ping either other through the Firewall. 

Each server will be scheduled to a unique node through the use of an [AntiAffinity rule](patch-vm-affinity.yaml) based on hypervisor node hostname.

The initial OS setup uses [this cloud-init script](scripts/userData).

Networking in the VMs is ephemerally configured by [this script](scripts/netsetup). This can be run after boot at `/usr/local/bin/netsetup`.

Currently, most of the VM configuration is applied via inline patches in [kustomization.yaml](kustomization.yaml) that apply to [component VM definitions](../../components/vms/).

```mermaid
graph TD;
    classDef interface fill:#ffcc00,stroke:#333,stroke-width:2px;
    classDef network fill:#ddd,stroke:#333,stroke-width:2px;
    classDef neighbor fill:#ffeb99,stroke:#333,stroke-width:2px;

    subgraph Cluster ["Primary Cluster Network"]
        net-pod[Default<br> 10.0.2.0/24]:::network;
        net-pod --(NAT)--> internet
    end

    subgraph Networks["Overlay Networks"]
        net-left[Front Net<br> 10.111.111.0/24]:::network;
        net-right[Back Net<br> 10.222.222.0/24]:::network;
    end

    subgraph Server-Left
        server-left-eth0[eth0<br>10.0.2.2/24]:::interface;
        server-left-eth0 --> net-pod
        server-left-eth1[eth1<br>10.111.111.1/24]:::interface;
        server-left-eth1 ===> net-left
    end

    subgraph Firewall
        eth0[eth0<br>10.0.2.2/24]:::interface;
        eth0 ---> net-pod
        eth1[eth1<br>10.111.111.254/24]:::interface;
        eth1 ---> net-left;
        eth2[eth2<br>10.222.222.254/24]:::interface;
        eth2 ---> net-right;
    end

    subgraph Server-Right
        server-right-eth0[eth0<br>10.0.2.2/24]:::interface;
        server-right-eth0 --> net-pod
        server-right-eth1[eth1<br>10.222.222.2/24]:::interface;
        server-right-eth1 ===> net-right
    end
```