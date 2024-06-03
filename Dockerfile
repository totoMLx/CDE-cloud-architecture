FROM postgres:12.7

# Set environment variables
ENV POSTGRES_USER="tcampi"
ENV POSTGRES_PASSWORD="tcampitba"
ENV POSTGRES_DB="flights_data"

EXPOSE 5432