# Preparing Nodes

## Install Proxmox

Download Proxmox VE and flash it to a USB drive, boot the device from the USB drive and install Proxmox VE

### Configure Proxmox and the network

!!! Use as Static IP for your Proxmox node. This makes it way more easy to create a cluster with new nodes.


## Prepare Ubuntu/Centos for k8s

K8s Images are Build with Hashicorps Packer. With serveral configs which will prepare both os for automatic patching with kured.  

# TODO - Add Link for Packer Repo 