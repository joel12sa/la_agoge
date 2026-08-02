@gamification
Feature: XP and rank system
  As a user of AGOGE
  I want to earn XP and progress through ranks
  So that my effort over time is recognized

  Background:
    Given the tier configuration is:
      | tier          | reps | xp   |
      | Pre Iniciado  | 50   | 250  |
      | Iniciado      | 100  | 500  |
      | Guerrero      | 200  | 1200 |

  Scenario: XP accumulates across approved attempts
    Given my current XP total is 0
    When an attempt on the "Iniciado" tier is approved
    Then my XP total should become 500

  Scenario: XP does not change for rejected or pending attempts
    Given my current XP total is 500
    When an attempt on the "Guerrero" tier is submitted and still "analyzing"
    Then my XP total should remain 500
    When that same attempt is later "rejected"
    Then my XP total should remain 500

  Scenario Outline: Rank is derived from cumulative XP thresholds
    Given my cumulative XP total is <xp_total>
    Then my displayed rank should be "<rank>"

    Examples:
      | xp_total | rank         |
      | 0        | Sin rango    |
      | 250      | Pre Iniciado |
      | 750      | Iniciado     |
      | 1950     | Guerrero     |

  Scenario: Attempt history is preserved per user
    Given I have completed 3 approved attempts across different tiers
    When I view my history
    Then I should see all 3 attempts with their tier, time, date, and XP awarded

  Scenario: Tier configuration changes do not retroactively alter past XP
    Given I earned 250 XP from a "Pre Iniciado" attempt when its reward was 250 XP
    When the administrator changes the "Pre Iniciado" tier reward to 300 XP
    Then my historical attempt should still show "250 XP" awarded
    And only future attempts should award 300 XP
