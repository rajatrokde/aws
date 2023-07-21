#!/bin/bash

# Function to create an S3 bucket with a random suffix
create_s3_bucket() {
    bucket_name="$1"
    region="$2"

    # Generate a random suffix (8 characters long)
    random_suffix=$(openssl rand -hex 4)

    # Append the random suffix to the bucket name
    unique_bucket_name="${bucket_name}-${random_suffix}"

    # Create the S3 bucket
    aws s3api create-bucket \
        --bucket "$unique_bucket_name" \
        --region "$region"

    if [ $? -eq 0 ]; then
        echo "S3 bucket '$unique_bucket_name' created successfully in region '$region'."
    else
        echo "Failed to create the S3 bucket in region '$region'."
    fi
}

# Prompt the user for input
read -p "Enter the name for the S3 bucket: " bucket_name
read -p "Enter the AWS region for the bucket (e.g., us-east-1): " region

# Call the function to create the S3 bucket with a unique name
create_s3_bucket "$bucket_name" "$region"
