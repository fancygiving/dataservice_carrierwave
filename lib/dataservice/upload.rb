require 'carrierwave/mount'

module DataService
  module Upload
    include CarrierWave::Mount

    def mount_uploader(column, uploader=nil, options={}, &block)
      super

      before_save :"write_#{column}_identifier"
      after_save  :"store_#{column}!"

      define_method(:read_uploader) do |column|
        attributes[column]
      end

      define_method(:write_uploader) do |column, identifier|
        attributes[column] = identifier
      end

      define_method(:"extract_#{column}_attribute!") do
        upload = attributes.delete(column)
        send("#{column}=", upload)
      end

      define_method(:load) do |attrs|
        super(attrs)
        if attributes[column].is_a? ActionDispatch::Http::UploadedFile
          send(:"extract_#{column}_attribute!")
        end
        if attributes["remote_#{column}_url"]
          url = attributes.delete("remote_#{column}_url")
          send("remote_#{column}_url=", url)
        end
        self
      end

    end
  end
end