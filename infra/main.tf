module "kube-hetzner" {
  source  = "kube-hetzner/kube-hetzner/hcloud"
  version = "2.18.4"

  providers = {
    hcloud = hcloud
  }

  hcloud_token    = var.hcloud_token
  cluster_name    = "hetznetes"
  network_region  = "eu-central"
  ssh_private_key = var.ssh_private_key
  ssh_public_key  = var.ssh_public_key
  # ssh_private_key = file("~/.ssh/hetznetes")
  # ssh_public_key  = file("~/.ssh/hetznetes.pub")

  # Configure Flannel to use the correct network interface for Hetzner Cloud
  # Hetzner Cloud uses enp7s0 for the private network interface, not eth1
  control_planes_custom_config = {
    "flannel-iface" = "enp7s0"
  }
  agent_nodes_custom_config = {
    "flannel-iface" = "enp7s0"
  }

  control_plane_nodepools = [
    {
      name        = "control-plane",
      server_type = "cx23",
      location    = "nbg1",
      count       = 1
      labels      = []
      taints      = []
    }
  ]

  agent_nodepools = [
    {
      name        = "worker",
      server_type = "cx23",
      location    = "nbg1",
      count       = 1
      labels      = []
      taints      = []
    }
  ]
}

output "kubeconfig" {
  value     = module.kube-hetzner.kubeconfig
  sensitive = true
}
