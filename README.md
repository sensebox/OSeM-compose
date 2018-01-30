# openSenseMap in Docker Compose

This repository contains the `docker-compose.yml` how [opensensemap.org](https://opensensemap.org) is run. It includes a watchtower image which will periodically checks for and deploys updated images.

# What you need

- [Docker](https://docs.docker.com/engine/understanding-docker/) 1.13.0 or above and [Docker Compose](https://docs.docker.com/compose/overview/) 1.11.0 or above
- A server
- a web domain with dns control (you need the subdomains `www`, `api`, `ingress` and optionally `ttn-integration`)

# How to run

Use the script `create-volumes.sh` to create docker volumes. These will be used by the services specified in `docker-compose.yml`.

Create self signed certificates for inter-service communication with [`generateCertificates.sh`](#certificates-for-secure-inter-service-communication).

After you installed the software listed above, created the subdomains and place the `docker-compose.yml` on your server. You may want to configure some values in a `docker-compose.override.yml`. Configuration happens mainly through `environment` keys.

Afterwards you can start everything with `docker-compose up -d`. This repository also contains some bash scripts to deploy updated images.

# Certificates for secure inter-service communication

The `generateCertificates.sh` script wraps [`certstrap`](https://github.com/square/certstrap) to create a self signed certificate authority which can be used to sign server and client certificates.

## Prerequisites

Grab at least version 1.1.1 of `certstrap` ([github.com/square/certstrap/releases](https://github.com/square/certstrap/releases))

## Usage

    ./generateCertificates.sh YOUR-CERTIFICATE-AUTHORITY-NAME SERVICE1[,SERVICE2,...]

Generates a new certficate authority named YOUR-CERTIFICATE-AUTHORITY-NAME and certificates for services named SERVICE1 and SERVICE2. The certificates are valid for hostnames `SERVICE_NAME` and `localhost` and are stored in a new folder called `certificates`.

You can convert the certificate files to \n delimited strings using `sed -z 's/\n/\\n/g' < certificate.crt`.

# Configuration

## Service `web`

| key | comment | optional |
|-----|---------|----------|
| `WEB_DOMAIN` | your domain without protocol. also no `www` |  |
| `API_DOMAIN` | normally `api.yourdomain.tld` |  |
| `INGRESS_DOMAIN` | normally `ingress.yourdomain.tld` |  |
| `ISSUER_ADDRESS` | your email for automatic issuing of a [letsencrypt](https://letsencrypt.org/) tls certificate |  |
| `ADDITIONAL_VHOSTS` | Allows to specify additional vhosts for the caddy web server. | y |
| `USE_STAGING_CA` | if `true` a test-certificate will be issued. Otherwise omit this key | y |

## Service `api`

| key | comment | optional |
|-----|---------|----------|
| `NODE_ENV` | should be set to `production` to enable https checking in the api. | |
| `NODE_CONFIG` | JSON string containing the configuration of the [`openSenseMap-API`](https://github.com/sensebox/openSenseMap-API) service |  |

## Service `mongo`

| key | comment | optional |
|-----|---------|----------|
| `OSEM_dbuser` | the database user to connect to your mongodb, should be the same in services `api`, `mongo`, `ttn-integration` and `mqtt-integration` | y |
| `OSEM_dbuserpass` | the password for the mongodb user, should be the same in services `api`, `mongo`, `ttn-integration` and `mqtt-integration` | y |

## Service `mailer`

| key | comment | optional |
|-----|---------|----------|
| `SENSEBOX_MAILER_CA_CERT` | the certificate of your CA. Server and client should be signed by this CA. See [Certificates for secure inter-service communication](#certificates-for-secure-inter-service-communication) for more information. |  |
| `SENSEBOX_MAILER_SERVER_CERT` | the server certificate |  |
| `SENSEBOX_MAILER_SERVER_KEY` |  the key of the server certificate |  |
| `SENSEBOX_MAILER_SMTP_SERVER` | the smtp server address |  |
| `SENSEBOX_MAILER_SMTP_PORT` | the smtp server port |  |
| `SENSEBOX_MAILER_SMTP_USER` | the smtp server user |  |
| `SENSEBOX_MAILER_SMTP_PASSWORD` | the smtp server password |  |
| `SENSEBOX_MAILER_FROM_DOMAIN` | the domain you are sending from |  |
| `SENSEBOX_MAILER_HONEYBADGER_APIKEY` | api key for honeybadger error reporting | y |

## Service `ttn-integration`

| key | comment | optional |
|-----|---------|----------|
| `ENV` | should be set to `prod` in production. |  |
| `OSEM_dbuser` | the database user to connect to your mongodb, should be the same in services `api`, `mongo` and `ttn-integration` | y |
| `OSEM_dbuserpass` | the password for the mongodb user, should be the same in services `api`, `mongo` and `ttn-integration` | y |
| `OSEM_dbhost` | the hostname or ip of the mongodb instance, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbport` | the port of the mongodb instance, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbauthsource` | the authSource of the mongodb instance, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbdb` | the name of the mongodb database, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbconnectionstring` | alternative method to specify the mongodb connection string. If you specify this, `dbuser`,`dbhost` and `dbpass` will be ignored | y |
| `TTN_OSEM_PORT` | the port on which the ttn integration runs | y |
| `TTN_OSEM_loglevel` | loglevel for the ttn integration. `info`, `warn`, `error` | y |

## Service `mqtt-integration`

| key | comment | optional |
|-----|---------|----------|
| `NODE_ENV` | should be set to `production` in production. |  |
| `NODE_CONFIG` | JSON string containing the configuration of the [`mqtt-osem-integration`](https://github.com/sensebox/mqtt-osem-integration) service |  |

## Service `backup`

| key | comment | optional |
|-----|---------|----------|
| `DUPLY_GPG_KEY` | gpg key id or 'disabled' |  |
| `DUPLY_GPG_PW` | gpg password for the key | y |
| `DUPLY_TARGET_URL` | duplicity target url. See [duplicity man page](http://duplicity.nongnu.org/duplicity.1.html) | |
| `DUPLY_TARGET_USER` | user for accessing the target url | y |
| `DUPLY_TARGET_PASS` | password for accessing the target url | y |
| `DUPLY_SOURCE` | source folder for backups | |
| `DUPLY_MAXAGE` | age after duplicity deletes old backups | y |
| `DUPLY_MAXFULLBKPAGE` | age after duplicity creates a new full backup instead of a incremental one | y |
| `DUPLY_ACTION` | duply action. See [http://duply.net/wiki/index.php/Duply-documentation](duply documentation) | y |
| `SCHEDULE` | Cron schedule for running the backup | y |
| `SLACK_HOOK_URL` | Slack webhook url for duply post script | y |
| `DUPLY_PRE` | Complete Duply pre script. Use `$$` to escape single `$`. | y |
| `DUPLY_POST` | Complete Duply post script.  Use `$$` to escape single `$`. | y |
