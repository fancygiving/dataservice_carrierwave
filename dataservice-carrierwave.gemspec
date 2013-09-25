Gem::Specification.new do |s|
  s.name          = 'dataservice-carrierwave'
  s.version       = '0.0.2'
  s.date          = '2013-09-25'
  s.summary       = "Utility classes to allow carrierwave to be used with dataservice remote client."
  s.description   = "Utility classes to allow carrierwave to be used with dataservice remote client."
  s.authors       = ["Samuel Scully"]
  s.email         = 'dev@fancygiving.com'
  s.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/fancygiving/dataservice-client'
  s.add_dependency('carrierwave')
end