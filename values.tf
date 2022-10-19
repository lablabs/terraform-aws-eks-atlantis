locals {
  values_default = yamlencode({
    "serviceAccount" : {
      "name" : var.service_account_name
      "annotations" : {
        "eks.amazonaws.com/role-arn" : local.irsa_role_arn
      }
    }
    "aws" : {
      "config": templatefile("${path.module}/templates/.aws/config", {
        override_default_irsa_profile = var.atlantis_override_irsa_aws_profile
        role_arn                      = local.irsa_role_arn
        profiles                      = var.aws_profiles
      })
    }
    # add default values here
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    var.values
  ])
}
