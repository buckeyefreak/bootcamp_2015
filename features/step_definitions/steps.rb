Given(/^I open the "(.*?)" browser$/) do |browser|
  @browser_opened = Watir::Browser.new HelperMethods.to_browser_id(browser)
end

Then(/^the "(.*?)" browser is open$/) do |browser|
  fail ("The #{browser} browser is not open.") unless HelperMethods.to_browser_id(browser) == @browser_opened.name
  @browser_opened.close
end

Given /^I am on the USA.gov home page$/ do
  BROWSER.goto 'www.usa.gov'
end

Then /^I see a search field$/ do
  expect(BROWSER.text_field(:id =>'query')).to be_visible
end

Then /^the search field value is "([^"]*)"$/ do |search_string|
  expect(BROWSER.text_field(:id => "query").placeholder).to eq(search_string)
end

Then /^I see a search button$/ do
  expect(BROWSER.button(:id => "buscarSubmit").present?).to be_truthy
end

Then /^the search button label is "([^"]*)"$/ do |button_label|
  expect(BROWSER.button(:id => "buscarSubmit").text).to eq(button_label)
end

When(/^I submit a search "(.*?)"$/) do |search_string|
  BROWSER.text_field(:id => "query").set search_string
  BROWSER.button(:id => "buscarSubmit").click
end

Then(/^I see "(.*?)" search result\(s\)$/) do |expected_count|
# parse expected count
    parse_count = expected_count.to_s.match(/(\d*)([a-z|A-Z ]*)(\d*)/)
    compare_to = parse_count[2].strip
    count = parse_count[1] == '' ? parse_count[3].to_i : parse_count[1].to_i

# get the number of results
    result_count = BROWSER.divs(:id => /^result-/).size
    no_result = BROWSER.div(:id => "no-results").exists?

# determine if step passes 
    comparison = case compare_to
                 when '', /equal/
                   count == result_count
                 when 'less than'
                   result_count < count
                 when 'greater than'
                   result_count > count
                 when 'or less'
                   result_count <= count
                 when 'or more', 'at least'
                   result_count >= count
                 when 'no results found'
                   no_result == true
                 else
                   fail ("Comparison #{compare_to} not supported")
                 end

    expect(result_count).to be_truthy
end

Then /^a "([^"]*)" message displays$/ do |message|
  expect(BROWSER.div(:id => 'no-results').text).to include(message)
end

Then(/^I see the search term truncated to (\d+) characters$/) do |search_size_allowed|
  expect(BROWSER.text_field(:id =>"query").value.size).to eq(search_size_allowed).to_i
end
