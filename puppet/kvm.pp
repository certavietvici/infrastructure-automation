class kvm {
  package { ['qemu-kvm', 'libvirt', 'libvirt-client', 'bridge-utils', 'virt-install']:
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
