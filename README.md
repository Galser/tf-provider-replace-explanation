# tf-provider-replace-explanation

Demo for the explanation of provider/alias replacement "issue"

# Initial assumption.

For the resource with Terraform code if the provider used is aliased and one replaced with another during run it can fail.

Reported here at first: https://github.com/terraform-provider-openstack/terraform-provider-openstack/issues/1322


## One of the proposed tests

Later reproduced for custom provider had been proposed here: https://github.com/ya-isakov/terraform-fs-test/blob/main/main.tf with the following subject: 

1) Clone https://github.com/ya-isakov/terraform-fs-test
2) `terraform apply` (should create file.text in test1 dir)
3) Change provider in main.tf from fs.one to fs.two
4) `terraform plan`

Last step should fail with following error:
filesystem_file_writer.example: Refreshing state... [id=test1/file.text]
╷
│ Error: failed to open: open test2/file.text: no such file or directory
│
│ with filesystem_file_writer.example,
│ on main.tf line 1, in resource "filesystem_file_writer" "example":
│ 1: resource "filesystem_file_writer" "example" {
│


# Testing

Provided the following [versions.tf](versions.tf) constrainsts and providers defined : 

```Terraform
terraform {
  required_version = ">= 0.13"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "random" {
  alias = "one"
  # some parameters, base path for example like in FS provider
  # or region
  #   base_path = "test1" 
  #   region = us-east-9
}

provider "random" {
  alias = "two"
  # some parameters, base path for example like in FS provider
  # or region (potentially different set of access rules )
  #   base_path = "test2" 
  #   region = us-west-12
}

```

And the following [main.tf code](main.tf) : 
```Terraform

# git@github.com:Galser/tf-provider-replace-explanation.git
resource "random_pet" "animal" {
  provider = random.one
}


resource "null_resource" "animal-echo" {

  provisioner "local-exec" {
    command = "echo ${random_pet.animal.id}"
  }
}

```

Let's run `terraform init` . 

Output as follows :  

- init : 

```Terraform
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/null versions matching "3.1.0"...
- Finding hashicorp/random versions matching "3.1.0"...
- Installing hashicorp/null v3.1.0...
- Installed hashicorp/null v3.1.0 (signed by HashiCorp)
- Installing hashicorp/random v3.1.0...
- Installed hashicorp/random v3.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```


- lock file had been createrd with content : 

```HCL
cat .terraform.lock.hcl
# This file is maintained automatically by "terraform init".
# Manual edits may be lost in future updates.

provider "registry.terraform.io/hashicorp/null" {
  version     = "3.1.0"
  constraints = "3.1.0"
  hashes = [
    "h1:xhbHC6in3nQryvTQBWKxebi3inG5OCgHgc4fRxL0ymc=",
    "zh:02a1675fd8de126a00460942aaae242e65ca3380b5bb192e8773ef3da9073fd2",
    "zh:53e30545ff8926a8e30ad30648991ca8b93b6fa496272cd23b26763c8ee84515",
    "zh:5f9200bf708913621d0f6514179d89700e9aa3097c77dac730e8ba6e5901d521",
    "zh:9ebf4d9704faba06b3ec7242c773c0fbfe12d62db7d00356d4f55385fc69bfb2",
    "zh:a6576c81adc70326e4e1c999c04ad9ca37113a6e925aefab4765e5a5198efa7e",
    "zh:a8a42d13346347aff6c63a37cda9b2c6aa5cc384a55b2fe6d6adfa390e609c53",
    "zh:c797744d08a5307d50210e0454f91ca4d1c7621c68740441cf4579390452321d",
    "zh:cecb6a304046df34c11229f20a80b24b1603960b794d68361a67c5efe58e62b8",
    "zh:e1371aa1e502000d9974cfaff5be4cfa02f47b17400005a16f14d2ef30dc2a70",
    "zh:fc39cc1fe71234a0b0369d5c5c7f876c71b956d23d7d6f518289737a001ba69b",
    "zh:fea4227271ebf7d9e2b61b89ce2328c7262acd9fd190e1fd6d15a591abfa848e",
  ]
}

provider "registry.terraform.io/hashicorp/random" {
  version     = "3.1.0"
  constraints = "3.1.0"
  hashes = [
    "h1:rKYu5ZUbXwrLG1w81k7H3nce/Ys6yAxXhWcbtk36HjY=",
    "zh:2bbb3339f0643b5daa07480ef4397bd23a79963cc364cdfbb4e86354cb7725bc",
    "zh:3cd456047805bf639fbf2c761b1848880ea703a054f76db51852008b11008626",
    "zh:4f251b0eda5bb5e3dc26ea4400dba200018213654b69b4a5f96abee815b4f5ff",
    "zh:7011332745ea061e517fe1319bd6c75054a314155cb2c1199a5b01fe1889a7e2",
    "zh:738ed82858317ccc246691c8b85995bc125ac3b4143043219bd0437adc56c992",
    "zh:7dbe52fac7bb21227acd7529b487511c91f4107db9cc4414f50d04ffc3cab427",
    "zh:a3a9251fb15f93e4cfc1789800fc2d7414bbc18944ad4c5c98f466e6477c42bc",
    "zh:a543ec1a3a8c20635cf374110bd2f87c07374cf2c50617eee2c669b3ceeeaa9f",
    "zh:d9ab41d556a48bd7059f0810cf020500635bfc696c9fc3adab5ea8915c1d886b",
    "zh:d9e13427a7d011dbd654e591b0337e6074eef8c3b9bb11b2e39eaaf257044fd7",
    "zh:f7605bd1437752114baf601bdf6931debe6dc6bfe3006eb7e9bb9080931dca8a",
  ]
}
```

- NO STATE file present yet, here is output of folder listing : 


```Bash
 ls -la
total 48
drwxr-xr-x   10 andrii  staff   320 Jan 17 14:33 .
drwxr-xr-x  168 andrii  staff  5376 Jan 17 14:23 ..
drwxr-xr-x   10 andrii  staff   320 Jan 17 14:34 .git
-rw-r--r--    1 andrii  staff   716 Jan 17 14:23 .gitignore
drwxr-xr-x    3 andrii  staff    96 Jan 17 14:33 .terraform
-rw-r--r--    1 andrii  staff  2105 Jan 17 14:33 .terraform.lock.hcl
-rw-r--r--    1 andrii  staff  1074 Jan 17 14:23 LICENSE
-rw-r--r--    1 andrii  staff    96 Jan 17 14:23 README.md
-rw-r--r--    1 andrii  staff   298 Jan 17 14:33 main.tf
```

# First, normal `terraform apply` to create resources


```Terraform
terraform apply --auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with
the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.animal-echo will be created
  + resource "null_resource" "animal-echo" {
      + id = (known after apply)
    }

  # random_pet.animal will be created
  + resource "random_pet" "animal" {
      + id        = (known after apply)
      + length    = 2
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
random_pet.animal: Creating...
random_pet.animal: Creation complete after 0s [id=beloved-humpback]
null_resource.animal-echo: Creating...
null_resource.animal-echo: Provisioning with 'local-exec'...
null_resource.animal-echo (local-exec): Executing: ["/bin/sh" "-c" "echo beloved-humpback"]
null_resource.animal-echo (local-exec): beloved-humpback
null_resource.animal-echo: Creation complete after 0s [id=132494255143995112]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```


We have a state file created that is carrying our testing resource : 

```
...
      "type": "random_pet",
      "name": "animal",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"].one",
...
```

And the provider `random.one` clearly can be seen in it.
 
More details including full state content here : [Terrafrom first apply run](tf_1st_apply.md)

# Hypothesis test, `apply` for modified code

- Let's change code in [main.tf code](main.tf) to replace provider alias with the new one :

```Terraform
# git@github.com:Galser/tf-provider-replace-explanation.git
resource "random_pet" "animal" {
  provider = random.two ## <--- this line had been changed
}


resource "null_resource" "animal-echo" {

  provisioner "local-exec" {
    command = "echo ${random_pet.animal.id}"
  }
}

```

- Running `terraform apply` **with and without auto-approve** producing the following output :

```Terraform
terraform apply --auto-approve
random_pet.animal: Refreshing state... [id=beloved-humpback]
null_resource.animal-echo: Refreshing state... [id=132494255143995112]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes
are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```


State file had changed on-disk, and can be found in [this detailed apply log](tf_2nd_apply.md) 

## Detailed, step-by-step analysis of the 2-nd run with TRACE enabled :


Providers and references in the order of time evnets :

```Terraform
2022-01-17T14:47:57.469+0100 [DEBUG] ReferenceTransformer: "provider[\"registry.terraform.io/hashicorp/random\"].two" references: []
2022-01-17T14:47:57.469+0100 [DEBUG] ReferenceTransformer: "random_pet.animal" references: []
2022-01-17T14:47:57.469+0100 [DEBUG] ReferenceTransformer: "null_resource.animal-echo" references: [random_pet.animal]
2022-01-17T14:47:57.469+0100 [DEBUG] ReferenceTransformer: "provider[\"registry.terraform.io/hashicorp/null\"]" references: []
```

E.g. provider `random.two` - don't have resources yet, as the statefile have them written belonging to `random.one` -> 

```JSON
...
      "type": "random_pet",
      "name": "animal",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"].one",
      "instances": [
        {
...        	
```

Now TF is reading code : 

```Terraform
2022-01-17T14:47:57.770+0100 [TRACE] ProviderTransformer: exact match for provider["registry.terraform.io/hashicorp/random"].two serving random_pet.animal (expand)
2022-01-17T14:47:57.770+0100 [DEBUG] ProviderTransformer: "random_pet.animal (expand)" (*terraform.nodeExpandPlannableResource) needs provider["registry.terraform.io/hashicorp/random"].two
2022-01-17T14:47:57.770+0100 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.ProviderTransformer with new graph:
```

And replacing part for that resource with new graph : 

```Terraform
  null_resource.animal-echo (expand) - *terraform.nodeExpandPlannableResource
    provider["registry.terraform.io/hashicorp/null"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/null"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/random"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/random"].one - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/random"].two - *terraform.NodeApplyableProvider
  random_pet.animal (expand) - *terraform.nodeExpandPlannableResource
    provider["registry.terraform.io/hashicorp/random"].two - *terraform.NodeApplyableProvider
```    

An after apply had finished, the state file contains : 

```JSON
      "type": "random_pet",
      "name": "animal",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"].two",
```

And the state file "serial" has changed to "4" even though no real changes had happened to the infrastructure, but instead, one of the providers had been replaced.


As such - the initial assumption is not confirmed, no error is produced with `random` provider. Going to check the repository provided earlier for that `fs` provider


# TODO

- [X] make inital code
- [X] test one standart HashiCorp providers
- [ ] test example provided by 3-rd party - community provider with parameters

