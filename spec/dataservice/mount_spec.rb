require_relative '../../lib/dataservice_carrierwave'

class TestModel
  extend DataService::Upload

  class << self
    def before_save(*); end
    def after_save(*); end
  end

  mount_uploader :logo
end

describe 'mounting an uploader' do
  it 'defines a new load method' do
    expect(TestModel.new).to respond_to(:load)
  end
end