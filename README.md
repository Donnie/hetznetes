# What is this?

This is the cheapest way you can run Kubernetes period.

Using this you spin up a full `k3s` cluster running on MicroOS VMs on Hetzner.

The entire setup is managed from one repo via GitOps, this one.

## What kind of a cluster setup do I get?

You get one control plane and one worker node with a load balancer setup by default by running this setup.

Simply run `terraform output -raw kubeconfig > ~/.kube/config` to get the Kubeconfig and then access via `k9s` or `kubectl`.

## Shoulders of Giants

As you can see this setup uses the [`kube-hetzner/kube-hetzner/hcloud`](https://github.com/mysticaltech/terraform-hcloud-kube-hetzner) Terraform module to bootstrap everything.

So if you want to explore more options then simply head over the repo and feel free to discover other parts of the module.

## Why GCP for Terraform state?

Object Storage on Hetzner has a base price of around €6 a month.

GCP Object Storage cost is close to zero for the use case here.

GCP Object Storage also has native locking support.

# Getting Started

## On Google Cloud

### Create the bucket

```
gcloud storage buckets create gs://state-hetznetes --location=us-east1 --uniform-bucket-level-access
```

### Create the Workload Federation for this repository

```
gcloud iam workload-identity-pools providers create-oidc hetznetes \
  --workload-identity-pool=github \
  --project=donnie-in \
  --location=global \
  --display-name="hetznetes" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='Donnie/hetznetes' && assertion.actor=='Donnie'"
```

### Allow it full rights on the bucket

```
gcloud storage buckets add-iam-policy-binding gs://state-hetznetes \
   --member="principalSet://iam.googleapis.com/projects/667036752995/locations/global/workloadIdentityPools/github/attribute.repository/Donnie/hetznetes" \
   --role="roles/storage.admin"
```

_If you are new to OIDC setup between GCP and Github, watch this [video](https://www.youtube.com/watch?v=ZgVhU5qvK1M)._

## On Github

Visit Repo > Settings > Actions secrets and variables

### Add these variables

#### Add the `STATE_BUCKET_NAME`

Name of the bucket you created above.

#### Add the `GCP_PROJECT_ID`

Name of the GCP Project

#### Add the `GCP_WIF`

Workflow federation ID generated above.

### Add these secrets

#### Add the `HET_TOK`

This is the API Token issued by Hetzner.

Create a project in your Hetzner Cloud Console, and go to Security > API Tokens of that project to grab the API key, it needs to be Read & Write. Take note of the key! ✅

#### Add the `SSH_PUB` and the `SSH_PVT`

Generate a Key Pair, this would be used by Terraform to communicate with your VMs.

## Run the Github Workflows

### Run State Bucket Check

A simple check to make sure you have read and write perms on the GCP Object Storage

### Run Packer Build

Packer creates the necessary MicroOS Distro Snapshot, to be used on the VMs.

### Run Terraform Plan and Apply

Finally run the Terraform workflow. You may run it multiple times if the process breaks in between.
