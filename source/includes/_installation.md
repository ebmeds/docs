# Installation

The main steps to installing EBMeDS 2.0 are the following:

* Install prerequisites
* Get a Docker registry username from Duodecim
* Pull the Docker images
* Configure the individual Docker images
* Configure the Docker Swarm
* Start up the Swarm

These steps are given in more detail below.

## Install prerequisites

EBMeDS 2.x only requires Docker. Docker runs on Linux, Windows and Mac, but Linux is recommended, since Docker runs Linux internally and thus running it on other platforms incurs a small performance hit. Note that Docker supports running Windows internally on newer versions of Windows Server, but this is not supported by EBMeDS.

### Install Docker
The installation instructions for Docker itself can be found on e.g. [Docker's site](https://www.docker.com). We support version 1.12+.

### Install Node.js (optional)
You will need Node.js to run the `npm [...]` commands below. You can also run docker commands manually, removing the need for Node. The commands are defined in the file `package.json`.

### Download ebmeds-docker repository
Download the zip file from [Github](https://github.com/ebmeds/ebmeds-docker) (the "Clone or download" button) or if you have Git installed, run the `git clone` command.

```bash
# Get a copy of the EBMeDS Docker configuration
git clone https://github.com/ebmeds/ebmeds-docker.git
```

This repository does not contain the Docker images themselves, only startup scripts and configuration files. It also contains a sample `docker-compose.yml` file to get a Docker Swarm up and running with minimal effort.

## Get a Docker registry username from Duodecim

If you don't already have it, you need a Duodecim-supplied username and password to be able to download the EBMeDS Docker images, which reside in a private repository at `quay.io`. The username is in the form `duodecim+yourname`.

### Login to quay.io and pull the required images

The built Docker images are stored in a repository on quay.io. Vendor organizations are provided with a login username and password. Developers with access to the EBMeDS Github repos can build the images locally.

### Pull the Docker images

You need the proper Docker images downloaded ("pulled") onto your server before running them. This is true for single-machine servers and for each node in larger clusters.

```bash
# Go to the downloaded ebmeds-docker repository
cd /path/to/ebmeds-docker

# Run script that downloads the correct docker images and tags them
./get-images.sh
```

The `get-images.sh` script will ask for the username/password of the EBMeDS Docker registry located at `quay.io`. These credentials are supplied by Duodecim. It will then pull the appropriate docker images and tag them with the following names:

* engine
* api-gateway
* auth
* coaching
* elastichsearch *(vanilla)*
* kibana *(vanilla)*
* logstash *(vanilla)*

The last three images are the vanilla ELK stack, the rest are custom images.

## Deployment

### Docker 1.13+

```bash
# In the ebmeds-docker root directory:
npm run docker:init    # init Docker Swarm if not already running.
npm run docker:start

# to stop
npm run docker:stop

# and to restart:
npm run docker:restart  # same as stop + start

# to stop the entire Swarm
npm run docker:deinit   # not needed in most cases
```

Assuming that the Docker images are available on the machine, there are a bunch of NPM scripts in `ebmeds-docker` that can start and stop a simple Docker Swarm configuration. `docker:init` starts up a Docker Swarm with one member: the local machine. It is also the master of the swarm. The command outputs an ID number that other machines can use to join the swarm, for multi-node cluster support. See the Docker documentation for more details on this. The `docker:start` and `docker:stop` commands start and stop the containers themselves. They are configured in `docker-compose.yml`.

### Docker 1.12

```bash
# Example of how to start a service manually
docker service create \
  --name api-gateway \
  -e LISTEN_PORT=3001 \
  -e ENGINE_URL=http://engine:3002/dss.asp?mode=test \
  --network ebmedsnet \
  --publish 3001:3001 \
  --replicas=3 \
  --update-delay 10s \
  --update-parallelism 1 \
  api-gateway
```

The oldest supported version of Docker does not have support for Docker Compose files when used together with Docker Swarm. Therefore the command `npm run docker:start` will not work, and the `docker-compose.yml` file must be transformed into e.g. shell scripts that set up the services manually. For example, starting the `api-gateway` service manually (see the example) is a matter of setting environment variables, publishing a port, setting the number of replicas and optionally setting some update settings for Docker's rolling updates.

Before this the swarm must be initialized and the network ebmedsnet created (in this example). Also note that the environment variables used in this example are the ones found in `api-gateway/config.env`.

## Configuration

### Environment variables

All configuration of the EBMeDS services (except the ELK stack) is done through environment variables. These are defined in the `ebmeds-docker` directory at `<image-name>/config.env`, i.e. each container is configured separately. The `.env` files contain comments describing the different options.

### Default ports

The containers inside the Swarm are configured to listen to the following ports per default:

* api-gateway: 3001
* engine: 3002
* coaching: 3003
* elasticsearch: 9200 (REST API), 9300 (node communication in clusters)
* logstash: 5000 (TCP input)
* kibana: 5601

<aside class="notice">
The above ports are not accessible outside of the swarm, except for <code>api-gateway</code> at port 3001 and <code>kibana</code> at port 5601. Port 3001 should therefore be open for general EBMeDS usage (see #Usage) and port 5601 is for log data analysis using the web UI in Kibana, which should be accessible only by trusted sources.
</aside>

### File system access

Docker containers cannot per default persist data to disk, i.e. all changes to the container file system are lost when the container is shut down. Therefore, to be able to save data between restarts, the host system running Docker must mount its own directories on top of the file system inside of Docker, to "catch" the saved data. The table below lists the folders that are configured to be mounted onto various Docker containers ($ROOT is the path to the `ebmeds-docker` project):

| Default host directory (configurable) | Internal Docker directory     | Description |
|---------------------------------------|-------------------------------|-------------|
| $ROOT/elasticsearch/data       | /usr/share/elasticsearch/data | The place where the Elasticsearch DB data lives (may get very large) |
| $ROOT/logstash/pipeline        | /usr/share/logstash/pipeline  | How Logstash should process the data flowing through it |
| $ROOT/logstash/queue          | /usr/share/logstash/data/queue    | Instead of storing the input queue in memory, persist it to disk to avoid data loss |
| $ROOT/logstash/config          | /usr/share/logstash/config    | General configuration for the Logstash server process (usually no need to edit this) |
| $ROOT/kibana/config/           | /usr/share/kibana/config      | General configuration for the Kibana server process (usually no need to edit this) |

Note that the permissions must be set correctly for the host folders: the UID and GID should match the UID and GID that the user inside Docker has (which per default is 1000/1000). SELinux labels can also be used to avoid getting permission errors. Permissions on Windows/OSX will behave differently.

<aside class="notice">
Also note that the Docker daemon itself will use the file system to store pulled images internally. These images are not removed by default when new versions are pulled, to support roll-backs of updates that are not working etc. The system administrator should keep in mind that the images will, in time, take up a lot of disk space, and steps should be taken to remove unused Docker images.
</aside>

### Advanced deployment

There are many advanced features of Docker that can be used to make the service more failsafe. This includes backups, monitoring, automatic node failure recovery etc. These advanced features should be implemented by a competent DevOps professional and is not covered in this documentation.

## Verifying the installation

To see that the installation is succesful, perform the checklist below. $HOST is the hostname of the server running the Swarm. It may also be localhost:

* Make a HTTP GET to $HOST:3001/status, you should receive the reply "OK".
* Make a HTTP POST to $HOST:3001/xml, with the payload of an EBMeDS XML request. You should receive an XML response.
* Open up Kibana at $HOST:5601 and add the indexes `logstash` and `engine`, if not already added.
  * In the "Discover" tab, check the `logstash` index to see that logging from the various containers is working.
  * In the "Discover" tab, check the `engine` index to see that logging of request/response pairs is working (this kind of logging can be turned off).
* On the host's filesystem, check that `$ROOT/elasticsearch/data` and `$ROOT/logstash/queue` (or what you have configured them to be) are being populated with files. If not, the folder mounts are not working, and any data saved to the Elasticsearch database will disappear when the `elasticsearch` container is stopped.