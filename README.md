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

| Service                                         | Use                                                               | Cost           |
|-------------------------------------------------|-------------------------------------------------------------------|----------------|
| [Cloudflare](https://www.cloudflare.com/)       | Domain, DNS and proxy management                                  | ~€30/yr        |
| [Hetzner](https://www.hetzner.com/)             | Email & VPS hosting                                               | ~€90/yr        |
| [GitHub](https://github.com/)                   | Hosting this repository and continuous integration/deployments    | Free           |

---
## 🔧 Hardware

<details>
  <summary>Click to see mini rack!</summary>

  <img src="https://user-images.githubusercontent.com/71972864/225144867-8657dd4e-09fb-4f39-9a2a-9945a1c20a30.png" align="center" width="200px" alt="rack"/>
</details>

| Device                           | Count | OS Disk Size | Data Disk Size              | Ram  | Operating System | Purpose             |
|----------------------------------|-------|--------------|-----------------------------|------|------------------|---------------------|
| Lenovo ThinkCentre M900 i5 6500t | 3     | 1TB SSD      | -                           | 16GB | Ubuntu 22.04     | Kubernetes Masters  |
| IdeaCentre Mini 5i 10400t        | 3     | 256GB SSD    | 1TB NVMe (rook-ceph)        | 16GB | Ubuntu 22.04     | Kubernetes Worker   |
| Synology RS1221+                 | 1     | 60TB HDD     | -                           | 4GB  | DSM 7.1          | NFS Storage         |
| MinisForum HM80                  | 1     | 512GB NVMe   | -                           | 32GB | Proxmox 7.1      | Hypervisor DNS etc. |
| TP-Link TL-SG1016DE 16-Port      | 1     | -            | -                           | -    | -                | Rack-Switch         |
| Raspberry Pi4                    | 1     | 32GB SD-Card | -                           | 8GB  | Raspbian         | PiHole & Backupsvc  |

---
## Special thanks
A lot of inspiration is taken form the k8s at home community. If you are intrested in learning kubernetes i highly recommand to visit them over at discord
[![Discord](https://img.shields.io/discord/673534664354430999?style=for-the-badge&label&logo=discord&logoColor=white&color=blue)](https://discord.gg/k8s-at-home)
