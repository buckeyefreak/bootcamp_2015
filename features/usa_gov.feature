Feature: usa.gov

  Scenario: Search section exists
    Given I am on the usa.gov home page
    Then I see the search field
    And I see a search button
    And the field value is "Search the Government..."
    And the button label is "Search"

  Scenario: Searching
    Given I am on the usa.gov home page
    When I submit a search of "gi bill"
    Then I see "at least 1" result/s

  Scenario: Special Characters
    Given I am on the usa.gov home page
    When I submit a search of "(*&^#@$@@"
    Then I see "at least 1" result/s

  Scenario: More than 50 characters
    Given I am on the usa.gov home page
    When I submit a search of "afghanistan.campaign.veterans.benefits.for.state.of.ohio"
    Then I see "0" result/s
    And I see "Sorry, no results found for 'afghanistan.campaign.veterans.benefits.for.state.o'. Try entering fewer or broader query terms.

  Scenario: Max results per page of 20
    Given I am on the usa.gov home page
    When I submit a search of "kuwait"
    Then I see "20" result/s
