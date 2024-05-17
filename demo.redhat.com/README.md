# Deploy lab environment on demo.redhat.com

## Pre-requisites
* [Deploy on the base system on Red Hat Product Demo System using the following steps.](https://tosin2013.github.io/qubinode_navigator/deployments/demo-redhat-com.html)
* [Configure One Dev Server](https://tosin2013.github.io/qubinode_navigator/plugins/onedev.html)

## Step 1: Configure Networking on the Host
* [Configure Networking on the Host](docs/step1.md)
  
## Step 2: Deploy OpenShift
* [Deploy OpenShift](docs/step2.md)


set interfaces ethernet eth4 mtu '1500'
set interfaces ethernet eth4 vif 1927 ipvlan id '1927'
set interfaces ethernet eth4 vif 1927 ipvlan mode 'l3'
set interfaces ipvlan iveth4 vif 1927 address '192.168.56.1/24'
set interfaces ipvlan iveth4 vif 1927 description 'Metal'