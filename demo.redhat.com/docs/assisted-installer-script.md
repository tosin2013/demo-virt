# Assisted Installer Scripts

[Assisted Installer Scripts](https://github.com/tosin2013/openshift-4-deployment-notes/blob/master/assisted-installer/README.md)


## Prerequisites

The following binaries need to be included in the system $PATH:

- curl
- jq
- python3
- j2cli
```
sudo pip3 install j2cli
```

## Chapter 4. Installing with the Assisted Installer API
> https://access.redhat.com/documentation/en-us/assisted_installer_for_openshift_container_platform/2024/html/installing_openshift_container_platform_with_the_assisted_installer/installing-with-api#doc-wrapper

## Assisted Installer Steps for Bare Metal machines with Static IPs

1. Get offline token and save it to `~/rh-api-offline-token`
> [Red Hat API Tokens](https://access.redhat.com/management/api)

```bash
vim ~/rh-api-offline-token
```

2. Get OpenShift Pull Secret and save it to `~/ocp-pull-secret`
> [Install OpenShift on Bare Metal](https://console.redhat.com/openshift/install/metal/installer-provisioned)

```bash
vim ~/ocp-pull-secret
```

3. Ensure there is an SSH Public Key at `~/.ssh/id_rsa.pub`

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

4. Copy the cluster variables example file and modify as needed
*Update the DNS server under `export CLUSTER_NODE_NET_DNS_SERVERS=("8.8.8.8" "1.1.1.1")`*
```bash
git clone https://github.com/tosin2013/openshift-4-deployment-notes.git
cd openshift-4-deployment-notes/assisted-installer
cp example-mutli-network.demo-virt.cluster-vars.sh cluster-vars.sh
vim cluster-vars.sh
```

1. Run the bootstrap script to create the cluster, configure it, and download the ISO
> the bootstrap-create.sh script may also be used. 
```bash
./bootstrap.sh
```

Sample expected output:

```
[kemo@raza assisted-installer]$ ./bootstrap.sh 

===== Running preflight...

===== Generating asset directory...
===== Checking for needed programs...
curl                                                                     PASSED!
jq                                                                       PASSED!
python3                                                                  PASSED!
===== Authenticating to the Red Hat API...
  Using Token: eyJhbGciOiJSUzI...

===== Querying the Assisted Installer Service for supported versions...
  Found Cluster Release 4.9.4 from target version 4.9

===== Preflight passed...

===== Cluster ai-poc.lab.local not found, creating now...

===== Creating a new cluster...
  CLUSTER_ID: dc3cfcc3-6a11-4fb2-a94f-e4fe8cac617f

===== Generating NMState Configuration files...
  Working with 3 nodes...
  Creating NMState config for ocp01...
  Creating NMState config for ocp02...
  Creating NMState config for ocp03...

===== Setting password authentication for core user...

===== Configuring Discovery ISO...
  Working with 3 nodes...
  Generating ISO Config for ocp01...
  Generating ISO Config for ocp02...
  Generating ISO Config for ocp03...

===== Patching Discovery ISO...

===== Waiting 15s for ISO to build...


===== Downloading Discovery ISO locally to ./.generated/ai-poc.lab.local/ai-liveiso-dc3cfcc3-6a11-4fb2-a94f-e4fe8cac617f.iso ...

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  987M  100  987M    0     0  58.5M      0  0:00:16  0:00:16 --:--:-- 61.6M
```

2. Deploy the cluster using kvm script `./hack/create-kvm-vms.sh`
3. You may have to review the console before running the next command this will start the installation `./bootstrap-install.sh`
## Running bootstrap install manually  
> The bootstrap install script calls the scripts below in order. If you would like to walk thru the script call the scripts below. 
* `source cluster-vars.sh && source authenticate-to-api.sh` - sources variables to run scripts below.
* `steps/check-nodes-ready.sh` - Checks to see if all the nodes have reported in
* `steps/set-node-hostnames-and-roles.sh` - Set node hostnames and roles
* `steps/set-networking.sh` - configures network and other settings TBH
* `steps/check-cluster-ready-to-install.sh` - Check to see if the cluster is ready to install
* `steps/start-install.sh` -  Starts the Installation
4. Watch the installation with `./hack/watch-and-reboot-kvm-vms.sh`
5. Post-Install Cluster Configuration & Output `./bootstrap-post-install.sh`

## Bootstrap Execution Overview

- Run Preflight tasks - ensure files and variables are set, create asset generation directory
- Authenticate to the Assisted Installer Service
- Query the Assisted Installer Service for the supported OCP Release Version
- Create a Cluster in the AI Svc if it does not already exist
- Produce NMState configuration file
- [Optional] Set core user password
- Configure the Discovery ISO
- Download the Discovery ISO

Generated assets can be found in `./.generated/${CLUSTER_NAME}.${CLUSTER_BASE_DNS}/`

> Review [Hack-y](hack/README.md) scripts before start testing


## To destory test vms and cluster deployment 
```bash
./hack/delete-kvm-vms.sh
./destroy.sh
```