output "iam_role_attributes_arn" {
  description = "Atlantis IAM role attributes"
  value       = module.addon-irsa["atlantis"].iam_role_attributes.arn # Using local.addon.name causing loop in terraform
}
