RSpec.describe Daimyo::Export do
  let(:daimyo_client) { described_class.new }
  let(:client_mock) { instance_double('Daimyo::Client') }

  describe '.new' do
    describe '@wiki' do
      let(:already_existing_client_mock) { instance_double('Daimyo::Client') }

      before do
        expect(Daimyo::Client).to receive(:new).and_return(client_mock)
      end

      subject { daimyo_client.instance_variable_get(:@wiki) }

      context 'when @wiki is nil' do
        it { is_expected.to eq client_mock }
        it { is_expected.not_to eq already_existing_client_mock }
      end

      context 'when @wiki is not nil' do
        before do
          daimyo_client.instance_variable_set(:@wiki, already_existing_client_mock)
          expect(Daimyo::Client).not_to receive(:new)
        end

        it { is_expected.to eq already_existing_client_mock }
        it { is_expected.not_to eq client_mock }
      end
    end
  end

  describe '#run' do
    let(:space_id) { '1' }
    let(:project_id) { '2' }
    let(:wiki_id) { '3' }
    let(:wiki_content) { "content\n" }
    let(:list_wiki_mock) { instance_double('wiki', id: wiki_id) }
    let(:list_result_mock) { instance_double('list', body: [list_wiki_mock]) }
    let(:progressbar_mock) { instance_double('ProgressBar::Base') }
    let(:export_wiki_mock) { instance_double('wiki', name: wiki_name, content: wiki_content) }
    let(:export_result_mock) { instance_double('export', body: export_wiki_mock) }
    let(:output_file) { StringIO.new }
    let(:original_file) { StringIO.new }

    before do
      client_mock.instance_variable_set(:@client, BacklogKit::Client.new(space_id: space_id))
      expect(Daimyo::Client).to receive(:new).and_return(client_mock)
      expect(client_mock).to receive(:list).with(project_id).and_return(list_result_mock)
      expect(ProgressBar).to receive(:create).and_return(progressbar_mock)
      expect(progressbar_mock).to receive(:increment)
      expect(progressbar_mock).to receive(:finish)
      expect(client_mock).to receive(:export).with(wiki_id).and_return(export_result_mock)
      expect(FileTest).to receive(:exist?).and_return(false)
    end

    context 'when wiki_name includes `/`' do
      let(:wiki_name) { 'a/b/c' }

      before do
        expect(FileUtils).to receive(:mkdir_p).with("#{space_id}/#{project_id}/a/b")
        expect(File).to receive(:open).with("#{space_id}/#{project_id}/a/b/#{wiki_id}_c.md", 'w').and_yield(output_file)
        expect(File).to receive(:open).with("#{space_id}/#{project_id}/a/b/.#{wiki_id}_c.md", 'w').and_yield(original_file)

        daimyo_client.run(project_id)
      end

      describe 'output file' do
        subject { output_file.string }
        it { is_expected.to eq wiki_content }
      end

      describe 'original file' do
        subject { original_file.string }
        it { is_expected.to eq wiki_content }
      end
    end

    context 'when wiki_name does not include `/`' do
      let(:wiki_name) { 'a' }

      before do
        expect(FileUtils).to receive(:mkdir_p).with("#{space_id}/#{project_id}")
        expect(File).to receive(:open).with("#{space_id}/#{project_id}/#{wiki_id}_#{wiki_name}.md", 'w').and_yield(output_file)
        expect(File).to receive(:open).with("#{space_id}/#{project_id}/.#{wiki_id}_#{wiki_name}.md", 'w').and_yield(original_file)

        daimyo_client.run(project_id)
      end

      describe 'output file' do
        subject { output_file.string }
        it { is_expected.to eq wiki_content }
      end

      describe 'original file' do
        subject { original_file.string }
        it { is_expected.to eq wiki_content }
      end
    end
  end
end
