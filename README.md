# openSenseMap in Docker Compose

This repository the `docker-compose.yml` how [opensensemap.org](https://opensensemap.org) is run.

# What you need

- [Docker](https://docs.docker.com/engine/understanding-docker/) and [Docker Compose](https://docs.docker.com/compose/overview/)
- The [Local Persist Volume Plugin for Docker](https://github.com/CWSpear/local-persist)
- A server
- a web domain with dns control (you need the subdomains `www` and `api`)

# How to run

After you installed the software listed above, created the subdomains and placed the `docker-compose.yml` on your server, you need to configure some values in said `docker-compose.yml`. Place these below their respective services `environment` key.

Afterwards you can start everything with `docker-compose up -d`. This repository also contains some bash scripts to deploy updated images.

| key | service | comment | optional |
|---------------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `WEB_DOMAIN` | web | your domain without protocol. also no `www` |  |
| `API_DOMAIN` | web | normally `api.yourdomain.tld` |  |
| `ISSUER_ADDRESS` | web | your email or `off` if you don't want a [letsencrypt](https://letsencrypt.org/) tls certificate |  |
| `USE_STAGING_CA` | web | if `true` a test-certificate will be issued. Otherwise omit this key | y |
| `API_URL` | osem-static | The url of your api WITH protocol, e.g. `https://api.yourdomain.tld` |  |
| `MAPTILES_URL` | osem-static | tiles url for your map | y |
| `OSEM_dbuser` | api, mongo | the database user to connect to your mongodb, also configure this in the `mongo` service |  |
| `OSEM_dbpass` | api, mongo | the password for the mongodb user, also configure this in the `mongo` service |  |
| `OSEM_dbhost` | api | mongodb database host. Must correspond with the `mongo:` service in the `docker-compose.yml` |  |
| `OSEM_targetFolder` | api | if you are using the `osem-caddy` image for your frontend, leave as specified |  |
| `OSEM_imageFolder` | api | if you are using the `osem-caddy` image for your frontend, leave as specified |  |
| `OSEM_slack_url` | api | Slack Webhook url. Leave empty if you don't want slack notifications of the api | y |
| `OSEM_measurements_post_domain` | api | the plain domain of your openSenseMap instance. Will be used in the arduino sketches. no `www` and no protocol. should correspond to `WEB_DOMAIN` |  |
| `OSEM_honeybadger_apikey` | api | api key of honeybadger.io error reporting |  |
| `OSEM_mailer_url` | api | internal url of the mailer. `https://mailer:3924/` for example | |
| `OSEM_mailer_cert` | api | certificate to communicate with the mailer. see [https://github.com/sensebox/sensebox-mailer](sensebox-mailer) for more information. | |
| `OSEM_mailer_key` | api | key for the certificate | |
| `OSEM_mailer_ca` | api | signing ca for your certificate | |
| `OSEM_mailer_origin` | api | origin of your openSenseMap installation. With protocol. | |
| `OSEM_dbconnectionstring` | api | alternative method to specify the mongodb connection string. If you specify this, `dbuser`,`dbhost` and `dbpass` will be ignored | y |
| `ENV` | api | should be set to `prod` to enable https checking in the api. | y |
| `SENSEBOX_MAILER_CA_CERT` | mailer | the certificate of your CA. Server and client should be signed by this CA see [https://github.com/sensebox/sensebox-mailer](sensebox-mailer) for more information. | y |
| `SENSEBOX_MAILER_SERVER_CERT` | mailer | the server certificate | y |
| `SENSEBOX_MAILER_SERVER_KEY` |  mailer | the key of the server certificate | y |
| `SENSEBOX_MAILER_SMTP_SERVER` | mailer | the smtp server address | y |
| `SENSEBOX_MAILER_SMTP_PORT` | mailer | the smtp server port | y |
| `SENSEBOX_MAILER_SMTP_USER` | mailer | the smtp server user | y |
| `SENSEBOX_MAILER_SMTP_PASSWORD` | mailer | the smtp server password | y |
| `SENSEBOX_MAILER_FROM_DOMAIN` | mailer | the domain you are sending from | y |
| `SENSEBOX_MAILER_HONEYBADGER_APIKEY` | mailer | api key for honeybadger error reporting |  |
