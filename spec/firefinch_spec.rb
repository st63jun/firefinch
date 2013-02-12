require 'spec_helper'
require 'lorem-ipsum'

describe Firefinch::Preprocessor do
  context "when preprocess TeX source" do

    class MyObject
      def hello(opts={})
        if opts[:opts].nil?
          "hello, world!"
        else
          "hello, #{opts[:opts]}!"
        end
      end

      def nested_hello(opts={})
        "\\@hello[from nested command]"
      end

      def sqrt(opts={})
        val = opts[:args].first.to_i
        (val * val).to_s
      end

      def upcase(opts={})
        opts[:content].upcase
      end

      def downcase(opts={})
        opts[:content].downcase
      end
    end

    it "should pass through plain text" do
      p = Firefinch::Preprocessor.new(Object.new)
      p.compile("hello").should == "hello"
    end

    it "should pass through normal command" do
      p = Firefinch::Preprocessor.new(Object.new)
      p.compile("\\maketitle").should == "\\maketitle"
    end

    it "should raise exception if undefined command" do
      p = Firefinch::Preprocessor.new(Object.new)
      proc {p.compile("\\@undefined")}.should raise_error
    end

    it "should replace command that has no arg command" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@hello").should == "hello, world!"
    end

    it "should replace command that has no arg and one option" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@hello[Ruby]").should == "hello, Ruby!"
    end

    it "should replace command that has one arg" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@sqrt{2}").should == "4"
    end
    
    it "should replace multiple lines" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile(<<END
sqrt(2) = \\@sqrt{2}
sqrt(4) = \\@sqrt{4}
END
                )
        .should ==<<END
sqrt(2) = 4
sqrt(4) = 16
END
    end

    it "should replace nested command" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@nested_hello").should == "hello, from nested command!"
    end

    it "should replace no arg environment" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@begin{upcase}hogehoge\\@end{upcase}").should == "HOGEHOGE"
    end

    it "should replace nested environment" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@begin{upcase}hoge\\@begin{downcase}HUGAHUGA\\@end{downcase}hoge\\@end{upcase}").should == "HOGEHUGAHUGAHOGE"
    end

    it "should replace nested environment and command" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@begin{upcase}\\@hello\\@end{upcase}").should == "HELLO, WORLD!"
    end

    it "should replace ruby expression" do
      p = Firefinch::Preprocessor.new(MyObject.new)
      p.compile("\\@eval{1 + 1}").should == "2"
    end

  end
end
