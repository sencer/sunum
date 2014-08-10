# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'guard/plugin'
require 'slim'
require 'compass'
require 'sass/plugin'
require 'coffee-script'

notification :tmux

module ::Guard
  class Sunum < ::Guard::Plugin

    def initialize options = {}
      Compass.add_configuration(
        {
          :project_path => '.',
          :sass_path => 'theme',
          :css_path => 'theme/.cache'
        },
        'sunum'
      )
      super
    end

    def start
      UI.info "Compiling all the files..."
      run_on_changes Dir.glob("{theme,slides}/*.{coffee,scss,slim}")
    end

    def stop
      UI.info "Cleaning the cache..."
      File.delete(*Dir.glob("{theme,slides}/.cache/*"))
    end

    def run_on_changes paths
      paths.each do |path|
        dir = File.dirname path
        file = File.basename path
        ext = File.extname path
        self.send(ext[1..-1], dir, file)
        UI.info "Compiled #{path}"
      end
    end

    private

    def slim dir, file
      File.open("#{dir}/.cache/#{file.gsub('.slim', '.html')}", "w") do |f|
        f.puts Slim::Template.new("#{dir}/#{file}", pretty: true).render
      end
    end

    def scss dir, file
      Compass.compiler.compile("#{dir}/#{file}", "#{dir}/.cache/#{file.gsub('.scss', '.css')}")
    end

    def coffee dir, file
      File.open("#{dir}/.cache/#{file.gsub('.coffee', '.js')}", "w") do |f|
        f.puts CoffeeScript.compile(IO.read("#{dir}/#{file}"))
      end
    end

    def concat
    end

  end
end


guard 'Sunum' do
  watch(%r{slides/.+\.slim})
  watch(%r{theme/.+\.(slim|coffee|scss)})
end
