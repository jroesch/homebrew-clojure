require 'formula'

class Leiningen < Formula
  homepage 'http://github.com/technomancy/leiningen'
  url 'http://github.com/technomancy/leiningen/tarball/2.0.0-preview7'
  md5 '1ea6cdce60cbecdaa077f9ed19ad6063'

  head 'https://github.com/technomancy/leiningen.git'

  def install
    bin.install "bin/lein"
    system "#{bin}/lein", "self-install"
    (etc+'bash_completion.d').install 'bash_completion.bash' => 'lein-completion.bash'
  end

  def caveats; <<-EOS.undent
    Standalone jar and dependencies installed to:
      $HOME/.m2/repository
    EOS
  end
end
