# EBMeDS Hook Catalog

Below we list the available CDS hook endpoints, i.e. the REST endpoints at `[base-url]/cds-services/[endpoint]`.

**Note**: the FHIR resources to be included in the request are listed (per the CDS hooks standard) as FHIR search strings. However, there is sometimes not enough granularity available in FHIR STU3 searches to specify exactly what is needed. Be aware of this when reading the service descriptions below.

## /selfcare-filled-questionnaire

*Hook: 'questionnaire-completed'*

This hook is intended for the self-care context, where an individual (either by himself or with the assistance of a healthcare professional) fills in a form related to his or her health. This might be a questionnaire about the person's symptoms, a questionnaire calculating lifestyle-related health risks, etc. The responses are encoded into a FHIR QuestionnaireResponse. EBMeDS responds with ActivityDefinitions that include coded actions available for the individual, e.g. the reservation of a time for a lab test, visit to the doctor, etc. A special ActivityDefinition is provided containing reminder texts, instead of the texts being in the CDS hook cards.

### Used FHIR resources

* Request
    * [SelfCareQuestionnaireResponse](resources.md#selfcarequestionnaireresponse) (profile of QuestionnaireResponse)
* Response
    * SelfCareActivityDefinition (profile of ActivityDefinition)

### Versioning info

The version of the Questionnaire resource is tightly bound to the version of the ruleset used in EBMeDS to analyze the QuestionnaireResponse. Therefore the Questionnaire version (along with the Questionnaire ID itself) must be specified in the QuestionnaireResponse. The Questionnaire resource contains the `Questionnaire.url` field which is globally unique. That URL shall be included in the QuestionnaireResponse in the `QuestionnaireResponse.questionnaire.reference` field, which gives EBMeDS enough info to infer the version information.

Note that old Questionnaire versions will not be supported indefinitely, and it is strongly recommended to always use the latest available questionnaire version for a given questionnaire. It is up to the calling party to make sure that the newest version is in use, information about new releases are provided by Duodecim using a mechanism agreed upon with the customer.

### Service description

```json
{
  "id": "selfcare-filled-questionnaire",
  "hook": "questionnaire-completed",
  "name": "Self-care questionnaire analysis service",
  "description": "A hook for when a FHIR QuestionnaireResponse filled out by a patient/citizen is available for EBMeDS to process. The response may include directions both for the patient himself, and a medical professional.",
  "prefetch": {
    "questionnaireResponse": "/QuestionnaireResponse?patient={{Patient.id}}"
  }
}
```

### Example request

```json
{
  "hook": "questionnaire-completed",
  "context": {
    "dataVersion": "latest"
  },
  "prefetch": {
    "questionnaireResponse": {
      "resource": {
        "resourceType": "QuestionnaireResponse",
        "questionnaire": {
          "url": "https://www.ebmeds.org/form/api/FHIR/forms/export/21/622"
        },
        "status": "completed",
        "item": [
          {
            "linkId": "introduction",
            "item": [
              {
                "linkId": "20",
                "answer": [
                  {
                    "valueCoding": {
                      "id": "47"
                    }
                  }
                ]
              },
              {
                "linkId": "266"
              },
              {
                "linkId": "3",
                "answer": [
                  {
                    "valueDecimal": 45
                  }
                ]
              },
              {
                "linkId": "666"
              },
              {
                "linkId": "305",
                "answer": [
                  {
                    "valueCoding": {
                      "id": "462"
                    }
                  }
                ]
              },
              {
                "linkId": "662"
              },
              {
                "linkId": "21",
                "answer": [
                  {
                    "valueCoding": {
                      "id": "69"
                    }
                  }
                ]
              },
              {
                "linkId": "22",
                "answer": [
                  {
                    "valueCoding": {
                      "id": "81"
                    }
                  }
                ]
              },
              {
                "linkId": "28"
              },
              {
                "linkId": "23"
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "24"
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "25"
                "answer": [
                  {
                    "valueCoding": {
                      "id": "414"
                    }
                  }
                ]
              },
              {
                "linkId": "184",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "26",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "27"
              },
              {
                "linkId": "29",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "660",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "30",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "31",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "32",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "33",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "702",
                "answer": [
                  {
                    "valueBoolean": true
                  }
                ]
              },
              {
                "linkId": "34"
              }
            ]
          }
        ]
      }
    }
  }
}
```

### Example response

```json
{
  "cards": [
    {
      "summary": "Selfcare action suggestions",
      "indicator": "info",
      "source": {
        "name": "EBMeDS v2.0.6",
        "url": "https://ebmeds.org/version/v2.0.6/data-version/v0.9.2"
      },
      "suggestions": [
        {
          "resourceType": "ActivityDefinition",
          "status": "active",
          "copyright": "Kustannus Oy Duodecim, 2017",
          "participant": [
            {
              "type": "patient"
            }
          ],
          "kind": "Observation",
          "code": {
            "coding": [
              {
                "code": "ADA001-P1",
                "system": "http://91.202.112.142/codeserver/pages/classification-view-page.xhtml?classificationKey=2023&versionKey=2283",
                "display": "Yleislääkärin päivystyksen palvelut - Hoidetaan päivystyksenä"
              }
            ]
          }
        },
        {
          "resourceType": "ActivityDefinition",
          "status": "active",
          "copyright": "Kustannus Oy Duodecim, 2017",
          "participant": [
            {
              "type": "patient"
            }
          ],
          "kind": "CommunicationRequest",
          "code": {
            "coding": [
              {
                "system": "https://duodecim.fi/fhir/stu3/CodeSystem/activity-definition-custom-actions",
                "code": "read-reminder",
                "display": "Lue muistutteet"
              }
            ]
          },
          "topic": [
            {
              "text": "Oireesi voivat johtua virtsatietulehduksesta, joka voi olla munuaistasoinen. Hakeudu päivystysvastaanotolle."
            }
          ]
        }
      ]
    }
  ]
}
```

## /selfcare-general-cds

The so-called general CDS is the traditional way of using EBMeDS, where as much patient data as possible is sent to the service, and a wide range of reminders and suggested actions are returned.

### Service description

```json
{
  "id": "selfcare-general-cds",
  "hook": "general-cds",
  "name": "General decision support, no specialization.",
  "description": "This hook takes as much patient data as possible and returns as many reminders as possible. As well as prefetch data, see the documentation for what can be put in the context property.",
  "prefetch": {
    "patient": "Patient/{{Patient.id}}",
    "allergyIntolerances": "AllergyIntolerance?patient={{Patient.id}}",
    "familyMemberHistories": "FamilyMemberHistory?patient={{Patient.id}}",
    "conditions": "Condition?patient={{Patient.id}}",
    "observations": "Observation?patient={{Patient.id}}",
    "medicationStatements": "MedicationStatement?patient={{Patient.id}}",
    "immunizations": "Immunization?patient={{Patient.id}}",
    "procedures": "Procedure?patient={{Patient.id}}",
    "procedureRequests": "ProcedureRequest?patient={{Patient.id}}"
  }
}
```

## /selfcare-monitoring

Given a MonitoringGoal and related measurements (e.g. a weight loss goal and weight measurements), provide feedback on the progress.

### Service description

```json
{
  "id": "selfcare-monitoring",
  "hook": "selfcare-monitoring",
  "name": "Monitoring of certain observations for self-care purposes",
  "description": "This hook takes a MonitoringGoal resource and a bundle of associated MeasurementObservations and returns textual feedback on the user's progress.",
  "context": {
    "goals": "Goal?patient={{Patient.id}}",
    "measurements": "Observation?patient={{Patient.id}}",
  }
}
```