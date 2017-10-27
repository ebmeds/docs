# FHIR STU3 API

## Getting started

EBMeDS can be used with the [HL7 FHIR STU3](https://www.hl7.org/fhir/STU3/) format. The main unit of information in FHIR is the *resource*, which is a JSON object with a particular type. FHIR can also be expressed in XML form, but this is not supported by EBMeDS.

One can interact with EBMeDS using FHIR in the following ways:

* Using a custom REST interface to retrieve static FHIR resources (Questionnaire, PlanDefinition, Goal)
* Using [CDS Hooks](http://cds-hooks.org) to call decision support. Input and output resource types depend on the hook.

## Custom REST API

