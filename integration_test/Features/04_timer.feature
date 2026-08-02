@timer
Feature: Time registration ("¿Cuánto tardaste?")
  As a user completing a challenge
  I want my completion time to be captured accurately
  So that my result is recorded fairly and cannot be arbitrarily edited

  Background:
    Given I have uploaded valid video and photo evidence
    And I am on the "¿Cuánto tardaste?" screen

  Scenario: In-app stopwatch runs during the recorded video
    Given the in-app stopwatch started automatically when video recording began
    When I stop the video recording
    Then the stopwatch should stop automatically
    And the elapsed time should be pre-filled in MIN:SEG format
    And the pre-filled time should be read-only by default

  Scenario: User confirms the captured time
    Given the stopwatch captured "05:00"
    When I tap "Registrar reto"
    Then the attempt's "time_seconds" should be set to 300
    And the time should become immutable for this attempt

  Scenario: Manual time entry fallback (only if stopwatch unavailable)
    Given the in-app stopwatch failed to capture a time
    When I am prompted to manually enter MIN and SEG
    And I enter "07" minutes and "30" seconds
    And I tap "Registrar reto"
    Then the attempt's "time_seconds" should be set to 450
    And the attempt should be flagged internally as "manual_time_entry: true" for moderation visibility

  Scenario: No time value is judged as "bad"
    Given I enter any valid time between 00:01 and 59:59
    When I submit it
    Then the app should accept it without a pass/fail judgment
    And the copy should reflect "No hay tiempo malo, solo el tuyo es real"

  Scenario: Time is required before continuing
    Given no time has been captured or entered
    When I try to tap "Registrar reto"
    Then the action should remain disabled
