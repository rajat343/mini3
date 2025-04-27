#!/bin/bash
cd "$(dirname "$0")"

# Activate your venv
source venv/bin/activate

# (Optional) give the servers a moment to be 100% ready
echo "Waiting 5s for servers to warm up..."
sleep 5

tasks=(
  "localhost:50051 Task-A1 10"
  "localhost:50052 Task-B1 8"
  "localhost:50053 Task-C1 6"
  "localhost:50054 Task-D1 5"
  "localhost:50055 Task-E1 7"
  "localhost:50055 Task-A2 9"
  "localhost:50054 Task-B2 18"
  "localhost:50054 Task-C3 22"
  "localhost:50055 Task-D2 17"
  "localhost:50055 Task-E2 12"
)

# tasks=(
#   "localhost:50051 Task-A1 10"
#   "localhost:50051 Task-B1 8"
#   "localhost:50051 Task-C1 6"
#   "localhost:50051 Task-D1 5"
#   "localhost:50051 Task-E1 7"
#   "localhost:50051 Task-A2 9"
#   "localhost:50051 Task-B2 18"
#   "localhost:50051 Task-C3 22"
#   "localhost:50051 Task-D2 17"
#   "localhost:50051 Task-E2 12"
# )

for info in "${tasks[@]}"; do
  echo "Submitting: $info"
  python client.py $info > /dev/null 2>&1
done

echo "✅ All client tasks submitted successfully."
