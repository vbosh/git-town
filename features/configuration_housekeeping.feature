Feature: Configuration housekeeping

  Scenario: Entering a main branch
    Given I don't have a main branch name configured
    When I run `git hack feature` and enter "main"
    Then the main branch name is now configured as "main"


  Scenario: Entering a blank main branch
    Given I don't have a main branch name configured
    When I run `git hack feature` and enter "" while allowing errors
    Then I get the error "You have not provided the name for the main branch."


  Scenario: Automatic update of old main branch configuration
    Given I have an old configuration file with main branch: "main"
    When I run `git hack feature`
    Then the main branch name is now configured as "main"
    And I don't have an old configuration file anymore
