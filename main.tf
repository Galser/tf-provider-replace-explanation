# git@github.com:Galser/tf-provider-replace-explanation.git
resource "random_pet" "animal" {
  provider = random.two
}


resource "null_resource" "animal-echo" {

  provisioner "local-exec" {
    command = "echo ${random_pet.animal.id}"
  }
}
