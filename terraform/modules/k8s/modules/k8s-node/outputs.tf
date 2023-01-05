output "workers_ip" {
    value = scaleway_instance_server.node[*].private_ip
}