require 'spec_helper'

RSpec.describe 'JsonFileWriter' do
  let(:file_path) { "#{RSPEC_ROOT}/fixtures/test_file.json" }

  describe '#write_to_files' do
    let(:objects) { JSON.parse(File.read(file_path)) }

    subject { JsonFileWriter.new }

    it 'writes objects to file' do
      expect(File).to receive(:open).with("#{JsonFileWriter::FILE_DIR}/batch_0.json", 'w')

      subject.write_to_file(objects)
    end
  end
end