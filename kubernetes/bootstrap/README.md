# Bootstrap

## Create namespace
```bash
kubectl create ns flux-system
```
```bash 
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
```

```bash
cat $SOPS_AGE_KEY_FILE | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin
```
## Decrypt cluster secrets an amply them during bootstrap to mitigate racing conditions

```bash
sops --decrypt kubernetes/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
```

```bash
kubectl apply --server-side --kustomize ./kubernetes/flux/config
```

## Force reconile for imidiate bootstrap
```bash
flux reconcile -n flux-system kustomization flux
```
## Force git sync 
```bash
flux reconcile -n flux-system source git home-ops-kubernetes
```