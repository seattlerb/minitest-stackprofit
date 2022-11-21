require "minitest"

module Minitest
  module Stackprofit
    VERSION = "1.0.0"
  end

  @stackprof_path = nil
  @stackprof_type = :wall

  def self.plugin_stackprofit_options opts, options # :nodoc:
    opts.on "--stackprof [path]", String, "Save profiling to [path]." do |s|
      @stackprof_path = s || "stackprof.dump"
    end

    opts.on "--stackprof-type type", String, "Set profile type (default: wall)." do |s|
      @stackprof_type = s.to_sym
    end
  end

  def self.plugin_stackprofit_init options # :nodoc:
    if @stackprof_path then
      require "stackprof"

      StackProf.start mode: @stackprof_type, out: @stackprof_path

      Minitest.after_run do
        StackProf.stop
        StackProf.results
      end
    end
  end
end
