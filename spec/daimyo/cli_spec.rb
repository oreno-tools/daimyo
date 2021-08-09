RSpec.describe Daimyo::CLI do
  describe '.start' do
    let(:project_id_error_message) { 'Backlog プロジェクトキーを指定してください.' }
    let(:list_mock) { instance_double('Daimyo::List') }
    let(:export_mock) { instance_double('Daimyo::Export') }
    let(:publish_mock) { instance_double('Daimyo::Publish') }
    let(:projects_mock) { instance_double('Daimyo::Projects') }

    subject { -> { described_class.start(thor_args) } }

    context 'given `version`' do
      let(:thor_args) { %w[version] }
      it { is_expected.to output("#{Daimyo::VERSION}\n").to_stdout }
    end

    context 'given `--version`' do
      let(:thor_args) { %w[--version] }
      it { is_expected.not_to output.to_stdout }
      # it { is_expected.to output("Could not find command \"__version\".\n").to_stderr }
    end

    context 'given `-v`' do
      let(:thor_args) { %w[-v] }
      it { is_expected.not_to output.to_stdout }
      # it { is_expected.to output("Could not find command \"_v\".\n").to_stderr }
    end

    context 'given `list --project-id 1`' do
      before do
        expect(Daimyo::List).to receive(:new).and_return(list_mock)
        expect(list_mock).to receive(:run).with('1')
      end

      let(:thor_args) { %w[list --project-id 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `list --project-id a`' do
      before do
        expect(Daimyo::List).to receive(:new).and_return(list_mock)
        expect(list_mock).to receive(:run).with('a')
      end

      let(:thor_args) { %w[list --project-id a] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `list --project_id 1`' do
      before do
        expect(Daimyo::List).to receive(:new).and_return(list_mock)
        expect(list_mock).to receive(:run).with('1')
      end

      let(:thor_args) { %w[list --project_id 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `list --project-id=1`' do
      before do
        expect(Daimyo::List).to receive(:new).and_return(list_mock)
        expect(list_mock).to receive(:run).with('1')
      end

      let(:thor_args) { %w[list --project-id=1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `list -p 1`' do
      before do
        expect(Daimyo::List).to receive(:new).and_return(list_mock)
        expect(list_mock).to receive(:run).with('1')
      end

      let(:thor_args) { %w[list -p 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `list`' do
      let(:thor_args) { %w[list] }
      it { is_expected.to raise_error(RuntimeError, project_id_error_message) }
    end

    context 'given `export --project-id 1`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[export --project-id 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project-id a`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('a', nil)
      end

      let(:thor_args) { %w[export --project-id a] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project_id 1`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[export --project_id 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project-id=1`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[export --project-id=1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export -p 1`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[export -p 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project-id 1 --wiki-id 2`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', '2')
      end

      let(:thor_args) { %w[export --project-id 1 --wiki-id 2] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project-id 1 --wiki_id 2`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', '2')
      end

      let(:thor_args) { %w[export --project-id 1 --wiki_id 2] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project-id 1 --wiki-id=2`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', '2')
      end

      let(:thor_args) { %w[export --project-id 1 --wiki-id=2] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export --project-id 1 -i 2`' do
      before do
        expect(Daimyo::Export).to receive(:new).and_return(export_mock)
        expect(export_mock).to receive(:run).with('1', '2')
      end

      let(:thor_args) { %w[export --project-id 1 -i 2] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `export`' do
      let(:thor_args) { %w[export] }
      it { is_expected.to raise_error(RuntimeError, project_id_error_message) }
    end

    context 'given `export --wiki-id 2`' do
      let(:thor_args) { %w[export --wiki-id 2] }
      it { is_expected.to raise_error(RuntimeError, project_id_error_message) }
    end

    context 'given `publish --project-id 1`' do
      let(:options) { {'project_id' => '1'} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[publish --project-id 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id a`' do
      let(:options) { {'project_id' => 'a'} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('a', nil)
      end

      let(:thor_args) { %w[publish --project-id a] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project_id 1`' do
      let(:options) { {'project_id' => '1'} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[publish --project_id 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id=1`' do
      let(:options) { {'project_id' => '1'} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[publish --project-id=1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish -p 1`' do
      let(:options) { {'project_id' => '1'} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', nil)
      end

      let(:thor_args) { %w[publish -p 1] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry_run`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry_run] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run=true`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run=true] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run false`' do
      let(:options) { {'project_id' => '1', 'dry_run' => false} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', false)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run false] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 -d`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 -d] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run --local`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true, 'local' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run --local] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run --local=true`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true, 'local' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run --local=true] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run --local false`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true, 'local' => false} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run --local false] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish --project-id 1 --dry-run -l`' do
      let(:options) { {'project_id' => '1', 'dry_run' => true, 'local' => true} }

      before do
        expect(Daimyo::Publish).to receive(:new).with(options).and_return(publish_mock)
        expect(publish_mock).to receive(:run).with('1', true)
      end

      let(:thor_args) { %w[publish --project-id 1 --dry-run -l] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end

    context 'given `publish`' do
      let(:thor_args) { %w[publish] }
      it { is_expected.to raise_error(RuntimeError, project_id_error_message) }
    end

    context 'given `publish --dry-run`' do
      let(:thor_args) { %w[publish --dry-run] }
      it { is_expected.to raise_error(RuntimeError, project_id_error_message) }
    end

    context 'given `publish --dry-run --local`' do
      let(:thor_args) { %w[publish --dry-run --local] }
      it { is_expected.to raise_error(RuntimeError, project_id_error_message) }
    end

    context 'given `projects`' do
      before do
        expect(Daimyo::Projects).to receive(:new).and_return(projects_mock)
        expect(projects_mock).to receive(:run)
      end

      let(:thor_args) { %w[projects] }
      it { is_expected.not_to output.to_stdout }
      it { is_expected.not_to output.to_stderr }
    end
  end
end
