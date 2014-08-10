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
      run_all
    end

    def stop
      UI.info "Cleaning the cache..."
      File.delete(*Dir.glob("{theme,slides}/.cache/*"))
    end

    def run_all
      run_on_changes Dir.glob("{theme,slides}/*.{coffee,scss,slim}")
    end

    def run_on_changes paths
      paths.each do |path|
        dir = File.dirname path
        file = File.basename path
        ext = File.extname path
        self.send(ext[1..-1], dir, file)
        UI.info "Compiled #{path}"
      end
      concat
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
      File.open("sunum.html", "w") do |f|
        f.puts <<-eos
				<!doctype html>
				<html lang="en">
				#{IO.read("theme/.cache/theme.html")}
				<body>
				  <div class="reveal">
				    <div class="slides">
				eos
        File.readlines("slides/slides.list").each do |line|
          UI.info line
          unless line.start_with? "#"
            f.puts "<section>"
            f.puts IO.read("slides/.cache/#{line.chomp}.html")
            f.puts "</section>"
          end
        end
        f.puts <<-eos
				    </div>
				  </div>
				  <script>
				    Reveal.initialize({
				      controls: true,
				      progress: true,
				      history: true,
				      center: true,
				      theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
				      transition: Reveal.getQueryHash().transition || 'default', // default/cube/page/concave/zoom/linear/fade/none
				    });
				  </script>
				</body>
				</html>
				eos
      end
    end

  end
end


guard 'Sunum' do
  watch(%r{slides/.+\.slim})
  watch(%r{theme/.+\.(slim|coffee|scss)})
end
