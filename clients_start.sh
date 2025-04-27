#!/bin/bash

# Navigate to project directory
cd "$(dirname "$0")"

# Virtual environment activation
venv_path="venv/bin/activate"

# Check if venv exists
if [ ! -f "$venv_path" ]; then
  echo "❌ Virtual environment not found! Expected at: $venv_path"
  exit 1
fi

# Activate virtual environment
source $venv_path

# Define task submissions (server_address, task_name, weight)
# tasks=(
#   "localhost:50051 Task-A1 10"
#   "localhost:50052 Task-B1 8"
#   "localhost:50053 Task-C1 6"
#   "localhost:50054 Task-D1 5"
#   "localhost:50055 Task-E1 7"
#   "localhost:50055 Task-A2 9"
#   "localhost:50055 Task-B2 18"
#   "localhost:50055 Task-C3 22"
#   "localhost:50055 Task-D2 17"
#   "localhost:50055 Task-E2 12"
# )



tasks=(
  "localhost:50051 Task-A1 10"
  "localhost:50051 Task-B1 8"
  "localhost:50051 Task-C1 6"
  "localhost:50051 Task-D1 5"
  "localhost:50051 Task-E1 7"
  "localhost:50051 Task-A2 9"
  "localhost:50051 Task-B2 18"
  "localhost:50051 Task-C3 22"
  "localhost:50051 Task-D2 17"
  "localhost:50051 Task-E2 12"
)

# Submit each task sequentially
for task_info in "${tasks[@]}"
do
  echo "📤 Submitting: $task_info"
  python client.py $task_info
  sleep 1  # optional small wait between task submissions
done

echo "✅ All client tasks submitted successfully from single terminal session."
