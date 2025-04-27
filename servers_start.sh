#!/bin/bash
cd "$(dirname "$0")"

# Activate your venv
source venv/bin/activate

ports=(50051 50052 50053 50054 50055)
names=(Server1 Server2 Server3 Server4 Server5)

for i in "${!ports[@]}"; do
  port=${ports[i]}
  name=${names[i]}
  echo "Starting $name on port $port..."
  cmd="cd $(pwd) && source venv/bin/activate && python server.py $port $name ${ports[*]}; exec bash"
  osascript -e "tell application \"Terminal\" to do script \"$cmd\"" >/dev/null 2>&1
  sleep 1
done

echo "✅ All 5 servers started in new Terminal tabs."
