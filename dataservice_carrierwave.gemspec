Gem::Specification.new do |s|
  s.name          = 'dataservice_carrierwave'
  s.version       = '0.1.2'
  s.date          = '2013-09-25'
  s.summary       = "Utility classes to allow carrierwave to be used with dataservice remote client."
  s.description   = "Utility classes to allow carrierwave to be used with dataservice remote client."
  s.authors       = ["Samuel Scully"]
  s.email         = 'dev@fancygiving.com'
  s.files         = Dir["lib/dataservice_carrierwave.rb", "lib/dataservice_carrierwave/unique_upload_filename.rb" "LICENSE", "*.md"]
  s.require_path  = 'lib'
  s.homepage      = 'https://github.com/fancygiving/dataservice-carrierwave'
  s.add_dependency('carrierwave')
end