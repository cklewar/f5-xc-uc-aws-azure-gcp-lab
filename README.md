# F5-XC-AWS-AZURE-GCP-LAB

This repository consists of Terraform templates to bring up a F5XC AWS Azure GCP Lab environment.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-uc-aws-azure-lab`
- Enter repository directory with: `cd f5-xc-uc-aws-azure-lab`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Rename file __variables.tf.example__ to __variable.tf__ with: `rename variables.tf.example variable.tf`
- Rename file __apps.tf.example__ to __variable.tf__ with: `rename apps.tf.example apps.tf`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

### Example Output

Example output of a deployment with 2 Azure and 2 AWS sites.

```bash
aws-site-2a = {
  "aws_subnet_id" = {
    "0" = "subnet-03842c97783c95587"
    "1" = "subnet-0c16e8fcc7f939e69"
    "2" = "subnet-0729c64b5e913693c"
  }
  "aws_vpc_id" = "vpc-06bdd68a987e3ff8e"
  "aws_workload_private_ip" = "10.64.18.128"
  "aws_workload_public_ip" = "13.49.245.152"
  "sli_private_ip" = "10.64.17.196"
  "slo_private_ip" = "10.64.16.45"
  "slo_public_ip" = "13.50.54.218"
}
aws-site-2b = {
  "aws_subnet_id" = {
    "0" = "subnet-0598ad6bc5a237b98"
    "1" = "subnet-03c3d31fc0f3e122b"
    "2" = "subnet-002de36c46fb9b461"
  }
  "aws_vpc_id" = "vpc-0e3fddb15cc323b47"
  "aws_workload_private_ip" = "10.64.18.217"
  "aws_workload_public_ip" = "18.236.155.238"
  "sli_private_ip" = "10.64.17.26"
  "slo_private_ip" = "10.64.16.229"
  "slo_public_ip" = "44.225.20.121"
}
azure-site-1a = {
  "azure_vnet" = {
    "address_space" = "10.64.16.0/22"
    "name" = "lab-azure-1a"
  }
  "inside_subnet" = {
    "address_prefix" = "10.64.17.0/24"
    "name" = "lab-azure-1a-inside"
  }
  "outside_subnet" = {
    "address_prefix" = "10.64.16.0/24"
    "name" = "lab-azure-1a-outside"
  }
  "resource_group_location" = "westus2"
  "resource_group_name" = "lab-azure-1a"
  "sli_private_ip" = "10.64.17.6"
  "slo_private_ip" = "10.64.16.5"
  "slo_public_ip" = "20.98.105.131"
  "workload" = {
    "private_ip" = "10.64.17.4"
    "public_ip" = "20.115.217.202"
  }
}
azure-site-1b = {
  "azure_vnet" = {
    "address_space" = "10.64.16.0/22"
    "name" = "lab-azure-1b"
  }
  "inside_subnet" = {
    "address_prefix" = "10.64.17.0/24"
    "name" = "lab-azure-1b-inside"
  }
  "outside_subnet" = {
    "address_prefix" = "10.64.16.0/24"
    "name" = "lab-azure-1b-outside"
  }
  "resource_group_location" = "westus2"
  "resource_group_name" = "lab-azure-1b"
  "sli_private_ip" = "10.64.17.6"
  "slo_private_ip" = "10.64.16.5"
  "slo_public_ip" = "20.51.121.61"
  "workload" = {
    "private_ip" = "10.64.17.4"
    "public_ip" = "52.247.227.60"
  }
}
gcp-site-3a = {
  "site" = <<-EOT
  gcp_object_name = v4geegl1zr
  instance_names = [
    "lab-gcp-3a-grf5",
  ]
  master_private_ip_address = {
    "lab-gcp-3a-grf5" = "10.64.16.2"
  }
  master_public_ip_address = {
    "lab-gcp-3a-grf5" = "34.65.157.172"
  }
  
  EOT
  "workload" = {
    "private_ip" = "10.64.17.2"
    "public_ip" = "34.65.108.180"
  }
}
gcp-site-3b = {
  "site" = <<-EOT
  gcp_object_name = 
  instance_names = [
    "lab-gcp-3b-b4t0",
  ]
  master_private_ip_address = {
    "lab-gcp-3b-b4t0" = "10.64.16.2"
  }
  master_public_ip_address = {
    "lab-gcp-3b-b4t0" = "34.65.232.12"
  }
  
  EOT
  "workload" = {
    "private_ip" = "10.64.17.2"
    "public_ip" = "34.65.188.215"
  }
}
```

## AWS - Azure Lab usage example

````hcl
````

Access to workload instances via tailscale:

```bash
$ tailscale status|grep lab
100.66.170.187  lab-aws-2a-workload user@      linux   -
100.119.43.182  lab-aws-2b-workload user@      linux   -
100.80.104.134  lab-azure-1a-workload user@    linux   -
100.94.28.162   lab-azure-1b-workload user@    linux   -
100.125.121.151 lab-gcp-3a-workload user@      linux   -
100.78.134.207  lab-gcp-3b-workload user@      linux   -
```

```bash
$ ssh ubuntu@lab-azure-1a-workload 
The authenticity of host 'lab-azure-1a-workload (100.80.104.134)' can't be established.
ED25519 key fingerprint is SHA256:jVhO0fqGt+m7s2GS5JPyFM94j7Cn/Gk4EQUTk64Op3g.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'lab-azure-1a-workload' (ED25519) to the list of known hosts.
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1086-azure x86_64)
ubuntu@lab-azure-1a:~$ 
```

Some useful commands:

* Grep for resource groups

```bash
az group list --output table | grep mw-
mw-azure-site1    westus2   Succeeded
```

* Delete resource group

```bash
az group delete --name mw-azure-site1
```

* Something destroy fails with

```bash
s/lab-azure-1b-outside]
module.azure-site-1b[0].module.outside_subnet.azurerm_subnet.sn: Still destroying... [id=/subscriptions/e9cbbd48-704d-4dfa-bf62-...zure-1b/subnets/lab-azure-1b-outside, 10s elapsed]
module.azure-site-1b[0].module.outside_subnet.azurerm_subnet.sn: Destruction complete after 11s
╷
│ Error: waiting for update of Network Interface: (Name "lab-azure-1b" / Resource Group "lab-azure-1b"): Code="OperationNotAllowed" Message="Operation 'startTenantUpdate' is not allowed on VM 'lab-azure-1b' since the VM is marked for deletion. You can only retry the Delete operation (or wait for an ongoing one to complete)." Details=[]
│ 
│ 
╵
╷
│ Error: removing Network Security Group Association from Subnet: (Name "lab-azure-1b-inside" / Virtual Network Name "lab-azure-1b" / Resource Group "lab-azure-1b"): network.SubnetsClient#CreateOrUpdate: Failure sending request: StatusCode=400 -- Original Error: Code="ReferencedResourceNotProvisioned" Message="Cannot proceed with operation because resource /subscriptions/e9cbbd48-704d-4dfa-bf62-60edda755a66/resourceGroups/lab-azure-1b/providers/Microsoft.Network/networkInterfaces/lab-azure-1b/ipConfigurations/internal used by resource /subscriptions/e9cbbd48-704d-4dfa-bf62-60edda755a66/resourceGroups/lab-azure-1b/providers/Microsoft.Network/virtualNetworks/lab-azure-1b/subnets/lab-azure-1b-inside is not in Succeeded state. Resource is in Failed state and the last operation that updated/is updating the resource is PutNicOperation." Details=[]
│ 
```

* Rerun destroy after a few minutes will succeed.

## Validation

```
$ ./validate.sh
lab-azure-1a-workload curl workload.site1 ... Short Name: lab-azure-1b good
lab-azure-1a-workload curl workload.site2 ... Short Name: ip-10-64-18-155 good
lab-azure-1a-workload curl workload.site3 ... Short Name: lab-gcp-3b good
lab-azure-1b-workload curl workload.site1 ... Short Name: lab-azure-1b good
lab-azure-1b-workload curl workload.site2 ... Short Name: ip-10-64-18-155 good
lab-azure-1b-workload curl workload.site3 ... Short Name: lab-gcp-3a good
lab-aws-2a-workload curl workload.site1 ... Short Name: lab-azure-1a good
lab-aws-2a-workload curl workload.site2 ... Short Name: ip-10-64-18-241 good
lab-aws-2a-workload curl workload.site3 ... Short Name: lab-gcp-3b good
lab-aws-2b-workload curl workload.site1 ... Short Name: lab-azure-1a good
lab-aws-2b-workload curl workload.site2 ... Short Name: ip-10-64-18-155 good
lab-aws-2b-workload curl workload.site3 ... Short Name: lab-gcp-3b good
lab-gcp-3a-workload curl workload.site1 ... Short Name: lab-azure-1a good
lab-gcp-3a-workload curl workload.site2 ... Short Name: ip-10-64-18-155 good
lab-gcp-3a-workload curl workload.site3 ... Short Name: lab-gcp-3b good
lab-gcp-3b-workload curl workload.site1 ... Short Name: lab-azure-1b good
lab-gcp-3b-workload curl workload.site2 ... Short Name: ip-10-64-18-155 good
lab-gcp-3b-workload curl workload.site3 ... Short Name: lab-gcp-3b good
```

