Feature: git-pr when origin is on Bitbucket

  As a developer having finished a feature in a repository hosted on Bitbucket
  I want to be able to quickly create a pull request
  So that I have more time for coding the next feature instead of wasting it with process boilerplate.


  Scenario Outline: result
    Given I have a feature branch named "feature"
    And my remote origin is on Bitbucket through <PROTOCOL>
    And I have "open" installed
    And I am on the "feature" branch
    When I run `git pr`
    Then I see a new Bitbucket pull request for the "feature" branch in my browser

    Examples:
      | PROTOCOL                   |
      | HTTP ending with .git      |
      | HTTP not ending with .git  |
      | HTTPS ending with .git     |
      | HTTPS not ending with .git |
      | SSH ending with .git       |
      | SSH not ending with .git   |
