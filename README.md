# dataform-example-tf
This is a sample project for setting up infrastructure for the dataform example using terraform.

There are multiple terraform projects in this repository to enable setting up infrastructure.
1. source_infra - Used to provision the infrastructure for the source data in BigQuery and the IAM accounts required for dataform.
2. dataform - TODO

## Getting Started
1. Create a Google Cloud Storage Bucket to hold your terraform state (it's a really good idea to version this bucket)
2. Create a backend.conf file in the root of the cloned project with the details of your state bucket

### Example backend.conf
```hcl
bucket = "my-secret-terraform-state-bucket"
prefix = "terraform/state/dataform-example"
```


## source_infra

### Getting Started

1. Export your google cloud project id (e.g. `export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT"`)
2. Update the terraform.tfvars file if you want to make any changes
3. Create a terraform.tfvars file containing any variables you want to set
4. Run the commands below
```shell
cd source_infra
terraform init -backend-config=../backend.conf
terraform plan --var-file=terraform.tfvars
```

You can now run terraform apply to create the infrastructure if you wish: `terraform apply --var-file=terraform.tfvars`
