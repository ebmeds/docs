# Components

![EBMeDS architecture](images/EBMeDS-architecture.png)

When fully deployed, the EBMeDS solution includes the components pictured above. Each component is a Docker container, inside a Docker Swarm. Any of these components can be replicated across several machines, as performance and availability needs dictate. Docker Swarm performs an automatic round-robin load balancing on every network request done to any container with multiple instances.

## api-gateway

Github: [](https://github.com/ebmeds/api-gateway)

The API gateway is the access point from the outside world. It mostly acts as a request broker, forwarding requests to the appropriate containers, usually the engine. At the moment, it also provides the translation services between FHIR and the EBMeDS native XML format. Another output option is a custom internal JSON format as used by the apps

### Input

FHIR requests, EBMeDS XML requests.

### Output

FHIR, EBMeDS XML, custom JSON formats.

### Future plans

1. Refactor FHIR format conversion into a separate service.
2. Implement user authentication.

## engine

The main service, performing most of the calculations when performing decision support. Takes patient XML data as an input, and outputs data to aid in clinical decision making. Most notably, text-based reminder messages.

### Input

EBMeDS XML.

### Output

EBMeDS XML, custom JSON formats.

## coaching

An ODA-specific container, may or may not be present in the future. A simple REST interface providing access to coaching programs produced by Duodecim. These programs are given in FHIR STU3 form, and contain a number of messages that are to be sent to a patient at set times to aid in e.g. weight loss, cutting down on alcohol consumtion etc.

### Input

HTTP REST requests.

### Output

FHIR

## diagnosis-specific-view

A UI providing a specialised view of the results obtained from the engine, for a specific patient. This container works like a kind of proxy to the engine: instead of sending the XML with patient data to the engine, it is sent to this container. The request is sent onward to the engine with some special flags, making the engine produce a specialised JSON format, that this container renders as HTML for the user. The JSON can also be sent directly to the user, should he want to build his own UI.

### Input

EBMeDS XML

### Output

HTML

## comprehensive-medication-review

Similar to diagnosis-specific-view, this is another specialised UI view, focusing on medication.

### Input

EBMeDS XML

### Output

HTML

## elasticsearch

A standard Elasticsearch container, i.e. a database. Used for logging by all other containers (via logstash). Also, the engine saves request/response pairs to a separate index for debugging and statistics.

### Indices

* *logstash*: app logs from all other containers
* *engine*: request/response messages

## logstash

A standard Logstash container. Logs from all other containers are sent here, where they are queued and tagged with some extra metadata.

## kibana

A standard Kibana container. Kibana works as a web UI for inspecting logs or any other elasticsearch data. At the moment Kibana in EBMeDS is only geared towards use by system administrators and developers, but there is some demand for users to be able to access their own logs. It should be noted that with standard settings, Elasticsearch and Kibana have no user or namespace support, everything is global. This can be changed by getting an X-Pack license, which is costly.

# Supporting tools

There are a number of tools external to the EBMeDS deployment that is used primarily by Duodecim to produce content. These are hosted by Duodecim.

## Script editor

URL: [](http://www.ebmeds.org/script_editor.asp?mode=framesets)

Web-based UI for editing engine scripts (i.e. rulesets). Individual scripts can be set to apply to e.g. certain organizations, certain countries/languages or certain events. The text reminders are also defined here, as well as their translations.

<aside class="notice">
This script editor will be replaced by a new version soon.
</aside>

### Compilation

The scripts and their accompanying data is compiled from the script editor into text files that can be read by the engine. This compilation process also includes "numerical" medical data, i.e. databases of drug interactions etc. Some of this data is bought from other companies, some of it is produced in-house.