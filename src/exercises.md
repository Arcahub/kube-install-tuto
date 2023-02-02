# Exercises

## Disable bash history to cover our tracks

```bash
unset HISTFILE
```

## ideas

- Upgrade the cluster version
- Deploy a pod to the control plane node
- Manual schedule
- Deploy a 3 replicas deployment but only on pod can be scheduled by worker node
- Get container infos and logs
- Fix kubelet
- Fix kube-proxy
- Fix certificates
- Etcd backup and restore
- Curl to manually contact the API server with a custom service account token
- Enable pod isolation in specific namespace (network policy)

## Broke clusters scenarios

- Kubelet has wrong bin path // Update section to use systemctl status on kubelet
- Scaledown CNI to 0 pod
- Kubeproxy does not route traffic to worker nodes
- Controller manager certificate is expired
- Break pod scheduling
- etcd size is too small
- let a node cordonned

### Klusterd

- notes/klustered-teams/episode-2/talos-systems/README.md
- notes/klustered-teams/episode-3/digitalocean/README.md
- notes/klustered-teams/episode-3/skyscanner/README.md
- notes/klustered-teams/episode-5/Giant Swarm/README.md
- notes/klustered-teams/episode-6/BookClub/README.md
- notes/klustered/episode-7/guy-templeton/README.md
- notes/klustered/episode-7/philip-welz/README.md
- notes/klustered/episode-9/billie-cleek/README.md
- notes/klustered/episode-14/sid-palas/README.md
- notes/klustered/episode-17/william-lightning/break.sh **(not tested)**
- notes/klustered/episode-18/santana/README.md **adminsion webhook**
- notes/klustered/episode-19/borkod/README.md
- notes/klustered/episode-23/Marcus/README.md
- notes/klustered/episode-30/CrashBeerBackOff/README.md


## Implemented

- 01 - Kubelet has wrong bin path
- 02 - Drain a node and let it unschedulable
- 03 - Invalidate apiserver certificate (not tested)
- 04 - CoreDNS scale to 0
- 05 - CoreDNS bad config
- 06 - set `maxPods` to 3 and try to schedule 5 pods
- 07 - Break etcd health check
- 08 - Copy static pod manifest dir but remove the kube-api-server manifest
- 09 - Network policy to block all pods in a namespace
- 10 - Taint worker nodes
- 11 - chmod break
- 12 - Remove kube admin config
- 13 - Disable deployment controller
