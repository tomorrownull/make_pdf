require 'zip'

# This is a simple example which uses rubyzip to
# recursively generate a zip file from the contents of
# a specified directory. The directory itself is not
# included in the archive, rather just its contents.
#
# Usage:
#   directory_to_zip = "/tmp/input"
#   output_file = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directory_to_zip, output_file)
#   zf.write()
class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  # Zip the input directory.
  def write
    entries = Dir.entries(@input_dir) - %w[. ..]

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
      write_entries entries, '', zipfile
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zipfile_path)

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path)
    zipfile.mkdir zipfile_path
    subdir = Dir.entries(disk_file_path) - %w[. ..]
    write_entries subdir, zipfile_path, zipfile
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path)
    zipfile.add(zipfile_path, disk_file_path)
  end
end

module Progress
  require 'pty' if RbConfig::CONFIG['target_os'] !~ /mswin|mingw/ # no support for windows
  require 'English'

  def track_progress?(options)
    options[:progress] && !on_windows?
  end

  def invoke_with_progress(command, options)
    output = []
    begin
      PTY.spawn(command.join(' ')) do |stdout, _stdin, pid|
        begin
          stdout.sync
          stdout.each_line("\r") do |line|
            output << line.chomp
            options[:progress].call(line) if options[:progress]
          end
        rescue Errno::EIO # rubocop:disable Lint/HandleExceptions
          # child process is terminated, this is expected behaviour
        ensure
          ::Process.wait pid
        end
      end
    rescue PTY::ChildExited
      puts 'The child process exited!'
    end
    err = output.join('\n')
    raise "#{command} failed (exitstatus 0). Output was: #{err}" unless $CHILD_STATUS && $CHILD_STATUS.exitstatus.zero?
  end
end
