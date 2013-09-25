# encoding: utf-8

class UniqueUploadFilename
  extend Forwardable

  def self.filename(uploader)
    new(uploader).to_s
  end

  attr_reader :uploader, :prefix
  def_delegators :uploader, :model, :mounted_as, :file

  def initialize(uploader, options={})
    @uploader = uploader
    @prefix   = options[:prefix] || ''
  end

  def to_s
    return nil unless original_filename_present?

    if existing_file_present?
      "#{existing_filename}-#{suffix}.#{extension}"
    else
      "#{prefix}#{secure_token}-#{suffix}.#{extension}"
    end
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, random_uuid)
  end

  def random_uuid
    SecureRandom.uuid
  end

  def suffix
    if model.updated_at.present?
      Time.parse(model.updated_at).to_i
    end
  end

  def extension
    file.extension
  end

  def original_filename_present?
    uploader.send(:original_filename).present?
  end

  def existing_file_present?
    existing_file_path.present?
  end

  def existing_filename
    File.basename(existing_file_path, '.*').sub(/-\d+$/, '')
  end

  def existing_file_path
    model && model.attributes[mounted_as]
  end
end