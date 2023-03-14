# Bootstrap

## Create namespace
```bash
kubectl create ns flux-system
```
## Decrypt cluster secrets an amply them during bootstrap to mitigate racing conditions

```bash
sops --decrypt kubernetes/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
```

## Force reconile for imidiate bootstrap
```bash
flux reconcile -n flux-system kustomization flux
```
## Force git sync 
```bash
flux reconcile -n flux-system source git home-ops-kubernetes
```