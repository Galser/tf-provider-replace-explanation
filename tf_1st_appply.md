## First apply

```
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