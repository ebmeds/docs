# System requirements

EBMEDS is a collection of services delivered as Docker containers. The system consists of the core EBMEDS services which are stateless, and auxiliary services such as databases for storing settings and logs. Docker was chosen to provide a standardized way of scaling up the solution. The solution is designed to be run in large, multi-node clusters but can be deployed on single servers as well.

## Reference deployment instructions

Docker containers are highly portable and can be deployed in numerous ways. For inexperienced Docker system administrators, Duodecim provides instructions for a small reference installation with sensible defaults. These instructions are in the Github repository [ebmeds-docker](https://github.com/ebmeds/ebmeds-docker).

## Example single-node server

If you are in a hurry and don't want to read the details below, here is a server configuration that should work for a small installation where no clustering is needed:

* CPU: 2 x Intel i5-7600
* RAM: 8 GB
* Disk space: 256 GB
* OS: CentOS 7.4 (with latest patches)
* Docker: version 18.03.1-ce

## Software requirements

### Docker

The minimum requirement is Docker 1.13, but we recommend always using the latest stable version, especially in multi-node clusters. Most Linux distributions have a mechanism for installing Docker straight from Docker Inc's own repositories, which is the recommended way.

Docker comes in the free Community Edition (CE) and the paid-for Enterprise Edition (EE). EBMEDS runs on both, although inexperienced Docker admins may find the support channel for Enterprise Edition helpful.

### Operating system

EBMEDS requires Linux. Any of the Linux distributions with the official *Licensed Docker Infrastructure* mark works well, meaning either CentOS, Fedora, Debian or Ubuntu. Please see the [Docker documentation](https://docs.docker.com/install/#server) for more details about specific versions and caveats.

Docker also runs natively on Windows, but note that so-called *Windows containers* are not supported. If you want to run EBMEDS on Windows, you must run Linux in a virtual machine.

### Elasticsearch

The Elasticsearch database is an auxiliary service that is:

* An **optional** location to store application logs
* A **mandatory** location for storing *EBMEDS Population* data

In the reference installation, Elasticsearch is also run as a Docker container inside Docker Swarm, alongside the EBMEDS core services. However, Elasticsearch can also be installed more "traditionally", either on the same server or on a separate one. This may be an attractive option if you have an existing Elasticsearch installation available. Clustering is also easier to handle outside the Docker Swarm for high availability setups.

EBMEDS requires the 6.2.x version of Elasticsearch. See [the Elasticsearch documentation](https://www.elastic.co/guide/en/elasticsearch/reference/6.2/index.html) for more details on operation and installation.

As mentioned, Elasticsearch is optional for storing application logs. In the reference installation, logs are stored here. But all the application logs are routed through [Logstash](https://www.elastic.co/products/logstash), which can be configured to store the data [in a multitude of ways](https://www.elastic.co/guide/en/logstash/6.2/output-plugins.html), including as plain files on disk.

For population analysis, Elasticsearch (and Kibana) is still mandatory.

## Hardware requirements

The hardware requirements of course rely on the scale of the installation. Below, we have listed recommendations for a single cluster node (or just a single server) when Elasticsearch is used, as per the reference installation. Should Elasticsearch be irrelevant for you, the changes in hardware requirements are noted separately below.

### CPU

Any modern multicore x86_64 CPU is accepted. For performance, multiple cores are more important than higher clock rates.

* Minimum requirement: **8 cores, ~3 GHz**. *Example*: 2 x Intel i5-7600 (2 x 4 cores)
* Recommended: **16 cores, ~3 GHz**. *Example*: 2 x Intel i7-7820X (2 x 8 cores)

### RAM

* Minimum requirement: 8 GB (4 GB without Elasticsearch)
* Recommended: 16 GB (8 GB without Elasticsearch)

### Disk space:

The main things that take up disk space are:

* Database contents, i.e. logs and population analysis data
* Docker images, old versions can be saved and rollbacks performed if wanted.

If Elasticsearch is used, there should be a monitoring and archiving strategy for the data. Of course, this goes for any kind of logging solution.

* Minimum requirement: 256 GB (128 GB without Elasticsearch)
* Recommended: 512 GB (128 GB without Elasticsearch)
