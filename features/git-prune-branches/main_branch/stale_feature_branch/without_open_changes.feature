Feature: git prune-branches: remove stale feature branches when run on the main branch (without open changes)

  (see ../../feature_branch/behind_main/without_open_changes.feature)


  Background:
    Given I have a feature branch named "stale_feature" behind main
    And I am on the "main" branch
    When I run `git prune-branches`


  Scenario: result
    Then it runs the Git commands
      | BRANCH | COMMAND                        |
      | main   | git fetch --prune              |
      | main   | git push origin :stale_feature |
      | main   | git branch -d stale_feature    |
    And I end up on the "main" branch
    And the existing branches are
      | REPOSITORY | BRANCHES |
      | local      | main     |
      | remote     | main     |
      | coworker   | main     |
