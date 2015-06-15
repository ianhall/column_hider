$:.push File.expand_path('../lib', __FILE__)
require 'column_hider/version'

Gem::Specification.new do |spec|
  spec.name        = 'column_hider'
  spec.version     = ColumnHider::VERSION
  spec.authors     = ['Flashfunders']
  spec.email       = ['engineering@flashfunders.com']
  spec.homepage    = ''
  spec.summary     = 'Removes a database table column from the set of columns known to your application.'
  spec.description = 'Superclasses the "columns" method of ActiveRecord''s Attribute class and dynamically removes your chosen column(s).'
  spec.license     = 'MIT'

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.test_files = Dir['test/**/*']

  spec.add_dependency 'rails', '~> 4.1'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
