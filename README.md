# Docker-poa-blockscout

## HOW TO

### BUILD NODES

CWD: `eth-node`

Master Node: `docker build --tag=eth-master-node --build-arg NODE_ID=0 --build-arg JSON_KEY=folletto --file=./.docker/node.dockerfile .`

Slave Node: `docker build --tag=eth-slave-node --build-arg NODE_ID=1 --build-arg JSON_KEY=folletto --file=./.docker/node.dockerfile .`

### RUN NODES

CWD: `eth-node/k8s`

#### DEVELOPMENT WITH MINIKUBE

##### MASTER NODE

1. Add the container image to minikube:

  * Master Node: `minikube image load eth-master-node:latest`

2. Run the k8s pod deploy

  * Master Node: `kubectl apply --filename=master-node-pod.yaml`

3. Run the k8s service deploy

  * Master Node: `kubectl apply --filename=master-node-service.yaml`

##### SLAVE NODE



### DESTROY

* Master Node Pod: `kubectl delete pods master-node`

* Master Node Service: `kubectl delete service master-node-service`

## REFERENCES

* https://openethereum.github.io/JSONRPC-parity-module#parity_enode

* https://eth.wiki/en/fundamentals/enode-url-format

* https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

