# CDA to BPA API

The EBMeDS CDA API expects CDA XML requests and responds with a Best Practice Advisory XML message.

* URL: `[base-url]/cda`

## CDA Request

The request needs to be a well formed [CDA release 2](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=7) XML message. All relevant information must be included in the structured parts of the message, the textual parts are not used.

The CDA standard allows for different representations of related concepts. A couple of examples:

* The overall message structure may contain nested sections
* The `entryRelationship` elements can be used to represent almost all kinds of information

Many of these relationships and representations are supported, but changes in the message structure and new ways of representing information can cause problems.

All the codes must use the [supported code systems](https://www.ebmeds.org/www/supported_coding_systems.asp).

Check the [example request](./request-example.xml) for more information.

## BPA Response

The response format is a BPA / CDS Advisory XML as specified by Epic.

In a production environment the response contains only those reminders that were specifically agreed on. In other environments additional script reminders may be included in the response message depending on the configuration.

In addition to the structured `Order` elements, the response also contains textual information about the reminders, often including additional information links.
