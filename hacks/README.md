# Hacks

## Register new domain

(Make sure the payment is working)

```sh
aws route53domains register-domain \
  --cli-input-json file://deploy/http-server-abc.engineering.json \
  --region us-east-1

# {
#     "OperationId": "8753d80b-36a9-4a0c-9b94-281263c802de"
# }
```
