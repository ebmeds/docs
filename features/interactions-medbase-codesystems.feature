Feature: mutliple codesystem support and prioritization for Medbase reminders

  Medbase products internally only understands their own codesystem for chemical components in drugs, DLV. (There is also SFI for historical reasons, nowadays a subset of DLV.) Support is provided by Medbase for mapping ATC and VNR codesystems into DLV. VNR includes the drug route information, ATC does not.

  Background:
    Given a patient "Adam"
    And a doctor "Dumbledore"
    And Adam has a medication "Tango" with some chemical components
    And Adam has a medication "Salsa" with some other chemical components
    And Tango is known to be taken orally
    And Salsa has an undocumented/unknown administration route

  Scenario: use route information when available
    Given that Tango is identified by the "VNR" codesystem
    And Salsa is identified by the "ATC" codesystem
    Then Tango is split into DLV drug components that have a specific route information (given by the VNR code)
    And Salsa is split into DLV drug components with no route information (analogous to "all routes")
    And Medbase reminders (interactions, indications, contraindications, gravlact, renal failure) are produced for the aforementioned components and routes

  Scenario: support multiple drug codesystems for the same drug
    Given that Tango is identified by both the "VNR" and "ATC" codesystems
    And Salsa is identified only by the "ATC" codesystem
    Then Tango will use the "VNR" codesystem (it is preferred) for mapping to DLV components
    And Salsa will use the "ATC" codesystem for mapping to DLV components
    And Medbase reminders (interactions, indications, contraindications, gravlact, renal failure)are produced for the aforementioned components