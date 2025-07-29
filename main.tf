/**
 * # AWS EKS Universal Addon Terraform module
 *
 * A Terraform module to deploy the universal addon on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name = "atlantis"

    helm_chart_version = "5.18.0"
    helm_repo_url      = "https://runatlantis.github.io/helm-charts"
  }

  # FIXME config: add addon IRSA configuration here or remove if not needed
  addon_irsa = {
    (local.addon.name) = {
      # FIXME config: add default IRSA overrides here or leave empty if not needed, but make sure to keep at least one key

    }
  }

  # FIXME config: add addon OIDC configuration here or remove if not needed
  addon_oidc = {
    (local.addon.name) = {
      # FIXME config: add default OIDC overrides here or leave empty if not needed, but make sure to keep at least one key
    }
  }

  addon_values = yamlencode({
    # FIXME config: add default values here or leave empty if not needed
    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
   aws = {
      config = templatefile("${path.module}/templates/.aws/config", {
        override_default_irsa_profile = var.atlantis_override_default_aws_profile
        role_arn                      = local.irsa_role_create ? aws_iam_role.this[0].arn : var.irsa_role_arn
        profiles                      = var.atlantis_aws_profiles
      })
    }
  })

  addon_depends_on = [
    # FIXME config: add dependencies here, i.e. CRDs, or leave empty if not needed
  ]
}
