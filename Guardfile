# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'guard/plugin'

notification :tmux

module ::Guard
  class Sunum < ::Guard::Plugin

    def initialize options = {}
      super
    end

    def start
      UI.info "Compiling all the files..."
    end

    def stop
      UI.info "Cleaning the cache..."
    end

    def run_on_changes paths
      paths.each do |path|
        UI.info "Compiled #{path}"
      end
    end

    private

    def slim path
    end

    def sass path
    end

    def coffee path
    end

    def concat
    end

  end
end


guard 'Sunum' do
  watch(%r{slides/.+\.slim})
end
