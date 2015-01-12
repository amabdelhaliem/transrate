require 'helper'
require 'tmpdir'

class TestSalmon < Test::Unit::TestCase

  context "Salmon" do

    setup do
      @salmon = Transrate::Salmon.new
    end

    should "load an expression file" do
      file = File.join(File.dirname(__FILE__), 'data', 'test.sf')
      results = @salmon.load_expression file
      assert_equal 18, results.size, "should be 18 results loaded"
      assert_equal 1016, results['scaffold1'][:eff_len], "eff length is wrong"
      assert_equal 20690, results['scaffold1'][:eff_count],
                   "eff count is wrong"
      assert_equal 549.279, results['scaffold1'][:tpm], "tpm is wrong"
    end

    should "build a command to run salmon" do
      cmd = @salmon.build_command "assembly.fa", "alignments.bam"
      cmd = cmd.split(" ")[1..-1].join(" ") # remove command so test is portabl
      test = "quant --libtype IU --alignments alignments.bam "
      test << "--targets assembly.fa --threads 4 --useReadCompat "
      test << "--useFragLenDist --sampleOut --sampleUnaligned --output ."
      assert_equal test, cmd, "cmd is wrong"
    end

  end

end
