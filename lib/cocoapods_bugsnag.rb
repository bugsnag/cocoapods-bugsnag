module Pod
  class Installer::UserProjectIntegrator::TargetIntegrator

    BUGSNAG_PHASE_NAME = "Upload Bugsnag dSYM"
    BUGSNAG_PHASE_INPUT_PATHS = [
      "${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}",
      "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}"]
    BUGSNAG_PHASE_SHELL_PATH = "/usr/bin/env ruby"
    BUGSNAG_PHASE_SCRIPT = <<'RUBY'
# Set DISABLE_COCOAPODS_BUGSNAG=YES via Xcode's Build Settings, xcconfig or xcodebuild to skip upload
if ENV['DISABLE_COCOAPODS_BUGSNAG'] == 'YES'
  puts 'Skipping dSYM upload'
  return
end

# Attempt to get the API key from an environment variable (or Xcode build setting)
api_key = ENV["BUGSNAG_API_KEY"]

# If not present, attempt to lookup the value from the Info.plist
unless api_key
  info_plist_path = "#{ENV["BUILT_PRODUCTS_DIR"]}/#{ENV["INFOPLIST_PATH"]}"
  plist_buddy_response = `/usr/libexec/PlistBuddy -c "print :bugsnag:apiKey" "#{info_plist_path}"`
  plist_buddy_response = `/usr/libexec/PlistBuddy -c "print :BugsnagAPIKey" "#{info_plist_path}"` if !$?.success?
  api_key = plist_buddy_response if $?.success?
end

fail("No Bugsnag API key detected - add your key to your Info.plist or BUGSNAG_API_KEY environment variable") unless api_key

if ENV['ENABLE_USER_SCRIPT_SANDBOXING'] == 'YES'
  count = ENV['SCRIPT_INPUT_FILE_COUNT'].to_i
  abort 'error: dSYMs must be specified as build phase "Input Files" because ENABLE_USER_SCRIPT_SANDBOXING is enabled' unless count > 0
  dsyms = []
  for i in 0 .. count - 1
    file = ENV["SCRIPT_INPUT_FILE_#{i}"]
    next if file.end_with? '.plist'
    if File.exist? file
      dsyms.append file
    else
      abort "error: cannot read #{file}" unless ENV['DEBUG_INFORMATION_FORMAT'] != 'dwarf-with-dsym'
    end
  end
else
  dsyms = Dir["#{ENV['DWARF_DSYM_FOLDER_PATH']}/*/Contents/Resources/DWARF/*"]
end

dsyms.each do |dsym|
  Process.detach Process.spawn('/usr/bin/curl', '--http1.1',
    '-F', "apiKey=#{api_key}",
    '-F', "dsym=@#{dsym}",
    '-F', "projectRoot=#{ENV['PROJECT_DIR']}",
    'https://upload.bugsnag.com/',
    %i[err out] => :close
  )
end
RUBY

    alias_method :integrate_without_bugsnag!, :integrate!
    def integrate!
      integrate_without_bugsnag!
      return unless should_add_build_phase?

      UI.section("Integrating with Bugsnag") do
        add_bugsnag_upload_script_phase
        user_project.save
      end
    end

    def add_bugsnag_upload_script_phase
      native_targets.each do |native_target|
        phase = native_target.shell_script_build_phases.select do |bp|
          bp.name == BUGSNAG_PHASE_NAME
        end.first || add_shell_script_build_phase(native_target, BUGSNAG_PHASE_NAME)

        phase.input_paths = dsym_phase_input_paths(phase)
        phase.shell_path = BUGSNAG_PHASE_SHELL_PATH
        phase.shell_script = BUGSNAG_PHASE_SCRIPT
        phase.show_env_vars_in_log = '0'
      end
    end

    def add_shell_script_build_phase(native_target, name)
      UI.puts "Adding '#{name}' build phase to '#{native_target.name}'"
      native_target.new_shell_script_build_phase(name)
    end

    def dsym_phase_input_paths(phase)
      (phase.input_paths + BUGSNAG_PHASE_INPUT_PATHS + target.framework_dsym_paths).uniq
    end

    def should_add_build_phase?
      has_bugsnag_dep = target.target_definition.dependencies.any? do |dep|
        dep.name.match?(/bugsnag/i)
      end
      uses_bugsnag_plugin = target.target_definition.podfile.plugins.key?('cocoapods-bugsnag')
      return has_bugsnag_dep && uses_bugsnag_plugin
    end
  end
end

module Pod
  class AggregateTarget
    def framework_dsym_paths
      return [] unless includes_frameworks?

      framework_paths_by_config['Release'].map do |framework|
        name = File.basename(framework.source_path, '.framework')
        "#{framework.source_path}.dSYM/Contents/Resources/DWARF/#{name}"
      end
    end
  end
end
