flutter pub get

if [ -f "server.pid" ]; then
  pid=$(cat server.pid)

  if ps -p $pid > /dev/null; then
    echo "Found existing server. Stopping current server..."
    pgid=$(ps -o pgid= -p $pid)
    kill -TERM "-$pgid"
  fi

  rm server.pid
fi

export PORT=16901
dart bin/server.dart > normal.log 2> error.log &
echo $! > server.pid

echo "Successfully launched server on port $PORT"