let
  commit = "39c5d116a2967c2121725050bd63bc42505eb62c";
in
import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz")
