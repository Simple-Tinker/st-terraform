provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "cluster1/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "public"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}
See the sidebar for usage information on all of the resources, which will have examples specific to their own use cases.

Argument Reference
The following arguments are used to configure the VMware vSphere Provider:

user - (Required) This is the username for vSphere API operations. Can also be specified with the VSPHERE_USER environment variable.
password - (Required) This is the password for vSphere API operations. Can also be specified with the VSPHERE_PASSWORD environment variable.
vsphere_server - (Required) This is the vCenter server name for vSphere API operations. Can also be specified with the VSPHERE_SERVER environment variable.
allow_unverified_ssl - (Optional) Boolean that can be set to true to disable SSL certificate verification. This should be used with care as it could allow an attacker to intercept your auth token. If omitted, default value is false. Can also be specified with the VSPHERE_ALLOW_UNVERIFIED_SSL environment variable.
vim_keep_alive - (Optional) Keep alive interval in minutes for the VIM session. Standard session timeout in vSphere is 30 minutes. This defaults to 10 minutes to ensure that operations that take a longer than 30 minutes without API interaction do not result in a session timeout. Can also be specified with the VSPHERE_VIM_KEEP_ALIVE environment variable.
api_timeout - (Optional) Sets the number of minutes to wait for operations to complete. The default timeout is 5 minutes. Currently it will override the timeout for all VM creation operations.
