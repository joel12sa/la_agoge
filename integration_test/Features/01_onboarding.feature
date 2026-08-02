@onboarding
Feature: Onboarding - gender and archetype selection
  As a new user of AGOGE
  I want to select my gender track and my motivational archetype
  So that the app personalizes visuals, copy, and messaging for the rest of my journey

  Background:
    Given I have just opened AGOGE for the first time
    And I have seen the splash screen and tapped "CONTINUAR"

  # ---------------------------------------------------------------------
  # Gender selection
  # ---------------------------------------------------------------------

  Scenario: User selects a gender track
    Given I am on the gender selection screen
    When I tap the "♂" icon
    Then my profile "gender" field should be set to "male"
    And I should be routed to the male-track archetype screen
    And all subsequent screens should load the male color palette and copy set

  Scenario Outline: Selecting either gender loads the matching theme
    Given I am on the gender selection screen
    When I tap the "<icon>" icon
    Then my profile "gender" field should be set to "<gender>"
    And the app should load the "<palette>" palette for all following screens
    And the app should load the "<group_label>" group label ("se forjan guerreros/guerreras")

    Examples:
      | icon | gender | palette          | group_label |
      | ♂    | male   | red/black        | guerreros   |
      | ♀    | female | gold/bronze      | guerreras   |

  Scenario: Gender selection is required before continuing
    Given I am on the gender selection screen
    When I try to continue without selecting an icon
    Then the "continue" action should remain disabled
    And no navigation should occur

  # ---------------------------------------------------------------------
  # Archetype selection
  # ---------------------------------------------------------------------

  Scenario: Male-track user selects an archetype
    Given my profile "gender" is "male"
    And I am on the archetype screen "¿Eres presa o depredador?"
    When I tap "DEPREDADOR"
    Then my profile "archetype" field should be set to "depredador"
    And I should see the entry disclaimer text before I can proceed
    And I should be routed to the challenge tier selection screen

  Scenario: Female-track user selects an archetype
    Given my profile "gender" is "female"
    And I am on the archetype screen "¿Eres una muñeca rota o arquitecta de tu destino?"
    When I tap "ARQ. DE UN IMPERIO"
    Then my profile "archetype" field should be set to "arquitecta"
    And I should see the entry disclaimer text before I can proceed
    And I should be routed to the challenge tier selection screen

  Scenario: Archetype selection is required before continuing
    Given I am on the archetype screen
    When I try to continue without selecting an option
    Then the "continue" action should remain disabled

  Scenario: Entry disclaimer is always shown
    Given I am on the archetype screen
    Then I should see the following disclaimer lines:
      | line                                |
      | Al entrar aceptas que el camino duele |
      | Que nadie va a rescatarte            |
      | Que eres el único responsable        |
