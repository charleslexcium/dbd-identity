setup:
	mkdir -p db_data
	mkdir -p keycloak_data/providers
	mkdir -p mailcatcher_data
	mkdir -p mailpit_data

	mvn dependency:get -DremoteRepositories=http://repo1.maven.org/maven2/ \
                   -DgroupId=io.phasetwo.keycloak -DartifactId=keycloak-events -Dversion=0.46 \
                   -Dtransitive=false
	mv ~/.m2/repository/io/phasetwo/keycloak/keycloak-events/0.46/keycloak-events-0.46.jar keycloak_data/

	brew install buildkit

	# brew install lima
	# limactl start template://buildkit
	# export BUILDKIT_HOST="unix://$HOME/.lima/buildkit/sock/buildkitd.sock"

build:
	docker build . --tag keycloak:local
	docker build -f IdentityDockerfile . --tag identity:local

run:
	docker compose up