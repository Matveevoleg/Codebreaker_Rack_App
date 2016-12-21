module IOModule
  def save_result (str, path)
    File.open(path, 'a') do |file|
      file.puts str
    end
  end

  def load_results (path)
    file = File.open(path, 'r')
    file.nil? ? 'Error connecting to database' : file.read
  end
end