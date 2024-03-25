#build docker image
docker build -t amooedwin/multi-client:latest -t amooedwin/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t amooedwin/multi-server:latest -t amooedwin/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t amooedwin/multi-worker:latest -t amooedwin/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#push images to docker repository 
docker push amooedwin/multi-client:latest
docker push amooedwin/multi-server:latest
docker push amooedwin/multi-worker:latest

docker push amooedwin/multi-client:$SHA
docker push amooedwin/multi-server:$SHA
docker push amooedwin/multi-worker:$SHA


#deploying images into Kubernetes cluster 
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=amooedwin/multi-server:$SHA
kubectl set image deployments/client-deployment client=amooedwin/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=amooedwin/multi-worker:$SHA