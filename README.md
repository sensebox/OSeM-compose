# openSenseMap in Docker Compose

This repository the `docker-compose.yml` how [opensensemap.org](https://opensensemap.org) is run.

# What you need

- [Docker](https://docs.docker.com/engine/understanding-docker/) and [Docker Compose](https://docs.docker.com/compose/overview/)
- The [Local Persist Volume Plugin for Docker](https://github.com/CWSpear/local-persist)
- A server
- a web domain with dns control (you need the subdomains `www` and `api`)

# How to run

After you installed the software listed above, created the subdomains and placed the `docker-compose.yml` on your server, you need to configure some values in said `docker-compose.yml`. Place these below their respective services `environment` key.

Afterwards you can start everything with `docker-compose up -d`

| key | service | comment | optional |
|---------------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| `WEB_DOMAIN` | web | your domain without protocol. also no `www` |  |
| `API_DOMAIN` | web | normally `api.yourdomain.tld` |  |
| `ISSUER_ADDRESS` | web | your email or `off` if you don't want a [letsencrypt](https://letsencrypt.org/) tls certificate |  |
| `USE_STAGING_CA` | web | if `true` a test-certificate will be issued. Otherwise omit this key | y |
| `API_URL` | osem-static | The url of your api WITH protocol, e.g. `https://api.yourdomain.tld` |  |
| `OCPU_URL` | osem-static | the url of your OpenCPU deployment. ([https://github.com/sensebox/inteRsense](https://github.com/sensebox/inteRsense)). Otherwise omit this key | y |
| `MAPTILES_URL` | osem-static | tiles url for your map | y |
| `OSEM_dbuser` | api, mongo | the database user to connect to your mongodb, also configure this in the `mongo` service |  |
| `OSEM_dbpass` | api, mongo | the password for the mongodb user, also configure this in the `mongo` service |  |
| `OSEM_dbhost` | api | mongodb database host. Must correspond with the `mongo:` service in the `docker-compose.yml` |  |
| `OSEM_targetFolder` | api | if you are using the `osem-caddy` image for your frontend, leave as specified |  |
| `OSEM_imageFolder` | api | if you are using the `osem-caddy` image for your frontend, leave as specified |  |
| `OSEM_slack_url` | api | Slack Webhook url. Leave empty if you don't want slack notifications of the api | y |
| `OSEM_measurements_post_domain` | api | the plain domain of your openSenseMap instance. Will be used in the arduino sketches. no `www` and no protocol. should correspond to `WEB_DOMAIN` |  |
| `OSEM_email_host` | api | smtp email host. if omitted the api won't send mails | y |
| `OSEM_email_port` | api | smtp email host port | y |
| `OSEM_email_secure` | api | `true` or `false` for tls | y |
| `OSEM_email_user` | api | smtp email user | y |
| `OSEM_email_pass` | api | smtp email password | y |
| `OSEM_email_fromName` | api | fromName of the emails | y |
| `OSEM_email_fromEmail` | api | from email address  | y |
| `OSEM_email_replyTo` | api | email replyTo address | y |
| `OSEM_email_subject` | api | subject of the email | y |
| `OSEM_dbconnectionstring` | api | alternative method to specify the mongodb connection string. If you specify this, `dbuser`,`dbhost` and `dbpass` will be ignored | y |
