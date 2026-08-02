@challenge_selection
Feature: Challenge tier selection ("La Puerta del Agogé")
  As a user who has completed onboarding
  I want to choose a burpee challenge tier
  So that I know how much effort is required and how much XP I will earn

  Background:
    Given I have completed gender and archetype selection
    And I am on the "La Puerta del Agogé" screen

  Scenario Outline: Available challenge tiers
    Then I should see a tier card for "<reps> burpees" labeled "<rank>"
    And that card should show a reward of "<xp>" XP

    Examples:
      | reps | rank         | xp   |
      | 50   | Pre Iniciado | 250  |
      | 100  | Iniciado     | 500  |
      | 200  | Guerrero     | 1200 |

  Scenario: User selects a challenge tier
    When I tap the "100 burpees" card
    Then that card should become visually selected
    And any previously selected card should become unselected
    And a pending "ChallengeAttempt" should be created with tier "Iniciado", reps_required 100, xp_reward 500

  Scenario: Only one tier can be selected at a time
    Given I have selected the "50 burpees" tier
    When I tap the "200 burpees" card
    Then only the "200 burpees" card should remain selected
    And the pending "ChallengeAttempt" should be updated to tier "Guerrero", reps_required 200, xp_reward 1200

  Scenario: Confirming the challenge navigates to evidence capture
    Given I have selected the "50 burpees" tier
    When I tap "Acepta el reto" (or "CONTINUAR" on the male track)
    Then I should be routed to the evidence capture screen
    And the selected tier should remain associated with the current attempt

  Scenario: Tier data is sourced from configuration, not hardcoded
    Given the backend challenge tier configuration changes the "Guerrero" tier XP to 1500
    When I open the challenge tier selection screen
    Then the "200 burpees" card should display "+1500XP"
