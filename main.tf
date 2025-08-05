/**
 * # AWS EKS Atlantis Terraform module
 *
 * A Terraform module to deploy [Atlantis](https://www.runatlantis.io) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-atlantis/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-atlantis/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-atlantis/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-atlantis/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name = "atlantis"

    helm_chart_version = "5.18.0"
    helm_repo_url      = "https://runatlantis.github.io/helm-charts"
  }

  addon_irsa = {
    (local.addon.name) = {}
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
    aws = var.atlantis_enable_aws_profiles ? {
      directory = var.atlantis_aws_directory
      config = templatefile("${path.module}/templates/.aws/config", {
        override_default_irsa_profile = var.atlantis_override_default_aws_profile
        role_arn                      = module.addon-irsa[local.addon.name].irsa_role_enabled ? module.addon-irsa[local.addon.name].iam_role_attributes.arn : ""
        profiles                      = var.atlantis_aws_profiles
      })
    } : {}
  })

  addon_depends_on = []
}
