Feature: Medication properties that a javascript-based rule can find out about a patient
  # Note: it would probably be best to split each scenario below into its own feature. It would also be good to focus more on what the script writer actually wants to achieve than what the script API functions are at the moment.
  Much of EBMEDS' functionality is due to clinician-written javascript rules, so-called scripts. Here we detail what kind of medication information can be gotten out of the patient data sent to EBMEDS for use in the scripts.

  Background:
    Given a patient "Adam"
    And a medical professional "Dumbledore"
    And Dumbledore calls EBMEDS with Adam's patient info

  Scenario: Checking for an active medication
    Given that Adam has a medication "Ibuprofen" dated two weeks ago (still active)
    And Adam has a medication "Antihistamin" dated one year ago (ended a week later)
    And a script that fires a reminder "A" if the patient has Ibuprofen
    And a script that fires a reminder "B" if the patient has Antihistamin
    Then Dumbledore receives reminder A
    And Dumbledore does not receive reminder B

    # TODO: document rest of script API