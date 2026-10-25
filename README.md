# terraform-azure-aks-platform

![terraform](https://github.com/seunnuga93/terraform-azure-aks-platform/actions/workflows/terraform.yml/badge.svg)

Terraform for a small, production-shaped AKS platform on Azure: networking, an AKS cluster,
a container registry and Key Vault, split into reusable modules with separate `dev` and `prod`
environments and a CI pipeline that lints, security-scans and plans every change.

## Architecture

```
                   ┌──────────────────────── rg-platform-<env> ───────────────────────┐
                   │                                                                  │
 GitHub Actions ──►│  VNet 10.x.0.0/16                                                │
  (OIDC, no        │   └─ snet-aks ──► AKS (system pool, autoscaling, Azure CNI)       │
   secrets)        │                    │  ├─ Azure RBAC + workload identity           │
                   │                    │  ├─ Azure Policy add-on                       │
                   │                    │  └─ Container Insights ──► Log Analytics      │
                   │                    │                                               │
                   │                    ├──AcrPull (managed identity)──► ACR            │
                   │                    └──CSI secrets driver──────────► Key Vault      │
                   └──────────────────────────────────────────────────────────────────┘
 Remote state: Azure Storage (versioned, AAD auth, no shared keys)
```

## Layout

```
modules/
  network/    VNet, AKS subnet, NSG
  aks/        AKS cluster + Log Analytics workspace
  acr/        Container registry + AcrPull role assignments
  keyvault/   RBAC-mode Key Vault with firewall
environments/
  dev/        Free tier, 1-2 small nodes
  prod/       Standard (SLA) tier, 2-5 nodes, purge protection on
scripts/
  bootstrap-state.sh   one-off creation of the state storage account
```

## Design decisions

| Decision | Why |
| --- | --- |
| Managed identities everywhere, `local_account_disabled = true` | No static kubeconfig admin credentials or registry passwords to leak. |
| Azure RBAC for Kubernetes authorization | Cluster access is managed in Entra ID alongside everything else. |
| Workload identity + OIDC issuer | Pods get Azure access without secrets mounted in the cluster. |
| Authorized IP ranges instead of a private cluster | Keeps the API locked down without needing a VPN/jump box. Trade-off noted in `.checkov.yaml`. |
| Ephemeral OS disks (`D*ds_v5` sizes) | Faster node reimage/scale-out and no managed-disk cost. |
| `patch` upgrade channel | Picks up security patches automatically without surprise minor version jumps. |
| Same modules, different `tfvars` per env | Dev and prod can't drift structurally, only in size. |

Security checks that were consciously skipped (mostly Premium SKU or private networking features)
are listed with reasons in [`.checkov.yaml`](.checkov.yaml).

## Usage

Prerequisites: Azure CLI, Terraform >= 1.6, an Azure subscription.

```bash
az login
./scripts/bootstrap-state.sh               # prints the storage account name
# put that name in environments/*/providers.tf
# set allowed_ip_ranges in environments/<env>/terraform.tfvars to your public IP

cd environments/dev
terraform init
terraform plan -out tfplan
terraform apply tfplan

az aks get-credentials -g rg-platform-dev -n aks-platform-dev
kubectl get nodes
```

Tear down with `terraform destroy`. The dev environment costs roughly the price of one
`Standard_D2ds_v5` VM plus Log Analytics ingestion while it is running.

## CI

`.github/workflows/terraform.yml` runs on every pull request:

1. `terraform fmt -check` and `terraform validate` for both environments
2. `tflint` with the recommended ruleset
3. `checkov` security scan
4. `terraform plan` per environment. This only runs once a federated credential is set up, by adding
   repository variables `AZURE_CLIENT_ID`, `AZURE_TENANT_ID` and `AZURE_SUBSCRIPTION_ID`
   ([guide](https://learn.microsoft.com/azure/developer/github/connect-from-azure-openid-connect)).
