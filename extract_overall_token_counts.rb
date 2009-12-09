def update_function_call_count(filename, function_call_counts)
  f = File.new(filename, 'r')
  f.readlines.each do |line|
    begin
      line.scan(/[\w.]+\s*\(/).each do |function_name|
        function_name = function_name.chop.rstrip
        if function_call_counts[function_name].nil?
          function_call_counts[function_name] = 1
        else
          function_call_counts[function_name] = function_call_counts[function_name] + 1
        end
      end
    rescue ArgumentError
      puts "Problems with #{filename}"
    end
  end
  return nil
end

def write_csv_report(filename, function_call_counts)
  output_file = File.new(filename, 'w')
  output_file.puts "\"Function Name\",\"Call Count\""
  function_call_counts.keys.sort.each do |function_name|
    output_file.puts "\"#{function_name}\",\"#{function_call_counts[function_name]}\""
  end
  output_file.close
  return nil
end

def process_directory_of_r_files(directory_absolute_pathname, function_call_counts)
  starting_dir = Dir.getwd()
  Dir.chdir(directory_absolute_pathname)
  Dir.new('.').entries.each do |entry|
    if entry.match(/\.R$/)
      update_function_call_count(entry, function_call_counts)
    end
  end
  Dir.chdir(starting_dir)
  return nil
end

def process_r_repository(repository_absolute_pathname, function_call_counts)
  error_log = File.new('error.log', 'w')

  Dir.chdir(repository_absolute_pathname)

  Dir.new('.').entries.each do |entry|
    if entry.match(/tar\.gz$/)
      tar_file = entry
      package_name = tar_file.scan(/[^_]+/)[0]
      puts "Processing #{package_name}..."
      `tar xvfz #{tar_file}`
      Dir.chdir(package_name)
      if not File.exist?('R')
        error_log.puts "#{package_name} is non-standard."
      else
        process_directory_of_r_files('R', function_call_counts)
      end
      Dir.chdir('..')
      `rm -rf #{package_name}`
      puts "Finished with #{package_name}."
      puts
    end
  end

  error_log.close

  write_csv_report('../token_data/function_usage_report.csv', function_call_counts)
end

function_call_counts = {}
process_r_repository('/Users/johnmyleswhite/Academics/Princeton/Research/Analysis of R Function Usage/cran_11_19_2009', function_call_counts)
