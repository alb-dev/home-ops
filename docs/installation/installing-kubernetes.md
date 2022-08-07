# Installing Kubernetes and Nodes

Terraform will provide the infrastructer via the proxmox api. Nodes will be created and k3s will be bootstraped with k3sup. This cluster is a HA Cluster with k3s etcd backend. During the inital bootstrap kube-vip will be deployed as a daemonset for the ha k8s api.