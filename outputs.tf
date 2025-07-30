output "iam_role_attributes" {
  description = "Atlantis IAM role attributes"
  value       = module.addon-irsa["atlantis"].iam_role_attributes # Using local.addon.name causing loop in terraform
}
