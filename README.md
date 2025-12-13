# What is this?

## Why GCP for state?

Object Storage on Hetzner has a base price of around €6 a month.

GCP Object Storage cost is negligible for the use case here.

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

### Allow it storage.Admin on the state bucket

```
gcloud storage buckets add-iam-policy-binding gs://state-hetznetes --member="principalSet://iam.googleapis.com/projects/667036752995/locations/global/workloadIdentityPools/github/attribute.repository/Donnie/hetznetes" --role="roles/storage.admin"
```

_If you are new to OIDC setup between GCP and Github, watch this [video](https://www.youtube.com/watch?v=ZgVhU5qvK1M)._

## On Github

Visit Repo > Settings > Actions secrets and variables

Add these variables
- Add the STATE_BUCKET_NAME
- Add the GCP_PROJECT_ID
- Add the GCP_WIF
