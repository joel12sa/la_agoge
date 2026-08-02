@evidence_capture
Feature: Evidence capture ("Prueba de batalla")
  As a user attempting a challenge
  I want to record my training video and a final photo directly with my camera
  So that the evidence is trustworthy and cannot easily be faked with old media

  Background:
    Given I have selected a challenge tier
    And I am on the "Prueba de batalla" evidence screen

  # ---------------------------------------------------------------------
  # Camera-first capture (primary path)
  # ---------------------------------------------------------------------

  Scenario: User records a training video with the in-app camera
    When I tap the video capture control
    And the app requests camera and microphone permission
    And I grant permission
    And I record a video lasting at least 30 seconds
    And I stop the recording
    Then the video should be attached to the current attempt as "video_url"
    And the video should be tagged with a server-verified capture timestamp
    And the "Video de entrenamiento" slot should display as "SUBIDO"

  Scenario: Recorded video is shorter than the minimum duration
    When I record a video lasting 12 seconds
    And I stop the recording
    Then I should see an error "El video debe durar al menos 30 segundos"
    And the video should NOT be attached to the current attempt
    And I should be prompted to record again

  Scenario: User captures the final photo with the in-app camera
    When I tap the photo capture control
    And I grant camera permission
    And I take a photo
    Then the photo should be attached to the current attempt as "photo_url"
    And the photo should be tagged with a server-verified capture timestamp
    And the "Foto Final" slot should display as "SUBIDO"

  # ---------------------------------------------------------------------
  # Gallery fallback (secondary path, time-restricted)
  # ---------------------------------------------------------------------

  Scenario: Camera permission denied offers a restricted gallery fallback
    Given the user has denied camera permission
    When I tap the video capture control
    Then I should see a message explaining that camera access is required for stronger verification
    And I should be offered a "choose from gallery" fallback option

  Scenario: Gallery fallback accepts only recently created files
    Given I am using the gallery fallback for video
    When I select a video file created 8 minutes ago
    Then the file should be accepted and attached to the current attempt

  Scenario: Gallery fallback rejects stale files
    Given I am using the gallery fallback for video
    When I select a video file created 3 hours ago
    Then I should see an error "Solo se aceptan archivos grabados recientemente"
    And the file should NOT be attached to the current attempt

  # ---------------------------------------------------------------------
  # Format / size validation
  # ---------------------------------------------------------------------

  Scenario Outline: File format validation
    When I attach a file of type "<mime_type>" as "<slot>"
    Then the upload should be "<result>"

    Examples:
      | mime_type        | slot  | result   |
      | video/mp4         | video | accepted |
      | video/quicktime   | video | accepted |
      | video/avi         | video | rejected |
      | image/jpeg        | photo | accepted |
      | image/png         | photo | accepted |
      | image/gif         | photo | rejected |

  Scenario: Upload progress is shown
    Given I have recorded a valid video
    When the video begins uploading to storage
    Then I should see an upload progress indicator
    And I should be able to cancel the upload before it completes

  Scenario: Upload fails due to network loss
    Given I have recorded a valid video
    And the video is uploading
    When the network connection is lost
    Then the upload should pause and show a retry option
    And the attempt should remain in a recoverable "draft" state, not be lost

  Scenario: Honesty disclaimer is shown before continuing
    Given I am on the "Prueba de batalla" screen
    Then I should see the warning "La evidencia falsa es una traición a ti mismo. Aquí solo ganas si eres honesto."

  Scenario: Both video and photo are required to continue
    Given I have only uploaded the video
    When I try to tap "Evidencia lista"
    Then the action should remain disabled
    And I should see a message indicating the photo is still missing
