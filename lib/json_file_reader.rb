require 'yajl/ffi'
require_relative 'json_file_writer'

class JsonFileReader
  attr_accessor :objects

  SPECIAL_KEYS = %w[mentions hashtags _id].freeze
  OBJECTS_TO_WRITE_COUNT = 100

  def initialize(file, writer = JsonFileWriter.new)
    @writer = writer
    @stream = File.open(file)

    @parser = create_parser
    @last_event = nil
    @objects = []
    @current_object = {}
    @last_key = nil
    @last_value = nil

    %w[mentions hashtags].each do |key|
      instance_variable_set("@#{key}_started", false)
      instance_variable_set("@#{key}_arr", [])
    end
  end

  def parse_file
    @stream.each(1024) do |chunk|
      @parser << chunk

      parse_key(@last_key)
      parse_array("mentions")
      parse_array("hashtags")

      # if we finished parsing an object, add it to the array and set a new object
      if @last_event == :end_array && @current_object["hashtags"] && @current_object["mentions"]
        postprocess_current_object
        @objects << @current_object
        @current_object = {}
      end

      # if we have enough objects, write them to the file
      if @objects.count == OBJECTS_TO_WRITE_COUNT
        write_objects_to_file
        @objects = []
      end
    end
  end

  private

  def write_objects_to_file
    @writer.write_to_file(@objects)
  end

  def postprocess_current_object
    @current_object["bio"] = @current_object["bio"].gsub(/[^a-zA-Z0-9\s]/, '') if @current_object["bio"]
  end

  def parse_key(key)
    return unless key

    return if SPECIAL_KEYS.include?(key)

    @current_object[key] = @last_value
  end

  def parse_array(key_name)
    instance_variable_set("@#{key_name}_started", true) if @last_key == key_name && @last_event == :start_array

    if instance_variable_get("@#{key_name}_started") && @last_event == :end_array
      instance_variable_set("@#{key_name}_started", false)
      @current_object[key_name] = instance_variable_get("@#{key_name}_arr")[1..-1]

      instance_variable_set("@#{key_name}_arr", [])
    end

    instance_variable_get("@#{key_name}_arr") << @last_value if instance_variable_get("@#{key_name}_started")
  end

  def create_parser
    parser = Yajl::FFI::Parser.new
    parser.start_object { @current_object = { } }
    parser.start_object   { @last_event = :start_object }
    parser.end_object     { @last_event = :end_object }
    parser.start_array    { @last_event = :start_array  }
    parser.end_array      { @last_event = :end_array }
    parser.key            { |k| @last_key = k }
    parser.value          { |v| @last_value = v }
    parser
  end
end