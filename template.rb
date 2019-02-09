REPO_URL = "https://github.com/m11o/rails_template/master"

gems = {}

@app_name = app_name

def get_and_gsub(source_path, local_path)
  get source_path, local_path

  gsub_file local_path, /\{\{app_name\}\}/, @app_name
  gsub_file local_path, /\{\{UPCASE_APP_NAME\}\}/, @app_name.upcase
end

gem 'enum_help'
gem 'kaminari'
gem 'active_decorator'
gem 'config'
gem 'slim-rails'
gem 'mysql2'

if gems[:whenever] = yes?('Would you like to install whenever?')
  gem 'whenever', require: false
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

group :test do
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

if gems[:whenever]
  create_file "config/schedule.rb"
end

# database.yml
remove_file 'config/database.yml'
get_and_gsub "#{REPO_URL}/config/database.yml", 'config/database.yml'

# rspec
generate 'rspec:install'

# rails_config
generate 'rails_config:install'

git :init
git :add => '.'
git :commit => '-am "init commit"'
