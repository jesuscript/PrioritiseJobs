class Prioritise
  def run(jobs)
    result = []

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

      raise ArgumentError.new("Dependency error") unless found 
    end
    
    return result
  end
end

if __FILE__ == $0
  prioritise = Prioritise.new(ARGV)
  prioritise.run({})
end


