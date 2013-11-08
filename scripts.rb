require 'mechanize'
require 'pry'
require 'pry-debugger'
# require 'nokogiri'

class Scripts
  module Helper
    attr_reader :agent
    def initialize
      @agent ||= Mechanize.new
      @agent.get 'http://localhost:3000/'

    end

    def signin(name='default')
      agent.get '/users/sign_in'

      agent.page.forms.first.tap do |f|

        f['user[email]']                     = "#{name}@whatever.com"
        f['user[password]']                  = '123456789'
        f.submit
      end

      if agent.page.body =~ /Sign in/
        create_user(name)
      end
    end

    def create_user(name)
      # agent remembers the scheme + host, so no need to supply it when navigating somewhere else
      agent.get '/users/sign_up'

      # Click on a link with the given text
      agent.page.forms.first.tap do |f|
        f['user[name]']                      = name
        f['user[email]']                     = name + '@whatever.com'
        f['user[password]']                  = '123456789'
        f['user[password_confirmation]']     = '123456789'
        f['a_field[that_wasnt_in_the_form]'] = 'sneaky value'
        f.submit
      end
    end
  end
end