RSpec.describe Daimyo::Publish do
  let(:daimyo_client) { described_class.new }
  let(:client_mock) { instance_double('Daimyo::Client') }
  let(:space_id) { '1' }
  let(:project_id) { '2' }
  let(:wiki_id) { '3' }
  let(:wiki_file) { "a/b/#{wiki_id}_c.md" }
  let(:original_wiki_file) { "a/b/.#{wiki_id}_c.md" }
  let(:not_wiki_file) { 'd/e/f.txt' }
  let(:files) do
    [
      ["#{space_id}/#{project_id}/#{original_wiki_file}", "#{space_id}/#{project_id}/#{wiki_file}"],
      ["#{space_id}/#{project_id}/#{not_wiki_file}", "#{space_id}/#{project_id}/#{not_wiki_file}"]
    ]
  end

  describe '.new' do
    describe '@wiki' do
      let(:already_existing_client_mock) { instance_double('Daimyo::Client') }

      before do
        expect(Daimyo::Client).to receive(:new).and_return(client_mock)
        expect(described_class).to receive(:new).and_call_original
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

    describe '@is_local' do
      let(:daimyo_client) { described_class.new(params) }

      subject { daimyo_client.instance_variable_get(:@is_local) }

      context 'when params is nil' do
        let(:params) { nil }
        it { is_expected.to be_nil }
      end

      context 'when params[:local] is nil' do
        let(:params) { {a: true} }
        it { is_expected.to be_nil }
      end

      context 'when params[:local] is not nil' do
        let(:params) { {local: true} }
        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#search_files' do
    before do
      client_mock.instance_variable_set(:@client, BacklogKit::Client.new(space_id: space_id))
      expect(Daimyo::Client).to receive(:new).and_return(client_mock)
      expect(described_class).to receive(:new).and_call_original
      expect(Dir).to receive(:glob).with("#{space_id}/#{project_id}/**/*").and_return(["#{space_id}/#{project_id}/#{wiki_file}", "#{space_id}/#{project_id}/#{not_wiki_file}"])
    end

    subject { daimyo_client.search_files(project_id) }
    it { is_expected.to match files }
  end

  describe '#read_file' do
    subject { daimyo_client.read_file(__FILE__) }
    it { is_expected.not_to eq '' }
  end

  describe '#run' do
    let(:dry_run) { nil }
    let(:original_wiki_content) { "original\n" }
    let(:latest_wiki_content) { "latest\n" }
    let(:export_wiki_mock) { instance_double('wiki', content: original_wiki_content) }
    let(:export_result_mock) { instance_double('export', body: export_wiki_mock) }
    let(:message) { "\e[43m#{space_id}/#{project_id}/#{wiki_file}\e[0m\n\e[31m-#{original_wiki_content.chomp}\e[0m\n\e[32m+#{latest_wiki_content.chomp}\e[0m\n" }

    before do
      expect(Daimyo::Client).to receive(:new).and_return(client_mock)
      expect(described_class).to receive(:new).and_call_original
      expect(daimyo_client).to receive(:search_files).with(project_id).and_return(files)
      expect(daimyo_client).to receive(:read_file).with(files[0][0]).and_return(original_wiki_content)
      expect(daimyo_client).to receive(:read_file).with(files[0][1]).and_return(latest_wiki_content)
    end

    subject { -> { daimyo_client.run(project_id, dry_run) } }

    context 'when dry_run is nil' do
      before do
        expect(client_mock).to receive(:export).with(wiki_id).and_return(export_result_mock)
        expect(client_mock).to receive(:publish).with(wiki_id, 'a/b/c', "latest\n")
      end

      it { is_expected.to output(message).to_stdout }
    end

    context 'when dry_run is not nil' do
      let(:dry_run) { true }

      before do
        expect(client_mock).to receive(:export).with(wiki_id).and_return(export_result_mock)
        expect(client_mock).not_to receive(:publish)
      end

      it { is_expected.to output(message).to_stdout }
    end

    context 'when @is_local is true' do
      let(:daimyo_client) { described_class.new(local: true) }
      let(:message) { "\e[41m#{space_id}/#{project_id}/#{wiki_file}\e[0m\n\e[31m-#{original_wiki_content.chomp}\e[0m\n\e[32m+#{latest_wiki_content.chomp}\e[0m\n" }

      before do
        expect(client_mock).not_to receive(:export)
        expect(client_mock).to receive(:publish).with(wiki_id, 'a/b/c', "latest\n")
      end

      it { is_expected.to output(message).to_stdout }
    end
  end
end
