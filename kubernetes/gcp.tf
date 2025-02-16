# Sem variáveis, tudo hardcoded
# Sem organização de arquivos, tudo em um único arquivo
# Sem backend remoto, usando backend local por padrão
# Credenciais expostas diretamente no código

provider "google" {
  credentials = file("/home/user/my-secret-key.json")
  project     = "my-project-12345"
  region      = "us-central1"
}

# Rede VPC sem sub-redes adequadas
resource "google_compute_network" "network" {
  name                    = "network"
  auto_create_subnetworks = true  # Usando criação automática em vez de definir sub-redes específicas
}

# Firewall totalmente aberto
resource "google_compute_firewall" "allow_all" {
  name    = "allow-all"
  network = google_compute_network.network.name

  allow {
    protocol = "all"  # Permitindo todos os protocolos
  }

  source_ranges = ["0.0.0.0/0"]  # Aberto para o mundo inteiro
}

# VM com disco boot não criptografado e sem tags
resource "google_compute_instance" "vm" {
  name         = "vm1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"  # Imagem antiga e sem patch
    }
  }

  network_interface {
    network = google_compute_network.network.name
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["cloud-platform"]  # Escopo excessivamente amplo
  }

  metadata = {
    ssh-keys = "user:ssh-rsa AAAAB3N...examplekey user@example.com"  # Chave SSH hardcoded
  }
}

# Bucket de armazenamento público sem versionamento
resource "google_storage_bucket" "data" {
  name     = "my-important-data-bucket"
  location = "US"

  # Faltando configuração de lifecycle
  # Faltando versionamento
  # Faltando criptografia
  
  # Bucket público!
  iam_binding {
    role    = "roles/storage.objectViewer"
    members = ["allUsers"]
  }
}

# Banco de dados sem backup, sem alta disponibilidade, e com senha em texto claro
resource "google_sql_database_instance" "db" {
  name             = "my-database-instance"
  database_version = "MYSQL_5_7"  # Versão antiga
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
    
    backup_configuration {
      enabled = false  # Sem backups
    }
    
    ip_configuration {
      ipv4_enabled = true  # Exposto publicamente
      authorized_networks {
        value = "0.0.0.0/0"  # Acessível de qualquer lugar
      }
    }
  }
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.db.name
  password = "admin123"  # Senha fraca e em texto claro
}

# Usando identidade de serviço com permissões excessivas
resource "google_project_iam_binding" "project" {
  project = "my-project-12345"
  role    = "roles/owner"  # Permissão máxima

  members = [
    "serviceAccount:${google_compute_instance.vm.service_account[0].email}",
  ]
}

# Sem monitoramento ou logging configurado
# Sem tags ou labels para organização de recursos
# Sem módulos para reutilização de código
# Sem outputs para informações importantes