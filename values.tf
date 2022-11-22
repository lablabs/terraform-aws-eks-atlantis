locals {
  values_default = yamlencode({
    # add non-sensitive default values here
    "serviceAccount" : {
      "create" : var.service_account_create
      "name" : var.service_account_name
      "annotations" : {
        "eks.amazonaws.com/role-arn" : local.irsa_role_create ? aws_iam_role.this[0].arn : var.irsa_role_arn
      }
    }
  })
  values_aws_profiles = yamlencode({
    "aws" : {
      "config" : templatefile("${path.module}/templates/.aws/config", {
        override_default_irsa_profile = var.atlantis_override_default_aws_profile
        role_arn                      = local.irsa_role_create ? aws_iam_role.this[0].arn : var.irsa_role_arn
        profiles                      = var.atlantis_aws_profiles
      })
    }
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    var.atlantis_enable_aws_profiles ? local.values_aws_profiles : "",
    var.values
  ])
}
