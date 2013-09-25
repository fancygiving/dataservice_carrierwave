require_relative '../../lib/dataservice/unique_upload_filename'

describe UniqueUploadFilename do
  let(:model)    { double(attributes: {}, updated_at: '2013-09-25 13:26:20 +0100') }
  let(:file)     { double(extension: 'jpg') }
  let(:uploader) { double({
    original_filename:  'barry',
    model:              model,
    file:               file,
    mounted_as:         'photo'}) }

  before do
    SecureRandom.stub(:uuid).and_return('18f0b691-928b-480f-ac04-05687c8f4bd3')
  end

  it 'makes a filename' do
    expect(UniqueUploadFilename.filename(uploader))
      .to eq('18f0b691-928b-480f-ac04-05687c8f4bd3-1380111980.jpg')
  end

  it 'reuses the existing file name' do
    model.stub(attributes: {'photo' => '/public/AN-EXISTING-FILE-PATH-380435980.jpg'})
    expect(UniqueUploadFilename.filename(uploader))
      .to eq('AN-EXISTING-FILE-PATH-1380111980.jpg')
  end

  it 'can handle existing filenames without extensions' do
    model.stub(attributes: {'photo' => '/public/AN-EXISTING-FILE-PATH-380435980.'})
    file.stub(extension: '')
    expect(UniqueUploadFilename.filename(uploader))
      .to eq('AN-EXISTING-FILE-PATH-1380111980.')
  end
end