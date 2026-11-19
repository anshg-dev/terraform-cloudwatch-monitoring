terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "ci_test" {
  filename = "${path.module}/ci-test.txt"
  content  = "Terraform CI pipeline executed successfully"
}
