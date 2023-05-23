# Useful

## Encrypting:

```bash
sops --age age1mq6usjzvvxvcp7tl03yjdqd0kgjhhvhz48kmg86p43nhx0jc75jssw0kfn --encrypt --encrypted-regex '^(data|stringData|annotations|host)$' --in-place 
```

## Decrypting

```bash
sops --age age1mq6usjzvvxvcp7tl03yjdqd0kgjhhvhz48kmg86p43nhx0jc75jssw0kfn --encrypt --encrypted-regex '^(data|stringData|annotations|host)$' --in-place 
```