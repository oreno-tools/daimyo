RSpec.describe Daimyo::List do
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
    let(:wiki_mock) { instance_double('wiki', id: 1, name: 'a', created: 'b', updated: 'c') }
    let(:result_mock) { instance_double('list', body: [wiki_mock]) }
    let(:project_id) { 1 }

    before do
      expect(Daimyo::Client).to receive(:new).and_return(client_mock)
      expect(client_mock).to receive(:list).with(project_id).and_return(result_mock)
      expect_any_instance_of(described_class).to receive(:output_table).with([[1, 'a', 'b', 'c']])
    end

    subject { -> { daimyo_client.run(project_id) } }
    it { is_expected.not_to output.to_stdout }
  end

  describe '#output_table' do
    let(:wikis) { [[1, 'a', 'b', 'c'], [2, 'd', 'e', 'f']] }
    let(:stdout_terminal_ascii) do
      <<-EOS
+----+------+---------+---------+
| ID | Name | Created | Updated |
+----+------+---------+---------+
| 1  | a    | b       | c       |
| 2  | d    | e       | f       |
+----+------+---------+---------+
      EOS
    end

    subject { -> { daimyo_client.output_table(wikis) } }
    it { is_expected.to output(stdout_terminal_ascii).to_stdout }
  end
end
