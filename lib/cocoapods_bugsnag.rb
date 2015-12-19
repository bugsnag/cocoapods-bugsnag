module Pod
  class Installer::UserProjectIntegrator::TargetIntegrator

    BUGSNAG_PHASE_NAME = "Upload Bugsnag dSYM"
    BUGSNAG_PHASE_SCRIPT = <<'RUBY'
fork do
  Process.setsid
  STDIN.reopen("/dev/null")
  STDOUT.reopen("/dev/null", "a")
  STDERR.reopen("/dev/null", "a")

  require 'shellwords'

  Dir["#{ENV["DWARF_DSYM_FOLDER_PATH"]}/*/Contents/Resources/DWARF/*"].each do |dsym|
    system("curl -F dsym=@#{Shellwords.escape(dsym)} -F projectRoot=#{Shellwords.escape(ENV["PROJECT_DIR"])} https://upload.bugsnag.com/")
  end
end
RUBY

    alias_method :integrate_without_bugsnag!, :integrate!
    def integrate!
      integrate_without_bugsnag!
      return unless has_bugsnag_dependency?
      return if bugsnag_native_targets.empty?
      UI.section("Integrating with Bugsnag") do
        add_bugsnag_upload_script_phase
        user_project.save
      end
      UI.puts "Added 'Upload Bugsnag dSYM' build phase"
    end


    def add_bugsnag_upload_script_phase
      bugsnag_native_targets.each do |native_target|
        phase = native_target.shell_script_build_phases.select do |bp|
          bp.name == BUGSNAG_PHASE_NAME
        end.first || native_target.new_shell_script_build_phase(BUGSNAG_PHASE_NAME)

        phase.shell_path = "/usr/bin/env ruby"
        phase.shell_script = BUGSNAG_PHASE_SCRIPT
        phase.show_env_vars_in_log = '0'
      end
    end

    def has_bugsnag_dependency?
      target.target_definition.dependencies.detect do |dep|
        dep.name.include?('Bugsnag')
      end != nil
    end

    def bugsnag_native_targets
      @bugsnag_native_targets ||=(
        native_targets.reject do |native_target|
          native_target.shell_script_build_phases.any? do |bp|
            bp.name == BUGSNAG_PHASE_NAME && bp.shell_script == BUGSNAG_PHASE_SCRIPT
          end
        end
      )
    end
  end
end