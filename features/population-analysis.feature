Feature: Population analysis

  Population analysis consists of sending patient data for multiple patients to EBMEDS and associating them together using some unique "batch run ID". This feature list is intentionally left quite short, since caregap has its own feature list.

  Background:
    Given a patient "Adam"
    And a patient "Eve"
    And a Caregap user "Snape"
    And a batch run ID "B"

  Scenario: Basic functionality
    Given that Snape sends Adam's and Eve's patient information in two separate requests
    And each request has the batch run ID "B"
    And each request has the triggering event "onVirtualHealthCheck"
    Then Snape can view the patient data statistics for population "B" in Kibana
    And Snape can get quality measures for population "B"