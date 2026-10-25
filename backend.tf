terraform {
    backend "s3" {
        bucket = "cob-tfstate-bucket"
        key = "cobroot/terraform.tfstate"
        region = "eu-north-1"
        use_lockfile = "true"
    }
}