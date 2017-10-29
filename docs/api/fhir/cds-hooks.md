# CDS Hooks

EBMeDS uses a slightly customized version of the [CDS Hooks](http://cds-hooks.org) standard. This standard is still in flux and will soon reach its 1.0 version, at which point these customizations will be re-evaluated.

The overall point of CDS hooks is that the calling party calls EBMeDS using two pieces of information:

* The hook name, providing the use context for this particular call
* The clinical data specified in the EBMeDS hook catalog (below)

This enables EBMeDS to tailor its output depending on the usage context, and also to provide a machine-readable format for what data is required. The context itself is not machine-readable, i.e. it is described by natural language, but some [standardized hooks exist](http://cds-hooks.org/#hook-catalog).

**Differences between the EBMeDS implementation and the current CDS hooks documentation**:

* The `prefetch` field is used widely in EBMeDS at the moment. However, this field is intended to be used as an optional performance enhancement, i.e. the assumed data model in CDS hooks is that the CDS system has access to the calling party's FHIR server, from which it can read the clinical data by itself, if the data is not provided in `prefetch`. However, in EBMeDS, the `prefetch` field is mandatory at this moment. The `context` field will be used exclusively in the future.
* The response format in CDS hooks is in the form of *cards*. The card is a simple container for a message string (and some metadata) and is therefore usually not flexible enough to contain things like specifying the recipient of the message. Therefore, the meat of the response is located in the `suggestions` field, which contains an array of FHIR resources, not the structure with different action types (`create`, `update`, `delete`) that is described in the standard. All FHIR resources in the `suggestions` array are implicitly of the `create` type at this moment.

## Hook calling format

