#!/bin/bash
# Function to print a nicer header
header() {
    echo $1
    printf '=%.0s' {1..80}
    echo
}
# Q5
header "Question 5"
docker pull agrigorev/model-2025-hairstyle:v1
img_size=$(docker images | grep model-2025-hairstyle | xargs | cut -d " " -f 7)
echo "The image size is ${img_size}"


# Q6
predict_image_name="hw9"
header "Question 6"
echo "Building the Docker container"
docker build -t ${predict_image_name} .
echo "Starting the container"
docker run -d -p 8080:8080 --name $predict_image_name ${predict_image_name}
echo "Sleeping 3 seconds to make sure container is spun up"
sleep 3
echo "Running the test"
python test.py
echo "Done"
echo "Killing the container"
docker kill ${predict_image_name}
echo "Removing the container"
docker container rm ${predict_image_name}