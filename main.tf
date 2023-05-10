terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = "${var.yc_token}"
  cloud_id  = "b1ggel59310trksk1fu4"
  folder_id = "b1g9oing6niujio3j61t"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "zabbix-server" {
  name = "debian11-zabbix-server"
  platform_id = "standard-v3"
  resources {
    core_fraction = 50
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fphfpeqijnlu1phu4"
      size = 10
      type = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: night\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("./yc-terraform.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}

resource "yandex_compute_instance" "zabbix-slave1" {
  name = "debian11-zabbix-slave1"
  platform_id = "standard-v3"
  resources {
    core_fraction = 20
    cores  = 2
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fphfpeqijnlu1phu4"
      size = 3
      type = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: night\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("./yc-terraform.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}
resource "yandex_compute_instance" "zabbix-slave2" {
  name = "debian11-zabbix-slave2"
  platform_id = "standard-v3"
  resources {
    core_fraction = 20
    cores  = 2
    memory = 1
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fphfpeqijnlu1phu4"
      size = 3
      type = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: night\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("./yc-terraform.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}
resource "yandex_vpc_network" "network-2" {
  name = "network2"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-2.id
  v4_cidr_blocks = ["192.168.1.0/24"]
}

output "external_ip_address_zabbix-server" {
  value = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address
}
output "external_ip_address_zabbix-slave1" {
  value = yandex_compute_instance.zabbix-slave1.network_interface.0.nat_ip_address
}
output "external_ip_address_zabbix-slave2" {
  value = yandex_compute_instance.zabbix-slave2.network_interface.0.nat_ip_address
}
resource "null_resource" "ansible-zabbix-server" {
  depends_on = [yandex_compute_instance.zabbix-server]
  triggers = {
    server_ip = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address
  }
  provisioner "local-exec" {
    command = <<EOF
      #!/bin/bash
      # Update the Ansible hosts file with the new IP address
      sed -i "/zabbix_server/s/host=[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/host=${yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address}/"  hosts
    EOF
  }
}
resource "null_resource" "ansible-zabbix-slave1" {
  depends_on = [yandex_compute_instance.zabbix-slave1]
  triggers = {
    slave1_ip = yandex_compute_instance.zabbix-slave1.network_interface.0.nat_ip_address
  }
  provisioner "local-exec" {
    command = <<EOF
      #!/bin/bash
      # Update the Ansible hosts file with the new IP address
      sed -i "/zabbix_slave1/s/host=[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/host=${yandex_compute_instance.zabbix-slave1.network_interface.0.nat_ip_address}/"  hosts
    EOF
  }
}
resource "null_resource" "ansible-zabbix-slave2" {
  depends_on = [yandex_compute_instance.zabbix-slave2]
  triggers = {
    slave2_ip = yandex_compute_instance.zabbix-slave2.network_interface.0.nat_ip_address
  }
  provisioner "local-exec" {
    command = <<EOF
      #!/bin/bash
      # Update the Ansible hosts file with the new IP address
      sed -i "/zabbix_slave2/s/host=[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/host=${yandex_compute_instance.zabbix-slave2.network_interface.0.nat_ip_address}/"  hosts
    EOF
  }
}