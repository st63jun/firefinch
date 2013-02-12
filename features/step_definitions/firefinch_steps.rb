# Put your step definitions here
Then /^the banner should document that this app takes ([0-9]+) arguments?$/ do |argc|
  step %(the output should match /Usage: #{@app_name}\\s*\(\\[options\\]\)?( (\\w+)){#{argc}}$/)
end
