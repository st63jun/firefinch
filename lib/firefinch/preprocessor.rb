module Firefinch
  class Preprocessor

    PREFIX = '@'

    def initialize(bind)
      @bind = bind
    end

    def match_command(str)
      m = str
        .scan(/(\\#{PREFIX}(\w*)(\[[^\[\]]*\])?((?:\{.*?\})*))/m)
        .reject {|e| ["begin", "end"].include? e[1]}
      m.map do |e|
        {
          :origin  => e[0],
          :name    => e[1],
          :opts    => e[2].nil?   ? nil : e[2].gsub(/\[(.*)\]/, '\1'),
          :args    => e[3].empty? ? nil : e[3].scan(/\{([^\{\}]*)\}/).flatten
        }
      end
    end

    def match_environment(str)
      m = str.scan(/(\\#{PREFIX}begin\{(\w*)\}((?:\{.*\})*)(\[[^\[\]]*\])?(.*)\\#{PREFIX}end\{\2\})/m)
      m.map do |e|
        {
          :origin  => e[0],
          :name    => e[1],
          :opts    => (e[2].nil? or e[2].empty?) ? nil : e[2].gsub(/\[(.*)\]/, '\1'),
          :args    => (e[3].nil? or e[3].empty?) ? nil : e[3].scan(/\{([^\{\}]*)\}/).flatten,
          :content => e[4]
        }
      end
    end

    def compile1(source)
      match_command(source).each do |e|
        if e[:name] == "eval"
          result = eval(e[:args].first).inspect
        elsif e[:name] == "verb"
          result = e[:args]
        else
          result = @bind.send(e[:name], e)
          result = compile1(result) unless match_command(result).empty?
        end
        source.gsub!(e[:origin], result)
      end
      source
    end

    def compile2(source)
      match_environment(source).each do |e|
        e[:content] = compile2(e[:content]) 
        result = @bind.send(e[:name], e)
        source.gsub!(e[:origin], result)
      end
      source
    end

    def compile(source)
      compile2(compile1(source))
    end
  end
end
