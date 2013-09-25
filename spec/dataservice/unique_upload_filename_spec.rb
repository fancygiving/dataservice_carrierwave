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
    Time.stub(now: Time.parse('2013-09-25 13:00:00 +0100'))
  end

  it 'makes a filename' do
    model.stub(updated_at: '2013-09-25 13:26:20 +0100')
    expect(filename).to eq('18f0b691-928b-480f-ac04-05687c8f4bd3-1380111980.jpg')
  end

  it 'works if no updated_at attribute is available' do
    expect(filename).to eq('18f0b691-928b-480f-ac04-05687c8f4bd3-1380110400.jpg')
  end

  describe 'with an existing filename' do
    it 'reuses the existing file name' do
      model.stub(attributes: {'photo' => '/public/AN-EXISTING-FILE-PATH-380435980.jpg'})
      expect(filename).to eq('AN-EXISTING-FILE-PATH-1380110400.jpg')
    end

    it 'without extension' do
      model.stub(attributes: {'photo' => '/public/AN-EXISTING-FILE-PATH-380435980.'})
      file.stub(extension: '')
      expect(filename).to eq('AN-EXISTING-FILE-PATH-1380110400.')
    end
  end
end