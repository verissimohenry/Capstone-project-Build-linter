class Linters
  attr_reader :file_path, :content, :file_lines, :errors

  def initialize(file_path)
    @file_path = file_path
    @file_lines = File.readlines(@file_path)
    @errors = []
  end

  def run_checker
    trailing_white_spaces
    count_ends
    empty_line
  end

  def log_all_errors
    puts "#{@errors.length} errors found."
    @errors.each_with_index do |err, idx|
      puts "#{idx + 1} - #{err} "
    end
  end

  private

  def trailing_white_spaces
    @file_lines.each_with_index do |line, idx|
      @errors << "You have a trailing white space on line #{idx + 1}" if line[-2] == ' '
    end
  end

  def count_ends
    special_words = %w[def do if class]
    count_start = 0
    count_end = 0

    @file_lines.each do |line|
      if (line.split & special_words).any?
        count_start += 1

      elsif line.strip == 'end'
        count_end += 1
      end
    end

    if count_start < count_end
      @errors << 'You have an extra "end" in your code, please remove it'
    elsif count_start > count_end
      @errors << 'You are missing "end" in your code'
    end
  end

  def empty_line
    @file_lines.each_with_index do |line, idx|
      @errors << "You have an empty line on line #{idx + 0 + 1}, please remove it" if line.strip.empty?
    end
  end
end
