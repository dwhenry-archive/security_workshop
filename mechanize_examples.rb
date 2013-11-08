# Initialize Mechanize Agent
agent = Mechanize.new

# Visit a web page
agent.get 'http://localhost:3000/'

# agent remembers the scheme + host, so no need to supply it when navigating somewhere else
agent.get '/whatever'

# Click on a link with the given text
agent.page.link_with(text: "Click here").click

# Complete and submit the first form on the page
agent.page.forms.first.tap do |f|
  f['user[email]']                     = 'hello@whatever.com'
  f['user[password]']                  = '123456789'
  f['user[password_confirmation]']     = '123456789'
  f['a_field[that_wasnt_in_the_form]'] = 'sneaky value'
  f.submit
end

# Inspect the page body
puts agent.page.body.inspect

# Search for elements on the page
puts agent.page.search('.secret').text.strip

# Set a cookie
cookie = Mechanize::Cookie.new('key', 'value').tap do |c|
  c.domain = 'localhost:3000'
  c.path   = '/'
end

agent.cookie_jar.add(agent.history.last.uri, cookie)

# Make it a little DSL-ish with instance_eval if you like...
Mechanize.new.instance_eval do
  get 'http://localhost:3000'
  page.link_with(text: 'Sign up').click
  page.forms.first.tap do |f|
    f['user[email]']                     = 'hello@whatever.com'
    f['user[password]']                  = '123456789'
    f['user[password_confirmation]']     = '123456789'
    f.submit
  end
end

end