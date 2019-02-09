REPO_URL = "https://raw.githubusercontent.com/m11o/rails_template/master"

@app_name = app_name

def get_and_gsub(remote_path, local_path)
  get remote_path, local_path

  gsub_file local_path, /\{\{app_name\}\}/, @app_name
  gsub_file local_path, /\{\{UPCASE_APP_NAME\}\}/, @app_name.upcase
end

gem 'enum_help'
gem 'kaminari'
gem 'active_decorator'
gem 'config'
gem 'slim-rails'
gem 'mysql2'

if yes?('Would you like to install whenever?')
  gem 'whenever', require: false
  create_file 'config/schedule.rb' # wheneverの初期ファイルを作成
end

if yes?('Would you like to install ridgepole?')
  gem 'ridgepole'

  # ridgepoleの設定ファイルを追加
  create_file 'db/Schemafile'
  # ridgepoleの実行コマンド実装
  get "#{REPO_URL}/lib/tasks/ridgepole.rake", 'lib/tasks/ridgepole.rake'
end

gem_group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop'
end

gem_group :development do
  gem 'bullet'
  gem 'annotate'
end

gem_group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
end

# sqliteはコメントアウト
comment_lines 'Gemfile', "gem 'sqlite3'"

# 上記で記述したgeneratorの設定をファイルに書き出し
get "#{REPO_URL}/config/initializers/generators.rb", 'config/initializers/generators.rb'

# layouts/applicationをslimに変換
remove_file "app/views/layouts/application.html.erb"
get "#{REPO_URL}/app/views/layouts/application.html.slim", 'app/views/layouts/application.html.slim'

# .gitignore
remove_file '.gitignore'
get "#{REPO_URL}/gitignore", '.gitignore'

# locales/ja.yml
get "https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/ja.yml", "config/locales/ja.yml"

# database.yml
remove_file 'config/database.yml'
get_and_gsub "#{REPO_URL}/config/database.yml", 'config/database.yml'

run 'rm -rf test'

# bundle install
get "#{REPO_URL}/bundle/config", '.bundle/config'
run 'bundle install --path vendor/bundle'

# rspec
generate 'rspec:install'

# rails_config
generate 'rails_config:install'

git :init
git :add => '.'
git :commit => '-am "init commit"'
