# ODA project-specific customization

## SelfCareQuestionnaire FHIR resource

In the `selfcare-*` CDS hooks, the following metadata is included (by request from the ODA project) in the SelfCareQuestionnaire resource:

```json
"meta":{
  "profile":[
    "http://phr.kanta.fi/StructureDefinition/fiphr-questionnaire-stu3"
  ],
  "tag":[
    {
      "system":"http://oda.fi/Questionnaire",
      "code":"symptom"
    },
    {
      "system":"http://oda.fi/cds",
      "code":"oda1"
    }
  ]
}
```

## SelfCareQuestionnaire push

When new questionnaires (or versions of questionnaires) are available for use in the self-care context, they are pushed to a server specified by the ODA project.