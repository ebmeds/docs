# questionnaire

* https://duodecim.fi/fhir/extensions/self-care-instructions (container):
    * instruction-text (string): contains a markdown text with a link to more detailed self care instructions in terveyskirjasto.fi
* http://hl7.org/fhir/StructureDefinition/minValue (decimal): official hl7 extension for providing minimum value for a decimal number
* http://hl7.org/fhir/StructureDefinition/maxValue (decimal): official hl7 extension for providing maximum value for a decimal number
* https://duodecim.fi/fhir/extensions/item-type (string): "feedback", or "subtitle", a preciser type than only "display" for a questionnaire item.
*  https://duodecim.fi/fhir/extensions/enable-when-operator (string): extension to provide boolean logic for `enableWhen` field in questionnaire.
* http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive: "ei mikään näistä"