class Prioritise
  def run(jobs)
    result = []
    
    # any self-dependencies?
    if jobs.select{|j,d| j==d}.any?
      raise ArgumentError, "Jobs can't depend on themselves"
    end

    # any "external" dependencies?
    if jobs.select{|j,d| !d.nil? and !jobs.keys.include?(d) }.any?
      raise ArgumentError, "Dependency error"
    end

    # main loop
    while jobs.any? do
       found = false

      jobs.each do |job,depend|
        if depend.nil? or result.include? depend
          result.push(job)
          jobs.delete(job)
          found = true
          break
        end
      end

      # the queue is not empty but we couldn't find a job to add?
      unless found 
        raise ArgumentError, "Jobs can't have circular dependencies"
      end
    end
    
    return result
  end
end

if __FILE__ == $0
  prioritise = Prioritise.new(ARGV)
  prioritise.run({"a" => nil})
end


