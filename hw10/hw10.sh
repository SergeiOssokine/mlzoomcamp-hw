#!/bin/bash
#!/bin/bash
# Function to print a nicer header
header() {
    echo $1
    printf '=%.0s' {1..80}
    echo
}

# Question 1
header "Question 1"

rel_path="../../machine-learning-zoomcamp/cohorts/2025/05-deployment/homework/"
# Launch the docker container
name="zoomcamp-model"
echo "Launching docker container with service"
docker run -d --rm -p 9696:9696 --name ${name} zoomcamp-model:3.13.10-hw10
# Make sure uvicorn up and running
sleep 3
# sed to make things parsable by jq
prob=$(python ${rel_path}/q6_test.py | sed "s/'/\"/g; s/False/false/g" | jq '.conversion_probability')
echo "The conversion probability is ${prob}"
# Stop the container
echo "Stopping docker container"
docker kill ${name}

# Question 2
header "Question 2"
kind_version=$(kind version)
echo "Kind version is ${kind_version}"

# Question 3
header "Question 3"
echo "The smallest deployable computing unit that we can create and manage in Kubernetes is a pod"
kind create cluster

# Question 4
header "Question 4"
service_type=$(kubectl describe services | grep Type | xargs | cut -d " " -f 2)
echo "The Type of the running service is ${service_type}"

# Question 5
header "Question 5"
echo "The command to register the previously built image with kind is: kind load docker-image"


# Question 6
header "Question 6"
kind load docker-image zoomcamp-model:3.13.10-hw10
echo "The correct value of port is 9696"

# Apply the deployment
kubectl apply -f deployment.yaml

# Question 7
header "Question 7"
echo "The correct value for app is 'subscription'"

# Apply the service
kubectl apply -f service.yaml 
# Wait for pods to boot up
echo "Waiting for nodes to be ready"
kubectl rollout status deployment/subscription --timeout=60s
kubectl wait --for=condition=ready pod -l app=subscription --timeout=30s
# Wait a bit longer for the container to be fully ready to accept connections
sleep 5
# Forward the port and save the PID
kubectl port-forward service/subscription-service 9696:80 &
PF_PID=$!
# Wait until port is actually accepting connections
echo "Sleeping for 20 seconds for port forward to be ready"
sleep 20

echo "Port-forward ready!"
# Run the test
python ${rel_path}/q6_test.py

# Kill the port forward
kill $PF_PID

echo "All done"

