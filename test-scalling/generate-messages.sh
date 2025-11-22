#!/bin/bash

# Your project and topic from the KEDA demo
project_id="supple-alpha-474315-q5"
topic_name="keda-demo-topic"

echo "Flooding Pub/Sub topic '$topic_name' in project '$project_id' ..."
echo "Every second a new message will be published – watch your keda-demo pods explode!"
echo "Press Ctrl+C to stop"

while true; do
    message="Hello from Bondok @ $(date '+%Y-%m-%d %H:%M:%S')"
    gcloud pubsub topics publish "$topic_name" \
        --message "$message" \
        --project "$project_id"
    
    echo "Published: $message"
    sleep 1
done