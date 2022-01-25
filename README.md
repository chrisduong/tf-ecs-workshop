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

### Secure connection with HTTPS

Our ALB will force customer to use the HTTPS connection to our web server by redirect the HTTP traffic to HTTPS

```txt
❯ curl -IL http://web.example.com/version
HTTP/1.1 301 Moved Permanently
Server: awselb/2.0
Date: Tue, 25 Jan 2022 14:52:11 GMT
Content-Type: text/html
Content-Length: 134
Connection: keep-alive
Location: https://web.example.com:443/version

HTTP/2 200 
date: Tue, 25 Jan 2022 14:52:12 GMT
content-type: text/plain; charset=utf-8
content-length: 6
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
