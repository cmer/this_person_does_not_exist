require "this_person_does_not_exist/version"
require 'httparty'
require 'securerandom'

module ThisPersonDoesNotExist
  class Error < StandardError; end

  class Client
    URL = "https://thispersondoesnotexist.com/image"
    HEADERS = {
      "authority" => "thispersondoesnotexist.com",
      "pragma" => "no-cache",
      "cache-control" => "no-cache",
      "upgrade-insecure-requests" => "1",
      "user-agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.80 Safari/537.36",
      "accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/jpeg,*/*;q=0.8,application/signed-exchange;v=b3",
      "referer" => "https://thispersondoesnotexist.com/",
      "accept-language" => "en-US,en;q=0.9"
    }

    def save_as(path)
      File.open(path, "w") do |file|
        file.binmode

        HTTParty.get(bust_cache_url, headers: HEADERS, stream_body: true) do |fragment|
          file.write(fragment)
        end
      end
      path
    end

    private
    def bust_cache_url
      URL + "?#{SecureRandom.hex}"
    end

    def image_format_for(path)
      case path.split('.').last.downcase
        when 'jpeg', 'jpg'; 'jpg'
        when 'webp'; 'webp'
        else; 'jpg'
      end
    end
  end

  def ThisPersonDoesNotExist.save_as(path)
    @client ||= Client.new
    @client.save_as(path)
  end
end
