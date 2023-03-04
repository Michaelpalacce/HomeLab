
resource "proxmox_vm_qemu" "k3s-v4" {
  name        = "k3s-v4"
  vmid        = 103
  target_node = "prox-2"
  qemu_os     = "l26"

  cores   = 2
  sockets = 2
  memory  = 11500
  scsihw  = "virtio-scsi-pci"

  disk {
    type    = "scsi"
    storage = "local-lvm"
    size    = "64G"
    volume  = "local-lvm:vm-103-disk-0"
  }

  disk {
    type    = "scsi"
    storage = "extra"
    size    = "220G"
    volume  = "extra:vm-103-disk-0"
  }

  network {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
    macaddr  = "92:CC:0F:7C:89:DA"
  }

  lifecycle {
    ignore_changes = [
      network, desc
    ]
  }
}
