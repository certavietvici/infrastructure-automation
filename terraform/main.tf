provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu-qcow2" {
  name = "ubuntu-qcow2"
  pool = "default"
  source = "http://cloud-images.ubuntu.com/releases/20.04/release/ubuntu-20.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_domain" "ubuntu" {
  name   = "ubuntu"
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.common-init.id

  network_interface {
    network_name = "default"
    mac = "52:54:00:89:ad:57"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
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
