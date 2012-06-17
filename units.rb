require "test/unit"
require "set"
require_relative "jobs"

class TestPrioritise < Test::Unit::TestCase
  def test_empty
    assert_equal Prioritise.new.run({}), []
  end

  def test_single
    assert_equal Prioritise.new.run({"a" => nil}), ["a"]
  end

  def test_independent
    result = Prioritise.new.run({ "a" => nil,"b" => nil,"c" => nil })

    # check that the result contains the same elements (in any order)
    assert_equal ["a","b","c"].to_set, result.to_set
    assert_equal 3, result.length
  end

  def test_simple_dependency
    result = Prioritise.new.run({ "a" => nil,"b" => "c","c" => nil })
    
    assert_equal  ["a","b","c"].to_set, result.to_set

    #testing for correct order ("c" before "b")
    assert_operator to_hash(result)["c"], :<, to_hash(result)["b"]
  end

  def test_complex_dependency
    result = Prioritise.new.run({ "a" => nil,
                                  "b" => "c",
                                  "c" => "f",
                                  "d" => "a",
                                  "e" => "b",
                                  "f" => nil })

    assert_equal ["a","b","c","d","e","f"].to_set, result.to_set
    assert_equal 6, result.length

    assert_operator to_hash(result)["c"], :<, to_hash(result)["b"]
    assert_operator to_hash(result)["f"], :<, to_hash(result)["c"]
    assert_operator to_hash(result)["a"], :<, to_hash(result)["d"]
    assert_operator to_hash(result)["b"], :<, to_hash(result)["e"]
  end

  def test_self_dependency
    assert_raise ArgumentError do
      Prioritise.new.run({ "a" => nil,"b" => nil,"c" => "c" })
    end

    begin
      Prioritise.new.run({ "a" => nil,"b" => nil,"c" => "c" })
    rescue ArgumentError =>  e
      assert_equal "Jobs can't depend on themselves", e.message 
    end
  end

  def test_circular_dependency
    assert_raise ArgumentError do
      #Jobs can't have circular dependencies
      Prioritise.new.run({ "a" => nil,
                           "b" => "c",
                           "c" => "f",
                           "d" => "a",
                           "e" => nil,
                           "f" => "b"  })
    end

    begin
      Prioritise.new.run({ "a" => nil,
                           "b" => "c",
                           "c" => "f",
                           "d" => "a",
                           "e" => nil,
                           "f" => "b"  })
    rescue ArgumentError => e
      assert_equal "Jobs can't have circular dependencies", e.message
    end
  end

  private

  def to_hash(arr)
    Hash[arr.map.with_index{|*ki| ki}] 
  end
end


