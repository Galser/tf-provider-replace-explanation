# git@github.com:Galser/tf-provider-replace-explanation.git
resource "random_pet" "animal" {
  provider = random.one
}


resource "null_resource" "animal-echo" {
  
	#	triggers = {
	#    always_run = timestamp()
	#  }
  provisioner "local-exec" {
    command = "echo ${random_pet.animal.id}"
  }
}
