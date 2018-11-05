# FHIR STU3 API

## Getting started

EBMEDS can be used with the [HL7 FHIR STU3](https://www.hl7.org/fhir/STU3/) format. The main unit of information in FHIR is the *resource*, which is a JSON object with a particular type. FHIR can also be expressed in XML form, but this is not supported by EBMEDS.

One can interact with EBMEDS using FHIR in the following ways:

* [Calling decision support](cds-hooks.md): We use the [CDS Hooks](http://cds-hooks.org) standard as the communication model.
* [Custom REST API](custom-rest.md): We provide a REST interface to retrieve static FHIR resources (Questionnaire, PlanDefinition, Goal)

## Communication model

EBMEDS 2.0 is completely stateless and synchronous. In other words, each request to EBMEDS receives a response, and the response contents do not depend on previous requests. This also means that EBMEDS only operates on the data that is present in the request, combining it with the clinical knowledge base produced by Duodecim.

The most common way of using EBMEDS is sending a request containing some clinical data about a patient. After analysis of this data, EBMEDS returns *decision support information*, i.e. messages to be shown to either the patient or a medical professional. Depending on the use case, EBMEDS may also suggest specific actions to be done, actions that are codified using a code system. The caller may then display the messages using a UI of choice, and potentially arrange for automated or semi-automated execution of the attached actions.

The request is given a semantic context using [CDS hooks](cds-hooks.md). Regardless of the context, the general structure of the request and response is the same: one or more FHIR resources. See the [CDS hook catalog](hook-catalog.md) to see which resources are used in which context, and the [FHIR resource listing](resources.md) for more details on the individual resources.

## Versioning

There are four major versioning schemes in EBMEDS 2.0:

1. **The overall software version**. Changes with new releases of the software. (Version format: semver)
2. **The clinical data version**. All internal data in EBMEDS is versioned using one version number. This includes the rulesets, drug data, translations etc. (Version format: semver)
3. **The API versions**: At the moment EBMEDS supports XML and FHIR STU3 (JSON). These APIs are versioned separately. Newer software versions will support old interfaces for as long as technically feasible. (Version format: semver for XML, whole integers for FHIR)
4. **Distributed artifact versions**. Some artifacts are distributed to customers so they can be potentially used outside of EBMEDS, for example FHIR Questionnaires. These follow their own versioning scheme that is mappable to the clinical data version scheme if required. (Version format: whole integers)

## Examples

The easiest way to see EBMEDS 2.0 in action is by example. We therefore provide a collection of examples in the [Postman Collection v2.1 format](https://schema.getpostman.com/json/collection/v2.1.0/docs/index.html). These can be imported into the Postman app or explored by hand.

Download the package here: [EBMEDS FHIR examples v1.0](ebmeds-fhir-examples-v1.0.postman_collection.json)