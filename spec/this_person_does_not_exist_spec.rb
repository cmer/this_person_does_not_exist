require 'tempfile'
require 'digest'
require 'mini_magick'
require 'pry'

RSpec.describe ThisPersonDoesNotExist do
  it "has a version number" do
    expect(ThisPersonDoesNotExist::VERSION).not_to be nil
  end

  def temp_path
    "/tmp/tpdne.#{SecureRandom.hex}" + ".jpg"
  end

  def checksum(path)
    Digest::MD5.file(path).to_s
  end

  def file_type_for(path)
    img = MiniMagick::Image.open(path)
    img.data['format']
  end

  it "saves a new image every time" do
    path1 = temp_path
    path2 = temp_path

    expect(path1).not_to eq(path2)

    ThisPersonDoesNotExist.save_as(path1)
    expect(File.exist?(path1)).to be true
    expect(File.zero?(path1)).to be false
    expect(file_type_for(path1)).to eq "JPEG"

    ThisPersonDoesNotExist.save_as(path2)
    expect(File.exist?(path2)).to be true
    expect(File.zero?(path2)).to be false
    expect(file_type_for(path2)).to eq "JPEG"

    expect(checksum(path1)).not_to eq(checksum(path2))

    puts ""
    puts "Curious? You can see he images generated here:"
    puts "  #{path1}"
    puts "  #{path2}"
    puts ""
  end
end
