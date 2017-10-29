# FHIR STU3 API

## Getting started

EBMeDS can be used with the [HL7 FHIR STU3](https://www.hl7.org/fhir/STU3/) format. The main unit of information in FHIR is the *resource*, which is a JSON object with a particular type. FHIR can also be expressed in XML form, but this is not supported by EBMeDS.

One can interact with EBMeDS using FHIR in the following ways:

* [Calling decision support](cds-hooks.md): We use the [CDS Hooks](http://cds-hooks.org) standard as the communication model.
* [Custom REST API](custom-rest.md): We provide a REST interface to retrieve static FHIR resources (Questionnaire, PlanDefinition, Goal)


## Examples

The easiest way to see EBMeDS 2.0 in action is by example. We therefore provide a collection of examples in the [Postman Collection v2.1 format](https://schema.getpostman.com/json/collection/v2.1.0/docs/index.html). These can be imported into the Postman app or explored by hand.

Download the package here: [EBMeDS FHIR examples v1.0](ebmeds-fhir-examples-v1.0.postman_collection.json)
