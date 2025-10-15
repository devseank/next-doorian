#!/bin/bash
set -e

cd /api

# Remove a potentially pre-existing server.pid file for Rails
rm -f /api/tmp/pids/server.pid

# Execute the main command
exec "$@"