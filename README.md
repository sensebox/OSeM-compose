# openSenseMap in Docker Compose

This repository contains the `docker-compose.yml` how [opensensemap.org](https://opensensemap.org) is run. It includes a watchtower image which will periodically checks for and deploys updated images.

# What you need

- [Docker](https://docs.docker.com/engine/understanding-docker/) 1.13.0 or above and [Docker Compose](https://docs.docker.com/compose/overview/) 1.11.0 or above
- A server
- a web domain with dns control (you need the subdomains `www`, `api`, `ingress` and optionally `ttn-integration`)

# How to run

Use the script `create-volumes.sh` to create docker volumes. These will be used by the services specified in `docker-compose.yml`.

After you installed the software listed above, created the subdomains and place the `docker-compose.yml` on your server. You may want to configure some values in a `docker-compose.override.yml`. Configuration happens mainly through `environment` keys.

Afterwards you can start everything with `docker-compose up -d`. This repository also contains some bash scripts to deploy updated images.

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
| `ENV` | should be set to `prod` to enable https checking in the api. | |
| `OSEM_dbuser` | the database user to connect to your mongodb, should be the same in services `api`, `mongo` and `ttn-integration` | y |
| `OSEM_dbuserpass` | the password for the mongodb user, should be the same in services `api`, `mongo` and `ttn-integration` | y |
| `OSEM_dbhost` | the hostname or ip of the mongodb instance, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbport` | the port of the mongodb instance, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbauthsource` | the authSource of the mongodb instance, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbdb` | the name of the mongodb database, should be the same in services `api` and `ttn-integration` | y |
| `OSEM_dbconnectionstring` | alternative method to specify the mongodb connection string. If you specify this, `dbuser`,`dbhost` and `dbpass` will be ignored | y |
| `OSEM_targetFolder` | where the api puts sketches for users | y |
| `OSEM_imageFolder` | if you are using the `osem-caddy` image for your frontend, leave as specified | y |
| `OSEM_logFolder` | where the api puts error logs | y |
| `OSEM_slack_url` | Slack Webhook url. Leave empty if you don't want slack notifications of the api | y |
| `OSEM_api_base_domain` | the domain name of your openSenseMap-api instance. |  |
| `OSEM_api_protocol` | the protocol of your user facing api instance. Either `http` or `https`. | y |
| `OSEM_api_url` | Generated from the base_domain and protocol | y |
| `OSEM_api_measurements_post_domain` | the plain domain of your openSenseMap ingress domain. Will be used in the arduino sketches. no `www` and no protocol. |  |
| `OSEM_honeybadger_apikey` | api key of honeybadger.io error reporting | y |
| `OSEM_mailer_url` | internal url of the mailer. `https://mailer:3924/` for example | y |
| `OSEM_mailer_cert` | certificate to communicate with the mailer. see [https://github.com/sensebox/sensebox-mailer](sensebox-mailer) for more information. | y |
| `OSEM_mailer_key` | key for the certificate | y |
| `OSEM_mailer_ca` | signing ca for your certificate | y |
| `OSEM_mailer_origin` | Generated from base_domain and protocol. origin of your openSenseMap installation. With protocol. | y |
| `OSEM_jwt_secret` | Secret string for JWT generation. Should be at least 32 characters long | |
| `OSEM_jwt_algorithm` | Default: `HS256`. Algorithm used for JWT generation | y |
| `OSEM_jwt_validity_ms` | Default: `360000` (1 hour). How long a JWT should be valid in milliseconds | y |
| `OSEM_jwt_issuer` | Generated from base_domain and protocol. JWT issuer field | y |
| `OSEM_refresh_token_secret` | Secret string for refresh token generation. Should be at least 32 characters long | |
| `OSEM_refresh_token_algorithm` | Default: `sha256`. Algorithm used for refresh token generation | y |
| `OSEM_refresh_token_validity_ms` | Default: `60480000` (1 week). How long a refresh token should be valid in milliseconds | y |
| `OSEM_password_min_length` | Default: `8`. Minimal count of characters needed for passwords | y |
| `OSEM_password_salt_factor` | Default: `13` when `ENV=prod` is specified. bcrypt password salt factor | y |

## Service `mongo`

| key | comment | optional |
|-----|---------|----------|
| `OSEM_dbuser` | the database user to connect to your mongodb, should be the same in services `api`, `mongo` and `ttn-integration` | y |
| `OSEM_dbuserpass` | the password for the mongodb user, should be the same in services `api`, `mongo` and `ttn-integration` | y |

## Service `mailer`

| key | comment | optional |
|-----|---------|----------|
| `SENSEBOX_MAILER_CA_CERT` | the certificate of your CA. Server and client should be signed by this CA see [https://github.com/sensebox/sensebox-mailer](sensebox-mailer) for more information. | y |
| `SENSEBOX_MAILER_SERVER_CERT` | the server certificate | y |
| `SENSEBOX_MAILER_SERVER_KEY` |  the key of the server certificate | y |
| `SENSEBOX_MAILER_SMTP_SERVER` | the smtp server address | y |
| `SENSEBOX_MAILER_SMTP_PORT` | the smtp server port | y |
| `SENSEBOX_MAILER_SMTP_USER` | the smtp server user | y |
| `SENSEBOX_MAILER_SMTP_PASSWORD` | the smtp server password | y |
| `SENSEBOX_MAILER_FROM_DOMAIN` | the domain you are sending from | y |
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

## Service `backup`

| key | comment | optional |
|-----|---------|----------|
| `DUPLY_GPG_KEY` | gpg key id or 'disabled' |  |
| `DUPLY_GPG_PW` | gpg password for the key | y |
| `DUPLY_TARGET_URL` | duplicity target url. See [http://duplicity.nongnu.org/duplicity.1.html](duplicity man page) | |
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
