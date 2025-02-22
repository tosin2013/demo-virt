# Configure Networking on the Host Second Router Option


## Deploy vyos router on KVM
![20240502172209](https://i.imgur.com/1hinPuI.png)
![20240502172909](https://i.imgur.com/X7ULdH6.png)
*When vm has deployed you will see the folowing*
![20240427110356](https://i.imgur.com/PdnTynQ.png)
---
![20240427203404](https://i.imgur.com/IIq2kZI.png)
---
![20240427100654](https://i.imgur.com/aAmRFWl.png)
### Validate the vyos
**Default username and password**
* username: vyos
* password: vyos
![20240427101101](https://i.imgur.com/FA2rwXB.png)
### Run command : install image
![20240427101254](https://i.imgur.com/7yLOY8J.png)
---
![20240427101353](https://i.imgur.com/vmXQ8TE.png)
---
![20240427101428](https://i.imgur.com/PHT8DFo.png)
---
![20240427101509](https://i.imgur.com/Tp970x3.png)
**The vm will shut down and you must manually start it**

## Configure External interface
*if you are using the default kvm network the ip address can be 192.168.122.x*
```bash
$ configure
$ set interfaces ethernet eth0 address 192.168.122.3/24
$ set interfaces ethernet eth0 description Internet-Facing
$ commit
$ save
$ run show interfaces
$ set protocols static route 0.0.0.0/0 next-hop 192.168.122.1
$ commit 
$ run ping 1.1.1.1 interface 192.168.122.3
$ save 
$ exit 
```

**Enable SSH on router**
```bash
$ configure 
$ set service ssh
$ commit 
$ save
$ exit
``` 

ssh into router
```bash
$ ssh vyos@192.168.122.3
```


**Copy script to router**
* link to script [vyos-config.sh](https://raw.githubusercontent.com/tosin2013/demo-virt/refs/heads/rhpds/demo.redhat.com/vyos-config-1.5-second-router.sh)
* If are using not 192.168.122.3 as the ip address of the route or would like to edit items like dns server, you can edit the script
* Update the script to use the ip address from the created DNS Server in vim `:%s/1.1.1.1/newip/g`
```bash
$ vi vyos-config.sh
$ chmod +x vyos-config.sh
```

**Optional: if you run the onedev pipeline a script will generated in the home directory**
```
$ sudo su - 
$ ls -lath vyos-config.sh 
$ scp vyos-config.sh vyos@192.168.122.3:/tmp
$ ssh vyos@192.168.122.3
$ chmod +x /tmp/vyos-config.sh
$ vbash  /tmp/vyos-config.sh 
```

**run script**
```bash
vbash vyos-config.sh
```

**Add routes to linux server**
```
sudo ip route add 192.168.59.0/24 via 192.168.122.3
sudo ip route add 192.168.60.0/24 via 192.168.122.3
sudo ip route add 192.168.61.0/24 via 192.168.122.3
sudo ip route add 192.168.62.0/24 via 192.168.122.3
sudo ip route add 192.168.63.0/24 via 192.168.122.3
sudo ip route add 192.168.64.0/24 via 192.168.122.3
sudo ip route add 192.168.65.0/24 via 192.168.122.3
sudo ip route add 192.168.66.0/24 via 192.168.122.3
sudo ip route add 192.168.67.0/24 via 192.168.122.3
sudo ip route add 192.168.68.0/24 via 192.168.122.3
```

**nmcli script to add routes permanently**
```bash
#!/bin/bash

# Display available NetworkManager connections
echo "Available NetworkManager connections:"
nmcli con show

# Prompt user to enter the profile name
read -p "Enter the name of the NetworkManager profile you wish to modify select virbr0: " profile_name

# Confirm the profile name
nmcli con show "$profile_name" &>/dev/null
if [ $? -ne 0 ]; then
    echo "Profile '$profile_name' not found. Please check the profile name and try again."
    exit 1
fi

# Define the routes to be added
declare -a routes=(
    "192.168.59.0/24 192.168.122.3"
    "192.168.60.0/24 192.168.122.3"
    "192.168.61.0/24 192.168.122.3"
    "192.168.62.0/24 192.168.122.3"
    "192.168.63.0/24 192.168.122.3"
    "192.168.64.0/24 192.168.122.3"
    "192.168.65.0/24 192.168.122.3"
    "192.168.66.0/24 192.168.122.3"
    "192.168.67.0/24 192.168.122.3"
    "192.168.68.0/24 192.168.122.3"
)

# Add routes to the profile
for route in "${routes[@]}"; do
    nmcli connection modify "$profile_name" +ipv4.routes "$route"
done

# Restart the NetworkManager to apply changes
echo "Applying changes..."
sudo systemctl restart NetworkManager
echo "Routes added successfully to the profile '$profile_name'."
```
