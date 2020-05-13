# terraform-icon-packet-prep

[![open-issues](https://img.shields.io/github/issues-raw/insight-icon/terraform-icon-packet-prep?style=for-the-badge)](https://github.com/insight-icon/terraform-icon-packet-prep/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-icon/terraform-icon-packet-prep?style=for-the-badge)](https://github.com/insight-icon/terraform-icon-packet-prep/pulls)
[![build-status](https://img.shields.io/circleci/build/github/insight-icon/terraform-icon-packet-prep?style=for-the-badge)](https://circleci.com/gh/insight-icon/terraform-icon-packet-prep)

## Features

This module provisions a P-Rep node on packet.com bare metal cloud for the icon blockchain with terraform

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
variable "public_key" {}
module "this" {
  source = "github.com/insight-icon/terraform-icon-packet-prep"
  project_name = "stuff"
  public_key   = var.public_key
}
```
## Examples

- [defaults](https://github.com/robc-io/terraform-icon-packet-prep/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| packet | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ansible\_hardening | Run hardening roles | `bool` | `false` | no |
| associate\_ip | Boolean to determine if you should associate the ip when the instance has been configured | `bool` | `true` | no |
| create | Bool to create | `bool` | `true` | no |
| keystore\_password | The password to the keystore | `string` | `""` | no |
| keystore\_path | The path to the keystore | `string` | `""` | no |
| location | Data centre location name | `string` | `"ewr1"` | no |
| machine\_type | Instance type | `string` | `"t1.small.x86"` | no |
| name | Name for resources (i.e. hostname) | `string` | `"w3f"` | no |
| network\_name | The network name, ie kusama / mainnet | `string` | `"testnet"` | no |
| playbook\_vars | Additional playbook vars | `map(string)` | `{}` | no |
| private\_key\_path | Path to the private ssh key | `string` | `""` | no |
| project\_name | Name of the project in Packet | `string` | n/a | yes |
| public\_key | The public key to use | `string` | n/a | yes |
| tags | List of tags for resources | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_private\_ipv4 | n/a |
| access\_public\_ipv4 | n/a |
| created | n/a |
| hostname | n/a |
| id | n/a |
| plan | n/a |
| public\_ip | n/a |
| tags | n/a |
| updated | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [insight-infrastructure](https://github.com/insight-infrastructure) and [insight-icon](https://github.com/insight-icon)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.