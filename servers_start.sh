#!/bin/bash

# Navigate to project directory
cd "$(dirname "$0")"

# Ports and server names
ports=(50051 50052 50053 50054 50055)
names=("Server1" "Server2" "Server3" "Server4" "Server5")

# Virtual environment activation
venv_path="venv/bin/activate"

# Check if venv exists
if [ ! -f "$venv_path" ]; then
  echo "❌ Virtual environment not found! Expected at: $venv_path"
  exit 1
fi

# Command to run servers
for i in {0..4}
do
  port=${ports[$i]}
  name=${names[$i]}
  echo "Starting $name on port $port..."
  osascript -e "tell application \"Terminal\" to do script \"cd $(pwd); source $venv_path; python server.py $port $name 50051 50052 50053 50054 50055\""
done

echo "✅ All servers started in new terminal windows with virtual environment activated."
