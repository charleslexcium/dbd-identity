FROM docker.io/bitnami/keycloak:26.2.5

COPY keycloak_data/keycloak-events-0.46.jar /opt/bitnami/keycloak/providers/keycloak-events-0.46.jar
COPY keycloak_data/sample-event-listener.jar /opt/bitnami/keycloak/providers/sample-event-listener.jar

EXPOSE 8080 8443 9000

USER 1001

ENTRYPOINT [ "/opt/bitnami/scripts/keycloak/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/keycloak/run.sh" ]