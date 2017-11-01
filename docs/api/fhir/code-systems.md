# Used Code Systems

EBMeDS uses codes in a lot of different places. Below is a list of the code systems used in different parts of the system.

## Medical code systems

The full list of code systems for medical or clinical matters is given here: [](http://www.ebmeds.org/www/supported_coding_systems.asp)

For `selfcare-*` endpoints EBMeDS may return a customized coding related to actions a patient can do himself, unsupervised. This coding does not yet have an official code system, but is instead an amalgam of an existing code system (Finnish THL service coding or Kuntaliitto service coding) and an urgency code, separated by "-", for example `ADA001-P2`. The urgency code means:

* `P0`: Immediately
* `P1`: Within 2 hours
* `P2`: Within 10 hours
* `P3`: Within 1 day
* `P4`: Within 3 days
* `L2`: Within 7 days
* `L3`: Within 30 days
* `L4`: Within more than 30 days

And the service codings used (at the moment) are, in Finnish:

* THL service coding `http://91.202.112.142/codeserver/pages/classification-view-page.xhtml?classificationKey=2023&versionKey=2283` a.k.a. OID `1.2.246.537.6.49`
    * `AA-P0`: Hätäkeskuspalvelu - Hoidetaan välittömästi - yhteys hätäkeskukseen
    * `ADA001-P1`: Terveysalan päivystyspalvelu - Hoidetaan päivystyksenä
    * `ADA001-P2`: Terveysalan päivystyspalvelu - Hoidetaan päivystyksenä, mutta ei yöllä
    * `ADA001-P2`: Yleislääkärin päivystyspalvelut - Hoidetaan päivystyksenä, mutta ei yöllä
    * `ADA001-P3`: Yleislääkärin päivystyspalvelut - Voidaan siirtää virka-ajan lääkärille (1 vrk)
    * `ADA001-P4`: Yleislääkärin päivystyksen palvelut - Voidaan siirtää virka-ajan lääkärille (2-3 vrk)
    * `BAB-L2`: Sairauden hoitoon liittyvä neuvonta- ja ohjauspalvelu - 4-7 päivää
    * `BAB-P2`: Sairauden hoitoon liittyvä neuvonta- ja ohjauspalvelu - Hoidetaan päivystyksenä, mutta ei yöllä
    * `BAB-P3`: Sairauden hoitoon liittyvä neuvonta- ja ohjauspalvelu - Voidaan siirtää virka-aikaan (1 vrk)
    * `BAB-P4`: Sairauden hoitoon liittyvä neuvonta- ja ohjauspalvelu - Voidaan siirtää virka-aikaan (2 - 3 vrk)
    * `EDA-P2`: Sairaanhoitajan peruspalvelut - Hoidetaan päivystyksenä, mutta ei yöllä
    * `EDA-P3`: Sairaanhoitajan vastaanotto - Voidaan siirtää virka-aikaan (1 vrk)
    * `EDA-P4`: Sairaanhoitajan vastaanotto - Voidaan siirtää virka-aikaan (2 - 3 vrk)
    * `EEA-L2`: Yleislääkärin peruspalvelu - 4 - 7 päivää
    * `EEA-P4`: Yleislääkärin peruspalvelu - Voidaan siirtää virka-ajan lääkärille (2 - 3 vrk)
    * `HBA-L2`: Fysioterapian palvelut - 4-7 päivää
    * `LAD-P4`: Ultraäänitutkimus - Voidaan siirtää virka-aikaan (2 - 3 vrk)
* Kuntaliitto service coding `http://91.202.112.142/codeserver/pages/classification-view-page.xhtml?classificationKey=88&versionKey=120`
    * `1155-P2`: Virtsan bakteeriviljely (http://www.terveysportti.fi/dtk/ltk/avaa?p_artikkeli=lab30391) - Hoidetaan päivystyksenä, muttei yöllä
    * `1881-P2`: Virtsan kemiallinen seulonta (http://www.terveysportti.fi/dtk/ltk/avaa?p_artikkeli=lab31886) - Hoidetaan päivystyksenä mutta ei yöllä
    * `3635-P3`: Streptokokkipikatesti nielusta (www.terveysportti.fi/dtk/ltk/avaa?p_artikkeli=lab33681) - Voidaan siirtää virka-aikaan (1 vrk)
    * `4594-P2`: P-CRP - Hoidetaan päivystyksenä, mutta ei yöllä


## FHIR resource-specific code systems

Some code systems are specific to certain resources. They are listed below.

### Questionnaire

* `https://duodecim.fi/fhir/sid/vkt-questionnaire-id`: ID for questionnaire in VKT. In practice an integer string, e.g. `"348"`
* `http://loinc.org`: LOINC, for coding what type of measurement the question is asking about.
* `http://hl7.org/fhir/sid/icd-10-fi`: ICD10, for coding what type of diagnosis the question is asking about.

In the ODA project, some ODA specific code systems are used:

* `http://oda.fi/Questionnaire`: Identifies the subtype of SelfCareQuestionnaire. Values: `symptom`, other values unknown.
* `http://oda.fi/cds`: Tags what CDSS should be used. For EBMeDS, the value is `oda1`.

### ActivityDefinition

* `https://duodecim.fi/fhir/stu3/CodeSystem/activity-definition-custom-actions`: The identifier for ActivityDefinitions containing reminder texts of different priorities, as above. Values:
    * `read-reminder` (normal priority)
    * `read-prompt` (medium priority)
    * `read-alert` (high priority)
