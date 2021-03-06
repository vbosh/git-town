Feature: git-sync-fork: handling rebase conflicts between main branch and its remote with open changes

  Background:
    Given my repo has an upstream repo
    And the following commits exist in my repository
      | BRANCH | LOCATION | MESSAGE         | FILE NAME        | FILE CONTENT     |
      | main   | upstream | upstream commit | conflicting_file | upstream content |
      |        | local    | local commit    | conflicting_file | local content    |
    And I am on the "main" branch
    When I run `git sync-fork`


  Scenario: result
    Then it runs the Git commands
      | BRANCH | COMMAND                  |
      | main   | git fetch upstream       |
      | main   | git rebase upstream/main |
    And I get the error
      """
      To abort, run "git sync-fork --abort".
      To continue after you have resolved the conflicts, run "git sync-fork --continue".
      """
    And my repo has a rebase in progress


  Scenario: aborting
    When I run `git sync-fork --abort`
    Then it runs the Git commands
      | BRANCH | COMMAND            |
      | main   | git rebase --abort |
    And I end up on the "main" branch
    And there is no rebase in progress
    And I am left with my original commits


  Scenario: continuing after resolving the conflicts
    Given I resolve the conflict in "conflicting_file"
    When I run `git sync-fork --continue`
    Then it runs the Git commands
      | BRANCH | COMMAND               |
      | main   | git rebase --continue |
      | main   | git push              |
    And I end up on the "main" branch
    And I still have the following commits
      | BRANCH | LOCATION                    | MESSAGE         | FILE NAME        |
      | main   | local, remote, and upstream | upstream commit | conflicting_file |
      | main   | local, remote               | local commit    | conflicting_file |
    And now I have the following committed files
      | BRANCH | NAME             | CONTENT          |
      | main   | conflicting_file | resolved content |


  Scenario: continuing after resolving the conflicts and continuing the rebase
    Given I resolve the conflict in "conflicting_file"
    When I run `git rebase --continue; git sync-fork --continue`
    Then it runs the Git commands
      | BRANCH | COMMAND  |
      | main   | git push |
    And I end up on the "main" branch
    And I still have the following commits
      | BRANCH | LOCATION                    | MESSAGE         | FILE NAME        |
      | main   | local, remote, and upstream | upstream commit | conflicting_file |
      | main   | local, remote               | local commit    | conflicting_file |
    And now I have the following committed files
      | BRANCH | NAME             | CONTENT          |
      | main   | conflicting_file | resolved content |
