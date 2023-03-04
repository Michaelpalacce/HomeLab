module "k3s-v2" {
  source      = "./modules/k3s_node"
  name        = "k3s-v2"
  vmid        = 101
  target_node = "prox-1"

  disks = [
    {
      volume  = "local-lvm:vm-101-disk-0"
    }
  ]

  networks = [
    {
      macaddr  = "0E:D5:B3:62:30:01"
    }
  ]
}