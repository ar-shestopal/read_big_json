# Class to handle the command line arguments and pass them to the Reader class
# We can add more validations here if needed but I ommitted them do to time constraints
require_relative 'json_file_reader'

class ReaderCli
  def initialize

    raise ArgumentError.new("Please provide a file path") unless ARGV[1]
    path = File.join(
      File.dirname(File.absolute_path(__FILE__)),
      ARGV[1]
    )

    JsonFileReader.new(path).parse_file
  end
end