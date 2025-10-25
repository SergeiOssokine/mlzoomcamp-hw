#!/bin/bash

# Answer questions for homework 5

# Function to print a nicer header
header() {
    echo $1
    printf '=%.0s' {1..80}
    echo
}

echo "Beginning HW 5"

# Q1
header "Question 1"
version=$(uv --version)
echo "Running ${version}"

# Q2
header "Question 2"
sha=$(cat uv.lock | grep scikit | grep sha256 | head -n 1 | cut -d "," -f 2 | cut -d "=" -f 2 | xargs)
echo "The sha256 for sklearn is ${sha}"

# Q3
header "Question 3"

wget https://github.com/DataTalksClub/machine-learning-zoomcamp/raw/refs/heads/master/cohorts/2025/05-deployment/pipeline_v1.bin
uv run python score_client.py --payload '{
    "lead_source": "paid_ads",
    "number_of_courses_viewed": 2,
    "annual_income": 79276.0
}'

# Q4
header "Question 4"
echo "Launching the uvicorn server"
uv run uvicorn predict_service:app --host 0.0.0.0 --port 9696 --reload &
UV_PID=$!
sleep 2
echo "Running the inference client"
uv run python predict_client.py --payload '{"lead_source": "organic_search",
    "number_of_courses_viewed": 4,
    "annual_income": 80304.0
}'
echo "Shutting down the uvicorn server"
kill $UV_PID
wait $UV_PID 2>/dev/null

# Q5
header "Question 5"
img_size=$(docker images | grep zoomcamp-model | xargs | cut -d " " -f 7)
echo "The size of the base image is ${img_size}"

# Q6
header "Question 6"
IMG_NAME="ml_hw5"
echo "Building Docker container"
docker build -q -t $IMG_NAME .
echo "Launching Docker container"
docker run -p 9696:9696 -d --name=${IMG_NAME} $IMG_NAME
container_id=$(docker ps -a -f name=${IMG_NAME} --format json | jq -r .ID)
# Give the server enough time to start
sleep 4
echo "Running prediction job"
uv run python predict_client.py --payload '{
    "lead_source": "organic_search",
    "number_of_courses_viewed": 4,
    "annual_income": 80304.0
}'
sleep 2
echo "Stopping container"
docker stop $container_id > /dev/null
docker container rm $container_id > /dev/null
