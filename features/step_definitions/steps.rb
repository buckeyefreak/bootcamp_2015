Given(/^I open the "(.*?)" browser$/) do |browser|
  BROWSER = Watir::Browser.new HelperMethods.to_browser_id(browser)
end

Then(/^the "(.*?)" browser is open$/) do |browser|
  fail ("The #{browser} browser is not open.") unless HelperMethods.to_browser_id(browser) == BROWSER.name
  BROWSER.close
end

Given /^I am on the USA.gov home page$/ do
  BROWSER.goto 'www.usa.gov'
end

$searchId = 'query'
$searchButton = 'buscarSubmit'
Then(/^I see the search field$/) do

  fail ("Search field id #{$searchId} was not found.") unless BROWSER.text_field(:id => $searchId).exists?
end


And(/^I see a search button$/) do
  fail ("Search button #{$searchButton} was not found.") unless BROWSER.button(:id => $searchButton).exists?
end


And(/^the field value is "(.*?)"$/) do |placeholder|
  actualPlaceholder = BROWSER.text_field(:id => $searchId).placeholder
  fail ("The placeholder text of #{actualPlaceholder}, found on usa.gov does not match the required placeholder text of #{placeholder}") unless actualPlaceholder.eql?(placeholder)
end


And(/^the button label is "(.*?)"$/) do |label|
  actualLabel = BROWSER.button(:id => $searchButton).value
  puts label
  puts actualLabel
  fail ("The label for the search button is #{actualLabel}, and does not match the required label of #{label}") unless actualLabel.eql?(label)
end


When(/^I submit a search of "(.*?)"$/) do |search|
  BROWSER.text_field(:id => $searchId).set search
  $truncatedSearchLength = BROWSER.text_field(:id => $searchId).value.length
  $enteredSearchLength = search.length
  BROWSER.button(:id => $searchButton).click
end


Then(/^I see "(.*?)" result\/s$/) do |expected_results|
  max_num_results = 20
  max_search_length = 50
  actual_num_results = BROWSER.divs(:id => /^result-/).size

  puts expected_results
  puts actual_num_results

  if expected_results.include?(/\D/)
    expected_results = expected_results
  else
    expected_results.delete(/[^0-9]/)
  end

  puts "after change #{expected_results}"

  #div class next_page
  #failure messages

  #Scenario: --- fail if not at least 1 result
  fail("Number of results returned was #{actual_results} but at least #{expected_results} was required to pass") unless actual_results >= expected_results
  #Scenario: --- fail if allows more than 50 characters
  fail("Search string entered contained #{$enteredSearchLength} but was not truncated to the max of #{max_search_length} characters") unless $truncatedSearchLength <= max_search_length
  #Scenario: --- fail if less than 20 results per page and more than 1 page OR more than 20 results per page
  fail("Search returned #{actual_num_results} on one page but only #{max_num_results} is allowed") unless actual_num_results <= max_num_results.to_i
end

#  searchText = BROWSER.browser.text.include?(bad_search)
# fail("The search term '#{bad_search}' was not found on the no results page") unless searchText == true
