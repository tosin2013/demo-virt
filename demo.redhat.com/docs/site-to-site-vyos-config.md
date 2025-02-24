## Using ZeroTier for Site-to-Site Routing on VyOS

### Overview

This guide explores how to use ZeroTier for site-to-site routing in VyOS, running ZeroTier inside a container. This setup simplifies deployment by removing the need for additional routing protocols like BGP or OSPF.

### Topology

- Five sites, each with a single VyOS router.
- ZeroTier handles all routing between sites.
- No need for additional dynamic routing protocols.

### Setting Up ZeroTier

#### Creating a ZeroTier Account

1. Go to [ZeroTier Central](https://my.zerotier.com).
2. Sign up and create a new network.
3. Modify the subnet as needed (e.g., `10.13.0.0/16`).

#### Configuring VyOS

1. Ensure the steps in Step 1 and Second Router Setup have been completed.
2. Ensure VyOS has internet connectivity:
   ```bash
   configure
   set system name-server 1.1.1.1
   commit
   ```
3. Verify connectivity:
   ```bash
   ping www.google.com
   ```

### Installing ZeroTier in a Container

1. Pull the ZeroTier container image:
   ```bash
   add container image zerotier/zerotier:latest
   ```
2. Create a directory for persistent configuration:
   ```bash
   sudo mkdir -p /config/containers/zt1
   ```
3. Configure the container:
   ```bash
   configure
   set container name zt1 allow-host-networks
   set container name zt1 cap-add 'net-admin'
   set container name zt1 device tun destination '/dev/net/tun'
   set container name zt1 device tun source '/dev/net/tun'
   set container name zt1 image 'zerotier/zerotier:latest'
   set container name zt1 volume ZT_Path destination '/var/lib/zerotier-one'
   set container name zt1 volume ZT_Path source '/config/containers/zt1'
   commit
   ```
4. Verify container status:
   ```bash
   show container
   ```

### Joining the ZeroTier Network

1. Create a devicemap:
   ```bash
   sudo su
   cd /config/containers/zt1
   echo "<network-id>=eth10" > devicemap
   ```
2. Connect to the ZeroTier container:
   ```bash
   connect container zt1
   ```
3. Join the ZeroTier network:
   ```bash
   zerotier-cli join <network-id>
   ```
4. Verify the connection:
   ```bash
   zerotier-cli info
   ```
5. Authorize the node in [ZeroTier Central](https://my.zerotier.com).


Create routes for the endpoints in ZeroTier, ensuring they are properly configured in the "Managed Routes" section. Then, test connectivity between each router by performing ping and traceroute checks. 

## Tips
To restart container 
```
restart container zt1
```

View routes 
```
run show ip route
```

### Conclusion

ZeroTier provides a straightforward way to manage site-to-site VPNs on VyOS, eliminating the need for complex dynamic routing protocols. This setup is scalable and adaptable for various network deployments.

