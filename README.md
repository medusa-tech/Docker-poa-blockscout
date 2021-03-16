# Docker-poa-blockscout

## BUILD NODES

CWD: `eth-node`

Master Node: `docker build --tag=eth-master-node --build-arg NODE_ID=0 --build-arg JSON_KEY=folletto --file=./.docker/node.dockerfile .`

Slave Node: `docker build --tag=eth-slave-node --build-arg NODE_ID=1 --build-arg JSON_KEY=folletto --file=./.docker/node.dockerfile .`

If using minikube, add the images to minikube registry:

* Master Node: `minikube image load eth-master-node:latest`

* Slave Node: `minikube image load eth-slave-node:latest`

## RUN NODES

CWD: `eth-node/k8s`

### DEPLOYMENTS

This is the preferred method!

1. Run the k8s deployment: `kubectl apply --filename node-deployment.yaml`

2. Run the k8s service: `kubectl apply --filename=master-node-service.yaml`

### PODS

#### MASTER NODE

1. Run the k8s pod deploy

  * Master Node: `kubectl apply --filename=master-node-pod.yaml`

2. Run the k8s service deploy

  * Master Node: `kubectl apply --filename=master-node-service.yaml`

#### SLAVE NODE

#### DESTROY

* Master Node Pod: `kubectl delete pods master-node`

* Master Node Pod: `kubectl delete --filename=master-node-pod.yaml` 

* Master Node Service: `kubectl delete service master-node-service`

## REFERENCES

* https://openethereum.github.io/JSONRPC-parity-module#parity_enode

* https://eth.wiki/en/fundamentals/enode-url-format

* https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

