terraform {
  required_version = ">= 0.13"

	required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

provider "random" {
  alias     = "one"
	# some parameters, base path for example like in FS provider
	# or region
	#   base_path = "test1" 
	#   region = us-east-9
}

provider "random" {
  alias     = "two"
	# some parameters, base path for example like in FS provider
	# or region (potentially different set of access rules )
	#   base_path = "test1" 
	#   region = us-west-12
}
