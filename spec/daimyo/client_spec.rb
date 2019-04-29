RSpec.describe Daimyo::Client do
  let(:daimyo_client) { described_class.new }
  let(:client_mock) { instance_double('BacklogKit::Client') }

  describe '.new' do
    describe '@client' do
      let(:client) { daimyo_client.instance_variable_get(:@client) }

      before do
        expect_any_instance_of(described_class).to receive(:read_daimyo_yaml).and_return('space_id' => '1', 'api_key' => 'a', 'top_level_domain' => 'jp')
      end

      context 'when @client is nil' do
        before do
          expect(BacklogKit::Client).to receive(:new).with(space_id: '1', api_key: 'a', top_level_domain: 'jp').and_call_original
        end

        subject { client }
        it { is_expected.to be_a BacklogKit::Client }

        describe '#space_id' do
          subject { client.space_id }
          it { is_expected.to eq '1' }
        end

        describe '#api_key' do
          subject { client.api_key }
          it { is_expected.to eq 'a' }
        end

        describe '#top_level_domain' do
          subject { client.top_level_domain }
          it { is_expected.to eq 'jp' }
        end
      end

      context 'when @client is not nil' do
        before do
          daimyo_client.instance_variable_set(:@client, BacklogKit::Client.new(space_id: '2', api_key: 'b', top_level_domain: 'com'))
          expect(BacklogKit::Client).not_to receive(:new)
        end

        subject { client }
        it { is_expected.to be_a BacklogKit::Client }

        describe '#space_id' do
          subject { client.space_id }
          it { is_expected.to eq '2' }
        end

        describe '#api_key' do
          subject { client.api_key }
          it { is_expected.to eq 'b' }
        end

        describe '#top_level_domain' do
          subject { client.top_level_domain }
          it { is_expected.to eq 'com' }
        end
      end
    end
  end

  describe '#list' do
    let(:project_id) { 1 }
    let(:result) { [] }

    before do
      expect(BacklogKit::Client).to receive(:new).and_return(client_mock)
      expect(client_mock).to receive(:get_wikis).with(project_id).and_return(result)
    end

    subject { daimyo_client.list(project_id) }
    it { is_expected.to eq result }
  end

  describe '#export' do
    let(:wiki_id) { 1 }
    let(:result) { {} }

    before do
      expect(BacklogKit::Client).to receive(:new).and_return(client_mock)
      expect(client_mock).to receive(:get_wiki).with(wiki_id).and_return(result)
    end

    subject { daimyo_client.export(wiki_id) }
    it { is_expected.to eq result }
  end

  describe '#publish' do
    let(:wiki_id) { 1 }
    let(:wiki_name) { 'a' }
    let(:wiki_contents) { 'b' }
    let(:result) { {} }

    before do
      expect(BacklogKit::Client).to receive(:new).and_return(client_mock)
      expect(client_mock).to receive(:update_wiki).with(wiki_id, 'name' => wiki_name, 'content' => wiki_contents).and_return(result)
    end

    subject { daimyo_client.publish(wiki_id, wiki_name, wiki_contents) }
    it { is_expected.to eq result }
  end

  describe '#read_daimyo_yaml' do
    subject { -> { daimyo_client.read_daimyo_yaml } }

    context 'when .daimyo.yml does not exist' do
      before do
        expect(YAML).to receive(:load_file).with('.daimyo.yml').and_raise(Errno::ENOENT)
      end

      it { is_expected.to raise_error(SystemExit).and(output(".daimyo.yml が存在していません.\n").to_stdout) }
    end

    context 'when .daimyo.yml has wrong syntax' do
      let(:file) { '.daimyo.yml' }
      let(:line) { 3 }
      let(:col) { 1 }
      let(:offset) { 0 }
      let(:problem) { "could not find expected ':'" }
      let(:context) { 'while scanning a simple key' }
      let(:message) { "(#{file}): #{problem} #{context} at line #{line} column #{col}" }

      before do
        expect(YAML).to receive(:load_file).with('.daimyo.yml').and_raise(Psych::SyntaxError.new(file, line, col, offset, problem, context))
      end

      it { is_expected.to raise_error(SystemExit).and(output(".daimyo.yml の読み込みに失敗しました. #{message}\n").to_stdout) }
    end
  end
end
