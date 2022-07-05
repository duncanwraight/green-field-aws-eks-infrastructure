# Green field approach to deploying application services to AWS using EKS

## Repository structure

Three repositories:
 - `terraform`
 - `kubernetes`
 - `application_code`

In reality, you would likely have multiple `application_code` repositories - probably one per service, unless you were taking a mono-repo approach.

## The `terraform` repository

Hosts your Infrastructure as Code.

Set out as follows:

```
terraform
├── environments
│   ├── development
│   ├── production
│   └── staging
├── modules
│   ├── aurora_serverless
│   ├── eks_cluster
│   ├── eks_node_group
│   └── vpc
└── services
    ├── decisioning
    └── wallet
```

 - `modules` contains any group of reusable code, e.g. `eks_cluster` or `vpc`.
 - `services` contains any group of infrastructure associated with a given service, e.g. the `wallet` service may require an S3 bucket and an RDS instance. Can call `modules` or specify individual infrastructure resources
 - `environments` is where the infrastructure is "called". References modules created in `modules` and `services` folders. Any deployment pipeline would use these directories to deploy to different environments, e.g. `development`

## The `kubernetes` repository

Multiple approaches possible for Kubernetes, such as Helm. This structure uses Kustomize which is now built into the `kubectl` binary.

 - The `base` folder creates resources for each service. Store in here any part of a resource which is shared across all environments, such as the service selectors, pod affinity rules and container resource requirements etc.
 - The environment folders such as `development` then use Kustomize to merge any configuration which is environment-specific, e.g. the container image and any environment variables

## Creating a new service

Creating a new service in this framework is quite straightforward:

 - In the `terraform` repository, create a new folder in `services`. Create `.tf` files for any resources the new service requires. In each of the `environments`, create a `my-new-service.tf` file which references the components created in the `services` subfolder you just created
 - In the `kubernetes` repository, create a new folder for your service in the `base` folder and each of the environment folders. Create your YAML resource definitions in the `base` folder, then any environment-specific configuration in the environment subfolders you just created. Use `kustomization.yml` files to indicate which YAML files need to be merged
 - Update the terraform and application pipelines to deploy your new service

## Approach to deploying services

My favoured approach is "GitOps". An agent, such as ArgoCD, can sit inside the Kubernetes cluster and continually check the `kubernetes` repository for any changes to resource definition YAML files. If it sees this change, it applies it to the cluster.

From the application pipeline, all you then need to do is commit a changed image tag to the `kubernetes` repository and watch the ArgoCD UI to see all of the Kubernetes moving parts (e.g. deployment, then replicaset, then pods).
