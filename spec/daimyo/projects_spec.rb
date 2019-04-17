RSpec.describe Daimyo::Projects do
  let(:projects) { described_class.new }
  let(:space_id) { '1' }

  before do
    expect_any_instance_of(described_class).to receive(:read_daimyo_yaml).and_return({'space_id' => space_id})
  end

  describe '.new' do
    describe '@space' do
      subject { projects.instance_variable_get(:@space) }
      it { is_expected.to eq space_id }
    end
  end

  describe '#run' do
    before do
      expect(Dir).to receive(:glob).with("#{space_id}/*").and_return(['a', 'b', 'c'])
    end

    subject { -> { projects.run } }
    it { is_expected.to output("a\nb\nc\n").to_stdout }
  end
end
