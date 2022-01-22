# Terraform workshop for a Golang backend running in AWS ECS

## Setup

- Build the simple golang HTTP server which return its version.
- Create the ECS cluster.
- Deploy the backend service in ECS.

## Develop the HTTP server

**Requirements:**

- Docker.
- Go version ">= 1.12".

### Build the Docker image

About Versioning: we will have a Git tag for each release.

For e.g. to build the version `v0.1.0`:

```sh
VERSION=v0.1.0 make build
```

Run the docker image locally:

```sh
docker run --rm -it -p 8080:8080  http-server:0.1.0
```

## Setup the Infra

**Requirements**:

- Terraform version `> 1.0'.
- Community Terraform modules:
  - [aws-ecs](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest)
  - [aws-alb](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)

### Create the DNS first

Register a domain (dev):

```sh
aws route53domains register-domain \
  --cli-input-json file://deploy/http-server-example-dev.engineering.json \
  --region us-east-1

# {
#     "OperationId": "8753d80b-36a9-4a0c-9b94-281263c802de"
# }
```

```sh
terraform apply -target="module.zones" -auto-approve
```

### Deployment in ECS

We will have multiple Workspaces. Each Workspace will match for a specific environment.

For e.g. creating the `dev` environment:

```sh
cd terraform/deploy-ecs

terraform workspace select dev
terraform validate
terraform apply -auto-approve
```

## Production setup
