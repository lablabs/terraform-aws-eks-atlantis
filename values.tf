locals {
  values_default = yamlencode({
    "atlantisUrl" : var.atlantis_url
    "orgAllowlist" : join(",", var.atlantis_org_allowlist)
    "serviceAccount" : var.service_account_create ? {
      "create" : var.service_account_create
      "name" : var.service_account_name
      "annotations" : {
        "eks.amazonaws.com/role-arn" : local.irsa_role_arn
      }
    } : null
    "aws" : {
      "config" : var.atlantis_enable_aws_profiles ? templatefile("${path.module}/templates/.aws/config", {
        override_default_irsa_profile = var.atlantis_override_default_aws_profile
        role_arn                      = local.irsa_role_arn
        profiles                      = var.atlantis_aws_profiles
      }) : null
    }
    "replicaCount" : var.atlantis_replica_count
    "nodeSelector" : var.atlantis_node_selector
    "tolerations" : var.atlantis_tolerations
    "affinity" : var.atlantis_affinity
    # add non-sensitive default values here
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    var.values
  ])
}

