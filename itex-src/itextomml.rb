#  Ruby module for itex2MML
#
#  Installation
#  ------------
#    1. You need SWIG (>= 1.3) and GNU Make to install
#       the Ruby module.
#    2. Then type:
#            make ruby
#             make test_ruby
#            make install_ruby
#    3. This module can then be invoked like:
#
#            require 'itextomml'
#            
#            itex = Itex2MML::Parser.new
#            itex.html_filter(string)
#
#  Usage
#  -----
#
#      There are two public methods
#
#       itex.html_filter(a_string)
#               converts all itex equations in a_string to MathML, passing the
#               rest of a_string unmodified. Returns the converted string. 
#
#       itex.filter(a_string)
#               converts all itex equations in a_string to MathML. Returns just
#               the MathML equation(s), as a string.
#
#  Author: Justin Bonnar <jbonnar@berkeley.edu>
#  Placed in the Public Domain

require 'itex2MML'
require 'thread'

module Itex2MML
  class Error < RuntimeError; end
 
  class Parser
    def self.semaphore
      @semaphore ||= Mutex.new
    end
   
    def html_filter(string)
      parse(string, :itex2MML_html_filter)
    end
   
    def filter(string)
      parse(string, :itex2MML_filter)
    end
 
  private
 
    def parse(string, message)
      string = string.to_str
      self.class.semaphore.synchronize do
        raise Itex2MML::Error unless Itex2MML.send(message, string, string.length) == 0
        Itex2MML.itex2MML_output
      end
    end
  end
end

## Unit Tests ##
if __FILE__ == $0
  require 'test/unit'

  class Itex2MMLTest < Test::Unit::TestCase

    def test_inline_html
      itex = Itex2MML::Parser.new
      assert_equal("Inline: <math xmlns='http://www.w3.org/1998/Math/MathML' display='inline'><mi>sin</mi><mo stretchy=\"false\">(</mo><mi>x</mi><mo stretchy=\"false\">)</mo></math>", itex.html_filter('Inline: $\sin(x)$'))
    end

    def test_inline
      itex = Itex2MML::Parser.new
      assert_equal("<math xmlns='http://www.w3.org/1998/Math/MathML' display='inline'><mi>sin</mi><mo stretchy=\"false\">(</mo><mi>x</mi><mo stretchy=\"false\">)</mo></math>", itex.filter('Inline: $\sin(x)$'))
    end

    def test_block_html
      itex = Itex2MML::Parser.new
      assert_equal("Block: <math xmlns='http://www.w3.org/1998/Math/MathML' display='block'><mi>sin</mi><mo stretchy=\"false\">(</mo><mi>x</mi><mo stretchy=\"false\">)</mo></math>", itex.html_filter('Block: $$\sin(x)$$'))
    end

    def test_block
      itex = Itex2MML::Parser.new
      assert_equal("<math xmlns='http://www.w3.org/1998/Math/MathML' display='block'><mi>sin</mi><mo stretchy=\"false\">(</mo><mi>x</mi><mo stretchy=\"false\">)</mo></math>", itex.filter('Block: $$\sin(x)$$'))
    end

  end
end
