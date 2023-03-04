module "k3s-v1" {
  source      = "./modules/k3s_node"
  name        = "k3s-v1"
  vmid        = 100
  target_node = "prox-1"

  disks = [
    {
      volume  = "local-lvm:vm-100-disk-0"
    }
  ]

  networks = [
    {
      macaddr  = "22:F9:B7:37:2E:DE"
    }
  ]
}