.PHONY: $(MAKECMDGOALS)

# `make setup` will be used after cloning or downloading to fulfill
# dependencies, and setup the the project in an initial state.
# This is where you might download rubygems, node_modules, packages,
# compile code, build container images, initialize a database,
# anything else that needs to happen before your server is started
# for the first time
setup :	
	mix deps.get
	mix deps.compile
	mix ecto.create
	mix ecto.migrate
	cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development

# `make server` will be used after `make setup` in order to start
# an http server process that listens on any unreserved port
# of your choice (e.g. 8080). 
server :
	mix phx.server

# `make test` will be used after `make setup` in order to run
# your test suite.
test :
	MIX_ENV=integration_test mix compile
	mix test
	MIX_ENV=integration_test mix cypress.run