# frozen_string_literal: true

require 'cocoapods'
require 'cocoapods_bugsnag'
require 'tmpdir'

# rubocop:disable Lint/MissingCopEnableDirective, Metrics/BlockLength

RSpec.describe 'cocoapods-bugsnag' do
  context 'with a user project' do
    around(:each) do |t|
      Dir.chdir(Dir.mktmpdir) { t.run }
    end

    let(:config) { Pod::Config.instance }

    before do
      user_project = Xcodeproj::Project.new('App.xcodeproj')
      Pod::Generator::AppTargetHelper.add_app_target(user_project, :osx, '10.11')
      user_project.save

      CLAide::Command::PluginManager.load_plugins('cocoapods')
    end

    it 'adds a build phase if included in Podfile' do
      File.write 'Podfile', <<~RUBY
        use_frameworks!
        plugin 'cocoapods-bugsnag'
        target 'App' do
          pod 'AFNetworking'
          pod 'Bugsnag'
        end
      RUBY

      installer = Pod::Installer.new(config.sandbox, config.podfile, config.lockfile)
      installer.install!

      expect(Pod::UI.output).to include "Adding 'Upload Bugsnag dSYM' build phase to 'App'"

      expect(installer.aggregate_targets.flat_map(&:user_targets)).to all(satisfy do |target|
        upload_phase = target.shell_script_build_phases.find { |bp| bp.name == 'Upload Bugsnag dSYM' }
        expect(upload_phase.shell_path).to eq '/usr/bin/env ruby'
        expect(upload_phase.shell_script).to include 'BUGSNAG_API_KEY'
        expect(upload_phase.shell_script).to include 'SCRIPT_INPUT_FILE_COUNT'
        expect(upload_phase.show_env_vars_in_log).to eq '0'
        expect(upload_phase.input_paths).to eq %w[
          ${BUILT_PRODUCTS_DIR}/${INFOPLIST_PATH}
          ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}
          ${BUILT_PRODUCTS_DIR}/AFNetworking/AFNetworking.framework.dSYM/Contents/Resources/DWARF/AFNetworking
          ${BUILT_PRODUCTS_DIR}/Bugsnag/Bugsnag.framework.dSYM/Contents/Resources/DWARF/Bugsnag
        ]
      end)
    end

    it 'does not remove existing input phases' do
      File.write 'Podfile', <<~RUBY
        use_frameworks!
        plugin 'cocoapods-bugsnag'
        target 'App' do
          pod 'AFNetworking'
          pod 'Bugsnag'
        end
      RUBY

      installer = Pod::Installer.new(config.sandbox, config.podfile, config.lockfile)
      installer.install!

      expect(Pod::UI.output).to include "Adding 'Upload Bugsnag dSYM' build phase to 'App'"
      Pod::UI.output = ''.dup

      File.write 'Podfile', <<~RUBY
        use_frameworks!
        plugin 'cocoapods-bugsnag'
        target 'App' do
          # AFNetworking now omitted
          pod 'Bugsnag'
        end
      RUBY

      installer = Pod::Installer.new(config.sandbox, config.podfile, config.lockfile)
      installer.install!

      expect(Pod::UI.output).not_to include "Adding 'Upload Bugsnag dSYM' build phase to 'App'"

      expect(installer.aggregate_targets.flat_map(&:user_targets)).to all(satisfy do |target|
        upload_phase = target.shell_script_build_phases.find { |bp| bp.name == 'Upload Bugsnag dSYM' }
        expect(upload_phase.input_paths).to include(
          '${BUILT_PRODUCTS_DIR}/AFNetworking/AFNetworking.framework.dSYM/Contents/Resources/DWARF/AFNetworking'
        )
      end)
    end

    it 'does nothing if Bugsnag is not a dependency' do
      File.write 'Podfile', <<~RUBY
        plugin 'cocoapods-bugsnag'
        target 'App'
      RUBY

      installer = Pod::Installer.new(config.sandbox, config.podfile, config.lockfile)
      installer.install!

      expect(Pod::UI.output).not_to include "Adding 'Upload Bugsnag dSYM' build phase to 'App'"

      expect(installer.aggregate_targets.flat_map(&:user_targets)).to all(satisfy do |target|
        upload_phase = target.shell_script_build_phases.find { |bp| bp.name == 'Upload Bugsnag dSYM' }
        expect(upload_phase).to be_nil
      end)
    end

    it 'does nothing if not added as a plugin' do
      File.write 'Podfile', <<~RUBY
        target 'App' do
          pod 'Bugsnag'
        end
      RUBY

      installer = Pod::Installer.new(config.sandbox, config.podfile, config.lockfile)
      installer.install!

      expect(Pod::UI.output).not_to include "Adding 'Upload Bugsnag dSYM' build phase to 'App'"

      expect(installer.aggregate_targets.flat_map(&:user_targets)).to all(satisfy do |target|
        upload_phase = target.shell_script_build_phases.find { |bp| bp.name == 'Upload Bugsnag dSYM' }
        expect(upload_phase).to be_nil
      end)
    end
  end
end
