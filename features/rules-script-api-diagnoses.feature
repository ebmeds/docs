Feature: Diagnosis properties that a javascript-based rule can find out about a patient
  # Note: it would probably be best to split each scenario below into its own feature. It would also be good to focus more on what the script writer actually wants to achieve than what the script API functions are at the moment.
  Much of EBMEDS' functionality is due to clinician-written javascript rules, so-called scripts. Here we detail what kind of diagnosis information can be gotten out of the patient data sent to EBMEDS for use in the scripts.

  Background:
    Given a patient "Adam"
    And a medical professional "Dumbledore"
    And Dumbledore calls EBMEDS with Adam's patient info

  Scenario: Checking for an active diagnosis
    Given that Adam has a diagnosis "Scurvy" dated two years ago (still active)
    And Adam has a diagnosis "Flu" dated one year ago (ended a week later)
    And a script that fires a reminder "A" if the patient has Scurvy
    And a script that fires a reminder "B" if the patient has Flu
    Then Dumbledore receives reminder A
    And Dumbledore does not receive reminder B

  Scenario: Checking for a recent diagnosis
    Given that Adam has a diagnosis "Fever" starting two weeks ago (ended 2 days later)
    And a script that fires a reminder "A" if the patient has had a Fever within the last 30 days
    Then Dumbledore receives reminder A

  Scenario: Checking the patient's age
    Given a script that fires a reminder "A" if Adam is over 10 years old
    And Adam is over 10 years old
    Then Dumbledore receives reminder A

  Scenario: Echoing back the hand-written name of a diagnosis
    Given that Adam has a diagnosis "Flu" which is correctly coded using a supported codesystem but Dumbledore has misspelled the human-readable name as "Ful"
    And a script wants to refer to the diagnosis in a reminder message it is triggering
    Then Dumbledore will receive a reminder regarding the "Ful" diagnosis

  Scenario: Getting the first occurrence date of a diagnosis
    Given that Adam has multiple diagnoses of "Scurvy" throughout the years
    And a script reminder "A" relying on the date of the first Scurvy diagnosis being older/newer than a certain date
    And Adam fits the bill
    Then Dumbledore will receive reminder A

  Scenario: Getting the number of occurrences of a diagnosis
    Given that Adam has multiple diagnoses of "Scurvy" throughout the years
    And a script reminder "A" relying on the the amount of Scurvy diagnoses being more than one
    And Adam fits the bill
    Then Dumbledore will receive reminder A

  # Note: Quite many scripts do clumsy and error prone juggling of start and end dates
  # so the feature below should preferably be replaced by whatever these hand-written
  # algorithms are trying to do.
  Scenario: Getting the start and/or end date of a diagnosis
    Given that Adam has been diagnosed with "Scurvy" three times in the last year
    And a script "PREVIOUS_SCURVY" that triggers reminder "A" depending on the start and end date of the second to last scurvy diagnosis (if it exists)
    And this condition is satisfied
    Then Dumbledore will receive reminder A