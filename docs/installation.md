# Installation

The main steps to installing a minimal working deployment of EBMEDS are the following:

* Install prerequisites
* Get a Docker registry username from Duodecim
* Configure the service
* Start up the service

These steps are given in more detail below.

## Install prerequisites

EBMEDS only requires Docker to run. Docker runs on Linux, Windows and Mac, but Linux is recommended, since Docker runs Linux internally and thus running it on other platforms incurs a small performance hit. Note that Docker supports running Windows internally on newer versions of Windows Server, but this is not supported by EBMEDS.

It is also recommended to have `git` available on the server, for downloading the deployment package and keeping track of your local changes.

### Install Docker
The installation instructions for Docker itself can be found on e.g. [Docker's site](https://www.docker.com). We support version 1.13 or newer, and recommend the latest stable version. We warmly recommend to get well acquainted with Docker, many of the configuration steps below are more Docker specific than EBMEDS specific.

### Download ebmeds-docker repository
Duodecim provides the `ebmeds-docker` package, which is freely available and contains a pre-configured setup for a minimal installation of EBMEDS. Minimal in this case means a single-server setup for basic usage. The setup includes

- Four running copies of the EBMEDS analytical engine
- The services Logstash and Elasticsearch for storing log messages and (optionally) entire request bodies
- The Kibana service for inspecting the above data
- Redis for storing user configuration and for caching optimizations

The package is downloaded by running the command

```bash
# Get a copy of the EBMEDS Docker configuration
git clone https://github.com/ebmeds/ebmeds-docker.git

# We will be working from this directory for the rest of this installation guide
cd ebmeds-docker
```

This repository does *not* contain the Docker images themselves, only startup scripts and configuration files. It also contains a sample `docker-compose.yml` file to get a Docker Swarm up and running with minimal effort. This file can be used as inspiration for more advanced setups.

## Configure the services

EBMEDS consists of a number of services:

* api-gateway
* format-converter
* engine
* clinical-datastore
* elastichsearch *(third-party software)*
* kibana *(third-party software)*
* logstash *(third-party software)*
* redis *(third-party software)*

These services are pre-configured to work together, however some settings need to be decided upon by the system administrator. The settings can be found in `config.env`:

* `LOG_LEVEL` may be handy to set to `debug` while setting up. Return it to `info` or `warn` for production
* `ES_JAVA_OPTS` are options for Elasticsearch, follow the instructions in the comments
* `LS_JAVA_OPTS` are options for Logstash, follow the instructions in the comments
* `xpack.*` advanced, paid for features of Elasticsearch that are not part of the standard package. Consult the Elastic Stack documentation to see if it is something you need.

## Get a Docker registry username from Duodecim

If you don't already have it, you need a Duodecim-supplied username and password to be able to download the EBMEDS Docker images, which reside in a private repository at `quay.io`. The username is in the form `duodecim+yourname`.

### Start the service

EBMEDS' Docker images are stored in a repository on quay.io. Vendor organizations are provided with a login username and password. The credentials are asked on each run of the `start.sh` command, which quickly gets cumbersome. Instead, the credentials can be passed as environment variables `DOCKER_LOGIN` and `DOCKER_PASSWORD`, like so:

```bash
DOCKER_LOGIN=duodecim+example DOCKER_PASSWORD=example sudo -E sh start.sh
```

### Configure the service

The main configuration files are `config.env` for system configuration, and `users.json` for configuring the actual features of EBMEDS. More in this on the [configuration page](configuration.md).

### Stopping or updating the service

Stopping is simply done by running the `stop.sh` script, potentially with super-user privileges. In other words,

```bash
sudo sh stop.sh
```

while updating the service (e.g. if you want to deploy a new version or change the configuration) is done by repeating the command given in *Start the service*.

## File system access

Docker containers cannot per default persist data to disk, i.e. all changes to the container file system are lost when a container is shut down. Therefore, Docker must be explicitly told when it is allowed to read from or write to the filesystem on the server.

Reading files from outside the container (in practice, we are talking about configuration files) are done by *mounting* the files into the container. Examples of this can be seen in `docker-compose.yml` under the `volumes` property of some of the services.

Writing to the filesystem outside the container is done by mounting so-called *volumes* into the containers. Changes to the files inside the containers are then reflected on the filesystem of the server itself. The volumes are usually physically located in `/var/lib/docker/volumes`, but this varies from system to system. In any case, wherever these volumes are kept, sufficient disk space should be reserved.

<aside class="notice">
Also note that the Docker daemon itself will store pulled images internally. These images are not removed by default when new versions are pulled, to support roll-backs of updates that are not working etc. The system administrator should keep in mind that the images will, in time, take up a lot of disk space, and steps should be taken to remove unused Docker images. These are also kept in **/var/lib/docker**
</aside>

### Advanced deployment

There are many advanced features of Docker that can be used to make the service more failsafe. This includes backups, monitoring, automatic node failure recovery etc. These advanced features should be implemented by a competent DevOps professional and is not covered in this documentation.

## Verifying the installation

To see that the installation is succesful, perform the checklist below. $HOST is the hostname of the server running the Swarm. It may also be localhost:

* Make a HTTP GET to $HOST:3001/status, you should receive the reply "OK".
* Make a HTTP POST to $HOST:3001/xml, with the payload of an EBMEDS XML request. You should receive an XML response.
* Open up Kibana at $HOST:5601 and add the index `ebmeds-logs`, if not already added.
  * In the "Discover" tab, check the `ebmeds-logs` index to see that logging from the various containers is working.
* Use the command `docker ps -a` (`sudo` may be required) to check that all the services stay up for more than a couple of minutes. If not, there may be a file permission problem or you are running out of memory. `docker logs` should give you more clues.