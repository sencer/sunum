# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'guard/plugin'
require 'slim'
require 'compass'
require 'sass/plugin'
require 'coffee-script'
require 'yaml'

notification :tmux

module ::Guard
  class Compile < ::Guard::Plugin

    def initialize options = {}
      Compass.add_configuration(
        {
          project_path: '.',
          sass_path: 'theme',
          css_path: 'theme/.cache',
          output_style: :compressed,
          relative_assets: true
        },
        'sunum'
      )
      Slim::Embedded.set_default_options markdown: {
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        autolink: true,
        strikethrough: true,
        lax_html_blocks: true,
        superscript: true,
        underline: true,
        highlight: true,
        footnotes: true,
        tables: true,
        smartypants: true,
      }
      super
    end

    def start
      UI.info "Cleaning the cache..."
      File.delete(*Dir.glob("{theme,slides}/.cache/*"))
      UI.info "Compiling all the files..."
      run_all
    end

    def stop
    end

    def run_all
      run_on_changes Dir.glob("slides/*.slim")
      run_on_changes Dir.glob("theme/*.{coffee,scss}")
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
      #TODO that is dirty.
      return if dir == "theme"
      begin
        File.open("#{dir}/.cache/#{file.gsub('.slim', '.html')}", "w") do |f|
          f.puts(Slim::Template.new(pretty: true) do
            tmp = IO.read("#{dir}/#{file}")
            if tmp.start_with? '---'
              tmp.match /^---\n(.*\n)*---\n((.*\n)+)/
              $2
            else
              tmp
            end
          end.render)
        end
      rescue
        UI.info "Error rendering #{file}.slim"
      end
    end

    def scss dir, file
      begin
        Compass.compiler.compile("#{dir}/#{file}", "#{dir}/.cache/#{file.gsub('.scss', '.css')}")
      rescue
        UI.info "ERROR in #{dir}/#{file} file!"
      end
    end

    def coffee dir, file
      begin
        File.open("#{dir}/.cache/#{file.gsub('.coffee', '.js')}", "w") do |f|
        f.puts CoffeeScript.compile(IO.read("#{dir}/#{file}"))
        end
      rescue
        UI.info "ERROR in #{file}.coffee"
      end
    end

    def concat
      begin
        theme = Slim::Template.new("theme/theme.slim", pretty: true)
        %w[index notlar].each do |page|
          File.open("#{page}.html", "w") do |f|
            f.puts(
              theme.render(nil, page: page) do
                text = ""
                File.readlines("slides/slides.list").each do |line|
                  unless line.start_with? '#'
                    line.chomp!
                    tmp = IO.read("slides/#{line}.slim")
                    tmp.match /^---\n((.*\n)+)---/
                    text += "<section id='#{line}' data-state='#{line}' #{$1 ? $1.gsub(/\n/, ' ') : nil}>\n"
                    text += IO.read("slides/.cache/#{line}.html")
                    text += "\n</section>"
                  end
                end
                text
              end
            )
          end
        end
      rescue
        UI.info "ERROR in concat"
      end
    end

  end
end


guard 'Compile' do
  watch(%r{slides/.+\.slim})
  watch(%r{theme/.+\.(coffee|scss|slim)})
end

guard 'livereload' do
  watch('index.html')
  watch('notlar.html')
end
