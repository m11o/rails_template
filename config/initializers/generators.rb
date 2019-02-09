Rails.application.config.generators do |g|
  g.assets false
  g.helper false
  g.test_framework :rspec,
                   fixtures: true,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   controller_specs: true,
                   request_specs: true
  g.fixture_replacement :factory_girl, dir: 'spec/factories'
end