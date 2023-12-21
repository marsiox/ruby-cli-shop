require 'json'

module Configuration
  def self.config
    @config ||= load_config
  end

  private

  def self.load_config
    config_file = File.read("config.json")
    @config = JSON.parse(config_file)
  rescue Errno::ENOENT
    puts 'Configuration file not found.'
    exit
  rescue JSON::ParserError
    puts 'Configuration file is not valid JSON.'
    exit
    end
end
