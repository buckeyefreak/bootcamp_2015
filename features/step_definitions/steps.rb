Given(/^I open the "(.*?)" browser$/) do |browser|
  @browser_opened = Watir::Browser.new to_browser_id(browser)
end

Then(/^the "(.*?)" browser is open$/) do |browser|
  fail ("The #{browser} browser is not open.") unless to_browser_id(browser).to_sym == @browser_opened.name
end

#Convert user names for browser to strings for watir-webdriver
def to_browser_id (browser)
  case browser.downcase
    when 'internet explorer', 'ie'
      'internet explorer'
    when /phantom/
      'phantomjs'
    else
      browser.downcase!.nil? ? browser : browser.downcase!
  end
end


Given(/^I am on the usa\.gov home page$/) do
  @browser_opened = Watir::Browser.new
  @browser_opened.goto 'www.usa.gov'
end

$searchId = 'query'
$searchButton = 'buscarSubmit'
Then(/^I see the search field$/) do

  fail ("Search field id #{$searchId} was not found.") unless @browser_opened.text_field(:id => $searchId).exists?
end


And(/^I see a search button$/) do
  $searchButton = 'buscarSubmit'
  fail ("Search button #{$searchButton} was not found.") unless @browser_opened.button(:id => $searchButton).exists?
end


And(/^the field value is "(.*?)"$/) do |placeholder|
  actualPlaceholder = @browser_opened.text_field(:id => $searchId).placeholder
  fail ("The placeholder text of #{actualPlaceholder}, found on usa.gov does not match the required placeholder text of #{placeholder}") unless actualPlaceholder.eql?(placeholder)
end


And(/^the button label is "(.*?)"$/) do |label|
  actualLabel = @browser_opened.button(:id => $searchButton).value
  puts label
  puts actualLabel
  fail ("The label for the search button is #{actualLabel}, and does not match the required label of #{label}") unless actualLabel.eql?(label)
end


When(/^I submit a search of "(.*?)"$/) do |search|
  @browser_opened.text_field(:id => $searchId).set search
  $truncatedSearchLength = @browser_opened.text_field(:id => $searchId).value.length
  $enteredSearchLength = search.length
  @browser_opened.button(:id => $searchButton).click
end


Then(/^I see "(.*?)" result\/s$/) do |expected_num_results|
  actual_num_results = @browser_opened.divs(:id => /^result-/).size
  puts expected_num_results.to_i
  puts actual_num_results.to_i
  max_num_results = 20
  max_search_length = 50

  #div class next_page
  #failure messages

  #Scenario: --- fail if not at least 1 result
  fail("Number of results returned was #{actual_num_results} but at least #{expected_num_results} was required to pass") unless actual_num_results >= expected_num_results.to_i
  #Scenario: --- fail if allows more than 50 characters
  fail("Search string entered contained #{$enteredSearchLength} but was not truncated to the max of #{max_search_length} characters") unless $truncatedSearchLength <= max_search_length.to_i
  #Scenario: --- fail if less than 20 results per page and more than 1 page OR more than 20 results per page
  fail("Search returned #{actual_num_results} on one page but only #{max_num_results} is allowed") unless actual_num_results <= max_num_results.to_i
end

And(/^I see "Sorry, no results found for '(.*?)'\. Try entering fewer or broader query terms\.$/) do |bad_search|
  searchText = @browser_opened.browser.text.include?(bad_search)
  fail("The search term '#{bad_search}' was not found on the no results page") unless searchText == true
end