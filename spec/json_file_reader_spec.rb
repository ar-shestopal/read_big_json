require 'spec_helper'
require 'pry'

RSpec.describe 'JsonFileReader' do
  let(:file_path) { "#{RSPEC_ROOT}/fixtures/test_file.json" }

  describe '#read' do
    subject { JsonFileReader.new(file_path, writer) }

    let(:writer) { double('JsonFileWriter') }

    before do
      allow(writer).to receive(:write_to_file)
    end

    it 'extracts json objects from stream' do
      subject.parse_file

      expect(subject.objects.size).to eq(2)
    end

    it 'removes _id from objects' do
      subject.parse_file

      expect(subject.objects.first.keys).not_to include("_id")
    end

    it 'extracts mentions from objects' do
      subject.parse_file

      expect(subject.objects.first['mentions']).not_to be_empty
    end

    it 'extracts mentions from objects' do
      subject.parse_file

      expect(subject.objects.first['mentions']).not_to be_empty
    end
  end
end