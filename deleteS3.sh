#!/bin/bash

# Function to delete an S3 bucket
delete_s3_bucket() {
    bucket_name="$1"
    region="$2"

    # Delete the S3 bucket
    aws s3api delete-bucket \
        --bucket "$bucket_name" \
        --region "$region"

    if [ $? -eq 0 ]; then
        echo "S3 bucket '$bucket_name' deleted successfully from region '$region'."
    else
        echo "Failed to delete the S3 bucket from region '$region'."
    fi
}

# Prompt the user for input
read -p "Enter the name of the S3 bucket to delete: " bucket_name
read -p "Enter the AWS region of the bucket (e.g., us-east-1): " region

# Call the function to delete the S3 bucket
delete_s3_bucket "$bucket_name" "$region"
