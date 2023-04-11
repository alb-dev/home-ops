
# Installing gitops via brew
```bash
brew tap weaveworks/tap
brew install weaveworks/tap/gitops
```
# Generating hashed password
```bash
PASSWORD=""
echo -n $PASSWORD | gitops get bcrypt-hash 
```