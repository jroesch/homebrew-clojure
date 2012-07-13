require 'formula'

#TODO: Clean up 
class ClojureRlwrap < Formula
  homepage 'http://clojure.org/'
  url 'http://repo1.maven.org/maven2/org/clojure/clojure/1.4.0/clojure-1.4.0.zip'
  sha1 '34daf1bb035aba4c0e5ff3b4afef837d21700e72'

  head 'https://github.com/clojure/clojure.git'

  depends_on "rlwrap"
  
  #fix this

  def script;
    breakchars = '(){}[],^%$#@\"\";:''|\\\\'; <<-EOS.undent
    #!/bin/sh

    breakchars="#{breakchars}"
    CLOJURE_DIR="/usr/local/Cellar/clojure-rlwrap/1.4.0/"
    CLOJURE_JAR="$CLOJURE_DIR"/clojure-1.4.0.jar
    if [ $# -eq 0 ]; then 
        exec rlwrap --remember -c -b "$breakchars" \\
           -f "$HOME"/.clj_completions \\
            java -cp "$CLOJURE_JAR" clojure.main
    else
        exec java -cp "$CLOJURE_JAR" clojure.main $1 "$@"
    fi
    EOS
  end

  def install
    system "ant" if ARGV.build_head?
    prefix.install 'clojure-1.4.0.jar'
    (prefix+'clojure-1.4.0.jar').chmod(0644) # otherwise it's 0600
    (prefix+'classes').mkpath
    (bin+'clj').write script
    generate_completion
  end
  
  def generate_completion; gen_code = <<-EOS
    (def completions (mapcat (comp keys ns-publics) (all-ns)))
    
    (with-open [f (java.io.BufferedWriter. (java.io.FileWriter. (str (System/getenv "HOME") "/.clj_completions")))]
    (.write f (apply str (interpose \\newline completions))))
    EOS
    tmp = open "/tmp/gen_comp.clj", "w"
    tmp.write gen_code; tmp.close
    `java -cp /usr/local/Cellar/clojure-rlwrap/1.4.0/clojure-1.4.0.jar clojure.main /tmp/gen_comp.clj`
  end

  def test
    system "#{bin}/clj", "-e", '(println "Hello World")'
  end
end
