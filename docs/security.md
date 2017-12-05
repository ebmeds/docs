# Security

## Network security

### HTTP/HTTPS

By default, EBMeDS 2.0 serves its API over HTTP, with no encryption. It is, however, strongly recommended to enable HTTPS or use a reverse proxy like [nginx](https://nginx.org/en/) to provide SSL termination. There are two potentially public service that is good to protect: `api-gateway` and `kibana`.

#### Enabling native HTTPS for `api-gateway`

HTTPS is enabled by setting the environment variable `HTTP_MODE` to `https` when launching the `api-gateway` container. In addition to this, the system administrator must obtain/generate a .key and .crt file and bind mount them onto the container so they may be read by the `api-gateway` service.

Inside the container, the path to the aforementioned key and certificate files are by default `ssl/server.key` and `ssl/server.crt` but may be configured with the environment variables `HTTPS_KEY_PATH` and `HTTPS_CERT_PATH`, respectively. The path can be absolute, or (like in the default case) relative to the execution directory.

As an example, when starting the `api-gateway` service, it can be done like this:

```bash
# bind mount the .key and .crt files to match the default container-internal ssl/server.* path
docker run -d -it --name api-gateway -e HTTP_MODE=https -v path/to/generated.key:ssl/server.key:ro -v path/to/generated.crt:ssl/server.crt:ro api-gateway:latest
```

Note that if `api-gateway` is clustered onto several nodes, the files must be present on each server, either copied or shared over a network file system.

#### Enabling native HTTPS for `kibana`

It is not recommended to open up the log viewing UI `kibana` for public use due to data sensitivity concerns. In any case, however Kibana is run, it is usually a good idea to encrypt the traffic. Kibana is an open source project with flexible configuration options, SSL being one of them. SSL configuration ([](https://www.elastic.co/guide/en/kibana/5.6/production.html#enabling-ssl)) is done similarly to `api-gateway`, i.e. SSL is turned on and .key and .crt files are provided to the service. In this case, it is not done by environment variables but the Kibana configuration file. In the `ebmeds-docker` package, this is found in `kibana/config/kibana.yml`.

### Authentication (partially implemented)

EBMeDS 2.0 handles authentication by a HTTP bearer token. This token must be included in the header of all requests to the service. EBMeDS can be configured to:

1. Accept all traffic, without a token.
2. Authenticate traffic using a single, global token.
3. (**To be implemented**) Authenticate traffic using a multitenancy approach, where each user has his own token. This also enables per-user configuration of the response.

## Patient data security and liability

EBMeDS operates with patient data, so data security and anonymity is paramount. EBMeDS has no need for any personally identifying data like names or social security numbers. The only biographical information used is age and gender, which is sent in addition to the clinical data (diagnoses, medication etc.) itself. However, it is up to the users of the EBMeDS service to ensure that no explicitly identifying information is sent to EBMeDS. Duodecim accepts no liability should e.g. social security numbers be present in the request data.

The data security model is simple insofar as EBMeDS is completely stateless. In other words, there is no direct way of connecting the data in a request with any earlier requests. This also means that each request must contain all the data required for that particular CDS context.

### Cluster security

EBMeDS is a microservice architecture, meaning that the EBMeDS service in general consists of smaller services that communicate internally with each other. EBMeDS can be run on a single machine or clustered over multiple servers. The underlying platform is Docker Swarm, which has [the following network security model](https://docs.docker.com/engine/userguide/networking/overlay-security-model/).

In short, if EBMeDS is clustered onto multiple machines, intra-service communication may send patient data "over the wire". This traffic is unencrypted by default. It is up to the system administrator to ensure that communication between cluster nodes is secure, especially if the cluster is located in multiple data centers. Alternatively encryption of the entire Swarm overlay network can be enabled in Docker, although this is bad for performance.

### Logging

The one place where patient data may be stored is the service's logs. EBMeDS internally runs the so-called "ELK stack" (Elasticsearch, Logstash, Kibana). In other words, all logs are stored in an Elasticsearch database. Logging is done in two ways: regular service event logs, and logging of request/response data, i.e. patient data. Again, once the data is logged, it is up to the system administrator to store it and its backups in a secure fashion.

#### Request/response logging

EBMeDS may be configured to log the request data, i.e. patient data, together with the resulting response data structure. This is done partially for debugging purposes, partially for liability purposes (if some user requires a certain period of traceability for all decision support requests). The request/response data is also useful for statistical reasons, and some services utilizing this log data has already cropped up.

This type of logging can naturally be turned off completely.

#### Service event logging

Regular "system logs" from the internal microservices, interesting mainly for system administrators and developers. All services use the [Bunyan logging library](https://github.com/trentm/node-bunyan) which in turn sends the logs to Logstash, and finally they end up in Elasticsearch. Bunyan, like so many other logging libraries, has the concept of *log levels*, i.e. the quantified importance of a particular log message. In normal operation, logging is only done on the `info` log level, meaning that the levels `info`, `warn`, `error`, `fatal` actually end up in the log database.

**NOTE**: If the log level is set lower than `info`, i.e. if it is set to `debug` or `trace`, there may be some logging of patient data, in the form of internal data structures that are displayed in the logs. Do not use these log levels in production, at least not if you want to avoid storing patient data.



# Error handling

EBMeDS 2.0 uses standard HTTP error codes in its API. In addition to this, a JSON body is returned with some additional information, if available.

Example:

```json
{
  "statusCode": 400,
  "message": "Validation error: QuestionnaireResponse did not validate against Questionnaire: [more info]",
  "code": 'validation',
}
```

* `statusCode`: The same numerical HTTP error code as in the HTTP headers.
* `message`: A human-readable error message.
* `code` (**optional**): A short string describing special error types, for errors with a definite meaning to the caller. Is not necessarily present in all error messages. The available types are found below.

## Error types

In addition to the HTTP status code, some errors may have a more specific type attached to it. The current list of types is:

* `validation`: The user sent a request that failed validation in some way.
* `questionnaire-deprecated`: The entire questionnaire has been removed from production and should not be used.
* `questionnaire-version-deprecated`: This specific version of the questionnaire has been removed from production, please use a newer version.

## Retrying requests

As a general rule of thumb, 4xx errors require some action on the calling side, while 5xx errors are server-side. For 5xx errors, especially HTTP error 503 (service busy/unavailable), it is prudent to retry the request after a short wait, in case the error is transient in nature.


