provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "rocky-linux-qcow2" {
  name   = "rocky-linux-qcow2"
  pool   = "default"
  source = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-minimal.iso"
  format = "qcow2"
}

resource "libvirt_domain" "rocky-linux" {
  name   = "rocky-linux"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.common-init.id

  network_interface {
    network_name = "default"
    mac          = "52:54:00:89:ad:57"
  }

  disk {
    volume_id = libvirt_volume.rocky-linux-qcow2.id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }
}

resource "libvirt_cloudinit_disk" "common-init" {
  name           = "common-init.iso"
  user_data      = file("${path.module}/cloud-init/user_data.yml")
  network_config = file("${path.module}/cloud-init/network_config.yml")
}
