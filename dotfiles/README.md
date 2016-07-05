We observe that the experienced nerd often prefers tools which afford a measure of customization, and that most hackers accrue some amount of configuration for editors, shells, IRC clients, and the like.

This section may, at your option, contain either:

  a) A collection of dotfiles or other configuration from your working environment.
  b) A rationale for your lack of same.

 **~/.ssh/***  - private_keys, authorized_keys, and known_hosts are great!

     Not giving up anything in this directory, sorry! ;P

 **~/.bashrc** - Ruby Version Manager (rvm) the only good way of keeping multiple versions of ruby on your machine and switching between them



    export PATH="$PATH:$HOME/.rvm/bin" # Add RVM (Ruby Version Manager) to PATH for scripting

 **~/.bash_profile** - alias, colors, don't auto complete Mac's stupid .DS_Store files, mysql paths



    alias ls='ls -GFh'
    export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad
    export FIGNORE=DS_Store
    export DYLD_LIBRARY_PATH='/usr/local/mysql/lib/'
    export PATH=$PATH:/usr/local/mysql/bin


 **~/.nanorc** - Syntax highlighting for a ton of languages in nano. (Don't judge me for using nano, I can use vi. I just prefer nano's simplicity. ) Also you can't declare all these files with a wildcard it will break nanorc... https://github.com/scopatz/nanorc



    include "~/.nano/apacheconf.nanorc"
    include "~/.nano/arduino.nanorc"
    include "~/.nano/asciidoc.nanorc"
    include "~/.nano/asm.nanorc"
    include "~/.nano/awk.nanorc"
    include "~/.nano/c.nanorc"
    include "~/.nano/cmake.nanorc"
    include "~/.nano/coffeescript.nanorc"
    include "~/.nano/colortest.nanorc"
    include "~/.nano/conf.nanorc"
    include "~/.nano/csharp.nanorc"
    include "~/.nano/css.nanorc"
    include "~/.nano/cython.nanorc"
    include "~/.nano/dot.nanorc"
    include "~/.nano/email.nanorc"
    include "~/.nano/fish.nanorc"
    include "~/.nano/fortran.nanorc"
    include "~/.nano/gentoo.nanorc"
    include "~/.nano/git.nanorc"
    include "~/.nano/gitcommit.nanorc"
    include "~/.nano/glsl.nanorc"
    include "~/.nano/go.nanorc"
    include "~/.nano/groff.nanorc"
    include "~/.nano/haml.nanorc"
    include "~/.nano/haskell.nanorc"
    include "~/.nano/html.nanorc"
    include "~/.nano/ini.nanorc"
    include "~/.nano/inputrc.nanorc"
    include "~/.nano/java.nanorc"
    include "~/.nano/javascript.nanorc"
    include "~/.nano/js.nanorc"
    include "~/.nano/json.nanorc"
    include "~/.nano/keymap.nanorc"
    include "~/.nano/kickstart.nanorc"
    include "~/.nano/ledger.nanorc"
    include "~/.nano/lisp.nanorc"
    include "~/.nano/lua.nanorc"
    include "~/.nano/makefile.nanorc"
    include "~/.nano/man.nanorc"
    include "~/.nano/markdown.nanorc"
    include "~/.nano/mpdconf.nanorc"
    include "~/.nano/mutt.nanorc"
    include "~/.nano/nanorc.nanorc"
    include "~/.nano/nginx.nanorc"
    include "~/.nano/ocaml.nanorc"
    include "~/.nano/patch.nanorc"
    include "~/.nano/peg.nanorc"
    include "~/.nano/perl.nanorc"
    include "~/.nano/php.nanorc"
    include "~/.nano/pkg-config.nanorc"
    include "~/.nano/pkgbuild.nanorc"
    include "~/.nano/po.nanorc"
    include "~/.nano/pov.nanorc"
    include "~/.nano/privoxy.nanorc"
    include "~/.nano/puppet.nanorc"
    include "~/.nano/python.nanorc"
    include "~/.nano/reST.nanorc"
    include "~/.nano/rpmspec.nanorc"
    include "~/.nano/ruby.nanorc"
    include "~/.nano/rust.nanorc"
    include "~/.nano/scala.nanorc"
    include "~/.nano/sed.nanorc"
    include "~/.nano/sh.nanorc"
    include "~/.nano/sls.nanorc"
    include "~/.nano/sql.nanorc"
    include "~/.nano/systemd.nanorc"
    include "~/.nano/tcl.nanorc"
    include "~/.nano/tex.nanorc"
    include "~/.nano/vala.nanorc"
    include "~/.nano/vi.nanorc"
    include "~/.nano/xml.nanorc"
    include "~/.nano/xresources.nanorc"
    include "~/.nano/yaml.nanorc"
    include "~/.nano/yum.nanorc"
    include "~/.nano/zsh.nanorc"




Responses will be evaluated for both style and content.
