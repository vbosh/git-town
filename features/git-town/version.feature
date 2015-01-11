Feature: git town: show the current Git Town version

  As a user unsure about which version of Git Town is installed on a machine
  I want to quickly get this information
  So that I can manage my Git Town deployment effectively.


  Scenario: Using "version" flag
    When I run `git town version`
    Then I see "Git Town 0.5.0"
