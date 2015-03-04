Feature: git-pr when origin is on GitHub

  As a developer having finished a feature in a repository hosted on GitHub
  I want to be able to easily create a pull request
  So that I have more time for coding the next feature instead of wasting it with process boilerplate.


  Scenario Outline: result
    Given I have a feature branch named "feature"
    And my remote origin is <ORIGIN>
    And I have "open" installed
    And I am on the "feature" branch
    When I run `git pr`
    Then I see a new GitHub pull request for the "feature" branch in the "<REPOSITORY>" repo in my browser

    Examples:
      | ORIGIN                                                | REPOSITORY                     |
      | http://github.com/Originate/git-town.git              | Originate/git-town             |
      | http://github.com/Originate/git-town                  | Originate/git-town             |
      | https://github.com/Originate/git-town.git             | Originate/git-town             |
      | https://github.com/Originate/git-town                 | Originate/git-town             |
      | git@github.com:Originate/git-town.git                 | Originate/git-town             |
      | git@github.com:Originate/git-town                     | Originate/git-town             |
      | http://github.com/Originate/originate.github.com.git  | Originate/originate.github.com |
      | http://github.com/Originate/originate.github.com      | Originate/originate.github.com |
      | https://github.com/Originate/originate.github.com.git | Originate/originate.github.com |
      | https://github.com/Originate/originate.github.com     | Originate/originate.github.com |
      | git@github.com:Originate/originate.github.com.git     | Originate/originate.github.com |
      | git@github.com:Originate/originate.github.com         | Originate/originate.github.com |


  Scenario: with uncommitted changes


  Scenario: with unpushed changes
    Given I have a feature branch named "feature"
    And my remote origin is git@github.com:Originate/git-town
    And the following commits exist in my repository
      | BRANCH  | LOCATION | MESSAGE               | FILE NAME           |
      | feature | local    | local feature commit  | local_feature_file  |
    And I am on the "feature" branch
    When I run `git pr`
    Then it runs the Git commands
      | BRANCH  | COMMAND           |
      | feature | git fetch --prune |
      | feature | git stash -u      |
      | feature | git checkout main |
    And I am still on the "feature" branch
    And I have the following commits
      | BRANCH  | LOCATION         | MESSAGE              | FILE NAME          |
      | feature | local and remote | local feature commit | local_feature_file |
    And I see a new GitHub pull request for the "feature" branch in the "Originate/git-town" repo in my browser

