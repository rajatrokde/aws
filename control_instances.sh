#!/bin/bash

# Check if the awscli is installed
if ! command -v aws &>/dev/null; then
  echo "AWS CLI not found. Please install and configure the AWS CLI before running this script."
  exit 1
fi

# Prompt the user for the instance name and region
read -p "Enter the instance name: " INSTANCE_NAME
read -p "Enter the AWS region (e.g., us-east-1): " AWS_REGION

# Function to start the EC2 instance
start_instance() {
  aws ec2 start-instances --instance-ids "$1" --region "$2"
}

# Function to stop the EC2 instance
stop_instance() {
  aws ec2 stop-instances --instance-ids "$1" --region "$2"
}

# Function to terminate the EC2 instance
terminate_instance() {
  aws ec2 terminate-instances --instance-ids "$1" --region "$2"
}

# Get the instance ID based on the provided instance name and region
instance_id=$(aws ec2 describe-instances \
  --region "$AWS_REGION" \
  --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
  --query "Reservations[].Instances[0].InstanceId" \
  --output text
)

# Check if the instance ID is empty (no instance found with the provided name)
if [ -z "$instance_id" ]; then
  echo "No EC2 instance found with the name $INSTANCE_NAME in the $AWS_REGION region."
else
  echo "EC2 instance with ID $instance_id found."
  read -p "Enter the action (start, stop, terminate): " ACTION

  # Perform the chosen action
  case "$ACTION" in
    "start")
      start_instance "$instance_id" "$AWS_REGION"
      echo "Starting the EC2 instance..."
      ;;
    "stop")
      stop_instance "$instance_id" "$AWS_REGION"
      echo "Stopping the EC2 instance..."
      ;;
    "terminate")
      terminate_instance "$instance_id" "$AWS_REGION"
      echo "Terminating the EC2 instance..."
      ;;
    *)
      echo "Invalid action. Please choose 'start', 'stop', or 'terminate'."
      exit 1
      ;;
  esac
fi
