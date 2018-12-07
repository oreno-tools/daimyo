# Daimyo

## これなに

Backlog Wiki をオフラインで編集, 更新することを目的にした小さなツールです.

## インストール

```sh
gem 'daimyo', git: 'https://github.com/inokappa/daimyo.git'
```

## 使い方

### .daimyo.yml の作成

```yaml
space_id: 'your-space-name'
top_level_domain: 'jp'
api_key: 'your-api-key'
```

### プロジェクトの wiki を export

```sh
bundle exec daimyo export --project-id=your-backlog-project
```

### wiki を更新

```sh
# 編集による差分を表示 (あくまでもローカルマシン上の差分比較用のファイルと比較します)
bundle exec daimyo publish --project-id=your-backlog-project --dry-run
# 編集内容を Backlog に反映
bundle exec daimyo publish --project-id=your-backlog-project
```

## Todo

* 差分比較をローカルマシン上のファイル以外に, 実際の wiki とも比較出来るようにする (`--dry-run` する時に, `--remote` を付けるとか)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/daimyo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
