Feature: drug interaction warnings from Inxbase

  Inxbase is a database of pairs of chemical compounds that produce some kind of unwanted effect when taken together as medication. The severity of the effect varies. The chemical compounds are identified by an Inxbase-specific coding system, let's call it MID for Medbase ID. The administration route of the drug is also important.

  Background:
    Given a patient "Adam"
    And a doctor "Dumbledore"
    And Adam has a medication "Tango" with some chemical components
    And Adam has a medication "Salsa" with some other chemical components
    And both Tango and Salsa are known to be taken orally
    And both drugs are identified using some Inxbase-supported codesystem

  Scenario: find an interaction for a patient
    Given Tango is converted internally into chemical components "A" and "B" (MID)
    And Salsa is converted internally into chemical component "C" (MID)
    And Inxbase has interaction information for components "A" and "C" when they are taken orally
    And said interaction has a severity of "X"
    Then "Dumbledore" receives an interaction-based reminder regarding "Tango" and "Salsa" with severity "X"