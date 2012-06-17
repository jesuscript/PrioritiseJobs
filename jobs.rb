class Prioritise
  def run(jobs)
    result = []

    while jobs.any? do 
      jobs.each do |job,depend|
        result.push(job)
        jobs.delete(job)
        break
      end
    end
    
    return result
  end
end

if __FILE__ == $0
  prioritise = Prioritise.new(ARGV)
  prioritise.run({})
end


