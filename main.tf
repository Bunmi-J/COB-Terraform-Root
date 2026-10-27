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

  assume_role {
     role_arn = var.data_engineer_role_arn
   }
}



locals {
  resource_name = "${var.project_name}-${var.environment}"
}



module "cob_iam" {
  #source = "../modules/iam"
  source = "git::https://github.com/Bunmi-J/COB-Modules.git//iam?ref=v1.0.3"

  project_name = "cob-root-project"

  environment               = "dev"
  resource_name             = local.resource_name
  cob_glue_name             = "cob-glue"
  glue_role_arn             = module.cob_iam.glue_role_arn
  source_bucket_name        = module.cob_storage.s3_bucket_name
  query_results_bucket_name = module.cob_athena.query_results_bucket_name
  username                  = "cob_data_engineer"
  athena_user               = var.athena_user
  allowed_principal_arns    = var.athena_user




}

module "cob_storage" {
  #source = "../modules/s3"
  source = "git::https://github.com/Bunmi-J/COB-Modules.git//s3?ref=v1.0.3"

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
  #source = "../modules/glue"
  source = "git::https://github.com/Bunmi-J/COB-Modules.git//glue?ref=v1.0.3"

  cob-crawler_name      = "cob_crawler-root"
  catalog_database_name = "cob_catalog_database_root"
  catalog_table_name    = "cob_catalog_table_root"
  #catalog_name = "cob_catalog"
  #cob_glue_name = "cob-glue"
  glue_role_arn  = module.cob_iam.glue_role_arn
  s3_bucket_name = module.cob_storage.s3_bucket_name


}

module "cob_athena" {
  #source              = "../modules/athena"
  source = "git::https://github.com/Bunmi-J/COB-Modules.git//athena?ref=v1.0.3"

  athena_data_catalog = "cob_athena_catalog_root"
  #bucket_id  = module.cob_storage.s3-ids
  #athena_database_name = module.cob_glue.catalog_database_name
  consumer_name = "Data_Engineering"
  project_name  = "cob-root-project"
  environment   = "dev"
}