class CheckTimestamp < Scout::Plugin
  def build_report
    begin
      threshold = option(:threshold).to_f
      path = option(:path)
      timestamp = File.new(path).mtime
      current_time = Time.now
      difference = ((current_time - timestamp) / 60).round.to_f
      output = "Path: #{path}, Threshold: #{threshold} minutes, Path Timestamp: #{timestamp}, Current Time: #{current_time}, Difference: #{difference}"
      report(:difference => difference, :threshold => threshold)
      if difference > threshold
        alert(:subject => "File #{path} was older than #{threshold} minutes", :body => output)
      end
      return difference
    rescue Exception => e
      error(:subject => 'Error running Check Timestamp plugin', :body => e)
      return -1
    end
  end
end