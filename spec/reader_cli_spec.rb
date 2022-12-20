require 'spec_helper'

RSpec.describe 'ReaderCli' do
  context "when file is not given" do
    it 'raises an error if no file is given' do
      expect { ReaderCli.new }.to raise_error(ArgumentError)
    end
  end

  context 'with command line arguments' do
    before do
      ARGV.replace(["", '../spec/fixtures/test_file.json'])
    end

    it 'calls reader' do
      reader = double('reader')
      expect(JsonFileReader).to receive(:new)
      ReaderCli.new
    end
  end
end