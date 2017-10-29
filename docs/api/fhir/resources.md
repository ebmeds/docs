# FHIR resources in EBMeDS

## SelfCareQuestionnaire

*Inherits from*: [Questionnaire](https://www.hl7.org/fhir/questionnaire.html)

*FHIR profile*: [SelfCareQuestionnaire](https://simplifier.net/DuodecimCDS/SelfCareQuestionnaire)

The FHIR [Questionnaire resource](https://www.hl7.org/fhir/questionnaire.html) is a general way of describing, you guessed it, questionnaires.

### Example

An example resource is:

```json
{
  "resourceType":"Questionnaire",
  "language":"fi",
  "url":"https://www.ebmeds.org/form/api/FHIR/forms/export/107/550",
  "version":"v0.9.3"
  "status":"active",
  "date":"2017-10-11T11:45:49.036Z",
  "publisher":"© Kustannus Oy Duodecim, 2017",
  "copyright":"© Kustannus Oy Duodecim, 2017",
  "identifier":[
    {
      "system":"https://duodecim.fi/fhir/sid/vkt-questionnaire-id",
      "value":"107"
    }
  ],
  "title":"Hengitystietulehdusoireiden oirearvio",
  "text":{
    "status":"generated",
    "div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">Neuvova oirearviolomake, joka auttaa hengitystieinfektion oireita potevaa henkilöä arvioimaan ammattiavun tarvetta ja omahoidon mahdollisuuksia</div>"
  },
  "extension":[
    {
      "url":"https://duodecim.fi/fhir/extensions/self-care-instructions",
      "extension":[
        {
          "url":"instruction-text",
          "valueString":"[Itsehoito-ohje](http://www.terveyskirjasto.fi/terveyskirjasto/tk.koti?p_artikkeli=dlk01167)"
        }
      ]
    }
  ],
  "item":[
    {
      "linkId":"introduction",
      "text":"Introductory text of the questionnaire. Also a container item. Has no answer, but contains other items. The text is written in markdown, so it may contain [links](https://ebmeds.org).",
      "type":"group",
      "item":[
        {
          "linkId": "266",
          "type": "display"
          "text": "A display-type question in the Questionnaire, has no answer but must also be present in the QuestionnaireResponse according to the FHIR spec."
        },
        {
          "linkId":"3",
          "type":"decimal",
          "text":"A question with a numeric answer. (For example, age.)",
          "required":true,
          "code":[
            {
              "system":"http://loinc.org",
              "code":"21612-7"
            }
          ],
          "extension":[
            {
              "url":"http://hl7.org/fhir/StructureDefinition/minValue",
              "valueDecimal":10
            },
            {
              "url":"http://hl7.org/fhir/StructureDefinition/maxValue",
              "valueDecimal":99
            }
          ]
        },
        {
          "linkId":"306",
          "required":true,
          "text":"'Check box' type multiple choice questions may naturally have > 1 answers.",
          "type":"choice",
          "repeats":true,
          "option":[
            {
              "valueCoding":{
                "id":"452",
                "display":"First option."
              }
            },
            {
              "valueCoding":{
                "id":"453",
                "display":"Second option."
              }
            },
            {
              "valueCoding":{
                "id":"453",
                "display":"None of the above."
              },
              "extension": [
                {
                  "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
                  "valueBoolean": true
                }
              ]
            }
          ],
        },
        {
          "linkId":"305",
          "required":true,
          "text":"A 'radio button' type multiple choice question. In the QuestionnaireResponse, looks identical to a checkbox answer with one answer checked.",
          "type":"choice",
          "repeats":false,
          "option":[
            {
              "valueCoding":{
                "id":"462",
                "display":"First option."
              }
            },
            {
              "valueCoding":{
                "id":"463",
                "display":"Second option."
              }
            },
            {
              "valueCoding":{
                "id":"464",
                "display":"Third option."
              }
            }
          ],
        },
        {
          "linkId": "23",
          "required": true,
          "text": "A boolean-type question. In the Questionnaire this question contains display logic, i.e. the question is only visible when certain other questions have been answered in a certain way. In this example, the numerical answer in question ID 3 must be between 15 and 99.",
          "type": "boolean",
          "enableWhen": [
            {
              "question": "3",
              "answerQuantity": {
                "value": 15,
                "comparator": ">"
              }
            },
            {
              "question": "3",
              "extension": [
                {
                  "url": "https://duodecim.fi/fhir/extensions/enable-when-operator",
                  "valueString": "AND"
                }
              ],
              "answerQuantity": {
                "value": 99,
                "comparator": "<"
              }
            }
          ]
        }
    }
  ]
}
```

With the fields:

* `resourceType` (string): Always `Questionnaire`.
* `language` (string): What language is the form written in? BCP47 language tag, e.g. `fi` or `fi-FI`.
* `url` (string): Globally unique URL for this questionnaire.
* `status` (string): Can be `active`, `draft` or `retired`. Only active questionnaires should be used in production.
* `date` (string): ISO 8601 date of when the Questionnaire was created or last modified.
* `publisher` (string): Who published the Questionnaire. Usually Duodecim.
* `copyright` (string): Standard copyright notice.
* `identifier` (array of objects): Identifying codes, in practice only one object is listed.
    * `system` (string): `'http://duodecim.fi/fhir/sid/vkt-questionnaire-id'`, an internally defined code system.
    * `code` (string): The unique ID for this questionnaire (although different versions may exist with the same ID).
* `title` (string): The title of this questionnaire.
* `text` (object): A FHIR Narrative object, i.e. a human-readable description of the contents of this resource. Has the following fields:
    * `status` (string): Always `'generated'`.
    * `div` (string): A string containing an XHTML `div` with the contents. Note that entity references are not allowed.
* `item` (array of objects): The field describing one or more questions. Items may contain other items, forming a tree structure.

### Questionnaire items

The example Questionnaire above contains an assortment of the most common variants of a question item: the different question types, as well as the usage display logic (`enableWhen`) and custom extensions.

The fields in `item` are as follows.

* `item` (object): Items may contain other items.
* `linkId` (string): A unique ID for identifying this question in the form.
* `text` (string, markdown, **optional**): A markdown string containing the question text. May contain light text formatting and links to images. Not needed for certain item types, e.g. `group`.
* `required` (boolean): Whether or not this question is required to be answered. Questions with `type: 'display'` or `type: 'group'` can not be `required`. The `required` property is also not applicable to questions that are not visible to the user due to display logic hiding them. As a rule of thumb, the Questionnaires generated by Duodecim assume that all (visible and answerable) questions are required.
* `type` (string): One of `'decimal'`, `'boolean'`, `'string'`, `'integer'`, `'decimal'`, `'date'`, `'dateTime'`, '`choice`' for actual questions. We also have the special types `'group'` (that only contains other items) and `'display'` which is used to show some informative text and/or subtitles (in markdown). See section "Question types" below.
* `enableWhen` (array of objects): A list of criteria for when this question should be visible to the user. Each criterium in the list is connected to the other by boolean OR operators by default, with AND operators being implemented by an extension. See the section "Questionnaire extensions".

### Questionnaire extensions

#### self-care-instructions

* URL: `https://duodecim.fi/fhir/extensions/self-care-instructions`
* Location: Questionnaire root

Contains the sub-extension `instruction-text`. Has a string value which is a markdown string containing a link to long-form self-care instructions.

Example:

```json
{
  "url":"https://duodecim.fi/fhir/extensions/self-care-instructions",
  "extension":[
    {
      "url":"instruction-text",
      "valueString":"[Itsehoito-ohje](http://www.terveyskirjasto.fi/terveyskirjasto/tk.koti?p_artikkeli=dlk01167)"
    }
  ]
}
```

#### displayCategory

* URL: `http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory`
* Location: Questionnaire.item (and sub-items)

Question with `type: 'display'` require a few more subcategories, which is the purpose of this HL7 extension. The allowed values are:

* `subtitle`: As the name implies, a string designed to be a subtitle. The `text` field in this question is also styled with a markdown-style subtitle tag (`# Example subtitle`).
* `feedback`: Answering a set of questions in a certain way may provoke some immediate feedback in the questionnaire itself, without having to send the QuestionnaireResponse to EBMeDS. This display-type question contains this kind of feedback.
* `terminus`: This is similar to `feedback`, except that if the user has answered questions that produce this type of feedback, the situation is so critical that he should be stopped from answering any more questions, and immediately seek help. The UI should hide the questions following this feedback type, if it is visible.

Example:

```json
{
  "linkId":"14",
  "text":"# A subtitle",
  "type":"display",
  "extension":[
    {
      "url":"http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory",
      "valueString":"subtitle"
    }
  ]
}
{
  "linkId":"15",
  "text":"Things are really bad.",
  "type":"display",
  "extension":[
    {
      "url":"http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory",
      "valueString":"terminus"
    }
  ]
}
```

#### minValue

* URL: `http://hl7.org/fhir/StructureDefinition/minValue`
* Location: Questionnaire.item (and sub-items)

Extension by HL7 to specify a minimum value for a numerical question. Is often seen together with maxValue.

Example:

```json
{
  "url":"http://hl7.org/fhir/StructureDefinition/minValue",
  "valueDecimal":10
}
```

#### maxValue

* URL: `http://hl7.org/fhir/StructureDefinition/minValue`
* Location: Questionnaire.item (and sub-items)

Extension by HL7 to specify a maximum value for a numerical question. Is often seen together with minValue.

Example:

```json
{
  "url":"http://hl7.org/fhir/StructureDefinition/maxValue",
  "valueDecimal":99
}
```

There is some special UI logic required to handle a multiple choice question with the choice "none of the above". For this we use an extension that marks one of the choices as exclusive:

#### optionExclusive

* URL: `http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive`
* Location: Questionnaire.item.option (and in sub-items)

HL7 extension to specify that a multiple choice answer is *exclusive*, i.e. in a 'checkbox' multiple choice question, if you check this answer, all other options are taken to be unchecked, and should be greyed out in the UI. Mainly used for 'none of the above' types of answer choices.

Example:

```json
{
  "valueCoding":{
    "id": "-1",
    "display": "None of the above"
    "extension": [
      {
        "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
        "valueBoolean": true
      }
    ]
  }
},
```

#### enable-when-operator

* URL: `https://duodecim.fi/fhir/extensions/enable-when-operator`
* Location: Questionnaire.item.enableWhen (and in sub-items)

The display logic conditions in `Questionnaire.item.enableWhen` are given in an array. By default, the question should be visible when *any* of the listed conditions are true. This extension takes a string value `AND`, `OR`, `NOT`. They should be interpreted in the following manner:

* `OR`: If the condition extension contains this value, the logical operator between this condition and the previous condition in the array is the boolean OR. (This is the default when the extension is not present.)
* `AND`: As above, but the boolean operator is AND.
* `NOT`: This applies the NOT operator to the current condition.

The same extension may be present multiple times in a condition, to construct e.g. AND NOT.

Example:

```json
{
  "linkId": "23",
  "required": true,
  "type": "boolean",
  "enableWhen": [
    {
      "question": "3",
      "answerQuantity": {
        "value": 15,
        "comparator": ">"
      }
    },
    {
      "question": "3",
      "extension": [
        {
          "url": "https://duodecim.fi/fhir/extensions/enable-when-operator",
          "valueString": "AND"
        }
      ],
      "answerQuantity": {
        "value": 99,
        "comparator": "<"
      }
    }
  ]
}
```

## SelfCareQuestionnaireResponse

*Inherits from*: [QuestionnaireResponse](https://www.hl7.org/fhir/questionnaireresponse.html)

*FHIR profile*: [SelfCareQuestionnaireResponse](https://simplifier.net/DuodecimCDS/SelfCareQuestionnaireResponse)

The [SelfCareQuestionnaireResponse](https://simplifier.net/DuodecimCDS/SelfCareQuestionnaireResponse) is the counterpart to a Questionnaire: it contains the answers that the user has provided. This can be sent to EBMeDS for decision support.

Here is a complete example:

```json
{
  "resourceType": "QuestionnaireResponse",
  "id": "0685d814-f4af-41a3-8547-5c7e5f97c923",
  "questionnaire": {
    "identifier": {
      "system": "https://duodecim.fi/fhir/sid/vkt-questionnaire-id",
      "value": "21"
    }
  },
  "status": "completed",
  "item": [
    {
      "linkId": "introduction",
      "text": "Introductory text of the questionnaire. Also a container item. Has no answer, but contains other items. The text is written in markdown, so it may contain [links](https://ebmeds.org)."
      "item": [
        {
          "linkId": "266",
          "text": "A display-type question in the Questionnaire, has no answer but must also be present in the QuestionnaireResponse according to the FHIR spec."
        },
        {
          "linkId": "3",
          "text": "A question with a numeric answer. (For example, age.)",
          "answer": [
            {
              "valueDecimal": 45
            }
          ]
        },
        {
          "linkId": "306",
          "text": "'Check box' type multiple choice questions may naturally have > 1 answers.",
          "answer": [
            {
              "valueCoding": {
                "id": "452"
              }
            },
            {
              "valueCoding": {
                "id": "453"
              }
            }
          ]
        },
        {
          "linkId": "305",
          "text": "A 'radio button' type multiple choice question. In the QuestionnaireResponse, looks identical to a checkbox answer with one answer checked.",
          "answer": [
            {
              "valueCoding": {
                "id": "462"
              }
            }
          ]
        },
        {
          "linkId": "23"
          "text": "A boolean-type question. In the Questionnaire this question contains display logic, i.e. the question is only visible when certain other questions have been answered in a certain way. In this example, the numerical answer in question ID 3 must be between 15 and 99."
          "answer": [
            {
              "valueBoolean": true
            }
          ]
        }
      ]
    }
  ]
}
```

So the structure has the following fields:

* `resourceType` (string): Always `QuestionnaireResponse`.
* `id` (string, **optional**): A unique ID, UUID works great. Not needed for CDS, but good to have for archiving purposes.
* `questionnaire.identifier` (object): A unique identifier for the Questionnaire that this QuestionnaireResponse answers.
    * `system` (string): Always `https://duodecim.fi/fhir/sid/vkt-questionnaire-id`
    * `value` (string): A unique ID for the Questionnaire.
* `status` (string): Always `completed`.
* `item` (array of objects): Tree hierarchy of the answers to the questionnaire. The hierarchy must be the same as the question hierarchy in the Questionnaire.
    * `item` (see above, **optional**): Items may contain other items.
    * `linkId` (string): The unique ID of the question in the Questionnaire resource (also named `linkId` there). This ID is in fact globally unique for all Duodecim Questionnaires.
    * `answer` (array, **optional**): array of objects with property `value[x]`, corresponding to the Questionnaire `answer[x]` field for the question. The length of the array is always 1, or >= 1 if it is a multiple choice question (`valueCoding`).
        * `valueBoolean` (boolean): A yes or no question answer.
        * `valueDecimal` (number): A decimal-valued question answer.
        * `valueCoding` (object): has one property, `id` (string), the ID of the wanted answer. Also globally unique ID in all Duodecim Questionnaires.
    * `text` (markdown string, **optional**): The question text from the Questionnaire repeated here, mostly to aid debugging.

## SelfCareActivityDefinition

*Inherits from*: [ActivityDefinition](https://www.hl7.org/fhir/activitydefinition.html)

*FHIR profile*: [SelfCareActivityDefinition](https://simplifier.net/DuodecimCDS/SelfCareActivityDefinition/)

The main point of the FHIR resource [SelfCareActivityDefinition](https://simplifier.net/DuodecimCDS/SelfCareActivityDefinition/) is to describe an action. In the traditional CDS context the primary unit is the reminder, an informative message that may have an encoded action suggestion attached to it. In the self-care context it is the other way around: we return actions that have messages attached to them.

In practice, this means that if several reminders suggest the same action, only one SelfCareActivityDefinition is returned, with several reminder texts attached to it. This also means that the card structure of CDS hooks becomes meaningless, see the discussion at the bottom of [this page](cds-hooks.md#customselfcarecardformat).

### Data model

The ActivityDefinitions in the `selfcare-*` hooks separate the reminder texts from their suggested actions. Given a set of reminders, each with 0 or more suggested actions attached to them, the reminder texts and actions are split up into several SelfCareActivityDefinitions:

1. Zero or one ActivityDefinition containing the code system `https://duodecim.fi/fhir/stu3/CodeSystem/activity-definition-custom-actions` and the code `read-reminder`. This resource contains all reminder texts with severity level `reminder` in its `topic.text` field.
2. Zero or one ActivityDefinition containing the code system `https://duodecim.fi/fhir/stu3/CodeSystem/activity-definition-custom-actions` and the code `read-prompt`. This resource contains all reminder texts with severity level `prompt` in its `topic.text` field.
3. Zero or one ActivityDefinition containing the code system `https://duodecim.fi/fhir/stu3/CodeSystem/activity-definition-custom-actions` and the code `read-alert`. This resource contains all reminder texts with severity level `alert` in its `topic.text` field.
4. Zero or more ActivityDefinition containing any other code system and code, representing the actual actions.

In other words: ActivityDefinitions of type 1-3 may or may not be present, but at least one of them contains at least one reminder text. See below for an example.

### Code systems

These code systems are used when coding an ActivityDefinition. See the [code systems page](code-systems.md) for more detailed information.

* `https://duodecim.fi/fhir/stu3/CodeSystem/activity-definition-custom-actions`: custom codes identifying special types of ActivityDefinitions, like above.
* `http://91.202.112.142/codeserver/pages/classification-view-page.xhtml?classificationKey=2023&versionKey=2283` a.k.a. OID `1.2.246.537.6.49`: THL Sosiaali- ja terveysalan palvelunimikkeistö
* `http://91.202.112.142/codeserver/pages/classification-view-page.xhtml?classificationKey=88&versionKey=120` a.k.a. OID `1.2.246.537.6.3`: Kuntaliitto

### Restrictions

Some restrictions have been put in place to simplify data processing, using the [SelfCareActivityDefinition](https://simplifier.net/DuodecimCDS/SelfCareActivityDefinition/) profile.

* A SelfCareActivityDefinition is described by exactly one code, i.e. `code` must be present and `code.coding` may contain only one coding. The coding represents some kind of action.
* A reminder must have exactly one `participant`, i.e. the intended recipient of this SelfCareActivityDefinition. This is either the patient or a medical professional.
* The ActivityDefinitions are always freshly generated, so their `status` is always `active`.

### Example

Below is an example of the two kinds of SelfCareActivityDefinitions (one describing an action, one containing reminder texts) in a CDS response:

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

And the fields are described as follows.

* `resourceType` (string): Always `ActivityDefinition` for this resource.
* `status` (string): Only `active` ActivityDefinitions are returned.
* `code` (object, CodeableConcept): The code describing the action.
    * `coding`: container object for a code + code system
        * `system` (string): The code system used in this code. See [a list of used code systems](code-systems.html).
        * `code` (string): The actual code, a symbol in the given system.
        * `display` (string): Human-readable description of the action.
* `topic` (array, **optional**):
    * `text` (markdown string): The reminder text itself. May contain http links and text with light styling.
* `participant` (array of objects): A list of participants and their roles. In practice there is only ever one entry in this list. Each object contains the following field:
    * `type` (string): one of `patient`, `practitioner` or `related-person`. Only `patient` is in practical use at the moment.
* `copyright` (string): A standard copyright notice.

