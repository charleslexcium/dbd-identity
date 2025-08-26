FROM quay.io/keycloak/keycloak:24.0.2

# Switch to the new Quarkus distribution
WORKDIR /opt/keycloak

# Build the server with necessary features
RUN /opt/keycloak/bin/kc.sh build

# Heroku provides the $PORT env var
CMD ["/opt/keycloak/bin/kc.sh", "start", "--hostname-strict=false", "--http-port=${PORT}"]
