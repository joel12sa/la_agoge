@submission
Feature: Summary and final submission ("Resumen del sacrificio")
  As a user who has completed a challenge attempt
  I want to review everything before submitting
  So that I can confirm accuracy before the irreversible submission

  Background:
    Given I have selected a challenge tier
    And I have uploaded valid video and photo evidence
    And I have registered a completion time
    And I am on the "Resumen del sacrificio" screen

  Scenario: Summary displays all captured data
    Then I should see the following summary rows:
      | field  | value           |
      | RETO   | 50 BURPEES      |
      | TIEMPO | 5 MIN           |
      | VIDEO  | SUBIDO          |
      | FOTO   | SUBIDO          |
      | XP     | +250            |

  Scenario: User must certify the evidence is real before submitting
    Given the certification checkbox/statement is unchecked
    When I try to tap "Cruza la Puerta"
    Then the action should remain disabled

  Scenario: Successful final submission
    Given I have certified that the evidence is real
    When I tap "Cruza la Puerta"
    Then the attempt should be submitted as a single atomic transaction (tier + time + video + photo)
    And the attempt status should change to "analyzing"
    And I should be routed to the pending/processing state
    And the "Cruza la Puerta" action should become disabled to prevent duplicate submission

  Scenario: Submission is idempotent on retry
    Given I have submitted an attempt and the network connection dropped mid-request
    When the app retries the same submission automatically
    Then no duplicate "ChallengeAttempt" record should be created
    And the original attempt_id should be reused

  Scenario: Submission is irreversible once confirmed
    Given I have successfully submitted my attempt
    When I attempt to go back to the summary screen
    Then I should not be able to edit tier, time, video, or photo for this attempt
