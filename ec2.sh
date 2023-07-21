#!/bin/bash

# Function to create an EC2 instance
create_instance() {
    ami_id="$1"
    instance_type="$2"
    instance_name="$3"
    vpc_id="$4"
    subnet_id="$5"
    security_group="$6"

    # Launch the instance and capture the instance ID
    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --subnet-id "$subnet_id" \
        --security-group-ids "$security_group" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --query "Instances[0].InstanceId" \
        --output text)

    # Check if the instance was successfully launched
    if [ -n "$instance_id" ]; then
        echo "Successfully launched instance with ID: $instance_id"
        check_instance_status "$instance_id"
    else
        echo "Failed to launch the instance."
    fi
}

# Function to check instance status and display IP address
check_instance_status() {
    instance_id="$1"

    echo "Checking instance status..."
    status=$(aws ec2 describe-instances \
        --instance-ids "$instance_id" \
        --query "Reservations[0].Instances[0].State.Name" \
        --output text)

    if [ "$status" == "running" ]; then
        public_ip=$(aws ec2 describe-instances \
            --instance-ids "$instance_id" \
            --query "Reservations[0].Instances[0].PublicIpAddress" \
            --output text)

        echo "Instance is running with public IP: $public_ip"
    else
        echo "Instance is in status: $status"
    fi
}

# Prompt the user for input
read -p "Enter AMI ID: " ami_id
read -p "Enter Instance Type (e.g., t2.micro): " instance_type
read -p "Enter Instance Name: " instance_name
read -p "Enter VPC ID: " vpc_id
read -p "Enter Subnet ID: " subnet_id
read -p "Enter Security Group ID: " security_group

# Call the function to create the instance
create_instance "$ami_id" "$instance_type" "$instance_name" "$vpc_id" "$subnet_id" "$security_group"
