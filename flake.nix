{
  description = "A modern, minimal(ish) Vim distribution";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      inherit (builtins) attrValues;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        ## The Vim version.
        ##
        #@ String
        version = "9.2.1160";

        ## The Vim source.
        ##
        #@ Derivation
        src = pkgs.fetchFromGitHub {
          owner = "vim";
          repo = "vim";
          rev = "v${version}";
          hash = "sha256-y4CFI+msLXu32wjHnSHWKyJxr7b+gFV5daKChILC9zY=";
        };

        ## The Vim package.
        ##
        #@ Package
        package = pkgs.vim-full.overrideAttrs (_: {
          inherit version src;
        });

        ## The Vim derivation.
        ##
        #@ Package
        vim = package.customize {
          vimrcConfig.customRC = ''
            set runtimepath=${self},$VIMRUNTIME,${self}/after
            set packpath=${self},$VIMRUNTIME,${self}/after
          '';
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = attrValues { inherit vim; };
          shellHook = ''
            echo "Entering the 'github:52/vim' development environment"
            echo "Execute 'vim' or 'gvim' to open the build"
          '';
        };
      }
    );
}
