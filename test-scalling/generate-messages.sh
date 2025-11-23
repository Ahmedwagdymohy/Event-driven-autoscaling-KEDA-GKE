#!/bin/bash

# Your project and topic from the KEDA demo
project_id="supple-alpha-474315-q5"
topic_name="keda-demo-topic"

echo "Flooding Pub/Sub topic '$topic_name' in project '$project_id' ..."
echo "Every second a new message will be published – watch your keda-demo pods explode!"
echo "Press Ctrl+C to stop"

# Change your script to send 20 messages per second
while true; do
  for i in {1..20}; do
    gcloud pubsub topics publish keda-demo-topic --message="wake up!" --project=supple-alpha-474315-q5 &
  done
  wait
done