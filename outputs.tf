output "hostname" {
  value = packet_device.this.hostname
}

output "access_public_ipv4" {
  value = packet_device.this.access_public_ipv4
}

output "access_private_ipv4" {
  value = packet_device.this.access_private_ipv4
}

output "created" {
  value = packet_device.this.created
}

output "public_ip" {
  value = packet_device.this.network[0].address
}

output "tags" {
  value = packet_device.this.tags
}

output "updated" {
  value = packet_device.this.updated
}

output "plan" {
  value = packet_device.this.plan
}

output "id" {
  value = packet_device.this.id
}

