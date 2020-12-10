# kind-configs
my KIND configurations for different practices

CKA and CKAD test environment support calico and flannel. The KIND cluster configration will be adde first.

## Usage

./up.sh [cluster-name]

## Development

up.sh will call kind with the cluster configuration to create the cluster if there isn't kind clusters named kind. after the creationof the cluste, up.sh will call the corresponding hook script if it exists under ./configs folder.

### naming convention

. [clust-name]-cluster.yaml: mandate
. [clust-name]-hook.sh:  optional
