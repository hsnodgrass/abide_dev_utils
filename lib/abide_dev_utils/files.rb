# frozen_string_literal: true

module AbideDevUtils
  module Files
    class Writer
      MSG_EXT_APPEND = 'Appending %s extension to file'

      def write(content, file: nil, add_ext: true, file_ext: nil)
        valid_file = add_ext ? append_ext(file, file_ext) : file
        File.open(valid_file, 'w') { |f| f.write(content) }
        verify_write(valid_file)
      end

      def method_missing(m, *args, **kwargs, &_block)
        if m.to_s.match?(/^write_/)
          ext = m.to_s.split('_')[-1]
          write(args[0], **kwargs, file_ext: ext)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?('write_') || super
      end

      def append_ext(file_path, ext)
        return file_path if ext.nil?

        s_ext = ".#{ext}"
        unless File.extname(file_path) == s_ext
          puts MSG_EXT_APPEND % s_ext
          file_path << s_ext
        end
        file_path
      end

      def verify_write(file_path)
        if File.file?(file_path)
          puts "Successfully wrote to #{file_path}"
        else
          puts "Something went wrong! Failed writing to #{file_path}!"
        end
      end
    end
  end
end
