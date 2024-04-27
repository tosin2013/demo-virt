# Configure Networking on the Host



![20240427110356](https://i.imgur.com/PdnTynQ.png)
![20240427100635](https://i.imgur.com/ZJzE1Lp.png)
![20240427100654](https://i.imgur.com/aAmRFWl.png)
### Validate the vyos
**Default username and password**
* username: vyos
* password: vyos
![20240427101101](https://i.imgur.com/FA2rwXB.png)
*install image*
![20240427101254](https://i.imgur.com/7yLOY8J.png)
![20240427101353](https://i.imgur.com/vmXQ8TE.png)
![20240427101428](https://i.imgur.com/PHT8DFo.png)
![20240427101509](https://i.imgur.com/Tp970x3.png)

Configure External interface
*if you are using the default kvm network the ip address can be 192..168.122.x*
```bash
$ configure
$ set interfaces ethernet eth0 address 192.168.122.2/24
$ set interfaces ethernet eth0 description Internet-Facing
$ commit
$ save
$ run show interfaces
$ set protocols static route 0.0.0.0/0 next-hop 192.168.122.1
$ commit 
$ run ping 1.1.1.1 interface 192.168.122.2
$ save 
$ exit 
```

Enable SSH on router
```bash
$ configure 
$ set service ssh
$ commit 
$ save
$ exit
``` 

ssh into router
```bash
$ ssh vyos@192.168.122.2
```


copy script to router
* link to script [vyos-config.sh](https://github.com/tosin2013/demo-virt/blob/rhpds/demo.redhat.com/vyos-config-1.5.sh)
```bash
$ vi vyos-config.sh
$ chmod +x vyos-config.sh
```

run script
```bash
bash vyos-config.sh
```