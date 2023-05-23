# SOPS

Mozilla SOPS is a tool that allows you to commit encrypted secrets/data to git, without having to worry.

Note to self: the agekey is stored in Vaultwarden!

Guide: https://fluxcd.io/flux/guides/mozilla-sops/#encrypting-secrets-using-age

1. Generate an agekey
2. age-keygen -o age.agekey
3. cat age.agekey |
   kubectl create secret generic sops-age \
   --namespace=flux-system \
   --from-file=age.agekey=/dev/stdin


## Encrypting:

```bash
sops --age age1mq6usjzvvxvcp7tl03yjdqd0kgjhhvhz48kmg86p43nhx0jc75jssw0kfn --encrypt --encrypted-regex '^(data|stringData|annotations|host)$' --in-place 
```

## Decrypting

```bash
sops --age age1mq6usjzvvxvcp7tl03yjdqd0kgjhhvhz48kmg86p43nhx0jc75jssw0kfn --encrypt --encrypted-regex '^(data|stringData|annotations|host)$' --in-place 
```