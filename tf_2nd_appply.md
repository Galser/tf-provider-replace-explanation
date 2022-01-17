## Terrafrom apply 2

```Terraform
terraform apply --auto-approve
random_pet.animal: Refreshing state... [id=beloved-humpback]
null_resource.animal-echo: Refreshing state... [id=132494255143995112]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes
are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```


### State


```JSON
cat terraform.tfstate
{
  "version": 4,
  "terraform_version": "1.0.7",
  "serial": 4,
  "lineage": "acb3aad2-a408-7789-d7d1-01b45358aa58",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "null_resource",
      "name": "animal-echo",
      "provider": "provider[\"registry.terraform.io/hashicorp/null\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "132494255143995112",
            "triggers": null
          },
          "sensitive_attributes": [],
          "private": "bnVsbA==",
          "dependencies": [
            "random_pet.animal"
          ]
        }
      ]
    },
    {
      "mode": "managed",
      "type": "random_pet",
      "name": "animal",
      "provider": "provider[\"registry.terraform.io/hashicorp/random\"].two",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "beloved-humpback",
            "keepers": null,
            "length": 2,
            "prefix": null,
            "separator": "-"
          },
          "sensitive_attributes": [],
          "private": "bnVsbA=="
        }
      ]
    }
  ]
}
```



