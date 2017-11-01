# FHIR STU3 API

## Getting started

EBMeDS can be used with the [HL7 FHIR STU3](https://www.hl7.org/fhir/STU3/) format. The main unit of information in FHIR is the *resource*, which is a JSON object with a particular type. FHIR can also be expressed in XML form, but this is not supported by EBMeDS.

One can interact with EBMeDS using FHIR in the following ways:

* [Calling decision support](cds-hooks.md): We use the [CDS Hooks](http://cds-hooks.org) standard as the communication model.
* [Custom REST API](custom-rest.md): We provide a REST interface to retrieve static FHIR resources (Questionnaire, PlanDefinition, Goal)

## Communication model

EBMeDS 2.0 is completely stateless and synchronous. In other words, each request to EBMeDS receives a response, and the response contents do not depend on previous requests. This also means that EBMeDS only operates on the data that is present in the request, combining it with the clinical knowledge base produced by Duodecim.

The most common way of using EBMeDS is sending a request containing some clinical data about a patient. After analysis of this data, EBMeDS returns *decision support information*, i.e. messages to be shown to either the patient or a medical professional. Depending on the use case, EBMeDS may also suggest specific actions to be done, actions that are codified using a code system. The caller may then display the messages using a UI of choice, and potentially arrange for automated or semi-automated execution of the attached actions.

The request is given a semantic context using [CDS hooks](cds-hooks.md). Regardless of the context, the general structure of the request and response is the same: one or more FHIR resources. See the [CDS hook catalog](hook-catalog.md) to see which resources are used in which context, and the [FHIR resource listing](resources.md) for more details on the individual resources.

## Versioning

The software in EBMeDS naturally has its own version numbering. In addition, EBMeDS uses a wide range of clinical data sources to make its analyses. This data gets continually updated, so EBMeDS has the concept of *data versions*. All the data is contained internally in its own package, which gets new releases on a regular basis. Each release is versioned with a semver version (e.g. v1.0.2).

Usually the caller will always want to use the most up to date data version, which represents the most current clinical knowledge. This is also the default setting.

In some cases, e.g. when asking for decision support for a filled out questionnaire, the data version is important. This is because the Questionnaire resource, also produced by Duodecim, is part of the data package and therefore also has a data version number. The answers to the Questionnaire are analyzed by a ruleset in the engine (a so-called *script*) and the version of this ruleset must match the version of the Questionnaire, since the questions in different versions of the questionnaire may have changed. So for these kinds of decision support requests, the data version number must be specified.

The wanted version is specified in the CDS hook call in the `context.dataVersion` field. See the [CDS hooks page](cds-hooks.md) for more info.


## Examples

The easiest way to see EBMeDS 2.0 in action is by example. We therefore provide a collection of examples in the [Postman Collection v2.1 format](https://schema.getpostman.com/json/collection/v2.1.0/docs/index.html). These can be imported into the Postman app or explored by hand.

Download the package here: [EBMeDS FHIR examples v1.0](ebmeds-fhir-examples-v1.0.postman_collection.json)