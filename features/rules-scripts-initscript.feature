Feature: deciding which subset of EBMEDS' javascript-based rules to run

  Much of EBMEDS' functionality is due to clinician-written javascript rules, so-called scripts. The scripts contain a set of filters stating if they are to be run at all for the current patient context. The mechanism for defining filters is to add flags to the "libEBMEDS.initScript" function call. These flags are mentioned in brackets in the scenarios below.

  Background:
    Given a patient "Adam"
    And a medical professional "Dumbledore"
    And Dumbledore calls EBMEDS with Adam's patient info
    And unless otherwise stated, Adam's patient info is such that every script that is run in EBMEDS generates a reminder regarding Adam

  Scenario: run scripts based on caller country (SHOULD BE DEPRECATED)
    Given a script "FINLAND" which is set to only work in a Finnish context ("nafi")
    And a script "BELGIUM" which is set to only work in a Belgian context ("nabe")
    And a script "NOTBELGIUM" which is set to work in any country context except Belgium ("-nabe")
    And Dumbledore in his request message sets his country to Finland
    Then Dumbledore receives reminders from scripts FINLAND and NOTBELGIUM

  Scenario: run scripts based on questionnaire presence
    Given a script "COOLSCRIPT" that is set to only run if there is a questionnaire with ID "1337" in the request message ("fm1337")
    And a script "BADSCRIPT" that is set to only run if there is a questionnaire with ID "666" in the request message ("fm666")
    And Dumbledore's call contains questionnaire answers for questionnaire ID 1337
    Then Dumbledore receives reminders from COOLSCRIPT but not BADSCRIPT

  Scenario: run a script by default if no filtering info exists
    Given a script "GENERALSCRIPT" that has no explicit restrictions on when it should run or not run
    Then Dumbledore receives reminders from GENERALSCRIPT

  Scenario: run a script based on triggering event information
    Given a script "NEWDRUGSCRIPT" that is set to run if the request message says that it was triggered from a "newDrug" event ("onNewDrug")
    Given a script "NEWDIAGNOSISSCRIPT" that is set to run if the request message says that it was triggered from a "newDiagnosis" event ("onNewDiagnosis")
    Given a script "GENERALSCRIPT" that has no explicit restrictions on when it should run or not run
    Then Dumbledore receives reminders from GENERALSCRIPT and NEWDRUGSCRIPT
