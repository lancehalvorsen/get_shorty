echo "Resetting GetShorty Database"
MIX_ENV=integration_test mix ecto.reset
echo "Starting Phoenix Server"
MIX_ENV=integration_test mix phx.server &
pid=$!
echo "Running Cypress Tests"
cd ./assets && ./node_modules/.bin/cypress run --quiet
result=$?
kill $pid
echo "Shutting Down Phoenix Server"
exit $result