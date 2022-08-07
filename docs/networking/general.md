# Networking

{% import 'links.jinja2' as links %}

Description of how my network is set up.

| Name                        | CIDR                |
| --------------------------- | ------------------- |
| Proxmox API                 | `192.168.178.200/24`|
| Kubernetes - API            | `192.168.178.10/24` |
| k8s pods                    | `10.10.0.0/16`      |
| k8s services                | `192.168.178.241/32`|

## Running high-available control-plane

In order to make the controle plane ha i used kube-vip since my own network dosent support bgp routing as of now. 

## Exposing services via Ingress

With no flat networking all services must be exposed via LoadBalancer or Ingress. As of now all services are exposed via traefik 

### Mixed-protocol services

I have enabled the `MixedProtocolLBService=true` feature-gate on my cluster. This means that I can combine the same port with different protocols (UDP and TCP) on the same service.
