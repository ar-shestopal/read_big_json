require 'concurrent/executor/fixed_thread_pool'
require 'json'

class JsonFileWriter
  FILE_DIR = File.join(File.dirname(__FILE__), '../out').freeze

  def initialize
    @count = 0

    # Ideally, we would use message brocker to communicate
    # between the reader and writer as simple queue
    # can create memmory leaks if reader is faster than writer
    # but for the sake of simplicity, we will use queue
    @queue = Queue.new
  end

  def write_to_file(objects)
    filename = "#{FILE_DIR}/batch_#{@count}.json"
    @queue << { obj: objects.to_json, filename: filename }

    while @queue.size > 0
      # Its better to use thread pool here to avoid creating too many threads
      # but for the sake of simplicity, we will use single thread
      trh = Thread.new do
        obj = @queue.pop
        File.open(obj[:filename], 'w') { |file| file.write(obj[:obj]) }
      end
      trh.join
    end
  end
end


