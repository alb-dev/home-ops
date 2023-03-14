Create AGE key
```bash
age-keygen -o age.agekey
```
Move age key to sops directory
```bash
mkdir -p ~/.config/sops/age
mv age.agekey ~/.config/sops/age/keys.txt
```

Export key for kubernetes secret 

```bash
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
source ~/.zshrc
```

Create namespace for flux

```bash
kubectl create ns flux-system
```

Create generic secret with private key
```bash
cat $SOPS_AGE_KEY_FILE | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin
```

Create sops file in Repo .sops.yaml with the following content. It contains the publickey from the ~/.config/sops/age/keys.txt

```yaml
---
creation_rules:
  - path_regex: kubernetes/.*\.sops\.ya?ml
    encrypted_regex: "^(data|stringData)$"
    key_groups:
      - age:
          - age14zezx8350dxxh9kpqhpcna7a3gsma24n63qppqy0vfq47vvfkatqry5e9q
  - path_regex: kubernetes/.*\.sops\.ini
    key_groups:
      - age:
          - age14zezx8350dxxh9kpqhpcna7a3gsma24n63qppqy0vfq47vvfkatqry5e9q
  - path_regex: kubernetes/.*\.sops\.toml
    key_groups:
      - age:
          - age14zezx8350dxxh9kpqhpcna7a3gsma24n63qppqy0vfq47vvfkatqry5e9q
  - path_regex: kubernetes/.*\.sops\.json
    key_groups:
      - age:
          - age14zezx8350dxxh9kpqhpcna7a3gsma24n63qppqy0vfq47vvfkatqry5e9q
  - path_regex: ansible/.*\.sops\.ya?ml
    key_groups:
      - age:
          - age14zezx8350dxxh9kpqhpcna7a3gsma24n63qppqy0vfq47vvfkatqry5e9q
  - path_regex: terraform/.*\.sops\.ya?ml
    key_groups:
      - age:
          - age14zezx8350dxxh9kpqhpcna7a3gsma24n63qppqy0vfq47vvfkatqry5e9q
```