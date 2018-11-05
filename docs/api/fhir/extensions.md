# Questionnaire extensions

## self-care-instructions

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

## displayCategory

* URL: `http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory`
* Location: Questionnaire.item (and sub-items)

Question with `type: 'display'` require a few more subcategories, which is the purpose of this HL7 extension. The allowed values are:

* `subtitle`: As the name implies, a string designed to be a subtitle. The `text` field in this question is also styled with a markdown-style subtitle tag (`# Example subtitle`).
* `feedback`: Answering a set of questions in a certain way may provoke some immediate feedback in the questionnaire itself, without having to send the QuestionnaireResponse to EBMEDS. This display-type question contains this kind of feedback.
* `terminus`: This is similar to `feedback`, except that if the user has answered questions that produce this type of feedback, the situation is so critical that he should be stopped from answering any more questions, and immediately seek help. The UI should hide the questions following this feedback type, if it is visible.

Example:

```json
[
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
  },
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
]
```

## minValue

* URL: `http://hl7.org/fhir/StructureDefinition/minValue`
* Location: Questionnaire.item (and sub-items)

Extension by HL7 to specify a minimum value for a numerical question. Is often seen together with maxValue.

Example:

```json
{
  "linkId":"15",
  "text":"Give the length of your foot.",
  "type":"decimal",
  "extension":[
    {
      "url": "http://hl7.org/fhir/StructureDefinition/minValue",
      "valueDecimal": 15.3
    }
  ]
}
```

## maxValue

* URL: `http://hl7.org/fhir/StructureDefinition/minValue`
* Location: Questionnaire.item (and sub-items)

Extension by HL7 to specify a maximum value for a numerical question. Is often seen together with minValue.

Example:

```json
{
  "linkId":"15",
  "text":"Give your age.",
  "type":"decimal",
  "extension":[
    {
      "url": "http://hl7.org/fhir/StructureDefinition/maxValue",
      "valueDecimal": 100.3
    }
  ]
}
```

There is some special UI logic required to handle a multiple choice question with the choice "none of the above". For this we use an extension that marks one of the choices as exclusive:

## optionExclusive

* URL: `http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive`
* Location: Questionnaire.item.option (and in sub-items)

HL7 extension to specify that a multiple choice answer is *exclusive*, i.e. in a 'checkbox' multiple choice question, if you check this answer, all other options are taken to be unchecked, and should be greyed out in the UI. Mainly used for 'none of the above' types of answer choices.

Example:

```json
{
  "valueCoding":{
    "id": "-1",
    "display": "None of the above",
    "extension": [
      {
        "url": "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive",
        "valueBoolean": true
      }
    ]
  }
}
```

## maxDecimalPlaces

* URL: `http://hl7.org/fhir/StructureDefinition/maxDecimalPlaces`
* Location: Questionnaire.item (and sub-items)

For questions of type `decimal`, specifies an integer value signifying the maximum number of decimal places that a user is allowed to fill in for his answer. If the extension is not present, the value is taken to be infinity. If the value is 0, the question type should be `integer` instead.

```json
{
  "linkId":"15",
  "text":"Give your age with 2 decimal precision.",
  "type":"decimal",
  "extension":[
    {
      "url": "http://hl7.org/fhir/StructureDefinition/maxDecimalPlaces",
      "valueInteger": 2
    }
  ]
}
```

## enable-when-operator

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