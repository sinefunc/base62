module Base62
  SIXTYTWO = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a
  
  def encode( numeric )
    raise ArgumentError unless Numeric === numeric

    return '0' if numeric == 0
    s = ''

    while numeric > 0
      s << Base62::SIXTYTWO[numeric.modulo(62)]
      numeric /= 62
    end
    s.reverse
  end

  def decode( base62 )
    s = base62.to_s.reverse.split('')
    
    total = 0
    s.each_with_index do |char, index|
      if ord = SIXTYTWO.index(char)
        total += ord * (62 ** index)
      else
        raise ArgumentError, "#{base62} has #{char} which is not valid"
      end
    end
    total.to_s
  end

  module_function :encode, :decode
end

if $0 == __FILE__
  require 'test/unit'
  
  class Base62Test < Test::Unit::TestCase
    def test_base_62_of_max_big_int
      assert_equal 'lYGhA16ahyf', Base62.encode(18446744073709551615)
    end

    def test_numeric_of_base62d_max
      assert_equal '18446744073709551615', Base62.decode('lYGhA16ahyf')
    end
  end
end
