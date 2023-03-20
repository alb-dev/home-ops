<div align="center">

<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="center" width="144px" height="144px"/>

### My home operations repository :octocat:

_... managed with Flux, Renovate and GitHub Actions_ 🤖

</div>

<br/>

<div align="center">

[![Kubernetes](https://img.shields.io/badge/v1.26-blue?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io/)

</div>


---

## 📖 Overview

This is a mono repository for my home infrastructure and Kubernetes cluster. I try to adhere to Infrastructure as Code (IaC) and GitOps practices using the tools like [Ansible](https://www.ansible.com/), [Terraform](https://www.terraform.io/), [Kubernetes](https://kubernetes.io/), [Flux](https://github.com/fluxcd/flux2), [Renovate](https://github.com/renovatebot/renovate) and [GitHub Actions](https://github.com/features/actions).

---

## ⛵ Kubernetes

There is a template over at [onedr0p/flux-cluster-template](https://github.com/onedr0p/flux-cluster-template) if you wanted to try and follow along with some of the practices I use here. Even though cluster template from onedr0p is really good. I created a lot of parts in my cluster manually. This helped my understanding of kubernetes, iac etc..


### Installation

My cluster is [k3s](https://k3s.io/) provisioned overtop bare-metal Ubuntu Server using the [Ansible](https://www.ansible.com/) galaxy role [ansible-role-k3s](https://github.com/PyratLabs/ansible-role-k3s). This is a semi hyper-converged cluster, workloads and block storage are sharing the same available resources on my nodes while I have a separate server for (NFS) file storage.

🔸 _[Click here](./provision/kubernetes/servers/) to see my Ansible playbooks and roles._

As this is a monorepo for my whole homelab i will also include other parts like my pihole and DNS configuration later on. 


### Core Components

- [actions-runner-controller](https://github.com/actions/actions-runner-controller): Self-hosted Github runners.
- [calico](https://github.com/projectcalico/calico): Internal Kubernetes networking plugin.
- [cert-manager](https://cert-manager.io/docs/): Creates SSL certificates for services in my Kubernetes cluster.
- [external-dns](https://github.com/kubernetes-sigs/external-dns): Automatically manages DNS records from my cluster in a cloud DNS provider.
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/): Ingress controller to expose HTTP traffic to pods over DNS.
- [rook](https://github.com/rook/rook): Distributed block storage for peristent storage.
- [sops](https://toolkit.fluxcd.io/guides/mozilla-sops/): Managed secrets for Kubernetes, Ansible and Terraform which are commited to Git.
- [volsync](https://github.com/backube/volsync) and [snapscheduler](https://github.com/backube/snapscheduler): Backup and recovery of persistent volume claims.


### GitOps

[Flux](https://github.com/fluxcd/flux2) watches my [kubernetes](./kubernetes/) folder (see Directories below) and makes the changes to my cluster based on the YAML manifests.

The way Flux works for me here is it will recursively search the [kubernetes/apps](./kubernetes/apps) folder until it finds the most top level `kustomization.yaml` per directory and then apply all the resources listed in it. That aforementioned `kustomization.yaml` will generally only have a namespace resource and one or many Flux kustomizations. Those Flux kustomizations will generally have a `HelmRelease` or other resources related to the application underneath it which will be applied.

[Renovate](https://github.com/renovatebot/renovate) watches my **entire** repository looking for dependency updates, when they are found a PR is automatically created. When some PRs are merged [Flux](https://github.com/fluxcd/flux2) applies the changes to my cluster.

### Directories

This Git repository contains the following directories under [kubernetes](./kubernetes/).

```sh
📁 kubernetes      # Kubernetes cluster defined as code
├─📁 bootstrap     # Flux installation
├─📁 flux          # Main Flux configuration of repository
└─📁 apps          # Apps deployed into my cluster grouped by namespace (see below)
```


### Networking

| Name                                          | CIDR              |
|-----------------------------------------------|-------------------|
| Kubernetes Nodes VLAN                         | `192.168.178.0/24`|
| Kubernetes pods (Calico)                      | `10.56.0.0/16`    |
| Kubernetes services (Calico)                  | `10.57.0.0/16`    |

- Since my home-network is just one subnet everything is managed by calico's overlay-network in cluster.

---

## ☁️ Cloud Dependencies

While most of my infrastructure and workloads are selfhosted I do rely upon the cloud for certain key parts of my setup. This saves me from having to worry about two things. (1) Dealing with chicken/egg scenarios and (2) services I critically need whether my cluster is online or not.

The alternative solution to these two problems would be to host a Kubernetes cluster in the cloud and deploy applications like [HCVault](https://www.vaultproject.io/), [Vaultwarden](https://github.com/dani-garcia/vaultwarden), [ntfy](https://ntfy.sh/), and [Gatus](https://gatus.io/). However, maintaining another cluster and monitoring another group of workloads is a lot more time and effort than I am willing to put in.

| Service                                         | Use                                                               | Cost           |
|-------------------------------------------------|-------------------------------------------------------------------|----------------|
| [B2 Storage](https://www.backblaze.com/b2)      | Offsite application backups                                       | ~€5/mo         |
| [Cloudflare](https://www.cloudflare.com/)       | Domain, DNS and proxy management                                  | ~€30/yr        |
| [Hetzner](https://www.hetzner.com/)             | Email & VPS hosting                                               | ~€90/yr        |
| [GitHub](https://github.com/)                   | Hosting this repository and continuous integration/deployments    | Free           |

---

## 🔧 Hardware

<details>
  <summary>Click to see da rack!</summary>

  <img src="https://user-images.githubusercontent.com/71972864/225144867-8657dd4e-09fb-4f39-9a2a-9945a1c20a30.png" align="center" width="200px" alt="rack"/>
</details>

| Device                           | Count | OS Disk Size | Data Disk Size              | Ram  | Operating System | Purpose             |
|----------------------------------|-------|--------------|-----------------------------|------|------------------|---------------------|
| Lenovo ThinkCentre M900 i5 6500t | 1     | 1TB SSD      | -                           | 16GB | Ubuntu 22.04     | Kubernetes Masters  |
| IdeaCentre Mini 5i 10400t        | 3     | 256GB SSD    | 1TB NVMe (rook-ceph)        | 16GB | Ubuntu 22.04     | Kubernetes Worker   |
| Synology RS1221+                 | 1     | 60TB HDD     | -                           | 4GB  | DSM 7.1          | NFS Storage         |
| MinisForum HM80                  | 1     | 512GB NVMe   | -                           | 32GB | Proxmox 7.1      | Hypervisor DNS etc. |
| TP-Link TL-SG1016DE 16-Port      | 1     | -            | -                           | -    | -                | Rack-Switch         |
| Raspberry Pi4                    | 1     | 32GB SD-Card | -                           | 8GB  | Raspbian         | PiHole & Backupsvc  |

---

## Special thanks
A lot of inspiration is taken form the k8s at home community. If you are intrested in learning kubernetes i highly recommand to visit them over at discord
[![Discord](https://img.shields.io/discord/673534664354430999?style=for-the-badge&label&logo=discord&logoColor=white&color=blue)](https://discord.gg/k8s-at-home)
