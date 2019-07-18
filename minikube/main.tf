#####################################################################
# settings for dev
#####################################################################
locals {
  environment = "dev"
  domain      = "serlo.local"
  project     = "serlo-dev"

  ingress_tls_certificate_path = "~/.minikube/apiserver.crt"
  ingress_tls_key_path         = "~/.minikube/apiserver.key"
}

#####################################################################
# providers
#####################################################################

provider "kubernetes" {
  version                = "~> 1.8"
  config_context_cluster = "minikube"
}

#####################################################################
# namespaces
#####################################################################

resource "kubernetes_namespace" "athene2_namespace" {
  metadata {
    name = "athene2"
  }
}

#####################################################################
# mysql
#####################################################################

module "local_mysql" {
  source    = "./../modules/mysql"
  namespace = kubernetes_namespace.athene2_namespace.metadata.0.name
  node_port = 30024
}

module "athene2_dbsetup" {
  source                      = "./../modules/athene2_dbsetup"
  namespace                   = kubernetes_namespace.athene2_namespace.metadata.0.name
  database_username_default   = "root"
  database_password_default   = "admin"
  database_host               = "mysql.athene2"
  image_pull_policy           = "Never"
  gcloud_bucket_url           = ""
  feature_minikube            = true
  gcloud_service_account_name = ""
  gcloud_service_account_key  = ""
}

module "athene2_dbdump" {
  source                      = "./../modules/athene2_dbdump"
  namespace                   = kubernetes_namespace.athene2_namespace.metadata.0.name
  database_username_readonly  = "root"
  database_password_readonly  = "admin"
  database_host               = "mysql.athene2"
  image_pull_policy           = "Never"
  gcloud_service_account_name = ""
  gcloud_service_account_key  = ""

}

#####################################################################
# athene2
#####################################################################

module "legacy-editor-renderer" {
  source            = "./../modules/legacy-editor-renderer"
  namespace         = kubernetes_namespace.athene2_namespace.metadata.0.name
  image_pull_policy = "Never"

  container_limits_cpu      = "200m"
  container_limits_memory   = "200Mi"
  container_requests_cpu    = "100m"
  container_requests_memory = "100Mi"
}

module "editor-renderer" {
  source            = "./../modules/editor-renderer"
  namespace         = kubernetes_namespace.athene2_namespace.metadata.0.name
  image_pull_policy = "Never"

  container_limits_cpu      = "200m"
  container_limits_memory   = "200Mi"
  container_requests_cpu    = "100m"
  container_requests_memory = "100Mi"
}

module "varnish" {
  source            = "./../modules/varnish"
  namespace         = kubernetes_namespace.athene2_namespace.metadata.0.name
  app_replicas      = 1
  image_pull_policy = "Never"
  backend_ip        = module.athene2.athene2_service_ip
  varnish_memory    = "100M"

  resources_limits_cpu      = "50m"
  resources_limits_memory   = "200Mi"
  resources_requests_cpu    = "50m"
  resources_requests_memory = "200Mi"
}

module "athene2" {
  source = "./../modules/athene2"

  php_definitions-file_path = ""

  php_recaptcha_key    = "NOTSET"
  php_recaptcha_secret = "NOTSET"
  php_smtp_password    = "NOTSET"
  php_newsletter_key   = "NOTSET"
  php_tracking_switch  = "false"

  varnish_service_name = module.varnish.varnish_service_name
  varnish_service_port = module.varnish.varnish_service_port

  legacy_editor_renderer_uri = module.legacy-editor-renderer.service_uri
  editor_renderer_uri        = module.editor-renderer.service_uri

  domain = local.domain

  database_username_default  = "root"
  database_password_default  = "admin"
  database_username_readonly = "root"
  database_password_readonly = "admin"

  app_replicas = 1

  httpd_container_limits_cpu      = "200m"
  httpd_container_limits_memory   = "200Mi"
  httpd_container_requests_cpu    = "100m"
  httpd_container_requests_memory = "100Mi"

  php_container_limits_cpu      = "500m"
  php_container_limits_memory   = "400Mi"
  php_container_requests_cpu    = "250m"
  php_container_requests_memory = "200Mi"

  database_private_ip = "mysql.athene2"
  image_pull_policy   = "Never"
}
