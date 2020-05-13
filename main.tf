
data "packet_project" "this" {
  name = var.project_name
}

resource "packet_project_ssh_key" "this" {
  name       = var.name
  public_key = var.public_key
  project_id = data.packet_project.this.id
}

resource "packet_device" "this" {
  hostname         = var.name
  plan             = var.machine_type
  facilities       = [var.location]
  operating_system = "ubuntu_18_04"
  billing_cycle    = "hourly"
  project_id       = data.packet_project.this.id

  project_ssh_key_ids = [packet_project_ssh_key.this.id]

  tags = var.tags
}

module "ansible" {
  source           = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.10.0"
  create           = var.create
  ip               = join("", packet_device.this.*.access_public_ipv4)
  user             = "ubuntu"
  private_key_path = var.private_key_path

  playbook_file_path = "${path.module}/ansible/main.yml"
  playbook_vars = merge({
    keystore_path     = var.keystore_path,
    keystore_password = var.keystore_password,
    network_name      = var.network_name,
    main_ip           = split("/", data.packet_precreated_ip_block.this.cidr_notation)[0],
    dhcp_ip           = join("", packet_device.this.*.access_public_ipv4),
    ansible_hardening = var.ansible_hardening
  }, var.playbook_vars)

  requirements_file_path = "${path.module}/ansible/requirements.yml"
}

data "packet_precreated_ip_block" "this" {
  global         = true
  project_id     = data.packet_project.this.id
  address_family = 4
  public         = true
}

resource "packet_ip_attachment" "this" {
  count = var.associate_eip && var.create ? 1 : 0

  device_id     = packet_device.this.id
  cidr_notation = join("/", [cidrhost(data.packet_precreated_ip_block.this.cidr_notation, 0), "32"])
  depends_on    = [module.ansible]
}

module "ansible_service_start" {
  source = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.12.0"
  create = var.create

  ip               = join("", split("/", packet_ip_attachment.this.cidr_notation)[0])
  user             = "ubuntu"
  private_key_path = var.private_key_path

  tags = "service-start"

  playbook_file_path = "${path.module}/ansible/main.yml"

  module_depends_on = [join("", packet_ip_attachment.this.*.id), module.ansible.ip]
}