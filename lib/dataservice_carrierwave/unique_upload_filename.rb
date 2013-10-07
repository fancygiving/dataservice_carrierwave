# encoding: utf-8

require 'time'
require 'securerandom'
require 'forwardable'

class UniqueUploadFilename
  extend Forwardable

  def self.filename(uploader, options={})
    new(uploader, options).to_s
  end

  attr_reader :uploader, :prefix
  def_delegators :uploader, :model, :mounted_as, :file

  def initialize(uploader, options={})
    @uploader   = uploader
    @prefix     = options.fetch(:prefix) { '' }
    @timestamp  = options.fetch(:timestamp) { false }
  end

  def to_s
    return nil unless original_filename_present?
    "#{full_filename}#{suffix}.#{extension}"
  end

  private

  def full_filename
    if existing_file_present?
      "#{existing_filename}"
    else
      "#{prefix}#{secure_token}"
    end
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, random_uuid)
  end

  def random_uuid
    SecureRandom.uuid
  end

  def suffix
    if model.respond_to?(:updated_at) && present?(model.updated_at)
      '-' + Time.parse(model.updated_at).to_i.to_s
    end
  end

  def extension
    # Ignore any extension which is incorrectly formatted
    file.extension =~ /\// ? '' : file.extension
  end

  def original_filename_present?
    present?(uploader.send(:original_filename))
  end

  def existing_file_present?
    present?(existing_file_path)
  end

  def existing_filename
    File.basename(existing_file_path, '.*').sub(/-\d+$/, '')
  end

  def existing_file_path
    model && model.attributes[mounted_as]
  end

  def present?(string)
    string && !string.empty?
  end
end