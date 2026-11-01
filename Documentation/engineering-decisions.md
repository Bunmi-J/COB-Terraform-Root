Document your engineering choices, trade-offs and lesson learned.

## Choices

The Platform Engineering team has delivered the first version of Internal Infrastructure Provisioning Platform (COB). COB platform has capabilities for networking and computing, object storage, RDS, Identity and Access, and Data platform services. 
Since COB provide reusable Terraform modules that other engineering teams can consume to provision standardised AWS infrastructure,  the Data Engineering team can use COB to build a small, reliable data platform.

Based on the assumption that data engineering team would need to expose data stored in S3 to analytics users, it is required to integrate AWS Glue Data Catalog, Amazon Athena, IAM role and policies to enable a reliable and secure data platform.

  - AWS Glue service is to automate Extract,Transform and Load (ETL) processes, making it simple and cost-effective to catagorize, clean, enrich and move data easily between data stores. AWS Glue uses crawler to discover data stored in s3 and other data sources. The crawler will index the data source,  register the data schema in data catalogue. Glue job then uses the information in the data catalog to read, clean and transformed the data. The transformed data is maintained and centrally avaialble in the data catalog which makes it easy to find and understand.  The transformed data can be loaded to a destination like s3 or datalakes where the data is readily available for analytics.

  - Amazon Athena is an analytic service that allows data analysts to run SQL directly on data stored in Amazon S3.

  - S3 stores data from different sources.

  - IAM role and policies are needed to authenticate and grant permissions to AWS resources like IAM role, S3, AWS Glue, Athena, github Action.


## Tradeoffs
- One of the tradeoffs is deciding on wheather to create IAM user access key and ID or set up OIDC token for Github Actions to assume role on AWS. The main tradeoff is security versus simplicity of initial setup.For OIDC the credntials are temporary while Access key and ID are long-lived unless disabled. Access keys present higher risks if exposed while OIDC is more secure no keys stored in secrets and variables on Github. OIDC credentials expire automatically while access keys remain valid until disabled or rotated.

- Another tradeoff is between branch based OIDC subject claim format (repo:<owner>/<repo>:ref:refs/heads/main) and environment based (repo:<owner>/<repo>:environment:<environment-name>
). Environment based format is more flexible and often better for Terraform workflows because it enhaces environment level security. Github environment allows required reviewers, required secrets, deployment protection rules,manual approvals and concurrency limits. Branch‑based OIDC cannot do this.


## Lesson Learned
- First and foremost, I have established a better understanding of how COB Internal Infrastruture can be consumed by implementing modules created in COB project to provision a data platform on AWS. 

- I have learnt to automate Terraform with Continuous Integration/Continous Delivery. I designed and implemented an automated workflow for infrastructure changes using Github Actions. Engineers do not need to run terraform command manually anymore to implement infrastructure changes. Github Actions workflow automate terraform init, format, validate, terraform plan, review, and terraform apply.
Automated Terraform pipeline: Formatting, validation, planning, review, and controlled application of infrastructure changes.