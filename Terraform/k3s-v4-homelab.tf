module "k3s-v4" {
  source      = "./modules/k3s_node"
  name        = "k3s-v4"
  vmid        = 103
  target_node = "prox-2"

  disks = [
    {
      volume  = "local-lvm:vm-103-disk-0"
    },
    {
      storage = "extra"
      size    = "220G"
      volume  = "extra:vm-103-disk-0"
    }
  ]

  networks = [
    {
      macaddr  = "92:CC:0F:7C:89:DA"
    }
  ]
}