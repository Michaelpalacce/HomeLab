module "k3s-v3" {
  source      = "./modules/k3s_node"
  name        = "k3s-v3"
  vmid        = 102
  target_node = "prox-2"

  disks = [
    {
      volume  = "local-lvm:vm-102-disk-0"
    },
    {
      storage = "extra"
      size    = "220G"
      volume  = "extra:vm-102-disk-0"
    }
  ]

  networks = [
    {
      macaddr  = "FE:20:33:30:62:9D"
    }
  ]
}