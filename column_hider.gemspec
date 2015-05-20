$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "column_hider/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "column_hider"
  s.version     = ColumnHider::VERSION
  s.authors     = ["Ian Hall"]
  s.email       = ["ianh.99@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ColumnHider."
  s.description = "TODO: Description of ColumnHider."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
