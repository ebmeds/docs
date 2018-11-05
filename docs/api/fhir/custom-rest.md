# Custom REST API

EBMEDS 2.0 is not a full-blown FHIR server, but we do provide a REST interface for getting some of our static FHIR resources via HTTP.

## Coaching

* URL: `[base-url]/coaching`
* Resource: [CoachingPlanDefinition](resources.md#coachingplandefinition)

The CoachingPlanDefinition is a resource containing a set of messages that are sent to the user at specific intervals. There are coaching programs for a number of different topics, for example:

* Reduction of alcohol consumption
* Step exercise programme
* Good deeds
* Coaching programme for families with children
* Gratitude
* Optimism
* Positive interaction in couple relationship
* Resolving conflicts in a relationship
* Coachingprogrammet Konflikthantering
* Exercise programme three hours a week
* Exercise programme four hours a week
* Exercise programme five hours a week
* Exercise programme more than seven hours a week
* Exercise programme for diabetes patients
* Exercise programme for persons with musculoskeletal problems
* Coaching program for asthmatics
* Weight management
* Healthy nutrition programme
* Coaching program "Stress management"
* Preparing to quit smoking
* Quitting smoking
* Sleep coaching

A list of available programs are available at the address `[base-url]/coaching/programs` and the individual programs can be accessed at `[base-url]/coaching/programs/[id]`. So for example, on ebmedscloud.org, a coaching program can be retrieved by doing a HTTP GET on the URL `https://ebmedscloud.org/api/fhir/v1/coaching/programs/5`.

The format of the CoachingPlanDefinition is described in more detail in the EBMEDS 2.0 [FHIR resources listing](resources.md#coachingplandefinition).