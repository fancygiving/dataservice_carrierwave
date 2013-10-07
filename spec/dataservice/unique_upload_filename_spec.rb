require_relative '../../lib/dataservice_carrierwave/unique_upload_filename'

describe UniqueUploadFilename do
  let(:model)    { double(attributes: {}) }
  let(:file)     { double(extension: 'jpg') }
  let(:uploader) { double({
    original_filename:  'barry',
    model:              model,
    file:               file,
    mounted_as:         'photo'}) }
  let(:filename) { UniqueUploadFilename.filename(uploader) }

  before do
    SecureRandom.stub(:uuid).and_return('18f0b691-928b-480f-ac04-05687c8f4bd3')
  end

  it 'makes a filename' do
    expect(filename).to eq('18f0b691-928b-480f-ac04-05687c8f4bd3.jpg')
  end

  describe 'timestamp' do
    it 'adds a timestamp if present on the model' do
      model.stub(updated_at: '2013-09-25 13:26:20 +0100')
      expect(filename).to eq('18f0b691-928b-480f-ac04-05687c8f4bd3-1380111980.jpg')
    end

    it 'does not add the timestamp if the timestamp option is false' do
      filename = UniqueUploadFilename.filename(uploader, timestamp: false)
      expect(filename).to eq('18f0b691-928b-480f-ac04-05687c8f4bd3.jpg')
    end
  end

  describe 'with an existing filename' do
    it 'reuses the existing file name' do
      model.stub(attributes: {'photo' => '/public/AN-EXISTING-FILE-PATH-380435980.jpg'})
      expect(filename).to eq('AN-EXISTING-FILE-PATH.jpg')
    end

    it 'without extension' do
      model.stub(attributes: {'photo' => '/public/AN-EXISTING-FILE-PATH-380435980.'})
      # simulate strange behaviour of carrierwave file class
      file.stub(extension: 'public/gift-ideas/a061e1d9-9e9d')
      expect(filename).to eq('AN-EXISTING-FILE-PATH.')
    end
  end
end