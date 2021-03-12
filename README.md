# Docker-poa-blockscout

## HOW TO

### BUILD NODES

CWD: `eth-node`

Master Node: `docker build --tag=eth-master-node --build-arg NODE_ID=0 --build-arg JSON_KEY=folletto --build-arg NODE_PUBLIC_IP=0.0.0.0 --file=./.docker/node.dockerfile .`

Slave Node: ``

### RUN NODES

CWD: `eth-node/k8s`

#### DEVELOPMENT WITH MINIKUBE

1. Add the container image to minikube:

  * Master Node: `minikube cache add eth-master-node:latest`

2. Run the k8s pod deploy

  * Master Node: `kubectl apply --filename=master-node-pod.yaml`

3. Run the k8s service deploy

  * Master Node: `kubectl apply --filename=master-node-service.yaml`

### DESTROY

* Master Node Pod: `kubectl delete pods master-node`

* Master Node Service: `kubectl delete service master-node-service`

## REFERENCES

* https://openethereum.github.io/JSONRPC-parity-module#parity_enode

* https://eth.wiki/en/fundamentals/enode-url-format

* https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

