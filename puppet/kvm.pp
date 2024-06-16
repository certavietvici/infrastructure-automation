class kvm {
  package { ['qemu-kvm', 'libvirt-daemon-system', 'libvirt-clients', 'bridge-utils', 'virt-manager']:
    ensure => installed,
  }

  service { 'libvirtd':
    ensure => running,
    enable => true,
  }

  exec { 'add_user_to_groups':
    command => "usermod -aG kvm,libvirt ${::id}",
    path    => '/usr/bin:/usr/sbin:/bin:/sbin',
  }
}

include kvm
