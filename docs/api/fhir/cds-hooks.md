# CDS Hooks

EBMeDS uses a slightly customized version of the [CDS Hooks](http://cds-hooks.org) standard. This standard is still in flux and will soon reach its 1.0 version, at which point these customizations will be re-evaluated.

The overall point of CDS hooks is that the calling party calls EBMeDS using three pieces of information:

* The REST endpoint name (the "hook ID"), giving the high-level context, e.g. `selfcare-questionnaire-filled`.
* The hook name, providing the action/event that triggered this particular call, e.g. `questionnaire-completed`.
* The clinical data specified in the [EBMeDS hook catalog](hook-catalog.md).

This enables EBMeDS to tailor its output depending on the usage context, and also to provide a machine-readable format for what data is required. The context itself is not machine-readable, i.e. it is described by natural language, but some [standardized hooks exist](http://cds-hooks.org/#hook-catalog).

**Differences between the EBMeDS implementation and the current CDS hooks documentation**:

* The `prefetch` field is used widely in EBMeDS at the moment. However, this field is intended to be used as an optional performance enhancement, i.e. the assumed data model in CDS hooks is that the CDS system has access to the calling party's FHIR server, from which it can read the clinical data by itself, if the data is not provided in `prefetch`. However, in EBMeDS, the `prefetch` field is mandatory at this moment. The `context` field will be used exclusively in the future.
* The response format in CDS hooks is in the form of *cards*. The card is a simple container for a message string (and some metadata) and is therefore usually not flexible enough to contain things like specifying the recipient of the message. Therefore, the meat of the response is located in the `suggestions` field, which contains an array of FHIR resources, not the structure with different action types (`create`, `update`, `delete`) that is described in the standard. All FHIR resources in the `suggestions` array are implicitly of the `create` type at this moment.
* When calling a hook, the `context` field is currently specified as an array of objects in the standard. This is going to change in version 1.0 of the standard into a simple object. EBMeDS already uses this.
* The `context` field will work like a "mandatory `prefetch`" in CDS hooks 1.0, and will be described in the same way in the hook catalog, i.e. using FHIR search strings. EBMeDS also uses `context` for setting some options, i.e. `dataVersion`, which specifies which version of the internal clinical datasets EBMeDS should use. This is in no way describable by a FHIR search string.
* In `prefetch` (or `context`), most of the FHIR search strings return a Bundle, not an individual resource (like QuestionnaireResponse). However, EBMeDS supports returning an individual resource instead of a Bundle of length one. Bundles will be required in the future.

## CDS hooks REST API

The REST API for CDS hooks is very simple. One can `GET` the list of available hooks (the "hook catalog") from `[base-url]/cds-services`, and one calls a hook by `POST`ing to `[base-url]/cds-services/[hook-name]`. The base URL depends on where and how EBMeDS is installed: one example is `https://ebmedscloud.org/api/fhir/v1`.

## Hook description format

We will continue with the `questionnaire-completed` example mentioned briefly above. The EBMeDS hook catalog specifies this kind of hook:

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

So what does this mean? Let's go through the hook description field by field:

* `id`: Again, the main identifier for the hook in question. This field determines the URL used when calling the hook, e.g. `https://ebmedscloud.org/api/fhir/v1/cds-services/selfcare-filled-questionnaire`. At the same time, the `id` provides the most high level context for this hook. The value is unique.
* `hook`: The action or event that triggers this hook. The `hook` value is not unique, there may be many different CDS hooks (at different REST endpoints i.e. with a different `id`) that all have the same `hook` value. The idea is to develop a standardized set of hooks that behave the same in any CDS system. In this case, `questionnaire-completed` is a non-standard hook, specific to EBMeDS.
* `name`: A short description of the hook.
* `description`: A longer description of the hook.
* `prefetch`: This field is an object, each property within that object acts as a label for a set of FHIR resources, obtained by performing the FHIR search provided in the property value. It is not mandatory to use the search string (e.g. if you do not have a FHIR server), but it does specify the format of the data to be put in the request. **NOTE**: as mentioned, the prefetch fields are mandatory in EBMeDS, but not in the CDS hooks standard.
    * `prefetch.questionnaireResponse`: In this example, there is only one piece of data needed for the CDS hook call. This data is the FHIR resource called QuestionnaireResponse that has presumably just been filled out by the patient in question (identified by `{{Patient.id}}`). The property name `questionnaireResponse` is the label given this piece of data. This label will also be used when calling the CDS hook (see below).

## Calling a hook

So, given the hook description above, we can call the hook. The format is, quite simply:

```json
{
  "hook": "questionnaire-completed",
  "prefetch": {
    "questionnaireResponse": {
      "resource": { QuestionnaireResponse... }
    }
  },
  "context": {
    "dataVersion": "latest"
  }
}
```

* `hook`: The same value as in the hook description.
* `prefetch`: Contains the same properties as in the hook description. In this case, the wanted QuestionnaireResponse resource is in `prefetch.questionnaireResponse.resource`.
* `QuestionnaireResponse...`: Omitted for brevity, this is where the actual FHIR resource is. In this case it is a QuestionnaireResponse, so it starts with `{ "resourceType": "QuestionnaireResponse" ...` etc. See the [FHIR resource page](resources.md) for a closer description of the resource, among many others.
* `context`: Depending on the hook, this may contain other properties, but one (optional) property is `context.dataVersion`. `dataVersion` is a string containing the wanted version of the clinical data that EBMeDS uses for processing. If the value is `latest` or the field is missing, EBMeDS uses the latest version. The usage of older versions is not recommended, except for very specific use cases.

## Hook response

EBMeDS uses two patterns for CDS hook responses. The first pattern is a traditional approach, well suited for the CDS hooks standard. The second pattern is customized for the selfcare context. The example above, as you may remember, is in the selfcare context, so the call above will return the second pattern. More details below.

### Traditional response (to be implemented)

Traditional CDS is focused on providing one or more text-based messages to a clinical professional, sometimes accompanied by some suggested actions, identified by a code. Each message, or *reminder*, is independent of the others, i.e. the same actions may be suggested in multiple reminders. It is up to the calling party to handle a user-friendly display of the information, potentially removing duplicate suggested actions, rendering different kinds of messages in different ways etc. An example, showing two reminders, is the following:

```json
{
  "cards": [
    {
      "summary": "Decreased renal function, switch tiatside to furosemide?",
      "detail": "Renal function is decreased (eGFR 21 ml/min 16.10.2017). Tiatsides lose their effect when GFR < 30 ml/min. Consider switching to furosemide.",
      "indicator": "info",
      "source": {
        "name": "EBMeDS v2.0.6",
        "url": "https://ebmeds.org/version/v2.0.6/data-version/v0.9.2"
      },
      "suggestions": [
        { ActivityDefinition... },
        { ActivityDefinition... },
        ...
      ]
    },
    {
      "summary": "High ferritinine (355 ug/l 15.10.2017) - hemocromatosis?",
      "detail": "High ferritinine concentration (355 ug/l 15.10.2017): Consider the possibility of hemocromatosis. Ferritinine concentration may also be elevated due to infection or liver disease.",
      "indicator": "info",
      "source": {
        "name": "EBMeDS v2.0.6",
        "url": "https://ebmeds.org/version/v2.0.6/data-version/v0.9.2"
      },
      "suggestions": [
        { ActivityDefinition... },
        { ActivityDefinition... },
        ...
      ]
    }
  ]
}
```

Again, `ActivityDefinition...` signifies a FHIR resource that is omitted for brevity.

* `cards`: Array of one or more card structures, containing a message, importance level, source data and suggested actions.
* `summary`: The short version of the reminder. Good to display in lists etc.
* `detail`: The complete message. Usually only a simple text string, but Github-flavored Markdown is supported.
* `indicator`: One of `info`, `warning`, `hard-stop`. Instructs the calling party how important the reminder is.
* `source`: Contains properties `name` and `url`, giving info about the EBMeDS version as well as the clinical data version used for generating the reminders.
* `suggestions`: An array (non-standard CDS hooks) containing zero or more FHIR resources. These resources are to be considered as `create`-type resources, refer to the CDS hooks documentation for more information. These suggestions are not duplicates within one cards, but several cards may contain the same suggestion.

These cards are to be displayed by the calling party in a manner they see fit. Refer to the documentation of individual hooks regarding the formats and codings for suggested actions.

### Custom self-care card format

The self-care context poses some unique challenges. Originally created for a national project in Finland, these CDS cards are required to leave nothing to chance, since most parts of the self-care project in question are automated, without human intervention. In other words, the card format is too vague to offer much help, and all human-readable data is stripped out of it. Instead, the data is all in coded form inside `suggestions`, more specifically in the form of ActivityDefinition resources. Please refer to the `selfcare-*` hooks in the hook catalog.

```json
{
  "cards": [
    {
      "source": {
        "name": "EBMeDS v0.9.6",
        "url": "https://ebmeds.org/version/v0.9.6/data-version/v0.9.2"
      },
      "suggestions": [
        { ActivityDefinition... },
        { ActivityDefinition... },
        ...
      ]
    }
  ]
}
```