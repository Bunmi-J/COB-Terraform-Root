

output "s3-ids" {
  description = "ARN for the cob s3"
  value       = module.cob_storage.s3-ids
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.cob_storage.s3_bucket_name
}

output "s3-object-arn" {
  description = "ARN for the cob s3 object"
  value       = module.cob_storage.s3-object-arn
}

output "s3-version" {
  description = "version for the cob s3 bucket"
  value       = module.cob_storage.s3-version
}

output "glue_role_arn" {
  description = "Amazon resource name of the glue role"
  value       = module.cob_iam.glue_role_arn
}

output "catalog_database_name" {
  description = "Name of the catalog database name"
  value       = module.cob_glue.catalog_database_name
}


output "query_results_bucket_name" {
  description = "S3 bucket used for Athena query results"
  value       = module.cob_athena.query_results_bucket_name
}