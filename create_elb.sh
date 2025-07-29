#!/bin/bash

set -e

echo "[INFO] Creating Target Group..."
TG_ARN=$(aws elbv2 create-target-group \
  --name my-target-group \
  --protocol HTTP \
  --port 9000 \
  --target-type instance \
  --vpc-id vpc-xxxxxxxx \
  --query 'TargetGroups[0].TargetGroupArn' \
  --output text)

echo "[INFO] Creating Load Balancer..."
LB_ARN=$(aws elbv2 create-load-balancer \
  --name my-load-balancer \
  --subnets subnet-xxxx subnet-yyyy \
  --security-groups sg-xxxxxx \
  --scheme internet-facing \
  --type application \
  --ip-address-type ipv4 \
  --query 'LoadBalancers[0].LoadBalancerArn' \
  --output text)

echo "[INFO] Creating Listener..."
aws elbv2 create-listener \
  --load-balancer-arn $LB_ARN \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=forward,TargetGroupArn=$TG_ARN

echo "[INFO] Registering EC2 instance..."
aws elbv2 register-targets \
  --target-group-arn $TG_ARN \
  --targets Id=i-xxxxxxxx

echo "[INFO] Load Balancer setup complete!"
