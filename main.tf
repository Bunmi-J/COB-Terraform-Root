terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

locals {
  resource_name = "${var.project_name}-${var.environment}"
}



module "cob_iam" {
  source = "../modules/iam"

  project_name              = "cob-project"
  environment               = "dev"
  resource_name             = local.resource_name
  cob_glue_name             = "cob-glue"
  glue_role_arn             = module.cob_iam.glue_role_arn
  source_bucket_name        = module.cob_storage.s3_bucket_name
  query_results_bucket_name = module.cob_athena.query_results_bucket_name
  username                  = "cob_data_engineer"
  athena_user               = var.athena_user
  allowed_principal_arns    = var.athena_user
  #"arn:aws:iam::469935552963:user/Developer-BJ"
  #"arn:aws:iam::<account-id>:user/bunmi",
  #"arn:aws:iam::<account-id>:role/data-engineer",



}

module "cob_storage" {
  source = "../modules/s3"

  project_name         = "cob-project"
  environment          = "dev"
  bucket_name          = "cob-s3"
  lifecycle_prefix     = "log"
  versioning_enabled   = true
  enable_lifecycle     = true
  enable_object_upload = true
  object_key           = "cob/test-object"
  object_source        = "${path.root}/files/test-object.txt"
  consumer_name        = "data-engineering"

}


 module "cob_glue" {
  source = "../modules/glue"

  cob-crawler_name      = "cob_crawler"
  catalog_database_name = "cob_catalog_database"
  catalog_table_name    = "cob_catalog_table"
  #catalog_name = "cob_catalog"
  #cob_glue_name = "cob-glue"
  glue_role_arn  = module.cob_iam.glue_role_arn
  s3_bucket_name = module.cob_storage.s3_bucket_name


}

module "cob_athena" {
  source              = "../modules/athena"

  athena_data_catalog = "cob_athena_catalog"
  #bucket_id  = module.cob_storage.s3-ids
  #athena_database_name = module.cob_glue.catalog_database_name
  consumer_name = "Data_Engineering"
  project_name  = "cob-project"
  environment   = "dev"
}