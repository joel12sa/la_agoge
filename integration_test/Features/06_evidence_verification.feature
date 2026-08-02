@evidence_verification
Feature: Evidence verification and result ("Acceso Concedido")
  As the system
  I want to analyze submitted evidence and communicate a result to the user
  So that XP is only awarded for plausible, honest attempts

  Background:
    Given a user has submitted a challenge attempt with status "analyzing"

  Scenario: Evidence analysis runs asynchronously
    When the attempt enters the "analyzing" state
    Then the photo (and optionally sampled video frames) should be sent to the vision analysis service
    And the user should not be blocked waiting on the response in real time
    And the user should be notified (push or in-app) once analysis completes

  Scenario: Evidence is approved
    Given the vision analysis service returns a plausible-effort result
    When the attempt is marked "approved"
    Then the attempt's "ai_analysis_text" should be stored and shown to the user
    And the analysis text should use probabilistic language (e.g. "Es probable que...") rather than a certainty claim
    And the user's XP total should increase by the tier's xp_reward
    And the user's rank should be recalculated
    And the user should see the "Acceso Concedido" screen with the "Entra al Templo" call to action

  Scenario: Evidence is inconclusive
    Given the vision analysis service returns a low-confidence result
    When the attempt is marked "needs_review"
    Then the attempt should be queued for manual moderation review
    And the user should see a message that their evidence is under additional review
    And XP should NOT be awarded until a moderator makes a decision

  Scenario: Evidence is rejected
    Given a moderator or the vision analysis service rejects the evidence as invalid
    When the attempt is marked "rejected"
    Then XP should NOT be awarded
    And the user should see a clear explanation of why the evidence was rejected
    And the user should be offered the option to retry the challenge with new evidence

  Scenario: Rejected attempt does not block future attempts
    Given my most recent attempt was "rejected"
    When I start a new attempt on the same or a different tier
    Then a new "ChallengeAttempt" record should be created
    And my XP total should be unaffected by the rejected attempt

  Scenario: Inappropriate content moderation runs independently of effort analysis
    Given the submitted photo or video is flagged by the content moderation service
    When the attempt is processed
    Then the attempt should be marked "rejected" regardless of the effort-analysis result
    And the media should not be exposed to other users or moderators beyond what is required for review
