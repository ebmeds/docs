# Overview

The Evidence-Based Medicine electronic Decision Support (EBMeDS) system brings evidence into practice by means of context-sensitive guidance at the point of care.

EBMeDS receives structured patient data from electronic health records (EHRs) and returns reminders, therapeutic suggestions and diagnosis-specific links to guidelines. It can also be used to automatically prefill forms and calculators with patient specific data. In addition to real-time use, the EBMeDS decision support rules (so-called *scripts*) can also be run in patient populations ("virtual health checks").

EBMeDS is a platform-independent service, which can be integrated into any EHR containing structured patient data. Other customized integrations are also possible.

In addition to local installations of EBMeDS, there is also a cloud version of the service called [](https://ebmedscloud.org) which will be brought into use incrementally during 2017-2018.

EBMeDS is developed by [Duodecim Medical Publications Ltd](http://www.duodecimpublications.com/), a Finnish company owned by the Finnish Medical Society Duodecim. Both the association and the company have a long-standing collaborative relationship with the [Cochrane Collaboration](http://www.cochrane.org/), the [GRADE Working Group](http://www.gradeworkinggroup.org/), the [Guidelines International Network (G-I-N)](http://www.g-i-n.net/) and the publishing company [Wiley-Blackwell](http://www.wiley.com/).

# Getting started

EBMeDS talks two different protocols, JSON-formatted FHIR STU3, and a native XML format:

* [Get started with FHIR](api/fhir/getting-started.md)
* [Get started with XML](api/xml/getting-started.md)