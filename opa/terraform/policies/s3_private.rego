# policies/s3_private.rego
package terraform.aws.s3

deny[msg] {
  bucket := input.planned_values.root_module.resources[_]
  bucket.type == "aws_s3_bucket"
  bucket.values.acl == "public-read"
  msg := sprintf("Bucket S3 '%s' não pode ser público (ACL: public-read)", [bucket.values.bucket])
}