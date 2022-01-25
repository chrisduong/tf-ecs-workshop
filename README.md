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
  - [aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
  - [aws-ecs](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws/latest)
  - [aws-alb](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)

### Secure connection with HTTPS

Our ALB will force customer to use the HTTPS connection to our web server by
redirect the HTTP traffic to HTTPS.

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

### DRY for Terraform

When we have multiple environments to deploy and they use the same set of
job functions (create the VPC, ECS cluster, ....). To avoid of repeating those
jobs, we need to have a resuable solution for multiple environments.

Once we define each job as a module, you can easily reuse it in different environments
by sourcing the Terraform module.

In this setup, we used a lot of modules:

1. (App Level) we have VPC, ECS, ALB modules.
2. (Environment Level) we have the [vars module](./terraform/modules/vars) which
stores configurations for different environments (`app_version`,
`deployment_minimum_healthy_percent`,...). We also evaluate the Terraform Workspace
to avoid of repeating the module `deploy-ecs`.

### Manual Scale

You can increase (or reduce) the number of containers by setting the
`ecs_desired_count` for your specific environment.
SEE: [dev.tf/ecs_desired_count](./terraform/modules/vars/dev.tf#L4)

### Rolling Update without downtime

You set the `ecs_desired_count` greater than 1 and the `deployment_minimum_healthy_percent`
at the right percent for you. For e.g. You can set `ecs_desired_count=2` and
`deployment_minimum_healthy_percent=50`. Then during the deployment,
you always have at least 1 containers running.

## Recommendations for Production Setup

- We should have the AutoScaling system instead of "manual scale".
SEE: [Service Auto Scale](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-auto-scaling.html)
where you can confiure the Application AutoScaling target for your
ECS service. Then you can for e.g. dynamically scale your service
based on CPU or Memory usuage.
- Service should be exposed with HTTPS.
- Embrace the CI/CD, so that we can build, test and deploy at high velocity
and in the more reliable way.
- Embrace DevSecOps:
  - Should have an Security Scanning system integrated with the CI,
  to frequently scan the security vulnerability.
  - To use the advanced security features for your exposed service
such intrusion detection, consider to use Cloudflare to protect
the service.
- Follow container best practices:
  - Prefer minimal base images
  - Make container images complete and static
  - Least privileged user
  - Fix security vulnerabilities inside the container
  - Use Your Own Private Registry
- Need a solid Monitoring/Observability system so engineers can understand
know whether ths applications is healthy and how
to act on a specific issue ( Why is X broken?)
